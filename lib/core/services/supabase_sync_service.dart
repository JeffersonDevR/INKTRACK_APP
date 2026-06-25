import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:drift/drift.dart';
import 'package:InkTrack/core/data/local/database.dart';
import 'package:InkTrack/core/services/log_service.dart';
import 'package:InkTrack/core/services/analytics_service.dart';
import 'package:InkTrack/core/services/sync/batch_uploader.dart';
import 'package:InkTrack/core/services/sync/sync_strategy.dart';
import 'package:InkTrack/core/services/sync/strategies/sync_strategies.dart';

/// Coordinates cloud sync across all tables.
///
/// Uses per-table [SyncStrategy] instances and a shared [BatchUploader]
/// to batch-upload pending records with exponential-backoff retry.
/// Downloads use last-write-wins conflict resolution by comparing
/// the server's `updated_at` with the local `lastSyncedAt`.
class SupabaseSyncService {
  final AppDatabase _db;
  final SupabaseClient _client;
  final BatchUploader _uploader;

  /// Ordered strategies matching the dependency-safe sync order:
  /// parents first, then children.
  final List<SyncStrategy> _strategies;

  SupabaseSyncService(this._db, this._client, {BatchUploader? uploader})
      : _uploader = uploader ?? BatchUploader(),
        _strategies = _createStrategies();

  /// Create the default set of per-table strategies in dependency order.
  static List<SyncStrategy> _createStrategies() {
    return [
      LocalesSyncStrategy(),
      ClientesSyncStrategy(),
      ProveedoresSyncStrategy(),
      ProductosSyncStrategy(),
      PedidosProveedorSyncStrategy(),
      MovimientosSyncStrategy(),
      VentasSyncStrategy(),
    ];
  }

  /// Expose strategies for testing / selective sync.
  List<SyncStrategy> get strategies => _strategies;

  /// Get a strategy by Supabase table name.
  SyncStrategy? strategyFor(String tableName) {
    try {
      return _strategies.firstWhere((s) => s.tableName == tableName);
    } catch (_) {
      return null;
    }
  }

  /// Sync a single table: upload pending + download server changes.
  Future<SyncResult> syncTable(String tableName) async {
    final log = LogService.instance;
    final strategy = strategyFor(tableName);
    if (strategy == null) {
      log.warning('Sync', 'No strategy found for table: $tableName');
      return SyncResult(
        tableName: tableName,
        uploaded: 0,
        downloaded: 0,
        errors: 1,
      );
    }

    log.info('Sync', 'Starting sync for $tableName');

    int uploaded = 0;
    int downloaded = 0;
    int errors = 0;
    String? errorMessage;

    try {
      uploaded = await _uploader.uploadPending(_db, _client, strategy);
      if (uploaded > 0) {
        log.info('Sync', 'Uploaded $uploaded records to $tableName');
      }
    } catch (e) {
      errors++;
      errorMessage = 'Upload failed for ${strategy.tableName}: $e';
      log.error('Sync', errorMessage);
    }

    try {
      downloaded = await strategy.downloadAndMerge(_db, _client);
      if (downloaded > 0) {
        log.info('Sync', 'Downloaded $downloaded records from $tableName');
      }
    } catch (e) {
      errors++;
      errorMessage = (errorMessage ?? '') + 'Download failed for ${strategy.tableName}: $e';
      log.error('Sync', 'Download failed for $tableName: $e');
      return SyncResult(
        tableName: tableName,
        uploaded: uploaded,
        downloaded: 0,
        errors: errors,
        errorMessage: errorMessage,
      );
    }

    if (errors == 0 && uploaded == 0 && downloaded == 0) {
      log.debug('Sync', 'No changes for $tableName');
    }

    return SyncResult(
      tableName: tableName,
      uploaded: uploaded,
      downloaded: downloaded,
      errors: errors,
      errorMessage: errorMessage,
    );
  }

  /// Download server changes for a single table (without uploading).
  Future<SyncResult> downloadFromSupabase(String tableName) async {
    final strategy = strategyFor(tableName);
    if (strategy == null) {
      return SyncResult(
        tableName: tableName,
        uploaded: 0,
        downloaded: 0,
        errors: 1,
      );
    }

    try {
      final downloaded = await strategy.downloadAndMerge(_db, _client);
      return SyncResult(
        tableName: tableName,
        uploaded: 0,
        downloaded: downloaded,
        errors: 0,
      );
    } catch (e) {
      return SyncResult(
        tableName: tableName,
        uploaded: 0,
        downloaded: 0,
        errors: 1,
        errorMessage: '$e',
      );
    }
  }

  /// Sync all tables in dependency order.
  ///
  /// Locales are synced first, then any locales referenced by pending child
  /// rows are force-uploaded to avoid FK violations, then the remaining tables
  /// are synced.
  Future<SyncResult> syncAll() async {
    int totalUploaded = 0;
    int totalDownloaded = 0;
    int totalErrors = 0;

    AnalyticsService.instance.track('sync_start');
    final localeResult = await syncTable('locales');
    totalUploaded += localeResult.uploaded;
    totalDownloaded += localeResult.downloaded;
    totalErrors += localeResult.errors;

    // Upload locales referenced by pending child rows even if they were
    // already marked as synced locally (e.g. after a cloud reset).
    try {
      await _ensureReferencedLocalesUploaded();
    } catch (e) {
      totalErrors++;
    }

    for (final strategy in _strategies) {
      if (strategy is LocalesSyncStrategy) continue;
      final result = await syncTable(strategy.tableName);
      totalUploaded += result.uploaded;
      totalDownloaded += result.downloaded;
      totalErrors += result.errors;
    }

    AnalyticsService.instance.track('sync_completed', properties: {
      'uploaded': totalUploaded,
      'downloaded': totalDownloaded,
      'errors': totalErrors,
    });

    return SyncResult(
      tableName: 'all',
      uploaded: totalUploaded,
      downloaded: totalDownloaded,
      errors: totalErrors,
    );
  }

  /// Uploads every locale that is referenced by a pending child row.
  ///
  /// This prevents FK/RLS failures when a child record points to a locale that
  /// exists locally but is missing from Supabase.
  Future<void> _ensureReferencedLocalesUploaded() async {
    final localIds = <String>{};

    for (final strategy in _strategies) {
      if (strategy is LocalesSyncStrategy) continue;
      final rows = await strategy.getPendingRows(_db);
      for (final row in rows) {
        final id = row['local_id'] as String?;
        if (id != null && id.isNotEmpty) {
          localIds.add(id);
        }
      }
    }

    if (localIds.isEmpty) return;

    final locales = await (_db.select(_db.locales)
          ..where((t) => t.id.isIn(localIds.toList())))
        .get();

    if (locales.isEmpty) return;

    final log = LogService.instance;
    log.info('Sync', 'Ensuring ${locales.length} referenced locales exist in cloud');

    final currentUserId = _client.auth.currentUser?.id;
    final localeRows = locales
        .map((l) => {
              'id': l.id,
              'nombre': l.nombre,
              'direccion': l.direccion,
              'telefono': l.telefono,
              'tipo': l.tipo,
              'user_id': l.userId ?? currentUserId,
              'is_activo': l.isActivo,
            })
        .toList();

    try {
      await _client.from('locales').upsert(localeRows);
      log.info('Sync', 'Uploaded ${localeRows.length} referenced locales');

      // Keep local records consistent with what was just uploaded.
      final now = DateTime.now();
      for (final local in locales) {
        if (local.userId == null && currentUserId != null) {
          await (_db.update(_db.locales)..where((t) => t.id.equals(local.id))).write(
            LocalesCompanion(
              userId: Value(currentUserId),
              syncStatus: const Value(syncedStatus),
              lastSyncedAt: Value(now),
            ),
          );
        } else {
          await (_db.update(_db.locales)..where((t) => t.id.equals(local.id))).write(
            LocalesCompanion(
              syncStatus: const Value(syncedStatus),
              lastSyncedAt: Value(now),
            ),
          );
        }
      }
    } catch (e) {
      log.error('Sync', 'Failed to upload referenced locales: $e');
      rethrow;
    }
  }

  /// Download all tables in dependency order.
  Future<SyncResult> downloadAll() async {
    int totalDownloaded = 0;
    int totalErrors = 0;

    for (final strategy in _strategies) {
      final result = await downloadFromSupabase(strategy.tableName);
      totalDownloaded += result.downloaded;
      totalErrors += result.errors;
    }

    return SyncResult(
      tableName: 'all',
      uploaded: 0,
      downloaded: totalDownloaded,
      errors: totalErrors,
    );
  }
}

/// Result of a sync operation for a single table or the full sync.
class SyncResult {
  final String tableName;
  final int uploaded;
  final int downloaded;
  final int errors;
  final String? errorMessage;

  SyncResult({
    required this.tableName,
    required this.uploaded,
    required this.downloaded,
    required this.errors,
    this.errorMessage,
  });

  bool get isSuccess => errors == 0;

  String get message {
    if (errors > 0) {
      return 'Sync failed: $errors errors${errorMessage != null ? ' — $errorMessage' : ''}';
    }
    if (uploaded == 0 && downloaded == 0) {
      return 'No changes to sync';
    }
    return 'Synced: $uploaded uploaded, $downloaded downloaded';
  }
}

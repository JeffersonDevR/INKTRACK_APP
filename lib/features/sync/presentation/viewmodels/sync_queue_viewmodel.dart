import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:InkTrack/core/services/connectivity_service.dart';
import 'package:InkTrack/core/services/supabase_sync_service.dart';
import 'package:InkTrack/core/data/local/database.dart';

enum SyncOutcome { success, error, conflict }

class SyncResult {
  final SyncOutcome outcome;
  final String? messageKey;
  final DateTime at;

  SyncResult({
    required this.outcome,
    this.messageKey,
    required this.at,
  });
}

class SyncQueueViewModel extends ChangeNotifier {
  final SupabaseSyncService syncService;
  final ConnectivityService? connectivityService;
  final AppDatabase _db;

  int _pendingCount = 0;
  bool _isRunning = false;
  SyncResult? _lastSyncResult;
  Timer? _pollTimer;

  SyncQueueViewModel({
    required this.syncService,
    this.connectivityService,
    required AppDatabase db,
  }) : _db = db {
    recompute();
    // Auto-poll every 8 seconds so DB changes (new pending_upload rows) are
    // picked up without requiring manual badge interaction.
    _pollTimer = Timer.periodic(const Duration(seconds: 8), (_) => recompute());
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    super.dispose();
  }

  int get pendingCount => _pendingCount;
  bool get isRunning => _isRunning;
  SyncResult? get lastSyncResult => _lastSyncResult;

  Future<void> recompute() async {
    if (!syncService.isEnabled) {
      _pendingCount = 0;
      notifyListeners();
      return;
    }

    int count = 0;
    try {
      final locCount = await _db.customSelect(
        "SELECT COUNT(*) AS cnt FROM locales WHERE sync_status IN ('pending', 'pending_upload')"
      ).getSingle();
      count += locCount.read<int>('cnt');

      final prodCount = await _db.customSelect(
        "SELECT COUNT(*) AS cnt FROM productos WHERE sync_status IN ('pending', 'pending_upload')"
      ).getSingle();
      count += prodCount.read<int>('cnt');

      final cliCount = await _db.customSelect(
        "SELECT COUNT(*) AS cnt FROM clientes WHERE sync_status IN ('pending', 'pending_upload')"
      ).getSingle();
      count += cliCount.read<int>('cnt');

      final provCount = await _db.customSelect(
        "SELECT COUNT(*) AS cnt FROM proveedores WHERE sync_status IN ('pending', 'pending_upload')"
      ).getSingle();
      count += provCount.read<int>('cnt');

      final movCount = await _db.customSelect(
        "SELECT COUNT(*) AS cnt FROM movimientos WHERE sync_status IN ('pending', 'pending_upload')"
      ).getSingle();
      count += movCount.read<int>('cnt');

      final vtaCount = await _db.customSelect(
        "SELECT COUNT(*) AS cnt FROM ventas WHERE sync_status IN ('pending', 'pending_upload')"
      ).getSingle();
      count += vtaCount.read<int>('cnt');

      // Abonos are only included in the badge count when the sync flag is
      // enabled (task 4.5). When disabled, these rows will never be uploaded,
      // so including them would cause a permanent "N pendientes" display.
      if (syncService.abonosSyncEnabled) {
        final abCount = await _db.customSelect(
          "SELECT COUNT(*) AS cnt FROM abonos WHERE sync_status IN ('pending', 'pending_upload')"
        ).getSingle();
        count += abCount.read<int>('cnt');
      }
    } catch (_) {
      // safe fallback
    }

    if (count != _pendingCount) {
      _pendingCount = count;
      notifyListeners();
    }
  }

  Future<void> triggerSync() async {
    if (!syncService.isEnabled || _isRunning) return;

    _isRunning = true;
    _lastSyncResult = null;
    notifyListeners();

    try {
      final res = await syncService.syncAll();
      await recompute();

      if (res.errors > 0) {
        _lastSyncResult = SyncResult(
          outcome: SyncOutcome.error,
          messageKey: 'syncStateError',
          at: DateTime.now(),
        );
      } else {
        // Check if any client still has a conflict status after sync
        final conflictCount = await _db.customSelect(
          "SELECT COUNT(*) AS cnt FROM clientes WHERE sync_status = 'conflict'"
        ).getSingle();

        if (conflictCount.read<int>('cnt') > 0) {
          _lastSyncResult = SyncResult(
            outcome: SyncOutcome.conflict,
            messageKey: 'syncStateError', // Can maps to conflict error msg
            at: DateTime.now(),
          );
        } else {
          _lastSyncResult = SyncResult(
            outcome: SyncOutcome.success,
            messageKey: 'syncStateSynced',
            at: DateTime.now(),
          );
        }
      }
    } catch (_) {
      _lastSyncResult = SyncResult(
        outcome: SyncOutcome.error,
        messageKey: 'syncStateError',
        at: DateTime.now(),
      );
    } finally {
      _isRunning = false;
      notifyListeners();
    }
  }
}

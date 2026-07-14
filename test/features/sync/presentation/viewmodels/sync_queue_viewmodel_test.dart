import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';
import 'package:InkTrack/core/data/local/database.dart';
import 'package:InkTrack/core/services/supabase_sync_service.dart' as core_sync;
import 'package:InkTrack/features/sync/presentation/viewmodels/sync_queue_viewmodel.dart';

class FakeSupabaseSyncService extends core_sync.SupabaseSyncService {
  bool _enabled;
  int _syncAllErrors = 0;

  FakeSupabaseSyncService(AppDatabase db, {bool enabled = true})
      : _enabled = enabled,
        super(db, enabled ? 'https://example.com' : '', enabled ? 'key' : '');

  @override
  bool get isEnabled => _enabled;

  void setEnabled(bool enabled) {
    _enabled = enabled;
  }

  void setSyncAllErrors(int errors) {
    _syncAllErrors = errors;
  }

  @override
  Future<core_sync.SyncResult> syncAll() async {
    return core_sync.SyncResult(
      tableName: 'all',
      uploaded: 0,
      downloaded: 0,
      errors: _syncAllErrors,
    );
  }
}

void main() {
  late AppDatabase db;
  late FakeSupabaseSyncService syncService;
  late SyncQueueViewModel viewModel;

  setUp(() {
    db = AppDatabase.fromConnection(NativeDatabase.memory());
    syncService = FakeSupabaseSyncService(db);
    viewModel = SyncQueueViewModel(syncService: syncService, db: db);
  });

  tearDown(() async {
    await db.close();
  });

  group('SyncQueueViewModel Tests', () {
    test('pendingCount is 0 when local-only user', () async {
      syncService.setEnabled(false);
      await viewModel.recompute();
      expect(viewModel.pendingCount, equals(0));
    });

    test('recompute aggregates pendingCount correctly across tables', () async {
      await db.customStatement(
        "INSERT INTO clientes (id, nombre, telefono, sync_status) VALUES ('cli-1', 'Test', '123', 'pending_upload')"
      );
      await db.customStatement(
        "INSERT INTO productos (id, nombre, cantidad, precio, categoria, proveedor_id, sync_status) VALUES ('prod-1', 'Test', 5, 100.0, 'Cat', 'prov-1', 'pending')"
      );

      await viewModel.recompute();
      expect(viewModel.pendingCount, equals(2));
    });

    test('triggerSync triggers sync and updates lastSyncResult', () async {
      var listenerCalled = false;
      viewModel.addListener(() {
        listenerCalled = true;
      });

      await viewModel.triggerSync();
      expect(viewModel.isRunning, isFalse);
      expect(viewModel.lastSyncResult, isNotNull);
      expect(viewModel.lastSyncResult!.outcome, equals(SyncOutcome.success));
      expect(listenerCalled, isTrue);
    });

    test('triggerSync surfaces syncStateError on error', () async {
      syncService.setSyncAllErrors(1);
      await viewModel.triggerSync();
      expect(viewModel.lastSyncResult!.outcome, equals(SyncOutcome.error));
      expect(viewModel.lastSyncResult!.messageKey, equals('syncStateError'));
    });
  });
}

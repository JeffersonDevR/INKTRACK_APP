import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:drift/native.dart';
import 'package:InkTrack/core/data/local/database.dart';
import 'package:InkTrack/features/sync/presentation/widgets/sync_badge.dart';
import 'package:InkTrack/features/sync/presentation/viewmodels/sync_queue_viewmodel.dart';
import 'package:InkTrack/core/services/supabase_sync_service.dart' hide SyncResult;
import '../../../../helpers/pump_app.dart';

class FakeSyncService extends SupabaseSyncService {
  final bool _enabled;
  FakeSyncService(AppDatabase db, {bool enabled = true})
      : _enabled = enabled,
        super(db, enabled ? 'https://example.com' : '', enabled ? 'key' : '');

  @override
  bool get isEnabled => _enabled;
}

class MockSyncQueueViewModel extends SyncQueueViewModel {
  final int stubbedPendingCount;
  final bool stubbedIsRunning;
  final SyncResult? stubbedLastSyncResult;

  MockSyncQueueViewModel({
    required SupabaseSyncService syncService,
    required AppDatabase db,
    this.stubbedPendingCount = 0,
    this.stubbedIsRunning = false,
    this.stubbedLastSyncResult,
  }) : super(syncService: syncService, db: db);

  @override
  int get pendingCount => stubbedPendingCount;

  @override
  bool get isRunning => stubbedIsRunning;

  @override
  SyncResult? get lastSyncResult => stubbedLastSyncResult;
}

void main() {
  late AppDatabase db;
  late FakeSyncService syncService;

  setUp(() {
    db = AppDatabase.fromConnection(NativeDatabase.memory());
    syncService = FakeSyncService(db);
  });

  tearDown(() async {
    await db.close();
  });

  Widget wrapWithVM(SyncQueueViewModel vm, Widget child) {
    return MultiProvider(
      providers: [
        Provider<SupabaseSyncService>.value(value: syncService),
        ChangeNotifierProvider<SyncQueueViewModel>.value(value: vm),
      ],
      child: child,
    );
  }

  testWidgets('hides when pendingCount is 0, not running, and no error', (tester) async {
    final vm = MockSyncQueueViewModel(
      syncService: syncService,
      db: db,
      stubbedPendingCount: 0,
      stubbedIsRunning: false,
    );

    await pumpPage(
      tester,
      wrapWithVM(vm, const SyncBadge()),
    );

    expect(find.byType(Container), findsNothing);
  });

  testWidgets('shows pending count when there are pending changes', (tester) async {
    final vm = MockSyncQueueViewModel(
      syncService: syncService,
      db: db,
      stubbedPendingCount: 2,
      stubbedIsRunning: false,
    );

    await pumpPage(
      tester,
      wrapWithVM(vm, const SyncBadge()),
    );

    expect(find.text('2 pendientes'), findsOneWidget);
  });

  testWidgets('shows syncing state when running', (tester) async {
    final vm = MockSyncQueueViewModel(
      syncService: syncService,
      db: db,
      stubbedPendingCount: 2,
      stubbedIsRunning: true,
    );

    await pumpPage(
      tester,
      wrapWithVM(vm, const SyncBadge()),
    );

    expect(find.text('Sincronizando…'), findsOneWidget);
  });

  testWidgets('shows error state and retry action on error', (tester) async {
    final vm = MockSyncQueueViewModel(
      syncService: syncService,
      db: db,
      stubbedPendingCount: 3,
      stubbedIsRunning: false,
      stubbedLastSyncResult: SyncResult(
        outcome: SyncOutcome.error,
        messageKey: 'syncStateError',
        at: DateTime.now(),
      ),
    );

    await pumpPage(
      tester,
      wrapWithVM(vm, const SyncBadge()),
    );

    expect(find.text('Error de sincronización'), findsOneWidget);
    expect(find.text('REINTENTAR'), findsOneWidget);
  });
}

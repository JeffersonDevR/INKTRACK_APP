import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:drift/native.dart';
import 'package:InkTrack/core/data/local/database.dart';
import 'package:InkTrack/core/services/sync/batch_uploader.dart';
import 'package:InkTrack/core/services/sync/sync_strategy.dart';

class MockSupabase extends Mock implements SupabaseClient {}

/// A mock SyncStrategy that records calls and can be configured to fail.
class MockSyncStrategy extends Mock implements SyncStrategy {
  int uploadFailures = 0;
  int uploadCallCount = 0;
  final List<String> syncedIds = [];

  @override
  String get tableName => 'test_table';

  @override
  Future<List<Map<String, dynamic>>> getPendingRows(AppDatabase db) async {
    return List.generate(10, (i) => {'id': 'id_$i'});
  }

  @override
  Future<void> markAsSynced(AppDatabase db, List<String> ids) async {
    syncedIds.addAll(ids);
  }

  @override
  Future<bool> uploadBatch(
    SupabaseClient client,
    List<Map<String, dynamic>> rows,
  ) async {
    uploadCallCount++;
    if (uploadCallCount <= uploadFailures) {
      throw Exception('Transient failure #$uploadCallCount');
    }
    return true;
  }

  @override
  Future<int> downloadAndMerge(AppDatabase db, SupabaseClient client) async {
    return 0;
  }
}

void main() {
  late AppDatabase db;
  late SupabaseClient client;

  setUp(() {
    db = AppDatabase.withExecutor(NativeDatabase.memory());
    client = MockSupabase();
  });

  tearDown(() async {
    await db.close();
  });

  group('BatchUploader', () {
    late MockSyncStrategy strategy;
    late BatchUploader uploader;

    setUp(() {
      strategy = MockSyncStrategy();
    });

    test('uploads all pending records when no failures occur', () async {
      strategy.uploadFailures = 0;
      uploader = BatchUploader(batchSize: 5);

      final uploaded = await uploader.uploadPending(db, client, strategy);

      expect(uploaded, equals(10));
      // With batch size 5, should be called 2 times
      expect(strategy.uploadCallCount, equals(2));
      // All 10 IDs should be marked synced
      expect(strategy.syncedIds.length, equals(10));
    });

    test(
      'retries on transient failure and succeeds within max retries',
      () async {
        strategy.uploadFailures = 2; // fail first 2 calls
        uploader = BatchUploader(
          batchSize: 10, // single batch
          maxRetries: 3,
          initialDelay: const Duration(milliseconds: 10),
        );

        final uploaded = await uploader.uploadPending(db, client, strategy);

        expect(uploaded, equals(10));
        // Failed twice, succeeded on 3rd attempt
        expect(strategy.uploadCallCount, equals(3));
        expect(strategy.syncedIds.length, equals(10));
      },
    );

    test('exhausts retries and rethrows when all attempts fail', () async {
      strategy.uploadFailures = 5; // always fail
      uploader = BatchUploader(
        batchSize: 10,
        maxRetries: 3,
        initialDelay: const Duration(milliseconds: 10),
      );

      await expectLater(
        uploader.uploadPending(db, client, strategy),
        throwsException,
      );

      // Should have tried 3 times
      expect(strategy.uploadCallCount, equals(3));
      // No records should be marked synced
      expect(strategy.syncedIds, isEmpty);
    });
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:InkTrack/core/services/sync/conflict_resolver.dart';

void main() {
  group('ConflictResolver.shouldSkipDownload', () {
    test(
      'returns false when record does not exist locally (null syncStatus)',
      () {
        expect(
          ConflictResolver.shouldSkipDownload(
            localSyncStatus: null,
            localLastSyncedAt: null,
            serverUpdatedAt: DateTime(2025, 6, 1),
          ),
          isFalse,
        );
      },
    );

    test(
      'returns true when local record has pending_upload status',
      () {
        expect(
          ConflictResolver.shouldSkipDownload(
            localSyncStatus: 'pending_upload',
            localLastSyncedAt: DateTime(2025, 1, 1),
            serverUpdatedAt: DateTime(2025, 6, 1), // server newer
          ),
          isTrue,
        );
      },
    );

    test(
      'returns true when local record has pending (default) status',
      () {
        expect(
          ConflictResolver.shouldSkipDownload(
            localSyncStatus: 'pending',
            localLastSyncedAt: DateTime(2025, 1, 1),
            serverUpdatedAt: DateTime(2025, 6, 1), // server newer
          ),
          isTrue,
        );
      },
    );

    test(
      'returns false when server updated_at is newer and local is synced',
      () {
        expect(
          ConflictResolver.shouldSkipDownload(
            localSyncStatus: 'synced',
            localLastSyncedAt: DateTime(2025, 1, 1, 10, 0, 0), // older
            serverUpdatedAt: DateTime(2025, 6, 1, 10, 0, 0), // newer
          ),
          isFalse,
        );
      },
    );

    test(
      'returns true when local lastSyncedAt is newer than server updated_at',
      () {
        expect(
          ConflictResolver.shouldSkipDownload(
            localSyncStatus: 'synced',
            localLastSyncedAt: DateTime(2025, 6, 15, 10, 0, 0), // newer
            serverUpdatedAt: DateTime(2025, 1, 1, 10, 0, 0), // older
          ),
          isTrue,
        );
      },
    );

    test(
      'returns false when server updated_at is null (accept server)',
      () {
        expect(
          ConflictResolver.shouldSkipDownload(
            localSyncStatus: 'synced',
            localLastSyncedAt: DateTime(2025, 6, 1),
            serverUpdatedAt: null,
          ),
          isFalse,
        );
      },
    );

    test(
      'returns false when local lastSyncedAt is null and server has update',
      () {
        expect(
          ConflictResolver.shouldSkipDownload(
            localSyncStatus: 'synced',
            localLastSyncedAt: null,
            serverUpdatedAt: DateTime(2025, 6, 1),
          ),
          isFalse,
        );
      },
    );
  });

  group('ConflictResolver.parseDateTime', () {
    test('parses ISO 8601 string', () {
      final result = ConflictResolver.parseDateTime('2025-06-01T10:00:00Z');
      expect(result, isNotNull);
      expect(result!.year, equals(2025));
      expect(result.month, equals(6));
      expect(result.day, equals(1));
    });

    test('passes through DateTime', () {
      final dt = DateTime(2025, 6, 1);
      expect(ConflictResolver.parseDateTime(dt), equals(dt));
    });

    test('returns null for null', () {
      expect(ConflictResolver.parseDateTime(null), isNull);
    });

    test('returns null for invalid string', () {
      expect(ConflictResolver.parseDateTime('not-a-date'), isNull);
    });
  });
}

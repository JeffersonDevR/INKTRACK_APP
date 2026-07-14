import 'package:flutter_test/flutter_test.dart';
import 'package:InkTrack/core/utils/id_utils.dart';

void main() {
  group('IdUtils', () {
    test('generateId returns a valid UUID v4 string', () {
      final id = IdUtils.generateId();

      expect(id, isNotEmpty);
      expect(id.length, equals(36));
      expect(
        id,
        matches(
          r'^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$',
        ),
      );
    });

    test('generateId returns unique values across invocations', () {
      final ids = <String>{};
      for (var i = 0; i < 100; i++) {
        ids.add(IdUtils.generateId());
      }
      expect(ids.length, equals(100));
    });
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:InkTrack/core/utils/security_utils.dart';

void main() {
  group('SecurityUtils.maskSensitiveData', () {
    test(
      'BUG-001: masks all but the last N characters with asterisks',
      () {
        expect(
          SecurityUtils.maskSensitiveData(
            '1234567890123456',
            visibleChars: 4,
          ),
          equals('************3456'),
        );
      },
    );

    test(
      'returns full input when shorter than visibleChars',
      () {
        expect(
          SecurityUtils.maskSensitiveData('abc', visibleChars: 4),
          equals('abc'),
        );
      },
    );

    test(
      'returns full input when exactly visibleChars length',
      () {
        expect(
          SecurityUtils.maskSensitiveData('1234', visibleChars: 4),
          equals('1234'),
        );
      },
    );
  });
}

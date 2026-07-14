import 'package:flutter_test/flutter_test.dart';
import 'package:bcrypt/bcrypt.dart';

void main() {
  group('Manager PIN bcrypt verification tests', () {
    test('BCrypt verify works as expected for managers override', () {
      final pin = '4321';
      final salt = BCrypt.gensalt();
      final hashedPin = BCrypt.hashpw(pin, salt);

      // Correct PIN matches
      expect(BCrypt.checkpw(pin, hashedPin), isTrue);

      // Incorrect PIN fails
      expect(BCrypt.checkpw('1111', hashedPin), isFalse);
    });
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:InkTrack/core/utils/gs1_barcode_parser.dart';

void main() {
  late Gs1BarcodeParser parser;

  setUp(() {
    parser = Gs1BarcodeParser();
  });

  group('Gs1BarcodeParser — weight codes (AI 31xx)', () {
    test('weight code with 3 decimal places parses to quantity', () {
      final code = '3103012501231';
      final result = parser.parse(code);

      expect(result.isWeight, isTrue);
      expect(result.weightKg, 1.25);
      expect(result.productId, '123');
    });

    test('weight code with 0 decimal places', () {
      final code = '3100012501231';
      final result = parser.parse(code);

      expect(result.isWeight, isTrue);
      expect(result.weightKg, 1250.0);
    });

    test('weight code with 1 decimal place', () {
      final code = '3101012501231';
      final result = parser.parse(code);

      expect(result.isWeight, isTrue);
      expect(result.weightKg, 125.0);
    });

    test('weight code with 2 decimal places', () {
      final code = '3102012501231';
      final result = parser.parse(code);

      expect(result.isWeight, isTrue);
      expect(result.weightKg, closeTo(12.5, 0.01));
    });
  });

  group('Gs1BarcodeParser — price codes (AI 32xx)', () {
    test('price code with 2 decimal places (cents) parses to embedded price', () {
      final code = '3202012501231';
      final result = parser.parse(code);

      expect(result.isPrice, isTrue);
      expect(result.price, 12.5);
      expect(result.productId, '123');
    });

    test('price code with 0 decimal places', () {
      final code = '3200012501231';
      final result = parser.parse(code);

      expect(result.isPrice, isTrue);
      expect(result.price, 1250.0);
    });

    test('price code with 4 decimal places', () {
      final code = '3204012501231';
      final result = parser.parse(code);

      expect(result.isPrice, isTrue);
      expect(result.price, closeTo(0.125, 0.0001));
    });
  });

  group('Gs1BarcodeParser — error cases', () {
    test('non-GS1 barcode throws Gs1ParseException', () {
      expect(
        () => parser.parse('7701234567890'),
        throwsA(isA<Gs1ParseException>()),
      );
    });

    test('too-short barcode throws Gs1ParseException', () {
      expect(
        () => parser.parse('31031'),
        throwsA(isA<Gs1ParseException>()),
      );
    });

    test('non-digit characters throw Gs1ParseException', () {
      expect(
        () => parser.parse('31AB012501231'),
        throwsA(isA<Gs1ParseException>()),
      );
    });

    test('empty string throws Gs1ParseException', () {
      expect(
        () => parser.parse(''),
        throwsA(isA<Gs1ParseException>()),
      );
    });

    test('AI starting with 33 throws Gs1ParseException', () {
      expect(
        () => parser.parse('3300012501231'),
        throwsA(isA<Gs1ParseException>()),
      );
    });
  });
}

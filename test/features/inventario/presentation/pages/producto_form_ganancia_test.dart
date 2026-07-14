import 'package:flutter_test/flutter_test.dart';
import 'package:InkTrack/core/theme/app_theme.dart';
import 'package:InkTrack/features/inventario/presentation/pages/producto_form_page.dart';

void main() {
  group('calcularGananciaInfo', () {
    test('returns null when sell price is empty', () {
      expect(calcularGananciaInfo('', '100'), isNull);
    });

    test('returns null when cost price is empty', () {
      expect(calcularGananciaInfo('100', ''), isNull);
    });

    test('returns null when both prices are empty', () {
      expect(calcularGananciaInfo('', ''), isNull);
    });

    test('returns positive profit when sell price is greater than cost', () {
      final info = calcularGananciaInfo('150', '100')!;

      expect(info.isPositive, isTrue);
      expect(info.delta, 50.0);
      expect(info.color, AppTheme.successColor);
    });

    test('returns negative delta and error color when cost equals sell price', () {
      final info = calcularGananciaInfo('100', '100')!;

      expect(info.isPositive, isFalse);
      expect(info.delta, 0.0);
      expect(info.color, AppTheme.errorColor);
    });

    test('returns loss when sell price is lower than cost', () {
      final info = calcularGananciaInfo('80', '100')!;

      expect(info.isPositive, isFalse);
      expect(info.delta, -20.0);
      expect(info.color, AppTheme.errorColor);
    });

    test('parses comma decimal separator', () {
      final info = calcularGananciaInfo('150,50', '100,25')!;

      expect(info.isPositive, isTrue);
      expect(info.delta, closeTo(50.25, 0.001));
    });

    test('treats invalid input as zero', () {
      final info = calcularGananciaInfo('abc', '50')!;

      expect(info.isPositive, isFalse);
      expect(info.delta, -50.0);
      expect(info.color, AppTheme.errorColor);
    });
  });
}

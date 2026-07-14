import 'package:flutter_test/flutter_test.dart';
import 'package:InkTrack/core/utils/number_formatter.dart';

void main() {
  group('NumberFormatter Tests', () {
    test('formatCurrency should show full values for Colombian Pesos', () {
      expect(NumberFormatter.formatCurrency(1200), contains('1.200'));
      expect(NumberFormatter.formatCurrency(50000), contains('50.000'));
    });

    test('formatCompact should NOT compact values under 100M', () {
      expect(NumberFormatter.formatCompact(1200), contains('1.200'));
      expect(NumberFormatter.formatCompact(1500000), contains('1.5M'));
    });

    test('formatCompact should compact extremely large values', () {
      expect(NumberFormatter.formatCompact(150000000), contains('150M'));
    });
  });
}

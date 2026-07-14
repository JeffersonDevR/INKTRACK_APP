import 'package:flutter_test/flutter_test.dart';
import 'package:InkTrack/core/utils/ocr_parser.dart';

void main() {
  group('OcrParser Tests', () {
    test('extractAmounts should find various price formats', () {
      final text = r'Subtotal: $150.00\nIVA: 32,50\nTOTAL: 1.250,55';
      final amounts = OcrParser.extractAmounts(text);
      
      expect(amounts, contains(150.0));
      expect(amounts, contains(32.5));
      expect(amounts, contains(1250.55));
    });

    test('findTotal should prefer lines with total keyword', () {
      const text = 'Item 1: 500\nItem 2: 300\nTOTAL A PAGAR: 800.00';
      final total = OcrParser.findTotal(text);
      
      expect(total, 800.0);
    });

    test('findTotal should fallback to biggest amount if no keyword', () {
      const text = '100.00\n250.50\n50.00';
      final total = OcrParser.findTotal(text);
      
      expect(total, 250.5);
    });

    test('handle Spanish dot/comma format correctly', () {
      expect(OcrParser.extractAmounts('1.500,00').first, 1500.0);
      expect(OcrParser.extractAmounts('1,500.00').first, 1500.0);
    });

    group('findClientName', () {
      test('should find client name after keyword "cliente"', () {
        const text = 'FACTURA\nCLIENTE: Juan Perez\nTOTAL: 150.00';
        expect(OcrParser.findClientName(text), equals('Juan Perez'));
      });

      test('should find client name after keyword "para:"', () {
        const text = 'Nota de Venta\nPara: Maria Garcia\nImporte: 50.00';
        expect(OcrParser.findClientName(text), equals('Maria Garcia'));
      });

      test('should find client name on the next line if current line only has keyword', () {
        // Note: 'Vendido a' is not in my initial list but 'Nombre', 'Cliente', 'Para', 'Atn', etc are.
        // Let's test with 'Nombre'
        const text2 = 'Nombre:\nSebastian Won\nDirección: Calle 123';
        expect(OcrParser.findClientName(text2), equals('Sebastian Won'));
      });

      test('should clean punctuation from the name', () {
        const text = 'CLIENTE: "Lucas Modric."';
        expect(OcrParser.findClientName(text), equals('Lucas Modric'));
      });

      test('should return null if no client name found', () {
        const text = 'Simple receipt\nTotal: 100\nNo keywords here';
        expect(OcrParser.findClientName(text), isNull);
      });
    });
  });
}

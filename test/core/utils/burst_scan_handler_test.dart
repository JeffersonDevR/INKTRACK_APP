import 'package:flutter_test/flutter_test.dart';
import 'package:InkTrack/core/utils/burst_scan_handler.dart';

void main() {
  group('BurstScanHandler — debounce', () {
    test('first scan always processes', () {
      final handler = BurstScanHandler();
      expect(handler.shouldProcess('7701234567890'), isTrue);
    });

    test('same code within debounce window does not process', () {
      final handler = BurstScanHandler(
        debounceWindow: const Duration(milliseconds: 250),
      );
      expect(handler.shouldProcess('7701234567890'), isTrue);
      expect(handler.shouldProcess('7701234567890'), isFalse,
          reason: 'Same code within 250ms should be debounced');
    });

    test('different code within debounce window processes', () {
      final handler = BurstScanHandler(
        debounceWindow: const Duration(milliseconds: 250),
      );
      expect(handler.shouldProcess('7701234567890'), isTrue);
      expect(handler.shouldProcess('7709876543210'), isTrue,
          reason: 'Different code should not be debounced');
    });

    test('reset clears debounce state', () {
      final handler = BurstScanHandler();
      handler.shouldProcess('7701234567890');
      handler.reset();
      expect(handler.shouldProcess('7701234567890'), isTrue,
          reason: 'After reset, same code should process again');
    });
  });

  group('BurstScanHandler — increment or add', () {
    test('repeated scan increments quantity', () {
      final items = <BurstScanResult>[
        BurstScanResult(
          productoId: 'prod-1',
          nombre: 'Arroz 1kg',
          cantidad: 1,
          precioUnitario: 3200,
        ),
      ];

      final result = BurstScanHandler.incrementOrAdd(
        items,
        'prod-1',
        'Arroz 1kg',
        3200,
      );

      expect(result.length, 1);
      expect(result.first.cantidad, 2,
          reason: 'Repeated scan should increment cantidad by 1');
    });

    test('new product adds a new item', () {
      final items = <BurstScanResult>[
        BurstScanResult(
          productoId: 'prod-1',
          nombre: 'Arroz 1kg',
          cantidad: 3,
          precioUnitario: 3200,
        ),
      ];

      final result = BurstScanHandler.incrementOrAdd(
        items,
        'prod-2',
        'Aceite 900ml',
        8500,
      );

      expect(result.length, 2);
      expect(result.last.productoId, 'prod-2');
      expect(result.last.cantidad, 1);
    });

    test('debounced double-detection does not double-count', () {
      final handler = BurstScanHandler(
        debounceWindow: const Duration(milliseconds: 250),
      );
      var items = <BurstScanResult>[];

      final code = '7701234567890';

      // First detection processes
      if (handler.shouldProcess(code)) {
        items = BurstScanHandler.incrementOrAdd(
          items,
          'prod-1',
          'Arroz 1kg',
          3200,
        );
      }

      // Second detection within debounce window — should NOT process
      if (handler.shouldProcess(code)) {
        items = BurstScanHandler.incrementOrAdd(
          items,
          'prod-1',
          'Arroz 1kg',
          3200,
        );
      }

      expect(items.length, 1);
      expect(items.first.cantidad, 1,
          reason: 'Debounced double-detection should not double-count');
    });
  });
}

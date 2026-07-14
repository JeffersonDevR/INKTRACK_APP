// test/features/proveedores/proveedor_model_test.dart
// TDD RED: spec for Proveedor model with l10n-aware diasVisitaShort

import 'package:flutter_test/flutter_test.dart';
import 'package:InkTrack/features/proveedores/data/models/proveedor.dart';

void main() {
  group('Proveedor model (task 1.5)', () {
    test('diasVisitaShort returns day abbreviations for specific days', () {
      final proveedor = Proveedor(
        id: 'p1',
        nombre: 'Test',
        telefono: '123',
        diasVisita: ['Lunes', 'Miércoles', 'Viernes'],
      );

      final result = proveedor.diasVisitaShort;

      expect(result, contains('Lun'));
      expect(result, contains('Mié'));
      expect(result, contains('Vie'));
    });

    test('diasVisitaShort returns default day name when not in map', () {
      final proveedor = Proveedor(
        id: 'p2',
        nombre: 'Test',
        telefono: '123',
        diasVisita: ['UnknownDay'],
      );

      expect(proveedor.diasVisitaShort, equals('UnknownDay'));
    });

    test('diasVisitaShort with periodoVisita=1 shows monthly format', () {
      final proveedor = Proveedor(
        id: 'p3',
        nombre: 'Test',
        telefono: '123',
        diasVisita: [],
        periodoVisita: 1,
      );

      expect(proveedor.diasVisitaShort, equals('Cada mes'));
    });

    test('diasVisitaShort with periodoVisita > 1 shows N-month format', () {
      final proveedor = Proveedor(
        id: 'p4',
        nombre: 'Test',
        telefono: '123',
        diasVisita: [],
        periodoVisita: 3,
      );

      expect(proveedor.diasVisitaShort, equals('Cada 3 meses'));
    });
  });
}

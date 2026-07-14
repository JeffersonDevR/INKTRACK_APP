// test/core/services/reports/report_filters_test.dart
// Chain 6 — feat/m4-reportes-filtros-preview
// TDD anchor: "filters passed via DTO", "critical inventory valorized uses precioCompra"

import 'package:flutter_test/flutter_test.dart';
import 'package:InkTrack/core/services/reports/report_filters.dart';

void main() {
  group('ReportFilters DTO', () {
    test('default instance has all filters disabled', () {
      final filters = ReportFilters();
      expect(filters.soloDeudores, isFalse);
      expect(filters.abonosDelMes, isFalse);
      expect(filters.topVendidos, isFalse);
      expect(filters.inventarioCriticoValorizado, isFalse);
      expect(filters.incluirCosto, isFalse);
      expect(filters.startDate, isNull);
      expect(filters.endDate, isNull);
      expect(filters.clienteId, isNull);
      expect(filters.productoId, isNull);
      expect(filters.topN, isNull);
    });

    test('copyWith updates specified fields', () {
      final filters = ReportFilters().copyWith(
        soloDeudores: true,
        topN: 10,
        incluirCosto: true,
      );
      expect(filters.soloDeudores, isTrue);
      expect(filters.topN, equals(10));
      expect(filters.incluirCosto, isTrue);
      expect(filters.abonosDelMes, isFalse); // unchanged
    });
  });
}

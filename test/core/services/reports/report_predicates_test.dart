// test/core/services/reports/report_predicates_test.dart
// Chain 6 — feat/m4-reportes-filtros-preview

import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:InkTrack/core/services/reports/report_filters.dart';
import 'package:InkTrack/core/services/reports/report_predicates.dart';
import 'package:InkTrack/core/services/reports/mas_vendidos_aggregator.dart';
import 'package:InkTrack/features/inventario/data/models/producto.dart';
import 'package:InkTrack/features/ventas/data/models/venta.dart';
import 'package:InkTrack/features/clientes/data/models/cliente.dart';

Producto makeProducto({
  required String id,
  int cantidad = 10,
  int stockMinimo = 5,
  double? precioCompra,
  double precioVenta = 1000,
}) {
  return Producto(
    id: id,
    nombre: 'Producto $id',
    cantidad: cantidad,
    stockMinimo: stockMinimo,
    precioCompra: precioCompra,
    precioVenta: precioVenta,
    categoria: 'cat',
    proveedorId: 'prov',
  );
}

Venta makeVenta({
  required String id,
  required DateTime fecha,
  required List<Map<String, dynamic>> productos,
}) {
  return Venta(
    id: id,
    fecha: fecha,
    monto: 0,
    productosJson: jsonEncode(productos),
    clienteId: 'cliente1',
  );
}

void main() {
  group('ReportPredicates (task 6.4 & 6.2)', () {
    test('soloDeudores returns true only for clients with positive debt (task 6.2)', () {
      final filters = ReportFilters(soloDeudores: true);
      
      final debtor = Cliente(id: 'c1', nombre: 'Debtor', telefono: '123', saldoPendiente: 500);
      final paid = Cliente(id: 'c2', nombre: 'Paid', telefono: '123', saldoPendiente: 0);
      final negative = Cliente(id: 'c3', nombre: 'Overpaid', telefono: '123', saldoPendiente: -100);

      expect(ReportPredicates.soloDeudores(debtor, filters), isTrue);
      expect(ReportPredicates.soloDeudores(paid, filters), isFalse);
      expect(ReportPredicates.soloDeudores(negative, filters), isFalse);
    });

    test('inventarioCriticoValorizado uses precioCompra and stock (task 6.4)', () {
      final filters = ReportFilters(inventarioCriticoValorizado: true);

      // cantidad=2, stockMinimo=5, precioCompra=500, precioVenta=800 -> should appear
      final p1 = makeProducto(id: 'p1', cantidad: 2, stockMinimo: 5, precioCompra: 500, precioVenta: 800);
      // Not critical stock
      final p2 = makeProducto(id: 'p2', cantidad: 10, stockMinimo: 5, precioCompra: 500);
      // No valid cost
      final p3 = makeProducto(id: 'p3', cantidad: 2, stockMinimo: 5, precioCompra: null);
      final p4 = makeProducto(id: 'p4', cantidad: 2, stockMinimo: 5, precioCompra: 0);

      expect(ReportPredicates.inventarioCriticoValorizado(p1, filters), isTrue);
      expect(ReportPredicates.inventarioCriticoValorizado(p2, filters), isFalse);
      expect(ReportPredicates.inventarioCriticoValorizado(p3, filters), isFalse);
      expect(ReportPredicates.inventarioCriticoValorizado(p4, filters), isFalse);
    });
  });

  group('MasVendidosAggregator (task 6.5)', () {
    test('aggregates top sold products correctly', () {
      final filters = ReportFilters(topN: 1);
      final pA = makeProducto(id: 'A');
      final pB = makeProducto(id: 'B');

      final v1 = makeVenta(
        id: 'v1',
        fecha: DateTime.now(),
        productos: [
          {'productoId': 'A', 'cantidad': 30, 'precioUnitario': 100},
          {'productoId': 'B', 'cantidad': 10, 'precioUnitario': 100},
        ],
      );
      final v2 = makeVenta(
        id: 'v2',
        fecha: DateTime.now(),
        productos: [
          {'productoId': 'A', 'cantidad': 20, 'precioUnitario': 100},
        ],
      );

      final result = MasVendidosAggregator.aggregate([v1, v2], [pA, pB], filters: filters);

      expect(result.length, equals(1));
      expect(result.first.producto.id, equals('A'));
      expect(result.first.cantidadVendida, equals(50));
    });
  });
}

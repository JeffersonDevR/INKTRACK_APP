// lib/core/services/reports/mas_vendidos_aggregator.dart
import 'dart:convert';
import 'package:InkTrack/features/ventas/data/models/venta.dart';
import 'package:InkTrack/features/inventario/data/models/producto.dart';
import 'package:InkTrack/core/services/reports/report_filters.dart';
import 'package:InkTrack/core/services/reports/report_predicates.dart';

class VentaProductoAgregado {
  final Producto producto;
  final int cantidadVendida;
  final double ingresosGenerados;

  VentaProductoAgregado({
    required this.producto,
    required this.cantidadVendida,
    required this.ingresosGenerados,
  });
}

class MasVendidosAggregator {
  static List<VentaProductoAgregado> aggregate(
    List<Venta> ventas,
    List<Producto> productos, {
    required ReportFilters filters,
  }) {
    if (filters.topN == null || filters.topN! <= 0) return [];

    final ventasEnRango = ventas.where((v) => ReportPredicates.dateRange(v.fecha, filters));

    final Map<String, int> cantidadPorProducto = {};
    final Map<String, double> ingresosPorProducto = {};

    for (final venta in ventasEnRango) {
      if (venta.productosJson != null && venta.productosJson!.isNotEmpty) {
        try {
          final List<dynamic> productosRaw = jsonDecode(venta.productosJson!);
          for (final item in productosRaw) {
            final id = item['productoId'] as String;
            final cantidad = item['cantidad'] as int;
            final precioUnitario = (item['precioUnitario'] as num).toDouble();

            cantidadPorProducto[id] = (cantidadPorProducto[id] ?? 0) + cantidad;
            ingresosPorProducto[id] = (ingresosPorProducto[id] ?? 0.0) + (cantidad * precioUnitario);
          }
        } catch (e) {
          // Skip invalid JSON
        }
      }
    }

    final List<VentaProductoAgregado> agregados = [];
    for (final entry in cantidadPorProducto.entries) {
      final id = entry.key;
      final producto = productos.where((p) => p.id == id).firstOrNull;
      if (producto != null) {
        agregados.add(
          VentaProductoAgregado(
            producto: producto,
            cantidadVendida: entry.value,
            ingresosGenerados: ingresosPorProducto[id] ?? 0.0,
          ),
        );
      }
    }

    agregados.sort((a, b) => b.cantidadVendida.compareTo(a.cantidadVendida));
    return agregados.take(filters.topN!).toList();
  }
}

// lib/core/services/reports/report_predicates.dart
import 'package:InkTrack/core/services/reports/report_filters.dart';
import 'package:InkTrack/features/clientes/data/models/cliente.dart';
import 'package:InkTrack/features/movimientos/data/models/movimiento.dart';
import 'package:InkTrack/features/inventario/data/models/producto.dart';

class ReportPredicates {
  static bool soloDeudores(Cliente cliente, ReportFilters filters) {
    if (!filters.soloDeudores) return true;
    return cliente.saldoPendiente > 0;
  }

  static bool abonosDelMes(Movimiento movimiento, ReportFilters filters) {
    if (!filters.abonosDelMes) return true;
    if (movimiento.categoria != 'Abonos') return false;
    final now = DateTime.now();
    return movimiento.fecha.year == now.year && movimiento.fecha.month == now.month;
  }

  static bool inventarioCriticoValorizado(Producto producto, ReportFilters filters) {
    if (!filters.inventarioCriticoValorizado) return true;
    // CRITICAL: per ADR-08 and Chain 0, this uses precioCompra
    // Must have a valid cost and be below or at minimum stock
    return producto.cantidad <= producto.stockMinimo && (producto.precioCompra ?? 0) > 0;
  }

  static bool topVendidos(Movimiento movimiento, ReportFilters filters) {
    if (!filters.topVendidos) return true;
    // When active, only show sales (ingresos) — conceptually "top sold" for movements
    return movimiento.tipo == MovimientoType.ingreso;
  }

  static bool dateRange(DateTime date, ReportFilters filters) {
    if (filters.startDate != null && date.isBefore(filters.startDate!)) return false;
    if (filters.endDate != null && date.isAfter(filters.endDate!)) return false;
    return true;
  }
}

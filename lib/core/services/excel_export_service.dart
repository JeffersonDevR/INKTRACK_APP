import 'dart:typed_data';
import 'package:excel/excel.dart';
import 'package:intl/intl.dart';
import 'package:InkTrack/features/movimientos/data/models/movimiento.dart';
import 'package:InkTrack/features/inventario/data/models/producto.dart';
import 'package:InkTrack/features/clientes/data/models/cliente.dart';
import 'package:InkTrack/core/services/reports/report_filters.dart';
import 'package:InkTrack/core/services/reports/report_predicates.dart';

class ExcelExportService {
  static final _dateFormat = DateFormat('dd/MM/yyyy HH:mm');
  static final _currencyFormat = NumberFormat.currency(
    symbol: '\$',
    decimalDigits: 0,
  );

  static Future<Uint8List> generateMovementsReport(
    List<Movimiento> movements, {
    ReportFilters? filters,
  }) async {
    final activeFilters = filters ?? const ReportFilters();
    final excel = Excel.createExcel();
    final sheet = excel['Movimientos'];

    final filteredMovements = movements.where((m) {
      if (!ReportPredicates.dateRange(m.fecha, activeFilters)) return false;
      if (!ReportPredicates.abonosDelMes(m, activeFilters)) return false;
      return true;
    }).toList();

    final totalIngresos = filteredMovements
        .where((m) => m.tipo == MovimientoType.ingreso)
        .fold(0.0, (sum, m) => sum + m.monto);

    final totalEgresos = filteredMovements
        .where((m) => m.tipo == MovimientoType.egreso)
        .fold(0.0, (sum, m) => sum + m.monto);

    sheet.appendRow([TextCellValue('INKTRACK - REPORTE DE MOVIMIENTOS')]);
    sheet.appendRow([]);

    if (activeFilters.startDate != null || activeFilters.endDate != null) {
      sheet.appendRow([
        TextCellValue(
          'Período: ${activeFilters.startDate != null ? _dateFormat.format(activeFilters.startDate!) : 'Inicio'} - ${activeFilters.endDate != null ? _dateFormat.format(activeFilters.endDate!) : 'Fin'}',
        ),
      ]);
      sheet.appendRow([]);
    }

    sheet.appendRow([TextCellValue('RESUMEN')]);
    sheet.appendRow([
      TextCellValue('Total Ingresos'),
      TextCellValue(_currencyFormat.format(totalIngresos)),
    ]);
    sheet.appendRow([
      TextCellValue('Total Egresos'),
      TextCellValue(_currencyFormat.format(totalEgresos)),
    ]);
    sheet.appendRow([
      TextCellValue('Balance'),
      TextCellValue(_currencyFormat.format(totalIngresos - totalEgresos)),
    ]);
    sheet.appendRow([]);
    sheet.appendRow([TextCellValue('DETALLE DE MOVIMIENTOS')]);
    sheet.appendRow([
      TextCellValue('Fecha'),
      TextCellValue('Tipo'),
      TextCellValue('Monto'),
      TextCellValue('Concepto'),
      TextCellValue('Categoría'),
    ]);

    for (final mov in filteredMovements) {
      sheet.appendRow([
        TextCellValue(_dateFormat.format(mov.fecha)),
        TextCellValue(_getTipoLabel(mov.tipo)),
        TextCellValue(mov.monto.toString()),
        TextCellValue(mov.concepto),
        TextCellValue(mov.categoria ?? '-'),
      ]);
    }

    return Uint8List.fromList(excel.encode()!);
  }

  static Future<Uint8List> generateInventoryReport(
    List<Producto> productos, {
    ReportFilters? filters,
  }) async {
    final activeFilters = filters ?? const ReportFilters();
    final excel = Excel.createExcel();
    final sheet = excel['Inventario'];

    final filteredProductos = productos.where((p) {
      if (!ReportPredicates.inventarioCriticoValorizado(p, activeFilters)) return false;
      return true;
    }).toList();

    final totalValor = filteredProductos.fold(
      0.0,
      (sum, p) => sum + ((activeFilters.inventarioCriticoValorizado ? (p.precioCompra ?? 0) : p.precioVenta) * p.cantidad),
    );
    final totalStock = filteredProductos.fold(0.0, (sum, p) => sum + p.cantidad);
    final bajoStock = filteredProductos.where((p) => p.stockBajo).length;

    sheet.appendRow([TextCellValue('INKTRACK - REPORTE DE INVENTARIO')]);
    sheet.appendRow([]);
    sheet.appendRow([TextCellValue('RESUMEN')]);
    sheet.appendRow([
      TextCellValue('Total Productos'),
      TextCellValue(filteredProductos.length.toString()),
    ]);
    sheet.appendRow([
      TextCellValue('Stock Total'),
      TextCellValue(totalStock.toString()),
    ]);
    sheet.appendRow([
      TextCellValue('Valor Total'),
      TextCellValue(_currencyFormat.format(totalValor)),
    ]);
    sheet.appendRow([
      TextCellValue('Productos Bajo Stock'),
      TextCellValue(bajoStock.toString()),
    ]);
    sheet.appendRow([]);
    sheet.appendRow([TextCellValue('DETALLE DE PRODUCTOS')]);
    sheet.appendRow([
      TextCellValue('Nombre'),
      TextCellValue('Categoría'),
      TextCellValue('Stock'),
      TextCellValue(activeFilters.inventarioCriticoValorizado ? 'Costo' : 'Precio'),
      TextCellValue('Valor Total'),
      TextCellValue('Stock Mínimo'),
      TextCellValue('Estado'),
    ]);

    for (final prod in filteredProductos) {
      sheet.appendRow([
        TextCellValue(prod.nombre),
        TextCellValue(prod.categoria),
        TextCellValue(prod.cantidad.toString()),
        TextCellValue(_currencyFormat.format(activeFilters.inventarioCriticoValorizado ? (prod.precioCompra ?? 0) : prod.precioVenta)),
        TextCellValue(_currencyFormat.format((activeFilters.inventarioCriticoValorizado ? (prod.precioCompra ?? 0) : prod.precioVenta) * prod.cantidad)),
        TextCellValue(prod.stockMinimo.toString()),
        TextCellValue(prod.stockBajo ? 'BAJO STOCK' : 'OK'),
      ]);
    }

    return Uint8List.fromList(excel.encode()!);
  }

  static Future<Uint8List> generateClientDebtReport(
    List<Cliente> clientes, {
    ReportFilters? filters,
  }) async {
    final activeFilters = filters ?? const ReportFilters();
    final excel = Excel.createExcel();
    final sheet = excel['Clientes'];

    final filteredClientes = clientes.where((c) {
      if (!ReportPredicates.soloDeudores(c, activeFilters)) return false;
      return true;
    }).toList();

    final totalDeuda = filteredClientes.fold(0.0, (sum, c) => sum + c.saldoPendiente);
    final conDeuda = filteredClientes.where((c) => c.saldoPendiente > 0).length;

    sheet.appendRow([TextCellValue('INKTRACK - REPORTE DE CLIENTES')]);
    sheet.appendRow([]);
    sheet.appendRow([TextCellValue('RESUMEN')]);
    sheet.appendRow([
      TextCellValue('Total Clientes'),
      TextCellValue(filteredClientes.length.toString()),
    ]);
    sheet.appendRow([
      TextCellValue('Clientes con Deuda'),
      TextCellValue(conDeuda.toString()),
    ]);
    sheet.appendRow([
      TextCellValue('Deuda Total'),
      TextCellValue(_currencyFormat.format(totalDeuda)),
    ]);
    sheet.appendRow([]);
    sheet.appendRow([TextCellValue('DETALLE DE CLIENTES')]);
    sheet.appendRow([
      TextCellValue('Nombre'),
      TextCellValue('Teléfono'),
      TextCellValue('Email'),
      TextCellValue('Acreedores'),
      TextCellValue('Saldo Pendiente'),
    ]);

    for (final cliente in filteredClientes) {
      sheet.appendRow([
        TextCellValue(cliente.nombre),
        TextCellValue(cliente.telefono),
        TextCellValue(cliente.email ?? ''),
        TextCellValue(cliente.esFiado ? 'Sí' : 'No'),
        TextCellValue(_currencyFormat.format(cliente.saldoPendiente)),
      ]);
    }

    return Uint8List.fromList(excel.encode()!);
  }

  static String _getTipoLabel(MovimientoType tipo) {
    switch (tipo) {
      case MovimientoType.ingreso:
        return 'Ingreso';
      case MovimientoType.egreso:
        return 'Egreso';
      case MovimientoType.actividad:
        return 'Actividad';
    }
  }
}

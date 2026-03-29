import 'dart:typed_data';
import 'package:excel/excel.dart';
import 'package:intl/intl.dart';
import 'package:InkTrack/features/movimientos/data/models/movimiento.dart';
import 'package:InkTrack/features/inventario/data/models/producto.dart';
import 'package:InkTrack/features/clientes/data/models/cliente.dart';

class ExcelExportService {
  static final _dateFormat = DateFormat('dd/MM/yyyy HH:mm');
  static final _currencyFormat = NumberFormat.currency(
    symbol: '\$',
    decimalDigits: 0,
  );

  static Future<Uint8List> generateMovementsReport(
    List<Movimiento> movements, {
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final excel = Excel.createExcel();
    final sheet = excel['Movimientos'];

    final filteredMovements = movements.where((m) {
      if (startDate != null && m.fecha.isBefore(startDate)) return false;
      if (endDate != null && m.fecha.isAfter(endDate)) return false;
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

    if (startDate != null || endDate != null) {
      sheet.appendRow([
        TextCellValue(
          'Período: ${startDate != null ? _dateFormat.format(startDate) : 'Inicio'} - ${endDate != null ? _dateFormat.format(endDate) : 'Fin'}',
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
    List<Producto> productos,
  ) async {
    final excel = Excel.createExcel();
    final sheet = excel['Inventario'];

    final totalValor = productos.fold(
      0.0,
      (sum, p) => sum + (p.precio * p.cantidad),
    );
    final totalStock = productos.fold(0, (sum, p) => sum + p.cantidad);
    final bajoStock = productos.where((p) => p.stockBajo).length;

    sheet.appendRow([TextCellValue('INKTRACK - REPORTE DE INVENTARIO')]);
    sheet.appendRow([]);
    sheet.appendRow([TextCellValue('RESUMEN')]);
    sheet.appendRow([
      TextCellValue('Total Productos'),
      TextCellValue(productos.length.toString()),
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
      TextCellValue('Precio'),
      TextCellValue('Valor Total'),
      TextCellValue('Stock Mínimo'),
      TextCellValue('Estado'),
    ]);

    for (final prod in productos) {
      sheet.appendRow([
        TextCellValue(prod.nombre),
        TextCellValue(prod.categoria),
        TextCellValue(prod.cantidad.toString()),
        TextCellValue(_currencyFormat.format(prod.precio)),
        TextCellValue(_currencyFormat.format(prod.precio * prod.cantidad)),
        TextCellValue(prod.stockMinimo.toString()),
        TextCellValue(prod.stockBajo ? 'BAJO STOCK' : 'OK'),
      ]);
    }

    return Uint8List.fromList(excel.encode()!);
  }

  static Future<Uint8List> generateClientDebtReport(
    List<Cliente> clientes,
  ) async {
    final excel = Excel.createExcel();
    final sheet = excel['Clientes'];

    final totalDeuda = clientes.fold(0.0, (sum, c) => sum + c.saldoPendiente);
    final conDeuda = clientes.where((c) => c.saldoPendiente > 0).length;

    sheet.appendRow([TextCellValue('INKTRACK - REPORTE DE CLIENTES')]);
    sheet.appendRow([]);
    sheet.appendRow([TextCellValue('RESUMEN')]);
    sheet.appendRow([
      TextCellValue('Total Clientes'),
      TextCellValue(clientes.length.toString()),
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
      TextCellValue('Fiado'),
      TextCellValue('Saldo Pendiente'),
    ]);

    for (final cliente in clientes) {
      sheet.appendRow([
        TextCellValue(cliente.nombre),
        TextCellValue(cliente.telefono),
        TextCellValue(cliente.email),
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

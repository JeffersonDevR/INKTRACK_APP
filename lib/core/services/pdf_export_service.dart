import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';
import 'package:InkTrack/features/movimientos/data/models/movimiento.dart';
import 'package:InkTrack/features/inventario/data/models/producto.dart';
import 'package:InkTrack/features/clientes/data/models/cliente.dart';
import 'package:InkTrack/core/services/reports/report_filters.dart';
import 'package:InkTrack/core/services/reports/report_predicates.dart';

class PdfExportService {
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
    final pdf = pw.Document();

    final filteredMovements = movements.where((m) {
      if (!ReportPredicates.dateRange(m.fecha, activeFilters)) return false;
      if (!ReportPredicates.abonosDelMes(m, activeFilters)) return false;
      if (!ReportPredicates.topVendidos(m, activeFilters)) return false;
      // soloDeudores: when active, only show movements linked to a client
      if (activeFilters.soloDeudores && m.clienteId == null) return false;
      return true;
    }).toList();

    final totalIngresos = filteredMovements
        .where((m) => m.tipo == MovimientoType.ingreso)
        .fold(0.0, (sum, m) => sum + m.monto);

    final totalEgresos = filteredMovements
        .where((m) => m.tipo == MovimientoType.egreso)
        .fold(0.0, (sum, m) => sum + m.monto);

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        header: (context) => _buildHeader(
          _reportTitle(activeFilters),
          activeFilters: activeFilters,
        ),
        footer: (context) => _buildFooter(context),
        build: (context) => [
          _buildKpiSection(totalIngresos, totalEgresos),
          pw.SizedBox(height: 20),
          _buildMovementsTable(filteredMovements),
        ],
      ),
    );

    return pdf.save();
  }

  static Future<Uint8List> generateInventoryReport(
    List<Producto> productos, {
    ReportFilters? filters,
  }) async {
    final activeFilters = filters ?? const ReportFilters();
    final pdf = pw.Document();

    final filteredProductos = productos.where((p) {
      if (!ReportPredicates.inventarioCriticoValorizado(p, activeFilters)) return false;
      return true;
    }).toList();

    final totalValor = filteredProductos.fold(
      0.0,
      (sum, p) => sum + ((activeFilters.inventarioCriticoValorizado ? (p.precioCompra ?? 0) : p.precioVenta) * p.cantidad),
    );
    final totalStock = filteredProductos.fold(0.0, (sum, p) => sum + p.cantidad).toInt();
    final bajoStock = filteredProductos.where((p) => p.stockBajo).length;

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        header: (context) => _buildHeader('Reporte de Inventario'),
        footer: (context) => _buildFooter(context),
        build: (context) => [
          _buildInventoryKpiSection(
            filteredProductos.length,
            totalStock,
            totalValor,
            bajoStock,
          ),
          pw.SizedBox(height: 20),
          _buildInventoryTable(filteredProductos, includeCost: activeFilters.inventarioCriticoValorizado),
        ],
      ),
    );

    return pdf.save();
  }

  static Future<Uint8List> generateClientDebtReport(
    List<Cliente> clientes, {
    ReportFilters? filters,
  }) async {
    final activeFilters = filters ?? const ReportFilters();
    final pdf = pw.Document();

    final filteredClientes = clientes.where((c) {
      if (!ReportPredicates.soloDeudores(c, activeFilters)) return false;
      return true;
    }).toList();

    final totalDeuda = filteredClientes.fold(0.0, (sum, c) => sum + c.saldoPendiente);
    final conDeuda = filteredClientes.where((c) => c.saldoPendiente > 0).length;

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        header: (context) => _buildHeader('Reporte de Clientes'),
        footer: (context) => _buildFooter(context),
        build: (context) => [
          _buildClientKpiSection(filteredClientes.length, conDeuda, totalDeuda),
          pw.SizedBox(height: 20),
          _buildClientTable(filteredClientes),
        ],
      ),
    );

    return pdf.save();
  }

  /// Derives a contextual report title from active filters.
  static String _reportTitle(ReportFilters filters) {
    if (filters.soloDeudores) return 'Reporte de Deudores';
    if (filters.topVendidos) return 'Reporte de Top Vendidos';
    if (filters.abonosDelMes) return 'Reporte de Abonos del Mes';
    return 'Reporte de Movimientos';
  }

  /// Builds the comma-separated filter labels shown in the PDF header.
  static String _filterSummary(ReportFilters? filters) {
    if (filters == null) return '';
    final labels = <String>[];
    if (filters.soloDeudores) labels.add('Solo deudores');
    if (filters.topVendidos) labels.add('Top vendidos');
    if (filters.abonosDelMes) labels.add('Abonos del mes');
    return labels.isEmpty ? '' : 'Filtros: ${labels.join(" | ")}';
  }

  static pw.Widget _buildHeader(
    String title, {
    ReportFilters? activeFilters,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    final filterSummary = _filterSummary(activeFilters);
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text(
              'InkTrack',
              style: pw.TextStyle(
                fontSize: 24,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.indigo,
              ),
            ),
            pw.Text(
              _dateFormat.format(DateTime.now()),
              style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey600),
            ),
          ],
        ),
        pw.SizedBox(height: 8),
        pw.Text(
          title,
          style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
        ),
        if (startDate != null || endDate != null)
          pw.Padding(
            padding: const pw.EdgeInsets.only(top: 4),
            child: pw.Text(
              'Período: ${startDate != null ? _dateFormat.format(startDate) : 'Inicio'} - ${endDate != null ? _dateFormat.format(endDate) : 'Fin'}',
              style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey600),
            ),
          ),
        if (filterSummary.isNotEmpty)
          pw.Padding(
            padding: const pw.EdgeInsets.only(top: 4),
            child: pw.Text(
              filterSummary,
              style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey600),
            ),
          ),
        pw.Divider(color: PdfColors.indigo, thickness: 2),
        pw.SizedBox(height: 16),
      ],
    );
  }

  static pw.Widget _buildFooter(pw.Context context) {
    return pw.Container(
      alignment: pw.Alignment.centerRight,
      margin: const pw.EdgeInsets.only(top: 16),
      child: pw.Text(
        'Página ${context.pageNumber} de ${context.pagesCount}',
        style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey600),
      ),
    );
  }

  static pw.Widget _buildKpiSection(double ingresos, double egresos) {
    final balance = ingresos - egresos;
    return pw.Row(
      children: [
        pw.Expanded(
          child: _buildKpiCard(
            'Ingresos',
            _currencyFormat.format(ingresos),
            PdfColors.green,
          ),
        ),
        pw.SizedBox(width: 16),
        pw.Expanded(
          child: _buildKpiCard(
            'Egresos',
            _currencyFormat.format(egresos),
            PdfColors.red,
          ),
        ),
        pw.SizedBox(width: 16),
        pw.Expanded(
          child: _buildKpiCard(
            'Balance',
            _currencyFormat.format(balance),
            balance >= 0 ? PdfColors.green : PdfColors.red,
          ),
        ),
      ],
    );
  }

  static pw.Widget _buildInventoryKpiSection(
    int totalProductos,
    int totalStock,
    double totalValor,
    int bajoStock,
  ) {
    return pw.Row(
      children: [
        pw.Expanded(
          child: _buildKpiCard(
            'Productos',
            totalProductos.toString(),
            PdfColors.indigo,
          ),
        ),
        pw.SizedBox(width: 16),
        pw.Expanded(
          child: _buildKpiCard(
            'Stock Total',
            totalStock.toString(),
            PdfColors.blue,
          ),
        ),
        pw.SizedBox(width: 16),
        pw.Expanded(
          child: _buildKpiCard(
            'Valor',
            _currencyFormat.format(totalValor),
            PdfColors.green,
          ),
        ),
        pw.SizedBox(width: 16),
        pw.Expanded(
          child: _buildKpiCard(
            'Bajo Stock',
            bajoStock.toString(),
            PdfColors.orange,
          ),
        ),
      ],
    );
  }

  static pw.Widget _buildClientKpiSection(
    int total,
    int conDeuda,
    double totalDeuda,
  ) {
    return pw.Row(
      children: [
        pw.Expanded(
          child: _buildKpiCard(
            'Total Clientes',
            total.toString(),
            PdfColors.indigo,
          ),
        ),
        pw.SizedBox(width: 16),
        pw.Expanded(
          child: _buildKpiCard(
            'Con Deuda',
            conDeuda.toString(),
            PdfColors.orange,
          ),
        ),
        pw.SizedBox(width: 16),
        pw.Expanded(
          child: _buildKpiCard(
            'Deuda Total',
            _currencyFormat.format(totalDeuda),
            PdfColors.red,
          ),
        ),
      ],
    );
  }

  static pw.Widget _buildKpiCard(String label, String value, PdfColor color) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(12),
      decoration: pw.BoxDecoration(
        color: color.shade(0.1),
        borderRadius: pw.BorderRadius.circular(8),
        border: pw.Border.all(color: color, width: 1),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            label,
            style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey600),
          ),
          pw.SizedBox(height: 4),
          pw.Text(
            value,
            style: pw.TextStyle(
              fontSize: 16,
              fontWeight: pw.FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildMovementsTable(List<Movimiento> movements) {
    return pw.TableHelper.fromTextArray(
      headerStyle: pw.TextStyle(
        fontWeight: pw.FontWeight.bold,
        color: PdfColors.white,
      ),
      headerDecoration: const pw.BoxDecoration(color: PdfColors.indigo),
      cellPadding: const pw.EdgeInsets.all(8),
      headers: ['Fecha', 'Tipo', 'Monto', 'Concepto', 'Categoría'],
      data: movements
          .map(
            (m) => [
              _dateFormat.format(m.fecha),
              _getTipoLabel(m.tipo),
              _currencyFormat.format(m.monto),
              m.concepto,
              m.categoria ?? '-',
            ],
          )
          .toList(),
    );
  }

  static pw.Widget _buildInventoryTable(List<Producto> productos, {bool includeCost = false}) {
    return pw.TableHelper.fromTextArray(
      headerStyle: pw.TextStyle(
        fontWeight: pw.FontWeight.bold,
        color: PdfColors.white,
      ),
      headerDecoration: const pw.BoxDecoration(color: PdfColors.indigo),
      cellPadding: const pw.EdgeInsets.all(8),
      headers: ['Nombre', 'Categoría', 'Stock', includeCost ? 'Costo' : 'Precio', 'Valor Total'],
      data: productos
          .map(
            (p) => [
              p.nombre,
              p.categoria,
              p.cantidad.toString(),
              _currencyFormat.format(includeCost ? (p.precioCompra ?? 0) : p.precioVenta),
              _currencyFormat.format((includeCost ? (p.precioCompra ?? 0) : p.precioVenta) * p.cantidad),
            ],
          )
          .toList(),
    );
  }

  static pw.Widget _buildClientTable(List<Cliente> clientes) {
    return pw.TableHelper.fromTextArray(
      headerStyle: pw.TextStyle(
        fontWeight: pw.FontWeight.bold,
        color: PdfColors.white,
      ),
      headerDecoration: const pw.BoxDecoration(color: PdfColors.indigo),
      cellPadding: const pw.EdgeInsets.all(8),
      headers: ['Nombre', 'Teléfono', 'Acreedores', 'Saldo Pendiente'],
      data: clientes
          .map(
            (c) => [
              c.nombre,
              c.telefono,
              c.esFiado ? 'Sí' : 'No',
              _currencyFormat.format(c.saldoPendiente),
            ],
          )
          .toList(),
    );
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

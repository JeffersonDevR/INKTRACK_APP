import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:printing/printing.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:InkTrack/features/movimientos/presentation/viewmodels/movimientos_viewmodel.dart';
import 'package:InkTrack/features/movimientos/data/models/movimiento.dart'
    as mov_model;
import 'package:InkTrack/features/movimientos/presentation/pages/movimiento_form_page.dart';
import 'package:InkTrack/features/inventario/presentation/viewmodels/inventario_viewmodel.dart';
import 'package:InkTrack/core/theme/app_theme.dart';
import 'package:InkTrack/core/widgets/financial_summary_header.dart';
import 'package:InkTrack/core/widgets/trend_chart.dart';
import 'package:InkTrack/core/utils/number_formatter.dart';
import 'package:InkTrack/core/widgets/app_card.dart';
import 'package:InkTrack/core/services/pdf_export_service.dart';
import 'package:InkTrack/core/services/excel_export_service.dart';
import 'package:InkTrack/l10n/app_localizations.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Future<void> _selectDateRange(BuildContext context) async {
    final viewModel = context.read<MovimientosViewModel>();
    final now = DateTime.now();
    final initialRange = DateTimeRange(
      start: viewModel.startDateFilter ?? now.subtract(const Duration(days: 7)),
      end: viewModel.endDateFilter ?? now,
    );

    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      initialDateRange: initialRange,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppTheme.primaryColor,
              onPrimary: Colors.white,
              onSurface: AppTheme.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      viewModel.setDateFilter(picked.start, picked.end);
    }
  }

  Future<void> _exportPdf(BuildContext context) async {
    try {
      final movVM = context.read<MovimientosViewModel>();
      final l10n = AppLocalizations.of(context)!;
      
      final pdfData = await PdfExportService.generateMovementsReport(
        movVM.items,
        startDate: movVM.startDateFilter,
        endDate: movVM.endDateFilter,
      );
      
      final filename = 'reporte_movimientos_${DateFormat('yyyyMMdd').format(DateTime.now())}.pdf';
      await Printing.sharePdf(bytes: pdfData, filename: filename);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.pdfExportado(filename))),
        );
      }
    } catch (e) {
      if (context.mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.errorAlExportarPdf(e.toString()))),
        );
      }
    }
  }

  Future<void> _exportExcel(BuildContext context) async {
    try {
      final movVM = context.read<MovimientosViewModel>();
      final l10n = AppLocalizations.of(context)!;

      final excelData = await ExcelExportService.generateMovementsReport(
        movVM.items,
        startDate: movVM.startDateFilter,
        endDate: movVM.endDateFilter,
      );
      
      final filename = 'reporte_movimientos_${DateFormat('yyyyMMdd').format(DateTime.now())}.xlsx';
      
      await Share.shareXFiles([
        XFile.fromData(
          excelData,
          name: filename,
          mimeType: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
        ),
      ], text: 'InkTrack Report');

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.excelExportado(filename))),
        );
      }
    } catch (e) {
      if (context.mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.errorAlExportarExcel(e.toString()))),
        );
      }
    }
  }

  void _showMovimientoDetalle(BuildContext context, mov_model.Movimiento mov) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: isDark ? AppTheme.darkSurface : AppTheme.surfaceColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        ),
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 24),
                  decoration: BoxDecoration(
                    color: (isDark
                        ? AppTheme.darkBorder
                        : AppTheme.borderLightColor),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l10n.detalleMovimiento,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                    style: IconButton.styleFrom(
                      backgroundColor: isDark
                          ? AppTheme.darkCard
                          : AppTheme.backgroundColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              AppCard(
                margin: EdgeInsets.zero,
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    _DetailRow(label: l10n.concepto, value: mov.concepto),
                    const Divider(height: 32),
                    _DetailRow(
                      label: l10n.monto,
                      value: NumberFormatter.formatCompact(mov.monto),
                      valueStyle: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: mov.tipo == mov_model.MovimientoType.ingreso
                            ? AppTheme.successColor
                            : mov.tipo == mov_model.MovimientoType.egreso
                            ? AppTheme.errorColor
                            : null,
                      ),
                    ),
                    const Divider(height: 32),
                    _DetailRow(
                      label: l10n.fecha,
                      value: DateFormat('dd/MM/yyyy HH:mm').format(mov.fecha),
                    ),
                    if (mov.categoria != null) ...[
                      const Divider(height: 32),
                      _DetailRow(label: l10n.categoria, value: mov.categoria!),
                    ],
                    const Divider(height: 32),
                    _DetailRow(
                      label: l10n.tipo,
                      value: mov.tipo == mov_model.MovimientoType.ingreso
                          ? l10n.ingreso
                          : mov.tipo == mov_model.MovimientoType.egreso
                          ? l10n.egresoTipo
                          : l10n.actividad,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Map<String, double> _groupExpensesByCategory(
    List<mov_model.Movimiento> movs,
    AppLocalizations l10n,
  ) {
    final Map<String, double> data = {};
    for (var m in movs.where((m) => m.tipo == mov_model.MovimientoType.egreso)) {
      final cat = m.categoria ?? l10n.sinCategoria;
      data[cat] = (data[cat] ?? 0) + m.monto;
    }
    return data;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Consumer2<MovimientosViewModel, InventarioViewModel>(
        builder: (context, movVM, invVM, child) {
          final isFiltered = movVM.startDateFilter != null;
          
          final summary = FinancialSummaryHeader(
            title: isFiltered ? l10n.resultados : 'Reporte general',
            totalIngresos: isFiltered
                ? movVM.totalIngresosFiltered
                : movVM.totalIngresos,
            totalEgresos: isFiltered
                ? movVM.totalEgresosFiltered
                : movVM.totalEgresos,
            balance: isFiltered ? movVM.balanceFiltered : movVM.balance,
            startDate: movVM.startDateFilter,
            endDate: movVM.endDateFilter,
            onDateTap: () => _selectDateRange(context),
            label1: isFiltered ? l10n.ingreso : 'Ventas',
            label2: isFiltered ? l10n.egresoTipo : 'Gastos',
            label3: isFiltered ? l10n.balanceNeto : l10n.patrimonio,
            icon1: isFiltered ? Icons.trending_up : Icons.summarize_rounded,
            icon2: isFiltered ? Icons.trending_down : Icons.payments_rounded,
            icon3: Icons.account_balance_wallet_rounded,
            isCurrency3: true,
          );

          final historial =
              (movVM.startDateFilter == null
                    ? List<mov_model.Movimiento>.from(movVM.historialCompleto)
                    : List<mov_model.Movimiento>.from(movVM.filteredItems))
                ..sort((a, b) => b.fecha.compareTo(a.fecha));

          final expensesByCategory = _groupExpensesByCategory(
            movVM.startDateFilter == null ? movVM.historialCompleto : movVM.filteredItems,
            l10n,
          );
          final totalEgresos = movVM.startDateFilter == null 
              ? movVM.totalEgresos 
              : movVM.totalEgresosFiltered;

          return CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 24,
                ),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      summary,
                      const SizedBox(height: 16),
                      // Export Buttons
                      Row(
                        children: [
                          Expanded(
                            child: _ExportButton(
                              icon: Icons.picture_as_pdf_rounded,
                              label: 'PDF',
                              color: Colors.red.shade700,
                              onTap: () => _exportPdf(context),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _ExportButton(
                              icon: Icons.table_chart_rounded,
                              label: 'Excel',
                              color: Colors.green.shade700,
                              onTap: () => _exportExcel(context),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 28),
                      Text(
                        l10n.tendenciaFlujo,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(height: 16),
                      TrendChart(movimientos: movVM.historialCompleto),
                      const SizedBox(height: 24),
                      // Action Buttons (Ingreso/Egreso)
                      Row(
                        children: [
                          Expanded(
                            child: _ActionButton(
                              icon: Icons.add_circle_outline_rounded,
                              label: 'Ingreso',
                              color: AppTheme.successColor,
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const MovimientoFormPage(
                                    initialType: mov_model.MovimientoType.ingreso,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _ActionButton(
                              icon: Icons.remove_circle_outline_rounded,
                              label: 'Egreso',
                              color: AppTheme.errorColor,
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const MovimientoFormPage(
                                    initialType: mov_model.MovimientoType.egreso,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      // Pie Chart Integration
                      if (totalEgresos > 0) ...[
                        Text(
                          'Distribución de Gastos',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w800),
                        ),
                        const SizedBox(height: 16),
                        AppCard(
                          padding: const EdgeInsets.all(24),
                          child: _buildPieChart(
                            expensesByCategory,
                            totalEgresos,
                            isDark,
                            l10n: l10n,
                          ),
                        ),
                        const SizedBox(height: 32),
                      ],
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Últimas transacciones',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.w800),
                          ),
                          if (movVM.startDateFilter != null)
                            TextButton.icon(
                              onPressed: () => movVM.clearDateFilter(),
                              icon: const Icon(Icons.clear_rounded, size: 18),
                              label: Text(l10n.limpiar),
                              style: TextButton.styleFrom(
                                foregroundColor: AppTheme.errorColor,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Table Header
                      _HistoryTableHeader(),
                    ],
                  ),
                ),
              ),
              if (historial.isEmpty)
                SliverFillRemaining(hasScrollBody: false, child: _EmptyState())
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final mov = historial[index];
                        return _MovimientoTableRow(
                          mov: mov,
                          onTap: () => _showMovimientoDetalle(context, mov),
                        );
                      },
                      childCount:
                          historial.length > 10 && movVM.startDateFilter == null
                          ? 10
                          : historial.length,
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildPieChart(
    Map<String, double> categoryData,
    double total,
    bool isDark, {
    AppLocalizations? l10n,
  }) {
    final List<Color> colors = [
      AppTheme.primaryColor,
      AppTheme.secondaryColor,
      AppTheme.successColor,
      AppTheme.infoColor,
      Colors.purple,
      Colors.orange,
      Colors.teal,
    ];

    return Column(
      children: [
        SizedBox(
          height: 180,
          child: PieChart(
            PieChartData(
              sectionsSpace: 2,
              centerSpaceRadius: 35,
              sections: categoryData.entries.toList().asMap().entries.map((e) {
                final color = colors[e.key % colors.length];
                return PieChartSectionData(
                  color: color,
                  value: e.value.value,
                  title: '',
                  radius: 20,
                );
              }).toList(),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Wrap(
          spacing: 16,
          runSpacing: 10,
          alignment: WrapAlignment.center,
          children: categoryData.entries.toList().asMap().entries.map((e) {
            final color = colors[e.key % colors.length];
            final percentage = (e.value.value / total * 100).toStringAsFixed(0);
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  '${e.value.key} $percentage%',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppTheme.darkTextSecondary : AppTheme.textSecondary,
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _ExportButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ExportButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withValues(alpha: 0.2)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 18, color: color),
              const SizedBox(width: 8),
              Text(
                label,
                style: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              Icon(icon, color: Colors.white, size: 28),
              const SizedBox(height: 8),
              Text(
                label,
                style: GoogleFonts.plusJakartaSans(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HistoryTableHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textStyle = GoogleFonts.plusJakartaSans(
      fontSize: 11,
      fontWeight: FontWeight.w800,
      color: isDark ? AppTheme.darkTextTertiary : AppTheme.textTertiary,
      letterSpacing: 0.5,
    );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.darkCard.withValues(alpha: 0.5) : AppTheme.backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(flex: 2, child: Text('FECHA', style: textStyle)),
          Expanded(flex: 4, child: Text('CONCEPTO', style: textStyle)),
          Expanded(flex: 3, child: Text('VALOR', style: textStyle, textAlign: TextAlign.end)),
        ],
      ),
    );
  }
}

class _MovimientoTableRow extends StatelessWidget {
  final mov_model.Movimiento mov;
  final VoidCallback onTap;

  const _MovimientoTableRow({required this.mov, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = mov.tipo == mov_model.MovimientoType.ingreso
        ? AppTheme.successColor
        : mov.tipo == mov_model.MovimientoType.egreso
        ? AppTheme.errorColor
        : AppTheme.primaryColor;

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isDark ? AppTheme.darkBorder : AppTheme.borderLightColor,
              width: 0.5,
            ),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Text(
                DateFormat('dd/MM').format(mov.fecha),
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppTheme.darkTextSecondary : AppTheme.textSecondary,
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    mov.concepto,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (mov.categoria != null)
                    Text(
                      mov.categoria!,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        color: AppTheme.primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                ],
              ),
            ),
            Expanded(
              flex: 3,
              child: Text(
                (mov.tipo == mov_model.MovimientoType.ingreso ? '+' : '-') +
                    NumberFormatter.formatCompact(mov.monto),
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 15,
                  fontWeight: FontWeight.w900,
                  color: color,
                ),
                textAlign: TextAlign.end,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 60),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: (isDark ? AppTheme.darkCard : AppTheme.backgroundColor),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.history_toggle_off_rounded,
                size: 48,
                color: (isDark
                    ? AppTheme.darkTextTertiary
                    : AppTheme.textTertiary),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              l10n.noHayActividadRegistrada,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: (isDark
                    ? AppTheme.darkTextSecondary
                    : AppTheme.textSecondary),
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.tusMovimientosApareceranAqui,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: (isDark
                    ? AppTheme.darkTextTertiary
                    : AppTheme.textTertiary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final TextStyle? valueStyle;

  const _DetailRow({required this.label, required this.value, this.valueStyle});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: isDark ? AppTheme.darkTextSecondary : AppTheme.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          value,
          style:
              valueStyle ??
              Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}

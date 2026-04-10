import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:InkTrack/features/movimientos/presentation/viewmodels/movimientos_viewmodel.dart';
import 'package:InkTrack/features/inventario/presentation/viewmodels/inventario_viewmodel.dart';
import 'package:InkTrack/features/clientes/presentation/viewmodels/clientes_viewmodel.dart';
import 'package:InkTrack/features/movimientos/data/models/movimiento.dart';
import 'package:InkTrack/core/theme/app_theme.dart';
import 'package:InkTrack/core/utils/number_formatter.dart';
import 'package:InkTrack/core/widgets/app_card.dart';
import 'package:fl_chart/fl_chart.dart';

class ReportesPage extends StatefulWidget {
  const ReportesPage({super.key});

  @override
  State<ReportesPage> createState() => _ReportesPageState();
}

class _ReportesPageState extends State<ReportesPage> {
  @override
  void initState() {
    super.initState();
  }

  Future<void> _selectDateRange(BuildContext ctx) async {
    final viewModel = context.read<MovimientosViewModel>();
    final now = DateTime.now();
    final initialRange = DateTimeRange(
      start: viewModel.startDateFilter ?? now.subtract(const Duration(days: 30)),
      end: viewModel.endDateFilter ?? now,
    );

    final picked = await showDateRangePicker(
      context: ctx,
      firstDate: DateTime(2020),
      lastDate: now,
      initialDateRange: initialRange,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer3<MovimientosViewModel, InventarioViewModel, ClientesViewModel>(
        builder: (context, movVM, invVM, cliVM, child) {
          final isDark = Theme.of(context).brightness == Brightness.dark;
          final filteredMovs = movVM.items.where((m) {
            if (movVM.startDateFilter != null && m.fecha.isBefore(movVM.startDateFilter!)) return false;
            if (movVM.endDateFilter != null && m.fecha.isAfter(movVM.endDateFilter!.add(const Duration(days: 1)))) return false;
            return true;
          }).toList();

          final totalIngresos = filteredMovs
              .where((m) => m.tipo == MovimientoType.ingreso)
              .fold(0.0, (sum, m) => sum + m.monto);
          final totalEgresos = filteredMovs
              .where((m) => m.tipo == MovimientoType.egreso)
              .fold(0.0, (sum, m) => sum + m.monto);
          final ventasRealizadas = filteredMovs
              .where((m) => m.tipo == MovimientoType.ingreso) // Count all income as sales for KPI
              .length;
          final utilidadNeta = totalIngresos - totalEgresos;

          // Data for charts
          final expensesByCategory = _groupExpensesByCategory(filteredMovs);
          final weeklyData = _groupWeeklyData(filteredMovs, movVM.startDateFilter, movVM.endDateFilter);

          return CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Reportes Financieros',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          color: isDark ? Colors.white : AppTheme.textPrimary,
                          letterSpacing: -1,
                        ),
                      ),
                      Text(
                        'PERIODO DE ANÁLISIS',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.textTertiary,
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: 16),
                      InkWell(
                        onTap: () => _selectDateRange(context),
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: isDark ? AppTheme.darkCard : AppTheme.borderLightColor.withValues(alpha: 0.5),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: isDark ? AppTheme.darkBorder : AppTheme.borderColor),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.calendar_today_rounded, size: 18, color: AppTheme.secondaryColor),
                              const SizedBox(width: 12),
                              Text(
                                movVM.startDateFilter != null
                                    ? '${DateFormat('dd MMM').format(movVM.startDateFilter!)} – ${DateFormat('dd MMM').format(movVM.endDateFilter!)}'
                                    : 'Seleccionar Período',
                                style: GoogleFonts.plusJakartaSans(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Icon(Icons.keyboard_arrow_down_rounded, size: 18, color: AppTheme.textTertiary),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      _buildMetricCard(
                        label: 'INGRESOS TOTALES',
                        value: NumberFormatter.formatCurrency(totalIngresos),
                        icon: Icons.account_balance_wallet_rounded,
                        color: AppTheme.primaryColor,
                        isDark: isDark,
                      ),
                      _buildMetricCard(
                        label: 'EGRESOS TOTALES',
                        value: NumberFormatter.formatCurrency(totalEgresos),
                        icon: Icons.shopping_cart_rounded,
                        color: AppTheme.secondaryColor,
                        isDark: isDark,
                      ),
                      _buildMetricCard(
                        label: 'VENTAS REALIZADAS',
                        value: ventasRealizadas.toString(),
                        icon: Icons.local_offer_rounded,
                        color: AppTheme.secondaryColor,
                        isDark: isDark,
                      ),
                      _buildMetricCard(
                        label: 'UTILIDAD NETA',
                        value: NumberFormatter.formatCurrency(utilidadNeta),
                        icon: Icons.account_balance_rounded,
                        color: AppTheme.successColor,
                        isDark: isDark,
                        valueColor: AppTheme.successColor,
                      ),
                      const SizedBox(height: 16),
                      _buildChartCard(
                        title: 'Ventas vs Gastos',
                        child: _buildBarChart(weeklyData, isDark),
                        isDark: isDark,
                      ),
                      _buildChartCard(
                        title: 'Distribución de Gastos',
                        child: _buildPieChart(expensesByCategory, totalEgresos, isDark),
                        isDark: isDark,
                      ),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildMetricCard({
    required String label,
    required String value,
    required IconData icon,
    required Color color,
    required bool isDark,
    Color? valueColor,
  }) {
    return AppCard(
      margin: const EdgeInsets.only(bottom: 16),
      color: isDark ? AppTheme.darkCard : Colors.white,
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.textTertiary,
                    letterSpacing: 0.5,
                  ),
                ),
                Text(
                  value,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: valueColor ?? (isDark ? Colors.white : AppTheme.textPrimary),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChartCard({required String title, required Widget child, required bool isDark}) {
    return AppCard(
      margin: const EdgeInsets.only(bottom: 16),
      color: isDark ? AppTheme.darkCard : Colors.white,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(height: 200, child: child),
        ],
      ),
    );
  }

  Map<String, double> _groupExpensesByCategory(List<Movimiento> movs) {
    final Map<String, double> data = {};
    for (var m in movs.where((m) => m.tipo == MovimientoType.egreso)) {
      final cat = m.categoria ?? 'Sin Categoría';
      data[cat] = (data[cat] ?? 0) + m.monto;
    }
    return data;
  }

  List<Map<String, double>> _groupWeeklyData(List<Movimiento> movs, DateTime? start, DateTime? end) {
    final s = start ?? DateTime.now().subtract(const Duration(days: 30));
    final e = end ?? DateTime.now();

    // Divide the period into 4 "weeks" or chunks for display
    final duration = e.difference(s).inDays;
    final chunkDays = (duration / 4).ceil();

    List<Map<String, double>> groups = List.generate(4, (_) => {'ventas': 0.0, 'gastos': 0.0});

    for (var m in movs) {
      final diff = m.fecha.difference(s).inDays;
      int groupIndex = (diff / chunkDays).floor();
      if (groupIndex >= 4) groupIndex = 3;
      if (groupIndex < 0) groupIndex = 0;

      if (m.tipo == MovimientoType.ingreso) {
        groups[groupIndex]['ventas'] = (groups[groupIndex]['ventas'] ?? 0) + m.monto;
      } else if (m.tipo == MovimientoType.egreso) {
        groups[groupIndex]['gastos'] = (groups[groupIndex]['gastos'] ?? 0) + m.monto;
      }
    }
    return groups;
  }

  Widget _buildBarChart(List<Map<String, double>> data, bool isDark) {
    double maxVal = 0;
    for (var g in data) {
      if ((g['ventas'] ?? 0) > maxVal) maxVal = g['ventas']!;
      if ((g['gastos'] ?? 0) > maxVal) maxVal = g['gastos']!;
    }
    if (maxVal == 0) maxVal = 10;

    return BarChart(
      BarChartData(
        gridData: const FlGridData(show: false),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                return Text(
                  'SEM ${value.toInt() + 1}',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textTertiary,
                  ),
                );
              },
            ),
          ),
          leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        barGroups: data.asMap().entries.map((e) {
          return _makeGroupData(e.key, (e.value['ventas']! / maxVal) * 20, (e.value['gastos']! / maxVal) * 20);
        }).toList(),
      ),
    );
  }

  BarChartGroupData _makeGroupData(int x, double y1, double y2) {
    return BarChartGroupData(
      barsSpace: 4,
      x: x,
      barRods: [
        BarChartRodData(toY: y1, color: AppTheme.primaryColor.withValues(alpha: 0.4), width: 12, borderRadius: BorderRadius.circular(4)),
        BarChartRodData(toY: y2, color: AppTheme.secondaryColor, width: 12, borderRadius: BorderRadius.circular(4)),
      ],
    );
  }

  Widget _buildPieChart(Map<String, double> categoryData, double total, bool isDark) {
    if (total == 0) return const Center(child: Text('Sin gastos registrados'));

    final List<Color> colors = [
      AppTheme.primaryColor.withValues(alpha: 0.4),
      AppTheme.secondaryColor,
      AppTheme.successColor,
      AppTheme.infoColor,
      Colors.purple,
    ];

    return Column(
      children: [
        Expanded(
          child: PieChart(
            PieChartData(
              sectionsSpace: 0,
              centerSpaceRadius: 40,
              sections: categoryData.entries.toList().asMap().entries.map((e) {
                final color = colors[e.key % colors.length];
                return PieChartSectionData(
                  color: color,
                  value: e.value.value,
                  title: '',
                  radius: 25,
                );
              }).toList(),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 8,
          children: categoryData.entries.toList().asMap().entries.map((e) {
            final color = colors[e.key % colors.length];
            final percentage = (e.value.value / total * 100).toStringAsFixed(0);
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
                const SizedBox(width: 6),
                Text(
                  '${e.value.key} ($percentage%)',
                  style: GoogleFonts.plusJakartaSans(fontSize: 10, fontWeight: FontWeight.w600, color: AppTheme.textSecondary),
                ),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }
}

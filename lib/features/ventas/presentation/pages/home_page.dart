import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:InkTrack/features/movimientos/presentation/viewmodels/movimientos_viewmodel.dart';
import 'package:InkTrack/features/movimientos/data/models/movimiento.dart'
    as mov_model;
import 'package:InkTrack/features/inventario/presentation/viewmodels/inventario_viewmodel.dart';
import 'package:InkTrack/core/theme/app_theme.dart';
import 'package:InkTrack/core/widgets/financial_summary_header.dart';
import 'package:InkTrack/core/widgets/trend_chart.dart';
import 'package:InkTrack/core/utils/number_formatter.dart';
import 'package:InkTrack/core/widgets/app_card.dart';

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

  void _showMovimientoDetalle(BuildContext context, mov_model.Movimiento mov) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
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
                    'Detalle de movimiento',
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
                    _DetailRow(label: 'Concepto', value: mov.concepto),
                    const Divider(height: 32),
                    _DetailRow(
                      label: 'Monto',
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
                      label: 'Fecha',
                      value: DateFormat('dd/MM/yyyy HH:mm').format(mov.fecha),
                    ),
                    if (mov.categoria != null) ...[
                      const Divider(height: 32),
                      _DetailRow(label: 'Categoría', value: mov.categoria!),
                    ],
                    const Divider(height: 32),
                    _DetailRow(
                      label: 'Tipo',
                      value: mov.tipo == mov_model.MovimientoType.ingreso
                          ? 'Ingreso'
                          : mov.tipo == mov_model.MovimientoType.egreso
                          ? 'Egreso'
                          : 'Actividad',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer2<MovimientosViewModel, InventarioViewModel>(
        builder: (context, movVM, invVM, child) {
          final isFiltered = movVM.startDateFilter != null;
          final summary = FinancialSummaryHeader(
            title: isFiltered ? 'Resultados' : 'Acumulado Total',
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
            label1: isFiltered ? 'Ingresos' : 'Ventas Totales',
            label2: isFiltered ? 'Egresos' : 'Gastos Totales',
            label3: isFiltered ? 'Balance' : 'Patrimonio',
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
                      const SizedBox(height: 28),
                      Text(
                        'Tendencia de Flujo',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(height: 16),
                      TrendChart(movimientos: movVM.items),
                      const SizedBox(height: 32),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            movVM.startDateFilter == null
                                ? 'Actividad Reciente'
                                : 'Resultados del Filtro',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.w800),
                          ),
                          if (movVM.startDateFilter != null)
                            TextButton.icon(
                              onPressed: () => movVM.clearDateFilter(),
                              icon: const Icon(Icons.clear_rounded, size: 18),
                              label: const Text('Limpiar'),
                              style: TextButton.styleFrom(
                                foregroundColor: AppTheme.errorColor,
                              ),
                            ),
                        ],
                      ),
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
                        return _MovimientoItem(
                          mov: mov,
                          onTap: () => _showMovimientoDetalle(context, mov),
                        );
                      },
                      childCount:
                          historial.length > 10 && movVM.startDateFilter == null
                          ? 5
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
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
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
              'No hay actividad registrada',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: (isDark
                    ? AppTheme.darkTextSecondary
                    : AppTheme.textSecondary),
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tus movimientos aparecerán aquí',
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

class _MovimientoItem extends StatelessWidget {
  final mov_model.Movimiento mov;
  final VoidCallback onTap;

  const _MovimientoItem({required this.mov, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isMonetary = mov.tipo != mov_model.MovimientoType.actividad;
    final color = mov.tipo == mov_model.MovimientoType.ingreso
        ? AppTheme.successColor
        : mov.tipo == mov_model.MovimientoType.egreso
        ? AppTheme.errorColor
        : AppTheme.primaryColor;

    return AppCard(
      onTap: onTap,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              mov.tipo == mov_model.MovimientoType.ingreso
                  ? Icons.add_chart_rounded
                  : mov.tipo == mov_model.MovimientoType.egreso
                  ? Icons.shopping_bag_outlined
                  : Icons.info_outline_rounded,
              color: color,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  mov.concepto,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.access_time_rounded,
                      size: 12,
                      color: (isDark
                          ? AppTheme.darkTextTertiary
                          : AppTheme.textTertiary),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      DateFormat('HH:mm').format(mov.fecha),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (mov.categoria != null) ...[
                      const SizedBox(width: 8),
                      Container(
                        width: 3,
                        height: 3,
                        decoration: BoxDecoration(
                          color: (isDark
                              ? AppTheme.darkTextTertiary
                              : AppTheme.textTertiary),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          mov.categoria!,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: AppTheme.primaryColor,
                                fontWeight: FontWeight.w700,
                              ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          if (isMonetary)
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  (mov.tipo == mov_model.MovimientoType.ingreso ? '+ ' : '- ') +
                      NumberFormatter.formatCompact(mov.monto),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: color,
                  ),
                ),
                Text(
                  'Monto',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    fontSize: 9,
                    color: (isDark
                        ? AppTheme.darkTextTertiary
                        : AppTheme.textTertiary),
                  ),
                ),
              ],
            )
          else
            Icon(
              Icons.chevron_right_rounded,
              color: (isDark
                  ? AppTheme.darkTextTertiary
                  : AppTheme.textTertiary),
            ),
        ],
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

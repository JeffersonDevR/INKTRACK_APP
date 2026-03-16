import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:InkTrack/features/movimientos/presentation/viewmodels/movimientos_viewmodel.dart';
import 'package:InkTrack/features/movimientos/data/models/movimiento.dart' as mov_model;
import 'package:InkTrack/features/inventario/presentation/viewmodels/inventario_viewmodel.dart';
import 'package:InkTrack/core/theme/app_theme.dart';
import 'package:InkTrack/core/widgets/stat_card.dart';
import 'package:InkTrack/core/widgets/financial_summary_header.dart';
import 'package:InkTrack/core/widgets/trend_chart.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Future<void> _selectDateRange(BuildContext context) async {
    final viewModel = context.read<MovimientosViewModel>();
    final initialRange = DateTimeRange(
      start: viewModel.startDateFilter ?? DateTime.now().subtract(const Duration(days: 7)),
      end: viewModel.endDateFilter ?? DateTime.now(),
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
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: AppTheme.surfaceColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                ),
              ],
            ),
            const Divider(),
            const SizedBox(height: 16),
            _DetailRow(label: 'Concepto', value: mov.concepto),
            _DetailRow(
              label: 'Monto',
              value: NumberFormat.currency(symbol: '\$').format(mov.monto),
              valueStyle: TextStyle(
                fontWeight: FontWeight.bold,
                color: mov.tipo == mov_model.MovimientoType.ingreso
                    ? Colors.green
                    : mov.tipo == mov_model.MovimientoType.egreso
                        ? Colors.red
                        : null,
              ),
            ),
            _DetailRow(
              label: 'Fecha',
              value: DateFormat('dd/MM/yyyy HH:mm').format(mov.fecha),
            ),
            if (mov.categoria != null)
              _DetailRow(label: 'Categoría', value: mov.categoria!),
            _DetailRow(
              label: 'Tipo',
              value: mov.tipo == mov_model.MovimientoType.ingreso
                  ? 'Ingreso'
                  : mov.tipo == mov_model.MovimientoType.egreso
                      ? 'Egreso'
                      : 'Actividad',
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('InkTrack'),
        actions: [
          IconButton(
            onPressed: () => _selectDateRange(context),
            icon: const Icon(Icons.date_range_rounded),
          ),
        ],
      ),
      body: Consumer2<MovimientosViewModel, InventarioViewModel>(
        builder: (context, movVM, invVM, child) {
          final summary = FinancialSummaryHeader(
            totalIngresos: movVM.startDateFilter == null ? movVM.totalIngresosHoy : movVM.totalIngresosFiltered,
            totalEgresos: movVM.startDateFilter == null ? movVM.totalEgresosHoy : movVM.totalEgresosFiltered,
            balance: movVM.startDateFilter == null ? movVM.balanceHoy : movVM.balanceFiltered,
            startDate: movVM.startDateFilter,
            endDate: movVM.endDateFilter,
            onDateTap: () => _selectDateRange(context),
          );

          final historial = movVM.startDateFilter == null ? movVM.historialCompleto : movVM.filteredItems..sort((a,b) => b.fecha.compareTo(a.fecha));

          return CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.all(20),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    children: [
                      summary,
                      const SizedBox(height: 24),
                      TrendChart(movimientos: movVM.items),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: StatCard(
                              label: 'Valor Inventario',
                              value: NumberFormat.currency(symbol: '\$').format(invVM.valorTotalInventario),
                              color: AppTheme.secondaryColor,
                              icon: Icons.storefront_rounded,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: StatCard(
                              label: 'Stock Total',
                              value: invVM.totalProductos.toString(),
                              color: invVM.hayStockBajo ? AppTheme.errorColor : AppTheme.primaryColor,
                              icon: invVM.hayStockBajo ? Icons.warning_amber_rounded : Icons.inventory_2_rounded,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            movVM.startDateFilter == null ? 'Actividad de Hoy' : 'Resultados del Filtro',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (movVM.startDateFilter != null)
                            TextButton(
                              onPressed: () => movVM.clearDateFilter(),
                              child: const Text('Limpiar'),
                            ),
                        ],
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              ),
              if (historial.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: _EmptyState(),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final mov = historial[index];
                        return _MovimientoItem(
                          mov: mov,
                          onTap: () => _showMovimientoDetalle(context, mov),
                        );
                      },
                      childCount: historial.length > 10 && movVM.startDateFilter == null ? 10 : historial.length,
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
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Column(
          children: [
            Icon(Icons.history_toggle_off, size: 64, color: AppTheme.textSecondary.withValues(alpha: 0.2)),
            const SizedBox(height: 16),
            Text(
              'No hay actividad registrada.',
              style: Theme.of(context).textTheme.bodyMedium,
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
    final isMonetary = mov.tipo != mov_model.MovimientoType.actividad;
    final color = mov.tipo == mov_model.MovimientoType.ingreso
        ? AppTheme.successColor
        : mov.tipo == mov_model.MovimientoType.egreso
            ? AppTheme.errorColor
            : AppTheme.primaryColor;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            mov.tipo == mov_model.MovimientoType.ingreso
                ? Icons.add_rounded
                : mov.tipo == mov_model.MovimientoType.egreso
                    ? Icons.remove_rounded
                    : Icons.info_outline_rounded,
            color: color,
            size: 20,
          ),
        ),
        title: Text(
          mov.concepto,
          style: Theme.of(context).textTheme.titleSmall,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          '${DateFormat('HH:mm').format(mov.fecha)}${mov.categoria != null ? ' • ${mov.categoria}' : ''}',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppTheme.textSecondary,
          ),
        ),
        trailing: isMonetary 
          ? Text(
              (mov.tipo == mov_model.MovimientoType.ingreso ? '+ ' : '- ') + 
              NumberFormat.currency(symbol: '\$').format(mov.monto),
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            )
          : const Icon(Icons.chevron_right_rounded, color: AppTheme.textSecondary, size: 20),
      ),
    );
  }
}
class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final TextStyle? valueStyle;

  const _DetailRow({
    required this.label,
    required this.value,
    this.valueStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppTheme.textSecondary,
          )),
          Text(value, style: valueStyle ?? Theme.of(context).textTheme.bodyLarge),
        ],
      ),
    );
  }
}

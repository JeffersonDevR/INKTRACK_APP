import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:InkTrack/features/movimientos/data/models/movimiento.dart';
import 'package:InkTrack/features/movimientos/presentation/viewmodels/movimientos_viewmodel.dart';
import 'movimiento_form_page.dart';
import 'package:InkTrack/core/theme/app_theme.dart';
import 'package:InkTrack/core/widgets/financial_summary_header.dart';
import 'package:InkTrack/core/utils/number_formatter.dart';

class MovimientosPage extends StatelessWidget {
  const MovimientosPage({super.key});

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
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return Theme(
          data: isDark
              ? Theme.of(context).copyWith(
                  colorScheme: const ColorScheme.dark(
                    primary: AppTheme.primaryColor,
                    onPrimary: Colors.white,
                    surface: AppTheme.darkSurface,
                    onSurface: AppTheme.darkTextPrimary,
                  ),
                )
              : Theme.of(context).copyWith(
                  colorScheme: const ColorScheme.light(
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
      appBar: AppBar(
        title: const Text('Historial de Movimientos'),
        actions: [
          IconButton(
            onPressed: () => _selectDateRange(context),
            icon: const Icon(Icons.date_range_rounded),
          ),
        ],
      ),
      body: Consumer<MovimientosViewModel>(
        builder: (context, viewModel, child) {
          final items =
              viewModel.startDateFilter == null
                    ? viewModel.items.reversed.toList()
                    : viewModel.filteredItems
                ..sort((a, b) => b.fecha.compareTo(a.fecha));

          if (viewModel.items.isEmpty) {
            return _EmptyMovimientos();
          }

          return CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    children: [
                      FinancialSummaryHeader(
                        totalIngresos: viewModel.startDateFilter == null
                            ? viewModel.totalIngresos
                            : viewModel.totalIngresosFiltered,
                        totalEgresos: viewModel.startDateFilter == null
                            ? viewModel.totalEgresos
                            : viewModel.totalEgresosFiltered,
                        balance: viewModel.startDateFilter == null
                            ? viewModel.balance
                            : viewModel.balanceFiltered,
                        startDate: viewModel.startDateFilter,
                        endDate: viewModel.endDateFilter,
                        onDateTap: () => _selectDateRange(context),
                      ),
                      if (viewModel.startDateFilter != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: Builder(
                            builder: (context) {
                              final isDark =
                                  Theme.of(context).brightness ==
                                  Brightness.dark;
                              return OutlinedButton.icon(
                                onPressed: () => viewModel.clearDateFilter(),
                                icon: const Icon(Icons.clear_rounded, size: 18),
                                label: const Text('Limpiar Filtro'),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: isDark
                                      ? AppTheme.darkTextSecondary
                                      : AppTheme.textSecondary,
                                  side: BorderSide(
                                    color: isDark
                                        ? AppTheme.darkBorder
                                        : const Color(0xFFF1F5F9),
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: SliverToBoxAdapter(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        viewModel.startDateFilter == null
                            ? 'Registros Recientes'
                            : 'Resultados del Filtro',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      if (viewModel.startDateFilter == null)
                        Text(
                          'Total: ${items.length}',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: AppTheme.textSecondary),
                        ),
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final m = items[index];
                    return _MovimientoItem(movimiento: m);
                  }, childCount: items.length),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _MovimientoItem extends StatelessWidget {
  final Movimiento movimiento;

  const _MovimientoItem({required this.movimiento});

  @override
  Widget build(BuildContext context) {
    final isIngreso = movimiento.tipo == MovimientoType.ingreso;
    final isEgreso = movimiento.tipo == MovimientoType.egreso;

    final color = isIngreso
        ? AppTheme
              .successColor // Green = money in
        : isEgreso
        ? AppTheme
              .errorColor // Red = money out
        : AppTheme.primaryColor;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          radius: 24,
          backgroundColor: color.withValues(alpha: 0.1),
          child: Icon(
            isIngreso
                ? Icons.south_west_rounded
                : isEgreso
                ? Icons.north_east_rounded
                : Icons.info_outline,
            color: color,
            size: 20,
          ),
        ),
        title: Text(
          movimiento.concepto,
          style: Theme.of(context).textTheme.labelLarge,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              '${DateFormat('dd MMM yyyy').format(movimiento.fecha)}${movimiento.categoria != null ? ' • ${movimiento.categoria}' : ''}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (movimiento.tipo != MovimientoType.actividad)
              Text(
                '${isIngreso ? '+' : '-'}${NumberFormatter.formatCurrency(movimiento.monto)}',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: color,
                ),
              ),
            const SizedBox(width: 4),
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'edit') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          MovimientoFormPage(movimiento: movimiento),
                    ),
                  );
                } else if (value == 'delete') {
                  _confirmDelete(context);
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(Icons.edit_outlined, size: 20),
                      SizedBox(width: 8),
                      Text('Editar'),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(
                        Icons.delete_outline_rounded,
                        color: AppTheme.errorColor,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Eliminar',
                        style: TextStyle(color: AppTheme.errorColor),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar Registro'),
        content: const Text(
          '¿Estás seguro de que deseas eliminar este registro permanentemente?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              context.read<MovimientosViewModel>().eliminar(movimiento.id);
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(foregroundColor: AppTheme.errorColor),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }
}

class _EmptyMovimientos extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.history_toggle_off_rounded,
              size: 80,
              color: isDark
                  ? AppTheme.darkTextSecondary.withValues(alpha: 0.5)
                  : AppTheme.textSecondary.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'Historial vacío',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'No hay registros de ingresos o egresos todavía.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}

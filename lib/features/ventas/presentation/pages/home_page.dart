import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:InkTrack/features/movimientos/presentation/viewmodels/movimientos_viewmodel.dart';
import 'package:InkTrack/features/movimientos/data/models/movimiento.dart' as mov_model;
import 'package:InkTrack/features/inventario/presentation/viewmodels/inventario_viewmodel.dart';
import 'package:InkTrack/core/theme/app_theme.dart';
import 'package:InkTrack/core/widgets/stat_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
      appBar: AppBar(title: const Text('InkTrack')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const _ResumenDiario(),
            const SizedBox(height: 24),
            Text(
              'Historial de Actividad',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            Consumer<MovimientosViewModel>(
              builder: (context, viewModel, child) {
                final historial = viewModel.historialCompleto;
                if (historial.isEmpty) {
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
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: historial.length > 10 ? 10 : historial.length,
                  itemBuilder: (context, index) {
                    final mov = historial[index];
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
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.03),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ListTile(
                        onTap: () => _showMovimientoDetalle(context, mov),
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
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _ResumenDiario extends StatelessWidget {
  const _ResumenDiario();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<MovimientosViewModel>();
    final inventarioViewModel = context.watch<InventarioViewModel>();
    final currencyFormat = NumberFormat.currency(symbol: '\$', decimalDigits: 2);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Panel de Control',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.5,
                      ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Hoy en un vistazo',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.primaryColor.withValues(alpha: 0.1)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.calendar_today_rounded, size: 12, color: AppTheme.primaryColor),
                  const SizedBox(width: 6),
                  Text(
                    DateFormat('dd MMM').format(DateTime.now()),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: StatCard(
                label: 'Ingresos',
                value: currencyFormat.format(viewModel.totalIngresosHoy),
                color: AppTheme.accentColor,
                icon: Icons.trending_up_rounded,
                useSolidBackground: true,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: StatCard(
                label: 'Gastos',
                value: currencyFormat.format(viewModel.totalEgresosHoy),
                color: AppTheme.primaryColor,
                icon: Icons.trending_down_rounded,
                useSolidBackground: true,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        StatCard(
          label: 'Balance Neto Hoy',
          value: currencyFormat.format(viewModel.balanceHoy),
          color: viewModel.balanceHoy >= 0 ? AppTheme.primaryColor : AppTheme.accentColor,
          icon: Icons.account_balance_wallet_rounded,
          isLarge: true,
          subtitle: 'Suma de ingresos menos egresos del día',
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: StatCard(
                label: 'V. Inventario',
                value: currencyFormat.format(inventarioViewModel.valorTotalInventario),
                color: AppTheme.secondaryColor,
                icon: Icons.storefront_rounded,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: StatCard(
                label: 'En Stock',
                value: inventarioViewModel.totalProductos.toString(),
                color: inventarioViewModel.hayStockBajo ? AppTheme.errorColor : AppTheme.primaryColor,
                icon: inventarioViewModel.hayStockBajo ? Icons.warning_amber_rounded : Icons.inventory_2_rounded,
                subtitle: inventarioViewModel.hayStockBajo
                    ? 'Atención: Stock Bajo'
                    : 'Niveles óptimos',
              ),
            ),
          ],
        ),
      ],
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

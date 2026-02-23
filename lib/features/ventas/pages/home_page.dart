import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../movimientos/viewmodels/movimientos_viewmodel.dart';
import '../../movimientos/models/movimiento.dart' as mov_model;
import '../../movimientos/pages/movimiento_form_page.dart';
import '../../../core/theme/app_theme.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('InkTrack Proto')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const _ResumenDiario(),
            const SizedBox(height: 28),
            Text(
              'Acciones rápidas',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            _AccionButton(
              icon: Icons.add_circle_outline,
              label: 'Registrar ingreso',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MovimientoFormPage(
                      initialType: mov_model.MovimientoType.ingreso,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 8),
            _AccionButton(
              icon: Icons.remove_circle_outline,
              label: 'Registrar egreso',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MovimientoFormPage(
                      initialType: mov_model.MovimientoType.egreso,
                    ),
                  ),
                );
              },
            ),
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
                  return const Center(
                    child: Text('No hay actividad registrada.'),
                  );
                }
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: historial.length > 10 ? 10 : historial.length,
                  itemBuilder: (context, index) {
                    final mov = historial[index];
                    final isMonetary = mov.tipo != mov_model.MovimientoType.actividad;
                    
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: (mov.tipo == mov_model.MovimientoType.ingreso
                                  ? Colors.green
                                  : mov.tipo == mov_model.MovimientoType.egreso
                                      ? Colors.red
                                      : AppTheme.primaryColor)
                              .withValues(alpha: 0.1),
                          child: Icon(
                            mov.tipo == mov_model.MovimientoType.ingreso
                                ? Icons.add_circle_outline
                                : mov.tipo == mov_model.MovimientoType.egreso
                                    ? Icons.remove_circle_outline
                                    : Icons.info_outline,
                            color: mov.tipo == mov_model.MovimientoType.ingreso
                                ? Colors.green
                                : mov.tipo == mov_model.MovimientoType.egreso
                                    ? Colors.red
                                    : AppTheme.primaryColor,
                          ),
                        ),
                        title: Text(
                          mov.concepto,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text(
                          '${DateFormat('HH:mm').format(mov.fecha)}${mov.categoria != null ? ' • ${mov.categoria}' : ''}',
                        ),
                        trailing: isMonetary 
                          ? Text(
                              NumberFormat.currency(symbol: '\$').format(mov.monto),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: mov.tipo == mov_model.MovimientoType.ingreso ? Colors.green : Colors.red,
                              ),
                            )
                          : const Icon(Icons.check_circle_outline, color: Colors.grey, size: 16),
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
    final currencyFormat = NumberFormat.currency(symbol: '\$', decimalDigits: 2);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Resumen del día',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(
              DateFormat('dd/MM/yyyy').format(DateTime.now()),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _StatMiniCard(
                label: 'Ingresos',
                value: currencyFormat.format(viewModel.totalIngresosHoy),
                color: Colors.green,
                icon: Icons.trending_up,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _StatMiniCard(
                label: 'Egresos',
                value: currencyFormat.format(viewModel.totalEgresosHoy),
                color: Colors.red,
                icon: Icons.trending_down,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        _StatMiniCard(
          label: 'Balance Neto Hoy',
          value: currencyFormat.format(viewModel.balanceHoy),
          color: viewModel.balanceHoy >= 0 ? AppTheme.primaryColor : Colors.orange,
          icon: Icons.account_balance_wallet,
          isLarge: true,
        ),
      ],
    );
  }
}

class _StatMiniCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final IconData icon;
  final bool isLarge;

  const _StatMiniCard({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
    this.isLarge = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(isLarge ? 16 : 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: isLarge ? 24 : 18),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                value,
                style: (isLarge 
                  ? Theme.of(context).textTheme.headlineSmall 
                  : Theme.of(context).textTheme.titleMedium)?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isLarge ? color : null,
                  ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AccionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _AccionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: AppTheme.primaryColor.withValues(alpha: 0.12),
                child: Icon(icon, color: AppTheme.primaryColor),
              ),
              const SizedBox(width: 16),
              Text(label, style: Theme.of(context).textTheme.titleSmall),
              const Spacer(),
              const Icon(Icons.arrow_forward_ios, size: 16),
            ],
          ),
        ),
      ),
    );
  }
}

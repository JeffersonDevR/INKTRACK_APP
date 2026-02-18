import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../viewmodels/ventas_viewmodel.dart';
import '../../../core/theme/app_theme.dart';
import 'registrar_venta_page.dart';

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
            const _ResumenVentasCard(),
            const SizedBox(height: 28),
            Text(
              'Acciones rápidas',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            _AccionButton(
              icon: Icons.point_of_sale,
              label: 'Registrar venta',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const RegistrarVentaPage(),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            Text(
              'Historial de Ventas',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            Consumer<VentasViewModel>(
              builder: (context, viewModel, child) {
                if (viewModel.ventas.isEmpty) {
                  return const Center(
                    child: Text('No hay ventas registradas.'),
                  );
                }
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: viewModel.ventas.length,
                  itemBuilder: (context, index) {
                    final venta = viewModel.ventas[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: AppTheme.primaryColor.withValues(
                              alpha: 0.1,
                            ),
                            child: Icon(
                              Icons.receipt,
                              color: AppTheme.primaryColor,
                            ),
                          ),
                          title: Text(
                            venta.concepto ?? 'Venta general',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Text(
                            venta.clienteNombre != null
                                ? 'Cliente: ${venta.clienteNombre}'
                                : 'Cliente: Anónimo',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: Container(
                            constraints: const BoxConstraints(maxWidth: 120),
                            child: Text(
                              NumberFormat.currency(
                                symbol: '\$',
                              ).format(venta.monto),
                              style: const TextStyle(fontWeight: FontWeight.bold),
                              textAlign: TextAlign.end,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
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

class _ResumenVentasCard extends StatelessWidget {
  const _ResumenVentasCard();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<VentasViewModel>();
    final currencyFormat = NumberFormat.currency(
      symbol: '\$',
      decimalDigits: 2,
    );

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.today, color: AppTheme.accentColor, size: 28),
                const SizedBox(width: 12),
                Text(
                  'Ventas del día',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              currencyFormat.format(viewModel.totalVentasDia),
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                color: AppTheme.primaryColor,
                fontWeight: FontWeight.bold,
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

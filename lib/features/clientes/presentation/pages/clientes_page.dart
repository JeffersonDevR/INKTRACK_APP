import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:InkTrack/features/clientes/presentation/viewmodels/clientes_viewmodel.dart';
import 'package:InkTrack/features/clientes/data/models/cliente.dart';
import 'package:InkTrack/core/theme/app_theme.dart';
import 'package:InkTrack/core/widgets/stat_card.dart';
import 'cliente_form_page.dart';
import '../widgets/pago_dialog.dart';

class ClientesPage extends StatelessWidget {
  const ClientesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Clientes')),
      body: Consumer<ClientesViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.clientes.isEmpty) {
            return _EmptyClientes();
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Resumen de Clientes',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w900,
                            letterSpacing: -0.5,
                          ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: StatCard(
                            value: '${viewModel.totalClientes}',
                            label: 'Total Clientes',
                            icon: Icons.people_rounded,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: StatCard(
                            value: viewModel.clientesConDeuda.toString(),
                            label: 'Con Deuda',
                            icon: Icons.assignment_late_rounded,
                            color: AppTheme.errorColor,
                            subtitle: viewModel.clientesConDeuda == 0 ? 'Sin deudas pendientes' : 'Clientes fiados',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    StatCard(
                      value: '\$${viewModel.totalDeuda.toStringAsFixed(2)}',
                      label: 'Deuda Total Pendiente',
                      icon: Icons.payments_rounded,
                      color: AppTheme.accentColor,
                      isLarge: true,
                      subtitle: 'Suma de saldos de todos los clientes',
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(
                  'Listado de Clientes',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  itemCount: viewModel.clientes.length,
                  itemBuilder: (context, index) {
                    final cliente = viewModel.clientes[index];
                    return Card(
                      child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  leading: CircleAvatar(
                    backgroundColor: AppTheme.primaryColor.withValues(
                      alpha: 0.12,
                    ),
                    child: Icon(Icons.person, color: AppTheme.primaryColor),
                  ),
                  title: Row(
                    children: [
                      Text(
                        cliente.nombre,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      if (cliente.esFiado) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppTheme.errorColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: AppTheme.errorColor.withValues(alpha: 0.5)),
                          ),
                          child: Text(
                            'FIADO',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.errorColor,
                            ),
                          ),
                        ),
                      ],
                      if (cliente.saldoPendiente > 0) ...[
                        const Spacer(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'Saldo',
                              style: TextStyle(
                                fontSize: 10,
                                color: AppTheme.textSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              '\$${cliente.saldoPendiente.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppTheme.errorColor,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                  subtitle: Text(
                    '${cliente.telefono} • ${cliente.email}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) => _onMenuSelected(context, value, cliente),
                    itemBuilder: (context) => [
                      if (cliente.saldoPendiente > 0)
                        const PopupMenuItem(
                          value: 'pay',
                          child: Row(
                            children: [
                              Icon(Icons.payments_outlined, size: 20),
                              SizedBox(width: 8),
                              Text('Registrar Pago'),
                            ],
                          ),
                        ),
                      const PopupMenuItem(value: 'edit', child: Text('Editar')),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Text('Eliminar'),
                      ),
                    ],
                  ),
                ),
              );
            },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _onMenuSelected(BuildContext context, String value, Cliente cliente) {
    if (value == 'edit') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ClienteFormPage(cliente: cliente),
        ),
      );
    } else if (value == 'delete') {
      _showDeleteDialog(context, cliente);
    } else if (value == 'pay') {
      showDialog(
        context: context,
        builder: (context) => PagoDialog(cliente: cliente),
      );
    }
  }

  void _showDeleteDialog(BuildContext context, Cliente cliente) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar cliente'),
        content: Text('¿Eliminar a ${cliente.nombre}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              context.read<ClientesViewModel>().eliminar(cliente.id);
              Navigator.pop(ctx);
            },
            style: TextButton.styleFrom(foregroundColor: AppTheme.errorColor),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }
}

class _EmptyClientes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.people_outline,
              size: 80,
              color: AppTheme.textSecondary.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'No hay clientes',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Añade clientes con el botón de abajo para asociarlos a ventas.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}

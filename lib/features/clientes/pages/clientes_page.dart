import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../clientes_viewmodel.dart';
import '../cliente.dart';
import '../../../core/theme/app_theme.dart';
import 'cliente_form_page.dart';

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
          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                  title: Text(
                    cliente.nombre,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(
                    '${cliente.telefono} • ${cliente.email}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'edit') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ClienteFormPage(cliente: cliente),
                          ),
                        );
                      } else if (value == 'delete') {
                        _showDeleteDialog(context, cliente);
                      }
                    },
                    itemBuilder: (context) => [
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
          );
        },
      ),
    );
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

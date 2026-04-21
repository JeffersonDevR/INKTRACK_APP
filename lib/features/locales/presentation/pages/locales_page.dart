import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:InkTrack/features/locales/presentation/viewmodels/locales_viewmodel.dart';
import 'package:InkTrack/features/locales/data/models/local.dart';
import 'package:InkTrack/core/theme/app_theme.dart';
import 'package:InkTrack/core/utils/id_utils.dart';
import 'package:InkTrack/features/inventario/presentation/viewmodels/inventario_viewmodel.dart';
import 'package:InkTrack/features/clientes/presentation/viewmodels/clientes_viewmodel.dart';
import 'package:InkTrack/features/proveedores/presentation/viewmodels/proveedores_viewmodel.dart';
import 'package:InkTrack/features/proveedores/presentation/viewmodels/pedidos_viewmodel.dart';
import 'package:InkTrack/features/movimientos/presentation/viewmodels/movimientos_viewmodel.dart';
import 'package:InkTrack/features/ventas/presentation/viewmodels/ventas_viewmodel.dart';

class LocalesPage extends StatelessWidget {
  const LocalesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Locales'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showLocalDialog(context),
          ),
        ],
      ),
      body: Consumer<LocalesViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.items.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.store_rounded,
                    size: 80,
                    color: AppTheme.textTertiary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No hay locales registrados',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Agrega tu primera tienda o local',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () => _showLocalDialog(context),
                    icon: const Icon(Icons.add),
                    label: const Text('Agregar Local'),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: viewModel.items.length,
            itemBuilder: (context, index) {
              final local = viewModel.items[index];
              final isSelected = local.id == viewModel.localIdSeleccionado;

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                color: isSelected
                    ? AppTheme.primaryColor.withValues(alpha: 0.1)
                    : null,
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: isSelected
                        ? AppTheme.primaryColor
                        : AppTheme.primaryColor.withValues(alpha: 0.1),
                    child: Icon(
                      local.tipo == 'bodega'
                          ? Icons.warehouse_rounded
                          : Icons.store_rounded,
                      color: isSelected ? Colors.white : AppTheme.primaryColor,
                    ),
                  ),
                  title: Text(local.nombre),
                  subtitle: local.direccion != null
                      ? Text(local.direccion!)
                      : null,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (isSelected)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'Actual',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      PopupMenuButton<String>(
                        onSelected: (value) {
                          if (value == 'select') {
                            viewModel.seleccionarLocal(local.id);
                          } else if (value == 'edit') {
                            _showLocalDialog(context, local: local);
                          } else if (value == 'delete') {
                            _confirmDelete(context, viewModel, local);
                          }
                        },
                        itemBuilder: (context) => [
                          const PopupMenuItem(
                            value: 'select',
                            child: Row(
                              children: [
                                Icon(Icons.check_circle_outline, size: 20),
                                SizedBox(width: 8),
                                Text('Seleccionar'),
                              ],
                            ),
                          ),
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
                                  size: 20,
                                  color: AppTheme.errorColor,
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
            },
          );
        },
      ),
    );
  }

  void _showLocalDialog(BuildContext context, {Local? local}) {
    final nombreController = TextEditingController(text: local?.nombre);
    final direccionController = TextEditingController(text: local?.direccion);
    final telefonoController = TextEditingController(text: local?.telefono);
    String tipo = local?.tipo ?? 'tienda';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(local == null ? 'Nuevo Local' : 'Editar Local'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nombreController,
                  decoration: const InputDecoration(
                    labelText: 'Nombre',
                    hintText: 'Ej. Tienda Principal',
                  ),
                  textCapitalization: TextCapitalization.words,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: direccionController,
                  decoration: const InputDecoration(
                    labelText: 'Dirección (opcional)',
                    hintText: 'Ej. Calle 123 #45-67',
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: telefonoController,
                  decoration: const InputDecoration(
                    labelText: 'Teléfono (opcional)',
                  ),
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: tipo,
                  decoration: const InputDecoration(labelText: 'Tipo'),
                  items: const [
                    DropdownMenuItem(value: 'tienda', child: Text('Tienda')),
                    DropdownMenuItem(value: 'bodega', child: Text('Bodega')),
                    DropdownMenuItem(value: 'oficina', child: Text('Oficina')),
                  ],
                  onChanged: (value) {
                    setState(() => tipo = value ?? 'tienda');
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () {
                if (nombreController.text.trim().isEmpty) return;

                final viewModel = context.read<LocalesViewModel>();
                final nuevoLocal = Local(
                  id: local?.id ?? '',
                  nombre: nombreController.text.trim(),
                  direccion: direccionController.text.trim().isEmpty
                      ? null
                      : direccionController.text.trim(),
                  telefono: telefonoController.text.trim().isEmpty
                      ? null
                      : telefonoController.text.trim(),
                  tipo: tipo,
                  isActivo: local?.isActivo ?? true,
                );

                viewModel.guardar(nuevoLocal);
                if (local == null) {
                  viewModel.seleccionarLocal(nuevoLocal.id);
                }
                Navigator.pop(ctx);
              },
              child: Text(local == null ? 'Crear' : 'Guardar'),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(
    BuildContext context,
    LocalesViewModel viewModel,
    Local local,
  ) {
    final invVM = context.read<InventarioViewModel>();
    final cliVM = context.read<ClientesViewModel>();
    final provVM = context.read<ProveedoresViewModel>();
    final pedVM = context.read<PedidosProveedorViewModel>();
    final movVM = context.read<MovimientosViewModel>();
    final ventVM = context.read<VentasViewModel>();

    final productosCount = invVM.items
        .where((p) => p.localId == local.id)
        .length;
    final clientesCount = cliVM.items
        .where((c) => c.localId == local.id)
        .length;
    final proveedoresCount = provVM.items
        .where((p) => p.localId == local.id)
        .length;
    final pedidosCount = pedVM.items.where((p) => p.localId == local.id).length;
    final movimientosCount = movVM.items
        .where((m) => m.localId == local.id)
        .length;
    final ventasCount = ventVM.items.where((v) => v.localId == local.id).length;

    final totalDatos =
        productosCount +
        clientesCount +
        proveedoresCount +
        pedidosCount +
        movimientosCount +
        ventasCount;

    if (totalDatos > 0) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('📦 Local con datos'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('El local "${local.nombre}" tiene datos vinculados:'),
              const SizedBox(height: 12),
              if (productosCount > 0) Text('• $productosCount productos'),
              if (clientesCount > 0) Text('• $clientesCount clientes'),
              if (proveedoresCount > 0) Text('• $proveedoresCount proveedores'),
              if (pedidosCount > 0) Text('• $pedidosCount pedidos'),
              if (movimientosCount > 0) Text('• $movimientosCount movimientos'),
              if (ventasCount > 0) Text('• $ventasCount ventas'),
              const SizedBox(height: 12),
              const Text(
                '¿Qué deseas hacer?',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                viewModel.eliminar(local.id);
              },
              child: const Text('Eliminar igual'),
            ),
          ],
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Eliminar Local'),
          content: Text('¿Estás seguro de eliminar "${local.nombre}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: AppTheme.errorColor,
              ),
              onPressed: () {
                viewModel.eliminar(local.id);
                Navigator.pop(ctx);
              },
              child: const Text('Eliminar'),
            ),
          ],
        ),
      );
    }
  }
}

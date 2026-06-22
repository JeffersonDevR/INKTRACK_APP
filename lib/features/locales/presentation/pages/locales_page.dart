import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:InkTrack/core/data/local/database.dart';
import 'package:InkTrack/features/locales/presentation/viewmodels/locales_viewmodel.dart';
import 'package:InkTrack/features/locales/data/models/local.dart';
import 'package:InkTrack/core/theme/app_theme.dart';
import 'package:InkTrack/core/services/import_service.dart';
import 'package:InkTrack/l10n/app_localizations.dart';
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
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.misLocales),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              final viewModel = context.read<LocalesViewModel>();
              if (value == 'add') {
                _showLocalDialog(context);
              } else if (value == 'import') {
                _performImport(context);
              } else if (value == 'delete_all') {
                _confirmDeleteAllData(context, viewModel);
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'add',
                child: Row(
                  children: [
                    Icon(Icons.add, size: 20),
                    SizedBox(width: 8),
                    Text(l10n.agregarLocal),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'import',
                child: Row(
                  children: [
                    Icon(
                      Icons.file_upload_rounded,
                      size: 20,
                      color: AppTheme.primaryColor,
                    ),
                    SizedBox(width: 8),
                    Text(
                      l10n.importData,
                      style: TextStyle(color: AppTheme.primaryColor),
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'delete_all',
                child: Row(
                  children: [
                    Icon(
                      Icons.delete_forever,
                      size: 20,
                      color: AppTheme.errorColor,
                    ),
                    SizedBox(width: 8),
                    Text(
                      l10n.eliminarTodosLosDatos,
                      style: TextStyle(color: AppTheme.errorColor),
                    ),
                  ],
                ),
              ),
            ],
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
                    l10n.noLocales,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.agregaTuPrimeraTienda,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () => _showLocalDialog(context),
                    icon: const Icon(Icons.add),
                    label: Text(l10n.agregarLocal),
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
                          child: Text(
                            l10n.actual,
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
                          PopupMenuItem(
                            value: 'select',
                            child: Row(
                              children: [
                                Icon(Icons.check_circle_outline, size: 20),
                                SizedBox(width: 8),
                                Text(l10n.seleccionar),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            value: 'edit',
                            child: Row(
                              children: [
                                Icon(Icons.edit_outlined, size: 20),
                                SizedBox(width: 8),
                                Text(l10n.editar),
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
                                  l10n.eliminar,
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
    final l10n = AppLocalizations.of(context)!;
    final nombreController = TextEditingController(text: local?.nombre);
    final direccionController = TextEditingController(text: local?.direccion);
    final telefonoController = TextEditingController(text: local?.telefono);
    String tipo = local?.tipo ?? 'tienda';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(local == null ? l10n.nuevoLocal : l10n.editarLocal),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nombreController,
                  decoration: InputDecoration(
                    labelText: l10n.nombre,
                    hintText: l10n.ejemploNombre,
                  ),
                  textCapitalization: TextCapitalization.words,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: direccionController,
                  decoration: InputDecoration(
                    labelText: '${l10n.direccion} (${l10n.clienteOpcional})',
                    hintText: l10n.ejemploTelefono,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: telefonoController,
                  decoration: InputDecoration(
                    labelText: '${l10n.telefono} (${l10n.clienteOpcional})',
                  ),
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  initialValue: tipo,
                  decoration: InputDecoration(labelText: l10n.tipo),
                  items: [
                    DropdownMenuItem(value: 'tienda', child: Text(l10n.tienda)),
                    DropdownMenuItem(value: 'bodega', child: Text(l10n.bodega)),
                    DropdownMenuItem(value: 'oficina', child: Text(l10n.oficina)),
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
              child: Text(l10n.cancelar),
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
              child: Text(local == null ? l10n.crear : l10n.guardar),
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
      final l10n = AppLocalizations.of(context)!;
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(l10n.localConDatos),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${l10n.localConDatos}: "${local.nombre}"'),
                const SizedBox(height: 12),
                if (productosCount > 0) Text('• $productosCount ${l10n.productos}'),
                if (clientesCount > 0) Text('• $clientesCount ${l10n.clientes}'),
                if (proveedoresCount > 0) Text('• $proveedoresCount ${l10n.proveedores}'),
                if (pedidosCount > 0) Text('• $pedidosCount ${l10n.pedidosProveedores}'),
                if (movimientosCount > 0) Text('• $movimientosCount ${l10n.movimientos}'),
                if (ventasCount > 0) Text('• $ventasCount ${l10n.ventas}'),
                const SizedBox(height: 12),
                Text(
                  l10n.queDeseasHacer,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(l10n.cancelar),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                viewModel.eliminar(local.id);
              },
              child: Text(l10n.eliminarIgual),
            ),
          ],
        ),
      );
    } else {
      final l10n = AppLocalizations.of(context)!;
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('${l10n.eliminar} ${l10n.local}'),
          content: Text('${l10n.eliminar} "${local.nombre}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(l10n.cancelar),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: AppTheme.errorColor,
              ),
              onPressed: () {
                viewModel.eliminar(local.id);
                Navigator.pop(ctx);
              },
              child: Text(l10n.eliminar),
            ),
          ],
        ),
      );
    }
  }

  void _confirmDeleteAllData(BuildContext context, LocalesViewModel viewModel) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.eliminarTodosLosDatos),
        content: Text(l10n.resetearData),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.cancelar),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppTheme.errorColor),
            onPressed: () async {
              final db = context.read<AppDatabase>();

              await db.delete(db.productos).go();
              await db.delete(db.clientes).go();
              await db.delete(db.proveedores).go();
              await db.delete(db.ventas).go();
              await db.delete(db.movimientos).go();
              await db.delete(db.pedidosProveedor).go();
              await db.delete(db.locales).go();

              if (context.mounted) {
                final localesVM = context.read<LocalesViewModel>();
                await localesVM.refresh();
              }

              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(l10n.todosLosDatosEliminados)),
                );
              }

              if (ctx.mounted) Navigator.pop(ctx);
            },
            child: Text(l10n.eliminarTodosLosDatos),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Import helpers
// ---------------------------------------------------------------------------

Future<void> _performImport(BuildContext context) async {
  final result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['xlsx', 'csv'],
  );

  if (result == null || result.files.single.path == null) return;

  final filePath = result.files.single.path!;
  final db = context.read<AppDatabase>();
  final importService = ImportService(db);
  final scaffoldMessenger = ScaffoldMessenger.of(context);

  final l10n = AppLocalizations.of(context)!;
  scaffoldMessenger.showSnackBar(
    SnackBar(
      content: Text(l10n.importando),
      duration: const Duration(seconds: 1),
    ),
  );

  final importResult = await importService.importFile(filePath, 'locales');
  if (context.mounted) {
    await context.read<LocalesViewModel>().refresh();
    _showImportResultDialog(context, importResult, 'locales');
  }
}

void _showImportResultDialog(
  BuildContext context,
  ImportResult result,
  String moduleLabel,
) {
  final l10n = AppLocalizations.of(context)!;
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      title: Text(
        result.success ? l10n.importSuccess : l10n.importError,
      ),
      content: result.success
          ? Text(l10n.importSuccess)
          : SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.importError),
                  const SizedBox(height: 12),
                  ...?result.errors?.map(
                    (e) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text(
                        e.toString(),
                        style: const TextStyle(
                          color: AppTheme.errorColor,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: Text(l10n.cancelar),
        ),
      ],
    ),
  );
}

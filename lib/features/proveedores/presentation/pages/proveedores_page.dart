import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:InkTrack/core/data/local/database.dart';
import 'package:InkTrack/core/utils/import_flow.dart';
import 'package:InkTrack/features/proveedores/presentation/viewmodels/proveedores_viewmodel.dart';
import 'package:InkTrack/features/proveedores/data/models/proveedor.dart';
import 'package:InkTrack/features/proveedores/data/importers/proveedores_import_validator.dart';
import 'package:InkTrack/core/theme/app_theme.dart';
import 'package:InkTrack/core/widgets/financial_summary_header.dart';
import 'proveedor_form_page.dart';
import 'pedidos_proveedor_page.dart';
import 'historial_visitas_page.dart';

class ProveedoresPage extends StatelessWidget {
  const ProveedoresPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProveedoresViewModel>(
      builder: (context, viewModel, child) {
        final showInactive = viewModel.showInactive;
        return Scaffold(body: _buildBody(context, viewModel, showInactive));
      },
    );
  }

  Widget _buildBody(
    BuildContext context,
    ProveedoresViewModel viewModel,
    bool showInactive,
  ) {
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
          sliver: SliverToBoxAdapter(
            child: FinancialSummaryHeader(
              title: 'Resumen Proveedores',
              actions: [
                _HeaderAction(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const HistorialVisitasPage(),
                    ),
                  ),
                  icon: Icons.history_rounded,
                  label: 'Historial',
                  color: AppTheme.primaryColor,
                ),
                _HeaderAction(
                  onTap: () => viewModel.toggleShowInactive(),
                  icon: showInactive ? Icons.visibility : Icons.visibility_off,
                  label: showInactive ? 'Ocultar' : 'Ver',
                  color: showInactive
                      ? AppTheme.warningColor
                      : AppTheme.textSecondary,
                ),
                _HeaderAction(
                  onTap: () => _importProveedores(context),
                  icon: Icons.upload_file_rounded,
                  label: 'Importar',
                  color: AppTheme.infoColor,
                ),
              ],
              totalIngresos: viewModel.proveedores.length.toDouble(),
              totalEgresos: viewModel.proveedores
                  .where((p) => p.diasVisita.isNotEmpty)
                  .length
                  .toDouble(),
              balance: 0,
              label1: 'Total',
              label2: 'Con Ruta',
              label3: 'Estadísticas',
              icon1: Icons.local_shipping_rounded,
              icon2: Icons.route_rounded,
              icon3: Icons.bar_chart_rounded,
              isCurrency1: false,
              isCurrency2: false,
              isCurrency3: false,
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          sliver: SliverToBoxAdapter(
            child: Text(
              'Listado de Proveedores',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
        ),
        if (viewModel.proveedores.isEmpty)
          SliverFillRemaining(hasScrollBody: false, child: _EmptyProveedores())
        else
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final proveedor = viewModel.proveedores[index];
                final isInactive = !proveedor.isActivo;
                final isDark = Theme.of(context).brightness == Brightness.dark;
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  color: isInactive
                      ? (isDark ? AppTheme.darkCard : Colors.grey.shade100)
                      : (isDark ? AppTheme.darkCard : null),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: CircleAvatar(
                      radius: 24,
                      backgroundColor: AppTheme.primaryColor.withValues(
                        alpha: 0.1,
                      ),
                      child: const Icon(
                        Icons.local_shipping_outlined,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                    title: Row(
                      children: [
                        Expanded(
                          child: Text(
                            proveedor.nombre,
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                        ),
                        if (isInactive)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? Colors.grey.shade700
                                  : Colors.grey.shade400,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              'INACTIVO',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                              ),
                            ),
                          ),
                      ],
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(
                          proveedor.telefono,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        if (proveedor.diasVisita.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(
                                Icons.calendar_today_rounded,
                                size: 14,
                                color: AppTheme.infoColor,
                              ),
                              const SizedBox(width: 4),
                              Flexible(
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Visita: ${proveedor.diasVisitaShort}',
                                    style: Theme.of(context).textTheme.bodySmall
                                        ?.copyWith(
                                          color: AppTheme.infoColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'edit') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ProveedorFormPage(proveedor: proveedor),
                            ),
                          );
                        } else if (value == 'view_pedidos') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PedidosProveedorPage(
                                showAll: true,
                                proveedorId: proveedor.id,
                              ),
                            ),
                          );
                        } else if (value == 'delete') {
                          _showDeleteDialog(context, proveedor);
                        } else if (value == 'reactivate') {
                          context.read<ProveedoresViewModel>().reactivar(
                            proveedor.id,
                          );
                        }
                      },
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 'view_pedidos',
                          child: Row(
                            children: [
                              Icon(
                                Icons.local_shipping_rounded,
                                size: 20,
                                color: AppTheme.primaryColor,
                              ),
                              const SizedBox(width: 8),
                              const Text('Ver Pedidos'),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 'edit',
                          child: Row(
                            children: [
                              Icon(Icons.edit_outlined, size: 20),
                              const SizedBox(width: 8),
                              const Text('Editar'),
                            ],
                          ),
                        ),
                        if (isInactive)
                          PopupMenuItem(
                            value: 'reactivate',
                            child: Row(
                              children: [
                                Icon(
                                  Icons.refresh,
                                  size: 20,
                                  color: AppTheme.successColor,
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  'Reactivar',
                                  style: TextStyle(
                                    color: AppTheme.successColor,
                                  ),
                                ),
                              ],
                            ),
                          )
                        else
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
                                const Text(
                                  'Eliminar',
                                  style: TextStyle(color: AppTheme.errorColor),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              }, childCount: viewModel.proveedores.length),
            ),
          ),
      ],
    );
  }

  Future<void> _importProveedores(BuildContext context) async {
    final db = context.read<AppDatabase>();
    await runImportFlow<Proveedor>(
      context: context,
      moduleName: 'Proveedores',
      requiredColumns: ProveedoresImportValidator.requiredColumns,
      validate: ProveedoresImportValidator.validate,
      batchImport: ProveedoresImportValidator.batchImport,
      db: db,
      title: 'Importar Proveedores',
    );
    if (context.mounted) {
      context.read<ProveedoresViewModel>().refresh();
    }
  }

  void _showDeleteDialog(BuildContext context, Proveedor proveedor) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar Proveedor'),
        content: Text(
          '¿Eliminar ${proveedor.nombre}?\n(Se marcará como inactivo para trazabilidad)',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              context.read<ProveedoresViewModel>().eliminar(proveedor.id);
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

class _HeaderAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color color;

  const _HeaderAction({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 20),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 9,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyProveedores extends StatelessWidget {
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
              Icons.local_shipping_outlined,
              size: 80,
              color: isDark
                  ? AppTheme.darkTextSecondary.withValues(alpha: 0.5)
                  : AppTheme.textSecondary.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'No hay datos disponibles',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Registra proveedores para asociarlos con productos del inventario.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}

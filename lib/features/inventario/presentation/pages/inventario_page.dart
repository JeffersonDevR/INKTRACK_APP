import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:InkTrack/features/inventario/presentation/viewmodels/inventario_viewmodel.dart';
import 'package:InkTrack/features/inventario/data/models/producto.dart';
import 'package:InkTrack/features/clientes/presentation/viewmodels/clientes_viewmodel.dart';
import 'package:InkTrack/features/proveedores/presentation/viewmodels/proveedores_viewmodel.dart';
import 'package:InkTrack/features/ventas/presentation/viewmodels/ventas_viewmodel.dart';
import 'package:InkTrack/features/movimientos/presentation/viewmodels/movimientos_viewmodel.dart';
import 'package:InkTrack/core/theme/app_theme.dart';
import 'package:InkTrack/core/widgets/financial_summary_header.dart';
import 'package:InkTrack/core/utils/number_formatter.dart';
import 'package:InkTrack/core/services/supabase_sync_service.dart';
import 'package:InkTrack/core/widgets/app_card.dart';
import 'package:InkTrack/l10n/app_localizations.dart';
import 'producto_form_page.dart';

class InventarioPage extends StatelessWidget {
  const InventarioPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<InventarioViewModel>(
      builder: (context, viewModel, child) {
        final showInactive = viewModel.showInactive;
        final l10n = AppLocalizations.of(context)!;

        return Scaffold(
          body: CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
                sliver: SliverToBoxAdapter(
                  child: FinancialSummaryHeader(
                    title: l10n.controlDeInventarioTitle,
                    actions: [
                      _HeaderAction(
                        icon: showInactive
                            ? Icons.visibility_rounded
                            : Icons.visibility_off_rounded,
                        label: showInactive ? 'Ocultar' : 'Ver',
                        onTap: () => viewModel.toggleShowInactive(),
                        color: showInactive
                            ? AppTheme.warningColor
                            : AppTheme.textSecondary,
                      ),
                      _HeaderAction(
                        icon: Icons.cloud_sync_rounded,
                        label: 'Sincro',
                        onTap: () => _showSyncOptions(context, viewModel),
                        color: AppTheme.primaryColor,
                      ),
                    ],
                    totalIngresos: viewModel.totalProductos,
                    totalEgresos: viewModel.productosConStockBajo.length.toDouble(),
                    balance: viewModel.valorTotalInventario,
                    label1: l10n.total,
                    label2: 'Stock Bajo',
                    label3: 'Valor',
                    icon1: Icons.inventory_2_rounded,
                    icon2: Icons.warning_amber_rounded,
                    icon3: Icons.account_balance_wallet_rounded,
                    isCurrency1: false,
                    isCurrency2: false,
                    isCurrency3: true,
                  ),
                ),
              ),
              if (viewModel.productos.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: _EmptyInventario(),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final producto = viewModel.productos[index];
                      return _ProductoCard(
                        producto: producto,
                        onEdit: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ProductoFormPage(producto: producto),
                            ),
                          );
                        },
                        onDelete: () => _showDeleteDialog(context, producto),
                        onReactivate: () =>
                            _showReactivateDialog(context, producto),
                      );
                    }, childCount: viewModel.productos.length),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  void _showSyncOptions(BuildContext context, InventarioViewModel viewModel) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.cloud_upload_rounded),
              title: const Text('Subir cambios'),
              onTap: () {
                Navigator.pop(ctx);
                _performSync(context, viewModel, 'upload');
              },
            ),
            ListTile(
              leading: const Icon(Icons.cloud_download_rounded),
              title: const Text('Descargar de la nube'),
              onTap: () {
                Navigator.pop(ctx);
                _performSync(context, viewModel, 'download');
              },
            ),
            ListTile(
              leading: const Icon(Icons.sync_rounded),
              title: const Text('Sincronización total'),
              onTap: () {
                Navigator.pop(ctx);
                _performSync(context, viewModel, 'both');
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _performSync(
    BuildContext context,
    InventarioViewModel viewModel,
    String mode,
  ) async {
    final syncService = context.read<SupabaseSyncService>();
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    scaffoldMessenger.showSnackBar(
      SnackBar(
        content: Text(
          mode == 'upload'
              ? 'Subiendo cambios...'
              : mode == 'download'
              ? 'Descargando de la nube...'
              : 'Sincronizando todo...',
        ),
        duration: const Duration(seconds: 1),
      ),
    );

    SyncResult result;
    if (mode == 'upload') {
      result = await syncService.syncAll();
    } else if (mode == 'download') {
      result = await syncService.downloadAll();
    } else {
      final uploadResult = await syncService.syncAll();
      result = await syncService.downloadAll();
      if (uploadResult.errors > 0) {
        result = SyncResult(
          tableName: 'both',
          uploaded: uploadResult.uploaded,
          downloaded: result.downloaded,
          errors: uploadResult.errors + result.errors,
        );
      }
    }

    if (result.isSuccess) {
      await viewModel.refresh();
      if (context.mounted) {
        final cliVM = context.read<ClientesViewModel>();
        final provVM = context.read<ProveedoresViewModel>();
        final ventVM = context.read<VentasViewModel>();
        final movVM = context.read<MovimientosViewModel>();
        await Future.wait([
          cliVM.refresh(),
          provVM.refresh(),
          ventVM.refresh(),
          movVM.refresh(),
        ]);
      }
    }

    scaffoldMessenger.showSnackBar(
      SnackBar(
        content: Text(
          result.isSuccess
              ? '¡Sincronización completa!'
              : 'Error en sincronización: ${result.errors} errores',
        ),
        backgroundColor: result.isSuccess ? AppTheme.successColor : AppTheme.errorColor,
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, Producto producto) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        title: Text('Desactivar ${l10n.producto}'),
        content: Text(
          '¿Desactivar "${producto.nombre}"?\n\nNo aparecerá en listados o nuevas ventas, pero se conservarán sus registros históricos.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.cancelar),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<InventarioViewModel>().eliminar(producto.id);
              Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorColor,
              foregroundColor: Colors.white,
            ),
            child: const Text('Desactivar'),
          ),
        ],
      ),
    );
  }

  void _showReactivateDialog(BuildContext context, Producto producto) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        title: Text('Reactivar ${l10n.producto}'),
        content: Text('¿Reactivar "${producto.nombre}" en el catálogo?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.cancelar),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<InventarioViewModel>().reactivar(producto.id);
              Navigator.pop(ctx);
            },
            child: const Text('Reactivar'),
          ),
        ],
      ),
    );
  }
}

class _EmptyInventario extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: isDark ? AppTheme.darkCard : AppTheme.backgroundColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.inventory_2_outlined,
                size: 64,
                color: AppTheme.textTertiary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Inventario vacío',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 12),
            Text(
              'Comienza agregando productos manualmente o escaneando códigos de barras.',
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppTheme.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProductoCard extends StatelessWidget {
  final Producto producto;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onReactivate;

  const _ProductoCard({
    required this.producto,
    required this.onEdit,
    required this.onDelete,
    required this.onReactivate,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isInactive = !producto.isActivo;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final stockColor = producto.stockBajo
        ? AppTheme.errorColor
        : AppTheme.successColor;

    return AppCard(
      onTap: isInactive ? null : onEdit,
      isInactive: isInactive,
      padding: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: (isInactive ? AppTheme.textTertiary : stockColor)
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    isInactive
                        ? Icons.block_rounded
                        : (producto.stockBajo
                              ? Icons.warning_amber_rounded
                              : Icons.inventory_2_rounded),
                    color: isInactive ? AppTheme.textTertiary : stockColor,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              producto.nombre,
                              style: Theme.of(context).textTheme.titleSmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 16,
                                  ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (isInactive) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? AppTheme.darkBorder
                                    : Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                'INACTIVO',
                                style: TextStyle(
                                  fontSize: 8,
                                  fontWeight: FontWeight.w900,
                                  color: isDark
                                      ? AppTheme.darkTextSecondary
                                      : AppTheme.textSecondary,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        producto.categoria,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  icon: Icon(
                    Icons.more_vert_rounded,
                    color: AppTheme.textTertiary,
                  ),
                  onSelected: (value) {
                    if (value == 'edit' && !isInactive) onEdit();
                    if (value == 'delete') onDelete();
                    if (value == 'reactivate' && isInactive) onReactivate();
                  },
                  itemBuilder: (context) => [
                    if (!isInactive)
                      PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit_outlined, size: 20),
                            const SizedBox(width: 12),
                            Text('Editar ${l10n.producto}'),
                          ],
                        ),
                      ),
                    if (isInactive)
                      PopupMenuItem(
                        value: 'reactivate',
                        child: Row(
                          children: [
                            Icon(
                              Icons.restore_page_outlined,
                              color: AppTheme.successColor,
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              'Reactivar',
                              style: TextStyle(color: AppTheme.successColor),
                            ),
                          ],
                        ),
                      ),
                    if (!isInactive)
                      PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(
                              Icons.delete_outline_rounded,
                              color: AppTheme.errorColor,
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Desactivar',
                              style: TextStyle(color: AppTheme.errorColor),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.precioVenta.toUpperCase(),
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        letterSpacing: 1,
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.textTertiary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      NumberFormatter.formatCurrency(producto.precioVenta),
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w900,
                        color: isInactive
                            ? AppTheme.textTertiary
                            : (isDark
                                  ? AppTheme.darkTextPrimary
                                  : AppTheme.textPrimary),
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: (isInactive ? AppTheme.textTertiary : stockColor)
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: (isInactive ? AppTheme.textTertiary : stockColor)
                          .withValues(alpha: 0.2),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.layers_outlined,
                        size: 16,
                        color: isInactive ? AppTheme.textTertiary : stockColor,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'STOCK: ${producto.cantidad % 1 == 0 ? producto.cantidad.toInt() : producto.cantidad.toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.labelMedium
                            ?.copyWith(
                              color: isInactive
                                  ? AppTheme.textTertiary
                                  : stockColor,
                              fontWeight: FontWeight.w900,
                              fontSize: 12,
                            ),
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

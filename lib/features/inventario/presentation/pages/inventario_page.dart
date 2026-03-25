import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:InkTrack/features/inventario/presentation/viewmodels/inventario_viewmodel.dart';
import 'package:InkTrack/features/inventario/data/models/producto.dart';
import 'package:InkTrack/core/theme/app_theme.dart';
import 'package:InkTrack/core/widgets/financial_summary_header.dart';
import 'package:InkTrack/core/utils/number_formatter.dart';
import 'producto_form_page.dart';

class InventarioPage extends StatelessWidget {
  const InventarioPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<InventarioViewModel>(
      builder: (context, viewModel, child) {
        final showInactive = viewModel.showInactive;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Inventario'),
            actions: [
              IconButton(
                onPressed: () => viewModel.toggleShowInactive(),
                icon: Icon(
                  showInactive ? Icons.visibility_off : Icons.visibility,
                  color: showInactive ? AppTheme.secondaryColor : null,
                ),
                tooltip: showInactive ? 'Ocultar inactivos' : 'Ver inactivos',
              ),
            ],
          ),
          body: viewModel.productos.isEmpty && !showInactive
              ? _EmptyInventario()
              : CustomScrollView(
                  slivers: [
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
                      sliver: SliverToBoxAdapter(
                        child: FinancialSummaryHeader(
                          title: 'Resumen\nInventario',
                          totalIngresos: viewModel.totalProductos.toDouble(),
                          totalEgresos: viewModel.productosConStockBajo.length
                              .toDouble(),
                          balance: viewModel.valorTotalInventario,
                          label1: 'Stock Total',
                          label2: 'Bajo Stock',
                          label3: 'Valor Total',
                          icon1: Icons.inventory_2_rounded,
                          icon2: Icons.warning_amber_rounded,
                          icon3: Icons.account_balance_wallet_rounded,
                          isCurrency1: false,
                          isCurrency2: false,
                          isCurrency3: true,
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
                              'Catálogo de Productos',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            if (showInactive &&
                                viewModel.productos
                                    .where((p) => !p.isActivo)
                                    .isNotEmpty)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  '${viewModel.productos.where((p) => !p.isActivo).length} inactivo(s)',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade600,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
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
                            onDelete: () =>
                                _showDeleteDialog(context, producto),
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

  void _showDeleteDialog(BuildContext context, Producto producto) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar producto'),
        content: Text(
          producto.isActivo
              ? '¿Eliminar "${producto.nombre}" del inventario?\n\nEl producto se desactivará y no aparecerá en la lista, pero sus datos se mantendrán para auditoría.'
              : '"${producto.nombre}" ya está desactivado.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          if (producto.isActivo)
            TextButton(
              onPressed: () {
                context.read<InventarioViewModel>().eliminar(producto.id);
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${producto.nombre} desactivado'),
                    action: SnackBarAction(
                      label: 'Deshacer',
                      onPressed: () {
                        context.read<InventarioViewModel>().reactivar(
                          producto.id,
                        );
                      },
                    ),
                  ),
                );
              },
              style: TextButton.styleFrom(foregroundColor: AppTheme.errorColor),
              child: const Text('Desactivar'),
            ),
        ],
      ),
    );
  }

  void _showReactivateDialog(BuildContext context, Producto producto) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Reactivar producto'),
        content: Text(
          '¿Reactivar "${producto.nombre}"?\n\nEl producto volverá a aparecer en el inventario.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              context.read<InventarioViewModel>().reactivar(producto.id);
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${producto.nombre} reactivado')),
              );
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
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inventory_2_outlined,
              size: 80,
              color: AppTheme.textSecondary.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'No hay productos',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Usa el botón de abajo para añadir productos o escanear códigos.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
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
    final isInactive = !producto.isActivo;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: isInactive ? Colors.grey.shade100 : null,
      child: InkWell(
        onTap: isInactive ? null : onEdit,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color:
                          (isInactive
                                  ? Colors.grey
                                  : (producto.stockBajo
                                        ? AppTheme.errorColor
                                        : AppTheme.primaryColor))
                              .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      isInactive
                          ? Icons.block_rounded
                          : (producto.stockBajo
                                ? Icons.warning_amber_rounded
                                : Icons.inventory_2_rounded),
                      color: isInactive
                          ? Colors.grey
                          : (producto.stockBajo
                                ? AppTheme.errorColor
                                : AppTheme.primaryColor),
                      size: 24,
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
                                style: Theme.of(context).textTheme.labelLarge
                                    ?.copyWith(
                                      color: isInactive ? Colors.grey : null,
                                    ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (isInactive) ...[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade400,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text(
                                  'INACTIVO',
                                  style: TextStyle(
                                    fontSize: 8,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        Text(
                          producto.categoria,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: isInactive ? Colors.grey : null,
                              ),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'edit' && !isInactive) onEdit();
                      if (value == 'delete') onDelete();
                      if (value == 'reactivate' && isInactive) onReactivate();
                    },
                    itemBuilder: (context) => [
                      if (!isInactive)
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
                      if (isInactive)
                        PopupMenuItem(
                          value: 'reactivate',
                          child: Row(
                            children: [
                              Icon(
                                Icons.restore,
                                color: AppTheme.secondaryColor,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Reactivar',
                                style: TextStyle(
                                  color: AppTheme.secondaryColor,
                                ),
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
                              const SizedBox(width: 8),
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
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Precio Unitario',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: isInactive ? Colors.grey : null,
                        ),
                      ),
                      Text(
                        NumberFormatter.formatCurrency(producto.precio),
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              color: isInactive
                                  ? Colors.grey
                                  : AppTheme.secondaryColor,
                              fontWeight: FontWeight.w900,
                            ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color:
                          (isInactive
                                  ? Colors.grey
                                  : (producto.stockBajo
                                        ? AppTheme.errorColor
                                        : AppTheme.secondaryColor))
                              .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.warehouse_rounded,
                          size: 16,
                          color: isInactive
                              ? Colors.grey
                              : (producto.stockBajo
                                    ? AppTheme.errorColor
                                    : AppTheme.secondaryColor),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Stock: ${producto.cantidad}',
                          style: Theme.of(context).textTheme.labelMedium
                              ?.copyWith(
                                color: isInactive
                                    ? Colors.grey
                                    : (producto.stockBajo
                                          ? AppTheme.errorColor
                                          : AppTheme.secondaryColor),
                                fontWeight: FontWeight.bold,
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
      ),
    );
  }
}

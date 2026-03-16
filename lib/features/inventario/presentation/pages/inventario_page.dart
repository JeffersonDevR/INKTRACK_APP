import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:InkTrack/features/inventario/presentation/viewmodels/inventario_viewmodel.dart';
import 'package:InkTrack/features/inventario/data/models/producto.dart';
import 'package:InkTrack/core/theme/app_theme.dart';
import 'package:InkTrack/core/widgets/financial_summary_header.dart';
import 'package:InkTrack/features/inventario/presentation/widgets/barcode_viewer_dialog.dart';
import 'producto_form_page.dart';

class InventarioPage extends StatelessWidget {
  const InventarioPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Inventario')),
      body: Consumer<InventarioViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.productos.isEmpty) {
            return _EmptyInventario();
          }

          return CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
                sliver: SliverToBoxAdapter(
                  child: FinancialSummaryHeader(
                    title: 'Resumen\nInventario',
                    totalIngresos: viewModel.totalProductos.toDouble(),
                    totalEgresos: viewModel.productosConStockBajo.length.toDouble(),
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
                  child: Text(
                    'Catálogo de Productos',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final producto = viewModel.productos[index];
                      return _ProductoCard(
                        producto: producto,
                        onEdit: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductoFormPage(producto: producto),
                            ),
                          );
                        },
                        onDelete: () => _showDeleteDialog(context, producto),
                      );
                    },
                    childCount: viewModel.productos.length,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, Producto producto) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar producto'),
        content: Text('¿Eliminar "${producto.nombre}" del inventario?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              context.read<InventarioViewModel>().eliminar(producto.id);
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

  const _ProductoCard({
    required this.producto,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onEdit,
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
                      color: (producto.stockBajo ? AppTheme.errorColor : AppTheme.primaryColor)
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      producto.stockBajo ? Icons.warning_amber_rounded : Icons.inventory_2_rounded,
                      color: producto.stockBajo ? AppTheme.errorColor : AppTheme.primaryColor,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          producto.nombre,
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                        Text(
                          producto.categoria,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'edit') onEdit();
                      if (value == 'delete') onDelete();
                      if (value == 'view_code') {
                        final code = producto.codigoBarras ?? producto.codigoPersonalizado ?? producto.id;
                        final isCustom = producto.codigoPersonalizado != null && producto.codigoPersonalizado == code;
                        showDialog(
                          context: context,
                          builder: (context) => BarcodeViewerDialog(
                            code: code,
                            productName: producto.nombre,
                            isCustom: isCustom,
                          ),
                        );
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(value: 'edit', child: Row(children: [Icon(Icons.edit_outlined, size: 20), SizedBox(width: 8), Text('Editar')])),
                      const PopupMenuItem(value: 'view_code', child: Row(children: [Icon(Icons.qr_code_2_rounded, size: 20), SizedBox(width: 8), Text('Ver Código')])),
                      PopupMenuItem(
                        value: 'delete',
                        child: Row(children: [Icon(Icons.delete_outline_rounded, color: AppTheme.errorColor, size: 20), const SizedBox(width: 8), Text('Eliminar', style: TextStyle(color: AppTheme.errorColor))]),
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
                      Text('Precio Unitario', style: Theme.of(context).textTheme.labelSmall),
                      Text(
                        '\$${producto.precio.toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: AppTheme.secondaryColor,
                              fontWeight: FontWeight.w900,
                            ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: (producto.stockBajo ? AppTheme.errorColor : AppTheme.secondaryColor).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.warehouse_rounded,
                          size: 16,
                          color: producto.stockBajo ? AppTheme.errorColor : AppTheme.secondaryColor,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Stock: ${producto.cantidad}',
                          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                color: producto.stockBajo ? AppTheme.errorColor : AppTheme.secondaryColor,
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

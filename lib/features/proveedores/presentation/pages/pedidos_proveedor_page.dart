import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:InkTrack/core/theme/app_theme.dart';
import 'package:InkTrack/features/proveedores/presentation/viewmodels/pedidos_viewmodel.dart';
import 'package:InkTrack/features/proveedores/data/models/pedido_proveedor.dart';
import 'package:InkTrack/features/inventario/presentation/viewmodels/inventario_viewmodel.dart';
import 'package:InkTrack/features/movimientos/presentation/viewmodels/movimientos_viewmodel.dart';
import 'crear_pedido_page.dart';

class PedidosProveedorPage extends StatelessWidget {
  final bool showAll;

  const PedidosProveedorPage({super.key, this.showAll = true});

  @override
  Widget build(BuildContext context) {
    return Consumer<PedidosProveedorViewModel>(
      builder: (context, viewModel, child) {
        final pedidos = showAll ? viewModel.items : viewModel.pedidosPendientes;
        return Scaffold(
          appBar: AppBar(
            title: Text(
              showAll ? 'Pedidos a Proveedores' : 'Pedidos Pendientes',
            ),
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CrearPedidoPage(),
                    ),
                  );
                },
                icon: const Icon(Icons.add),
              ),
            ],
          ),
          body: pedidos.isEmpty
              ? _buildEmpty(context)
              : _buildList(context, pedidos, viewModel),
        );
      },
    );
  }

  Widget _buildEmpty(BuildContext context) {
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
              'No hay pedidos',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Crea un pedido a proveedor para recibir alertas de entrega.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildList(
    BuildContext context,
    List<PedidoProveedor> pedidos,
    PedidosProveedorViewModel viewModel,
  ) {
    final currencyFormat = NumberFormat.currency(
      symbol: '\$',
      decimalDigits: 2,
    );
    final dateFormat = DateFormat('dd MMM yyyy');
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: pedidos.length,
      itemBuilder: (context, index) {
        final pedido = pedidos[index];
        final isEntregado = pedido.isEntregado;
        final daysUntil = pedido.fechaEntrega.difference(DateTime.now()).inDays;

        Color statusColor;
        String statusText;
        if (isEntregado) {
          statusColor = AppTheme.successColor;
          statusText = 'Entregado';
        } else if (daysUntil < 0) {
          statusColor = AppTheme.errorColor;
          statusText =
              'Atrasado ${-daysUntil} día${-daysUntil == 1 ? '' : 's'}';
        } else if (daysUntil <= 2) {
          statusColor = AppTheme.warningColor;
          statusText = 'Próximo ($daysUntil días)';
        } else {
          statusColor = AppTheme.infoColor;
          statusText = dateFormat.format(pedido.fechaEntrega);
        }

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: InkWell(
            onTap: () => _showDetalleDialog(context, pedido, viewModel),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          pedido.proveedorNombre ??
                              'Proveedor #${pedido.proveedorId}',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                      PopupMenuButton<String>(
                        onSelected: (value) {
                          if (value == 'delete') {
                            _showEliminarDialog(context, pedido, viewModel);
                          }
                        },
                        itemBuilder: (context) => [
                          const PopupMenuItem(
                            value: 'delete',
                            child: Row(
                              children: [
                                Icon(
                                  Icons.delete_outline,
                                  color: AppTheme.errorColor,
                                  size: 20,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'Eliminar',
                                  style: TextStyle(color: AppTheme.errorColor),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: statusColor.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          statusText,
                          style: TextStyle(
                            color: statusColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${pedido.productos.length} producto${pedido.productos.length == 1 ? '' : 's'} • ${currencyFormat.format(pedido.montoTotal)}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Entrega: ${dateFormat.format(pedido.fechaEntrega)}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: isDark
                          ? AppTheme.darkTextSecondary
                          : AppTheme.textSecondary,
                    ),
                  ),
                  if (!isEntregado) ...[
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        OutlinedButton(
                          onPressed: () => _showMarcarEntregadoDialog(
                            context,
                            pedido,
                            viewModel,
                          ),
                          child: const Text('Marcar Entregado'),
                        ),
                      ],
                    ),
                  ] else ...[
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        OutlinedButton(
                          onPressed: null,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppTheme.successColor.withValues(
                              alpha: 0.5,
                            ),
                            side: BorderSide(
                              color: AppTheme.successColor.withValues(
                                alpha: 0.5,
                              ),
                            ),
                          ),
                          child: const Text('✓ Entregado'),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showDetalleDialog(
    BuildContext context,
    PedidoProveedor pedido,
    PedidosProveedorViewModel viewModel,
  ) {
    final currencyFormat = NumberFormat.currency(
      symbol: '\$',
      decimalDigits: 2,
    );
    final dateFormat = DateFormat('dd MMM yyyy');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        maxChildSize: 0.9,
        minChildSize: 0.4,
        expand: false,
        builder: (context, scrollController) => Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Detalle del Pedido',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Icon(
                    Icons.local_shipping_outlined,
                    color: AppTheme.primaryColor,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    pedido.proveedorNombre ?? 'Proveedor',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Icon(
                    Icons.calendar_today_outlined,
                    color: AppTheme.primaryColor,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Fecha de entrega: ${dateFormat.format(pedido.fechaEntrega)}',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  const Expanded(
                    flex: 3,
                    child: Text(
                      'Producto',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(
                    width: 50,
                    child: Text(
                      'Cant',
                      style: TextStyle(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(
                    width: 80,
                    child: Text(
                      'Precio',
                      style: TextStyle(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.right,
                    ),
                  ),
                  const SizedBox(
                    width: 80,
                    child: Text(
                      'Subtotal',
                      style: TextStyle(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.right,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                itemCount: pedido.productos.length,
                itemBuilder: (context, index) {
                  final producto = pedido.productos[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Row(
                      children: [
                        Expanded(flex: 3, child: Text(producto.nombre)),
                        const SizedBox(width: 8),
                        SizedBox(
                          width: 42,
                          child: Text(
                            '${producto.cantidad}',
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(width: 8),
                        SizedBox(
                          width: 72,
                          child: Text(
                            currencyFormat.format(producto.precioUnitario),
                            textAlign: TextAlign.right,
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                        const SizedBox(width: 8),
                        SizedBox(
                          width: 72,
                          child: Text(
                            currencyFormat.format(producto.subtotal),
                            textAlign: TextAlign.right,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'TOTAL',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  Text(
                    currencyFormat.format(pedido.montoTotal),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showMarcarEntregadoDialog(
    BuildContext context,
    PedidoProveedor pedido,
    PedidosProveedorViewModel viewModel,
  ) {
    final inventarioVM = context.read<InventarioViewModel>();
    final movimientosVM = context.read<MovimientosViewModel>();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirmar entrega'),
        content: Text(
          '¿Marcar el pedido como entregado?\n\n'
          '• ${pedido.productos.length} producto(s) se agregarán al inventario\n'
          '• Se registrará un egreso de ${NumberFormat.currency(symbol: '\$', decimalDigits: 2).format(pedido.montoTotal)}',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () async {
              await viewModel.marcarEntregado(
                pedido.id,
                inventarioVM,
                movimientosVM: movimientosVM,
              );
              if (ctx.mounted) Navigator.pop(ctx);
              if (context.mounted) Navigator.pop(context);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Pedido marcado como entregado + egreso de ${NumberFormat.currency(symbol: '\$', decimalDigits: 0).format(pedido.montoTotal)}',
                    ),
                    backgroundColor: AppTheme.successColor,
                  ),
                );
              }
            },
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );
  }

  void _showEliminarDialog(
    BuildContext context,
    PedidoProveedor pedido,
    PedidosProveedorViewModel viewModel,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar pedido'),
        content: Text(
          '¿Eliminar el pedido a ${pedido.proveedorNombre ?? "proveedor"}?\n\nEsta acción no se puede deshacer.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () {
              viewModel.eliminar(pedido.id);
              Navigator.pop(ctx);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Pedido eliminado'),
                  backgroundColor: AppTheme.errorColor,
                ),
              );
            },
            style: FilledButton.styleFrom(backgroundColor: AppTheme.errorColor),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }
}

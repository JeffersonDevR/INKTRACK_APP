import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:InkTrack/core/theme/app_theme.dart';
import 'package:InkTrack/core/utils/number_formatter.dart';
import 'package:InkTrack/features/proveedores/presentation/viewmodels/pedidos_viewmodel.dart';
import 'package:InkTrack/features/proveedores/data/models/pedido_proveedor.dart';

class HistorialVisitasPage extends StatelessWidget {
  const HistorialVisitasPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial de Visitas y Pedidos'),
      ),
      body: Consumer<PedidosProveedorViewModel>(
        builder: (context, viewModel, child) {
          final visitas = viewModel.pedidosEntregados
            ..sort((a, b) => b.fechaEntrega.compareTo(a.fechaEntrega));

          if (visitas.isEmpty) {
            return _buildEmpty(context);
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: visitas.length,
            itemBuilder: (context, index) {
              final visit = visitas[index];
              return _VisitCard(visit: visit);
            },
          );
        },
      ),
    );
  }

  Widget _buildEmpty(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history_rounded,
            size: 80,
            color: AppTheme.textSecondary.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 16),
          const Text(
            'No hay historial de visitas',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 8),
          const Text('Las entregas confirmadas aparecerán aquí.'),
        ],
      ),
    );
  }
}

class _VisitCard extends StatelessWidget {
  final PedidoProveedor visit;

  const _VisitCard({required this.visit});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final dateFormat = DateFormat('dd/MM/yyyy');
    
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: AppTheme.primaryColor.withValues(alpha: 0.1),
          child: const Icon(Icons.local_shipping_rounded, color: AppTheme.primaryColor),
        ),
        title: Text(
          visit.proveedorNombre ?? 'Proveedor',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text('Vino el día ${dateFormat.format(visit.fechaEntrega)}'),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Desglose de productos:',
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
                ),
                const SizedBox(height: 12),
                ...visit.productos.map((p) => Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          p.nombre,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                      Text(
                        '${p.cantidad.toInt()} x ${NumberFormatter.formatCompact(p.precioUnitario)}',
                        style: TextStyle(
                          color: isDark ? AppTheme.darkTextSecondary : AppTheme.textSecondary,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        NumberFormatter.formatCompact(p.subtotal),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                )),
                const Divider(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'TOTAL PACTADO',
                      style: TextStyle(fontWeight: FontWeight.w900, fontSize: 14),
                    ),
                    Text(
                      NumberFormatter.formatCurrency(visit.montoTotal),
                      style: const TextStyle(
                        fontWeight: FontWeight.w900, 
                        fontSize: 16,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                  ],
                ),
                if (visit.notas != null && visit.notas!.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isDark ? Colors.black26 : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Notas: ${visit.notas}',
                      style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

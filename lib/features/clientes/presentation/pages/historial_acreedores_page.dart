import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:InkTrack/core/theme/app_theme.dart';
import 'package:InkTrack/core/utils/number_formatter.dart';
import 'package:InkTrack/features/clientes/data/models/cliente.dart';
import 'package:InkTrack/features/clientes/presentation/viewmodels/clientes_viewmodel.dart';
import 'package:InkTrack/features/movimientos/data/models/movimiento.dart';
import 'package:InkTrack/features/movimientos/presentation/viewmodels/movimientos_viewmodel.dart';
import 'package:InkTrack/features/clientes/presentation/widgets/pago_dialog.dart';

class HistorialAcreedoresPage extends StatelessWidget {
  const HistorialAcreedoresPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Acreedores'),
      ),
      body: Consumer2<ClientesViewModel, MovimientosViewModel>(
        builder: (context, clientesVM, movimientosVM, child) {
          final clientes = clientesVM.clientes
              .where((cliente) => cliente.saldoPendiente > 0)
              .toList();

          if (clientes.isEmpty) {
            return _buildEmpty();
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: clientes.length,
            itemBuilder: (context, index) {
              final cliente = clientes[index];
              final creditos = _creditosDelCliente(cliente, movimientosVM);
              return _ClienteAcreedorCard(
                cliente: cliente,
                creditos: creditos,
                movimientosVM: movimientosVM,
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(
            Icons.account_balance_wallet_rounded,
            size: 72,
            color: AppTheme.textSecondary,
          ),
          SizedBox(height: 16),
          Text(
            'No hay acreedores registrados',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text('Las ventas a crédito aparecerán aquí para hacer abonos.'),
        ],
      ),
    );
  }

  List<Movimiento> _creditosDelCliente(
    Cliente cliente,
    MovimientosViewModel movimientosVM,
  ) {
    return movimientosVM.filteredItems
        .where((m) =>
            m.clienteId == cliente.id &&
            m.esFiado &&
            m.tipo == MovimientoType.ingreso)
        .toList()
      ..sort((a, b) => b.fecha.compareTo(a.fecha));
  }
}

class _ClienteAcreedorCard extends StatelessWidget {
  final Cliente cliente;
  final List<Movimiento> creditos;
  final MovimientosViewModel movimientosVM;

  const _ClienteAcreedorCard({
    required this.cliente,
    required this.creditos,
    required this.movimientosVM,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM/yyyy');
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Row(
          children: [
            Expanded(
              child: Text(
                cliente.nombre,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Text(
              NumberFormatter.formatCurrency(cliente.saldoPendiente),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: AppTheme.errorColor,
              ),
            ),
          ],
        ),
        subtitle: Text('Pendiente de pago: ${NumberFormatter.formatCurrency(cliente.saldoPendiente)}'),
        children: [
          if (creditos.isEmpty)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'No se encontraron ventas a crédito para este cliente.',
                style: TextStyle(color: AppTheme.textSecondary),
              ),
            )
          else ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: creditos.map((credito) {
                  return Column(
                    children: [
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: CircleAvatar(
                          backgroundColor: AppTheme.primaryColor.withValues(alpha: 0.1),
                          child: const Icon(
                            Icons.calendar_today_rounded,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                        title: Text(credito.concepto),
                        subtitle: Text(dateFormat.format(credito.fecha)),
                        trailing: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              NumberFormatter.formatCurrency(credito.monto),
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            TextButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => PagoDialog(
                                    cliente: cliente,
                                    maxAmount: math.min(
                                      credito.monto,
                                      cliente.saldoPendiente,
                                    ),
                                    conceptDetail:
                                        'Abono al acreedor del ${dateFormat.format(credito.fecha)}',
                                  ),
                                );
                              },
                              child: const Text('Abonar'),
                            ),
                          ],
                        ),
                      ),
                      const Divider(height: 0),
                    ],
                  );
                }).toList(),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

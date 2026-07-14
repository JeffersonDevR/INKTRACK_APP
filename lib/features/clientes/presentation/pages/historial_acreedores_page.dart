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
import 'package:InkTrack/features/clientes/domain/deudor_status.dart';
import 'package:InkTrack/l10n/app_localizations.dart';


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
            return _buildEmpty(context);
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

  Widget _buildEmpty(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.account_balance_wallet_rounded,
            size: 72,
            color: AppTheme.textSecondary,
          ),
          SizedBox(height: 16),
          Text(
            'No hay acreedores registrados',
            style: Theme.of(context).textTheme.titleLarge
                ?.copyWith(fontWeight: FontWeight.bold),
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

  Widget _buildTrafficLightBadge(BuildContext context) {
    final status = computeStatus(cliente);
    final l10n = AppLocalizations.of(context)!;
    
    Color badgeColor;
    String label;
    switch (status) {
      case DeudorStatus.alDia:
        badgeColor = AppTheme.successColor;
        label = l10n.debtorStatusUpToDate;
        break;
      case DeudorStatus.porVencer:
        badgeColor = Colors.orange;
        label = l10n.debtorStatusDueSoon;
        break;
      case DeudorStatus.vencido:
        badgeColor = AppTheme.errorColor;
        label = l10n.debtorStatusOverdue;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: badgeColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: badgeColor),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: badgeColor,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM/yyyy');
    final l10n = AppLocalizations.of(context)!;
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
            _buildTrafficLightBadge(context),
            const SizedBox(width: 8),
            Text(
              NumberFormatter.formatCurrency(cliente.saldoPendiente),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: AppTheme.errorColor,
              ),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Pendiente de pago: ${NumberFormatter.formatCurrency(cliente.saldoPendiente)}'),
            if (cliente.promesaPago != null) ...[
              const SizedBox(height: 4),
              Text(
                '${l10n.paymentPromiseDateLabel}: ${dateFormat.format(cliente.promesaPago!)}',
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ],
          ],
        ),
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

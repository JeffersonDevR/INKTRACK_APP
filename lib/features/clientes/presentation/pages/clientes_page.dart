import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:InkTrack/features/clientes/presentation/viewmodels/clientes_viewmodel.dart';
import 'package:InkTrack/features/clientes/data/models/cliente.dart';
import 'package:InkTrack/core/theme/app_theme.dart';
import 'package:InkTrack/core/widgets/financial_summary_header.dart';
import 'package:InkTrack/core/utils/number_formatter.dart';
import 'cliente_form_page.dart';
import '../widgets/pago_dialog.dart';

class ClientesPage extends StatelessWidget {
  const ClientesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ClientesViewModel>(
      builder: (context, viewModel, child) {
        final showInactive = viewModel.showInactive;
        return Scaffold(body: _buildBody(context, viewModel, showInactive));
      },
    );
  }

  Widget _buildBody(
    BuildContext context,
    ClientesViewModel viewModel,
    bool showInactive,
  ) {
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
          sliver: SliverToBoxAdapter(
            child: FinancialSummaryHeader(
              title: 'Resumen\nClientes',
              actions: [
                IconButton(
                  onPressed: () => viewModel.toggleShowInactive(),
                  icon: Icon(
                    showInactive ? Icons.visibility : Icons.visibility_off,
                    color: showInactive
                        ? AppTheme
                              .warningColor // Yellow = showing inactive
                        : AppTheme.textSecondary, // Gray = not showing
                  ),
                  tooltip: showInactive ? 'Ocultar inactivos' : 'Ver inactivos',
                ),
              ],
              totalIngresos: viewModel.totalClientes.toDouble(),
              totalEgresos: viewModel.clientesConDeuda.toDouble(),
              balance: viewModel.totalDeuda,
              label1: 'Clientes',
              label2: 'Con Deuda',
              label3: 'Deuda Total',
              icon1: Icons.people_rounded,
              icon2: Icons.assignment_late_rounded,
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
              'Listado de Clientes',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
        ),
        if (viewModel.clientes.isEmpty)
          SliverFillRemaining(hasScrollBody: false, child: _EmptyClientes())
        else
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final cliente = viewModel.clientes[index];
                final isInactive = !cliente.isActivo;
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
                        Icons.person_rounded,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                cliente.nombre,
                                style: Theme.of(context).textTheme.labelLarge,
                              ),
                            ),
                            if (isInactive) ...[
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
                                child: Text(
                                  'INACTIVO',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ] else if (cliente.esFiado) ...[
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: AppTheme.errorColor.withValues(
                                    alpha: 0.1,
                                  ),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text(
                                  'CRÉDITO',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w900,
                                    color: AppTheme.errorColor,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 4),
                      ],
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${cliente.telefono} • ${cliente.email}',
                          style: Theme.of(context).textTheme.bodyMedium,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (cliente.saldoPendiente > 0) ...[
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(
                                Icons.payments_outlined,
                                size: 14,
                                color: AppTheme.errorColor,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Deuda: ${NumberFormatter.formatCurrency(cliente.saldoPendiente)}',
                                style: Theme.of(context).textTheme.labelMedium
                                    ?.copyWith(
                                      color: AppTheme.errorColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) =>
                          _onMenuSelected(context, value, cliente),
                      itemBuilder: (context) => [
                        if (cliente.saldoPendiente > 0)
                          const PopupMenuItem(
                            value: 'pay',
                            child: Row(
                              children: [
                                Icon(Icons.payments_outlined, size: 20),
                                SizedBox(width: 8),
                                Text('Registrar Pago'),
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
                        if (isInactive)
                          const PopupMenuItem(
                            value: 'reactivate',
                            child: Row(
                              children: [
                                Icon(
                                  Icons.refresh,
                                  size: 20,
                                  color: AppTheme.successColor,
                                ),
                                SizedBox(width: 8),
                                Text(
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
                                Text(
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
              }, childCount: viewModel.clientes.length),
            ),
          ),
      ],
    );
  }

  void _onMenuSelected(BuildContext context, String value, Cliente cliente) {
    if (value == 'edit') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ClienteFormPage(cliente: cliente),
        ),
      );
    } else if (value == 'delete') {
      _showDeleteDialog(context, cliente);
    } else if (value == 'reactivate') {
      context.read<ClientesViewModel>().reactivar(cliente.id);
    } else if (value == 'pay') {
      showDialog(
        context: context,
        builder: (context) => PagoDialog(cliente: cliente),
      );
    }
  }

  void _showDeleteDialog(BuildContext context, Cliente cliente) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar cliente'),
        content: Text(
          '¿Eliminar a ${cliente.nombre}?\n(Se marcará como inactivo para trazabilidad)',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              context.read<ClientesViewModel>().eliminar(cliente.id);
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

class _EmptyClientes extends StatelessWidget {
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
              Icons.people_outline,
              size: 80,
              color: isDark
                  ? AppTheme.darkTextSecondary.withValues(alpha: 0.5)
                  : AppTheme.textSecondary.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'No hay clientes',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Añade clientes con el botón de abajo para asociarlos a ventas.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}

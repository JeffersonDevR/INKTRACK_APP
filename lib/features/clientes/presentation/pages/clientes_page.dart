import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:InkTrack/features/clientes/presentation/viewmodels/clientes_viewmodel.dart';
import 'package:InkTrack/features/clientes/data/models/cliente.dart';
import 'package:InkTrack/core/theme/app_theme.dart';
import 'package:InkTrack/core/widgets/financial_summary_header.dart';
import 'package:InkTrack/core/utils/number_formatter.dart';
import 'package:InkTrack/core/widgets/app_card.dart';
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
          sliver: SliverToBoxAdapter(
            child: FinancialSummaryHeader(
              title: 'Gestión de\nCartera',
              actions: [
                IconButton(
                  onPressed: () => viewModel.toggleShowInactive(),
                  icon: Icon(
                    showInactive ? Icons.visibility : Icons.visibility_off,
                    color: showInactive
                        ? AppTheme.warningColor
                        : AppTheme.textSecondary,
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
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          sliver: SliverToBoxAdapter(
            child: Row(
              children: [
                Container(
                  width: 4,
                  height: 20,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Listado de Clientes',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (viewModel.clientes.isEmpty)
          SliverFillRemaining(hasScrollBody: false, child: _EmptyClientes())
        else
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final cliente = viewModel.clientes[index];
                final isInactive = !cliente.isActivo;

                return AppCard(
                  onTap: () => _onMenuSelected(context, 'edit', cliente),
                  isInactive: isInactive,
                  padding: EdgeInsets.zero,
                  child: ListTile(
                    contentPadding: const EdgeInsets.fromLTRB(16, 12, 8, 12),
                    leading: Stack(
                      children: [
                        CircleAvatar(
                          radius: 28,
                          backgroundColor: AppTheme.primaryColor.withValues(
                            alpha: 0.1,
                          ),
                          child: Text(
                            cliente.nombre.substring(0, 1).toUpperCase(),
                            style: const TextStyle(
                              color: AppTheme.primaryColor,
                              fontWeight: FontWeight.w900,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        if (cliente.saldoPendiente > 0)
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: AppTheme.errorColor,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.priority_high_rounded,
                                size: 10,
                                color: Colors.white,
                              ),
                            ),
                          ),
                      ],
                    ),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                cliente.nombre,
                                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 15,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (isInactive) ...[
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
                                    fontSize: 9,
                                    fontWeight: FontWeight.w900,
                                    color: isDark ? AppTheme.darkTextSecondary : AppTheme.textSecondary,
                                  ),
                                ),
                              ),
                            ] else if (cliente.esFiado) ...[
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: AppTheme.primaryColor.withValues(
                                    alpha: 0.1,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Text(
                                  'CRÉDITO',
                                  style: TextStyle(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w900,
                                    color: AppTheme.primaryColor,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 6),
                      ],
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.phone_outlined, size: 12, color: AppTheme.textTertiary),
                            const SizedBox(width: 4),
                            Text(
                              cliente.telefono,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                        if (cliente.saldoPendiente > 0) ...[
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppTheme.errorColor.withValues(alpha: 0.05),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: AppTheme.errorColor.withValues(alpha: 0.1)),
                            ),
                            child: Text(
                              'Debe: ${NumberFormatter.formatCurrency(cliente.saldoPendiente)}',
                              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                color: AppTheme.errorColor,
                                fontWeight: FontWeight.w900,
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    trailing: PopupMenuButton<String>(
                      icon: Icon(Icons.more_vert_rounded, color: AppTheme.textTertiary),
                      onSelected: (value) =>
                          _onMenuSelected(context, value, cliente),
                      itemBuilder: (context) => [
                        if (cliente.saldoPendiente > 0)
                          const PopupMenuItem(
                            value: 'pay',
                            child: Row(
                              children: [
                                Icon(Icons.account_balance_wallet_outlined, size: 20),
                                SizedBox(width: 12),
                                Text('Registrar Pago'),
                              ],
                            ),
                          ),
                        const PopupMenuItem(
                          value: 'edit',
                          child: Row(
                            children: [
                              Icon(Icons.edit_outlined, size: 20),
                              SizedBox(width: 12),
                              Text('Editar Perfil'),
                            ],
                          ),
                        ),
                        if (isInactive)
                          const PopupMenuItem(
                            value: 'reactivate',
                            child: Row(
                              children: [
                                Icon(
                                  Icons.person_add_alt_outlined,
                                  size: 20,
                                  color: AppTheme.successColor,
                                ),
                                SizedBox(width: 12),
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
                                  Icons.person_remove_outlined,
                                  color: AppTheme.errorColor,
                                  size: 20,
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  'Inactivar',
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        title: const Text('Inactivar cliente'),
        content: Text(
          '¿Deseas inactivar a ${cliente.nombre}?\n\nSeguirá apareciendo en reportes pero no estará disponible para nuevas ventas.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<ClientesViewModel>().eliminar(cliente.id);
              Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorColor,
              foregroundColor: Colors.white,
            ),
            child: const Text('Inactivar'),
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
                Icons.people_outline_rounded,
                size: 64,
                color: AppTheme.textTertiary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Sin clientes registrados',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Comienza agregando tu primer cliente para gestionar sus compras y deudas.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:InkTrack/core/data/local/database.dart';
import 'package:InkTrack/features/clientes/presentation/viewmodels/clientes_viewmodel.dart';
import 'package:InkTrack/features/clientes/data/models/cliente.dart';
import 'package:InkTrack/core/theme/app_theme.dart';
import 'package:InkTrack/core/widgets/financial_summary_header.dart';
import 'package:InkTrack/core/utils/number_formatter.dart';
import 'package:InkTrack/core/services/import_service.dart';
import 'package:InkTrack/core/widgets/app_card.dart';
import 'package:InkTrack/l10n/app_localizations.dart';
import 'cliente_form_page.dart';
import 'historial_acreedores_page.dart';
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
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
          sliver: SliverToBoxAdapter(
            child: FinancialSummaryHeader(
              title: l10n.resumenClientes,
              actions: [
                _HeaderAction(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const HistorialAcreedoresPage(),
                    ),
                  ),
                  icon: Icons.account_balance_wallet_rounded,
                  label: l10n.acreedores,
                  color: AppTheme.primaryColor,
                ),
                _HeaderAction(
                  onTap: () => viewModel.toggleShowInactive(),
                  icon: showInactive ? Icons.visibility : Icons.visibility_off,
                  label: showInactive ? l10n.ocultar : l10n.ver,
                  color: showInactive
                      ? AppTheme.warningColor
                      : AppTheme.textSecondary,
                ),
                _HeaderAction(
                  onTap: () => _performImport(context),
                  icon: Icons.file_upload_rounded,
                  label: l10n.import,
                  color: AppTheme.secondaryColor,
                ),
              ],
              totalIngresos: viewModel.totalClientes.toDouble(),
              totalEgresos: viewModel.clientesConDeuda.toDouble(),
              balance: viewModel.totalDeuda,
              label1: l10n.clientes,
              label2: l10n.deudaPendiente,
              label3: l10n.deudaTotal,
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
                  l10n.listadoClientes,
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
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(
                              color: AppTheme.primaryColor,
                              fontWeight: FontWeight.w900,
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
                                style: Theme.of(context).textTheme.titleSmall
                                    ?.copyWith(
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
                                  l10n.inactive,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w900,
                                    color: isDark
                                        ? AppTheme.darkTextSecondary
                                        : AppTheme.textSecondary,
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
                                child: Text(
                                  l10n.acreedores,
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
                            Icon(
                              Icons.phone_outlined,
                              size: 12,
                              color: AppTheme.textTertiary,
                            ),
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
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.errorColor.withValues(
                                alpha: 0.05,
                              ),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: AppTheme.errorColor.withValues(
                                  alpha: 0.1,
                                ),
                              ),
                            ),
                                child: Text(
                                '${l10n.deudaPendiente}: ${NumberFormatter.formatCurrency(cliente.saldoPendiente)}',
                              style: Theme.of(context).textTheme.labelSmall
                                  ?.copyWith(
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
                      icon: Icon(
                        Icons.more_vert_rounded,
                        color: AppTheme.textTertiary,
                      ),
                      onSelected: (value) =>
                          _onMenuSelected(context, value, cliente),
                      itemBuilder: (context) => [
                        if (cliente.saldoPendiente > 0)
                          PopupMenuItem(
                            value: 'pay',
                            child: Row(
                              children: [
                                Icon(
                                  Icons.account_balance_wallet_outlined,
                                  size: 20,
                                ),
                                const SizedBox(width: 12),
                                Text(l10n.abonos),
                              ],
                            ),
                          ),
                        PopupMenuItem(
                          value: 'edit',
                          child: Row(
                            children: [
                              Icon(Icons.edit_outlined, size: 20),
                              const SizedBox(width: 12),
                              Text(l10n.editar),
                            ],
                          ),
                        ),
                        if (isInactive)
                          PopupMenuItem(
                            value: 'reactivate',
                            child: Row(
                              children: [
                                Icon(
                                  Icons.person_add_alt_outlined,
                                  size: 20,
                                  color: AppTheme.successColor,
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  l10n.reactivate,
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
                                  l10n.deactivate,
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
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        title: Text('${l10n.deactivate} ${l10n.cliente}'),
        content: Text(
          '${l10n.deactivate} ${cliente.nombre}?\n\n${l10n.noDisponible}',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.cancelar),
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
            child: Text(l10n.deactivate),
          ),
        ],
      ),
    );
  }
}

Future<void> _performImport(BuildContext context) async {
  final result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['xlsx', 'csv'],
  );

  if (result == null || result.files.single.path == null) return;

  final filePath = result.files.single.path!;
  final db = context.read<AppDatabase>();
  final importService = ImportService(db);
  final scaffoldMessenger = ScaffoldMessenger.of(context);

  final l10n = AppLocalizations.of(context)!;
  scaffoldMessenger.showSnackBar(
    SnackBar(
      content: Text(l10n.importando),
      duration: const Duration(seconds: 1),
    ),
  );

  final importResult = await importService.importFile(filePath, 'clientes');
  if (context.mounted) {
    await context.read<ClientesViewModel>().refresh();
    _showImportResultDialog(context, importResult, 'clientes');
  }
}

void _showImportResultDialog(
  BuildContext context,
  ImportResult result,
  String moduleLabel,
) {
  final l10n = AppLocalizations.of(context)!;
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      title: Text(
        result.success ? l10n.importSuccess : l10n.importError,
      ),
      content: result.success
          ? Text(l10n.importSuccess)
          : SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.importError),
                  const SizedBox(height: 12),
                  ...?result.errors?.map(
                    (e) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text(
                        e.toString(),
                        style: const TextStyle(
                          color: AppTheme.errorColor,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: Text(l10n.cancelar),
        ),
      ],
    ),
  );
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
                fontSize: 11,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyClientes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
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
              l10n.noDataAvailable,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 12),
            Text(
              l10n.comienzaAgregandoProductos,
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

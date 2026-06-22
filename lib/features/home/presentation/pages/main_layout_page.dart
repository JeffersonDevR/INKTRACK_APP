import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:printing/printing.dart';
import 'package:InkTrack/core/theme/app_theme.dart';
import 'package:InkTrack/l10n/app_localizations.dart';
import 'package:InkTrack/features/clientes/presentation/pages/clientes_page.dart';
import 'package:InkTrack/features/proveedores/presentation/pages/proveedores_page.dart';
import 'package:InkTrack/features/proveedores/presentation/pages/pedidos_proveedor_page.dart';
import 'package:InkTrack/features/ventas/presentation/pages/home_page.dart';
import 'package:InkTrack/features/inventario/presentation/pages/inventario_page.dart';
import 'package:InkTrack/features/movimientos/presentation/pages/movimiento_form_page.dart';
import 'package:InkTrack/features/movimientos/data/models/movimiento.dart'
    as mov_model;
import 'package:InkTrack/features/ventas/presentation/pages/registrar_venta_page.dart';
import 'package:InkTrack/features/clientes/presentation/pages/cliente_form_page.dart';
import 'package:InkTrack/features/proveedores/presentation/pages/proveedor_form_page.dart';
import 'package:InkTrack/features/inventario/presentation/pages/barcode_scanner_page.dart';
import 'package:InkTrack/features/inventario/presentation/pages/producto_form_page.dart';
import 'package:InkTrack/features/home/presentation/widgets/speed_dial_fab.dart';
import 'package:InkTrack/features/movimientos/presentation/viewmodels/movimientos_viewmodel.dart';
import 'package:InkTrack/features/inventario/presentation/viewmodels/inventario_viewmodel.dart';
import 'package:InkTrack/features/clientes/presentation/viewmodels/clientes_viewmodel.dart';
import 'package:InkTrack/features/proveedores/presentation/viewmodels/pedidos_viewmodel.dart';
import 'package:InkTrack/features/proveedores/presentation/viewmodels/proveedores_viewmodel.dart';
import 'package:InkTrack/features/ventas/presentation/viewmodels/ventas_viewmodel.dart';
import 'package:InkTrack/core/services/pdf_export_service.dart';
import 'package:InkTrack/core/services/excel_export_service.dart';
import 'package:InkTrack/core/services/auth_service.dart';
import 'package:InkTrack/core/services/notification_service.dart';
import 'package:InkTrack/core/widgets/offline_banner.dart';
import 'package:InkTrack/features/auth/presentation/pages/profile_page.dart';
import 'package:InkTrack/features/locales/presentation/viewmodels/locales_viewmodel.dart';
import 'package:InkTrack/features/locales/presentation/pages/locales_page.dart';

class MainLayoutPage extends StatefulWidget {
  final AuthService? authService;

  const MainLayoutPage({super.key, this.authService});

  @override
  State<MainLayoutPage> createState() => _MainLayoutPageState();
}

class _MainLayoutPageState extends State<MainLayoutPage> {
  int _currentIndex = 0;
  bool _listenerAdded = false;

  @override
  void initState() {
    super.initState();
    _checkPedidosNotificaciones();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _syncLocalToViewModels();
  }

  void _syncLocalToViewModels() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      final localesVM = context.read<LocalesViewModel>();
      final invVM = context.read<InventarioViewModel>();
      final cliVM = context.read<ClientesViewModel>();
      final provVM = context.read<ProveedoresViewModel>();
      final pedVM = context.read<PedidosProveedorViewModel>();
      final movVM = context.read<MovimientosViewModel>();
      final ventVM = context.read<VentasViewModel>();

      if (localesVM.localIdSeleccionado == null && localesVM.items.isNotEmpty) {
        localesVM.seleccionarLocal(localesVM.items.first.id);
      }

      if (!_listenerAdded) {
        _listenerAdded = true;
        localesVM.addListener(() {
          final currentLocalId = localesVM.localIdSeleccionado;

          if (localesVM.tieneDatosSinLocal && mounted) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!mounted) return;
              final locVM = context.read<LocalesViewModel>();
              final currentId = locVM.localIdSeleccionado;
              if (currentId != null) {
                locVM.migrateData(
                  currentId,
                  showConfirmation: true,
                  context: context,
                );
              }
            });
          }

          invVM.setLocalId(currentLocalId);
          invVM.refresh();
          cliVM.setLocalId(currentLocalId);
          cliVM.refresh();
          provVM.setLocalId(currentLocalId);
          provVM.refresh();
          pedVM.setLocalId(currentLocalId);
          pedVM.refresh();
          movVM.setLocalId(currentLocalId);
          movVM.refresh();
          ventVM.setLocalId(currentLocalId);
          ventVM.refresh();
        });
      }

      final currentLocalId = localesVM.localIdSeleccionado;
      invVM.setLocalId(currentLocalId);
      cliVM.setLocalId(currentLocalId);
      provVM.setLocalId(currentLocalId);
      pedVM.setLocalId(currentLocalId);
      movVM.setLocalId(currentLocalId);
      ventVM.setLocalId(currentLocalId);
    });
  }

  Future<void> _checkPedidosNotificaciones() async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final pedidosVM = context.read<PedidosProveedorViewModel>();
      NotificationService().checkAndNotify(pedidosVM.items);
    });
  }

  final List<Widget> _pages = const [
    HomePage(),
    ClientesPage(),
    ProveedoresPage(),
    InventarioPage(),
  ];

  FabTab get _currentFabTab {
    switch (_currentIndex) {
      case 0:
        return FabTab.home;
      case 1:
        return FabTab.clientes;
      case 2:
        return FabTab.proveedores;
      case 3:
        return FabTab.inventario;
      default:
        return FabTab.home;
    }
  }

  // ignore: unused_element
  void _navigateToReports() {
    setState(() {
      _currentIndex = 0; // Go to Home where reports are now
    });
  }

  Future<void> _exportPdf(String type) async {
    try {
      final movVM = context.read<MovimientosViewModel>();
      final invVM = context.read<InventarioViewModel>();
      final cliVM = context.read<ClientesViewModel>();

      Uint8List pdfData;
      String filename;

      switch (type) {
        case 'movimientos':
          pdfData = await PdfExportService.generateMovementsReport(movVM.items);
          filename =
              'reporte_movimientos_${DateFormat('yyyyMMdd').format(DateTime.now())}.pdf';
          break;
        case 'inventario':
          pdfData = await PdfExportService.generateInventoryReport(
            invVM.productos,
          );
          filename =
              'reporte_inventario_${DateFormat('yyyyMMdd').format(DateTime.now())}.pdf';
          break;
        case 'clientes':
          pdfData = await PdfExportService.generateClientDebtReport(
            cliVM.clientes,
          );
          filename =
              'reporte_clientes_${DateFormat('yyyyMMdd').format(DateTime.now())}.pdf';
          break;
        default:
          return;
      }

      await Printing.sharePdf(bytes: pdfData, filename: filename);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.pdfExportado(filename)),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context)!.errorAlExportarPdf(e.toString()),
            ),
          ),
        );
      }
    }
  }

  Future<void> _exportExcel(String type) async {
    try {
      final movVM = context.read<MovimientosViewModel>();
      final invVM = context.read<InventarioViewModel>();
      final cliVM = context.read<ClientesViewModel>();

      Uint8List excelData;
      String filename;

      switch (type) {
        case 'movimientos':
          excelData = await ExcelExportService.generateMovementsReport(
            movVM.items,
          );
          filename =
              'reporte_movimientos_${DateFormat('yyyyMMdd').format(DateTime.now())}.xlsx';
          break;
        case 'inventario':
          excelData = await ExcelExportService.generateInventoryReport(
            invVM.productos,
          );
          filename =
              'reporte_inventario_${DateFormat('yyyyMMdd').format(DateTime.now())}.xlsx';
          break;
        case 'clientes':
          excelData = await ExcelExportService.generateClientDebtReport(
            cliVM.clientes,
          );
          filename =
              'reporte_clientes_${DateFormat('yyyyMMdd').format(DateTime.now())}.xlsx';
          break;
        default:
          return;
      }

      await Share.shareXFiles([
        XFile.fromData(
          excelData,
          name: filename,
          mimeType:
              'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
        ),
      ], text: 'InkTrack Report');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context)!.excelExportado(filename),
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context)!.errorAlExportarExcel(e.toString()),
            ),
          ),
        );
      }
    }
  }

  // ignore: unused_element
  void _showExportOptions(String format) {
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.receipt_long),
              title: Text(l10n.movimientos),
              onTap: () {
                Navigator.pop(ctx);
                if (format == 'pdf') {
                  _exportPdf('movimientos');
                } else {
                  _exportExcel('movimientos');
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.inventory_2),
              title: Text(l10n.inventario),
              onTap: () {
                Navigator.pop(ctx);
                if (format == 'pdf') {
                  _exportPdf('inventario');
                } else {
                  _exportExcel('inventario');
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.people),
              title: Text(l10n.clientes),
              onTap: () {
                Navigator.pop(ctx);
                if (format == 'pdf') {
                  _exportPdf('clientes');
                } else {
                  _exportExcel('clientes');
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAlertasBanner(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Consumer<PedidosProveedorViewModel>(
          builder: (context, pedidosVM, child) {
            final alertas = pedidosVM.pedidosConAlerta;
            if (alertas.isEmpty) return const SizedBox.shrink();

            return _buildBannerItem(
              context,
              icon: Icons.local_shipping_rounded,
              title: l10n.entregasPendientes(alertas.length),
              subtitle: alertas
                  .map((p) => p.proveedorNombre ?? l10n.proveedor)
                  .join(', '),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const PedidosProveedorPage(showAll: false),
                  ),
                );
              },
            );
          },
        ),
        Consumer<ProveedoresViewModel>(
          builder: (context, provVM, child) {
            final visitanManana = provVM.proveedoresQueVisitanManana;
            if (visitanManana.isEmpty) return const SizedBox.shrink();

            return _buildBannerItem(
              context,
              icon: Icons.event_note_rounded,
              title: l10n.diasVisita,
              subtitle: visitanManana.length == 1
                  ? '${l10n.diasVisita}: ${visitanManana.first.nombre}'
                  : '${l10n.diasVisita}: ${visitanManana.map((p) => p.nombre).join(', ')}',
              onTap: () {
                setState(() => _currentIndex = 2); // Go to Proveedores tab
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildBannerItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.warningColor.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.warningColor.withValues(alpha: 0.3),
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Icon(icon, color: AppTheme.warningColor),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppTheme.warningColor,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: AppTheme.warningColor),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authService = widget.authService;
    final user = authService?.currentUser;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return Consumer<LocalesViewModel>(
      builder: (context, localesVM, child) {
        if (localesVM.items.isNotEmpty &&
            localesVM.localIdSeleccionado == null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => const LocalesPage()));
          });
        }

        return Scaffold(
          body: Column(
            children: [
              if (widget.authService?.offlineMode == true)
                const OfflineBanner(),
              Container(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top + 8,
                  left: 20,
                  right: 20,
                  bottom: 16,
                ),
                decoration: BoxDecoration(
                  color: isDark ? AppTheme.darkSurface : Colors.white,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(32),
                    bottomRight: Radius.circular(32),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // App Logo/Name with refined look
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: AppTheme.primaryColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              l10n.appTitle,
                              style: GoogleFonts.plusJakartaSans(
                                color: isDark
                                    ? Colors.white
                                    : AppTheme.textPrimary,
                                fontWeight: FontWeight.w900,
                                fontSize: 20,
                                letterSpacing: -1,
                              ),
                            ),
                          ],
                        ),
                        if (MediaQuery.of(context).size.width >= 360)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              [
                                l10n.panelDeInicio,
                                l10n.gestionDeClientes,
                                l10n.proveedoresHeader,
                                l10n.controlDeInventario,
                                l10n.reportesDeNegocio,
                              ][_currentIndex].toUpperCase(),
                              style: GoogleFonts.plusJakartaSans(
                                color: AppTheme.primaryColor,
                                fontWeight: FontWeight.w800,
                                fontSize: 10,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const Spacer(),
                    // Administrator Info (Compact & Modern)
                    InkWell(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const ProfilePage()),
                      ),
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppTheme.darkCard
                              : AppTheme.backgroundColor,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: isDark
                                ? AppTheme.darkBorder
                                : AppTheme.borderLightColor,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  user?.email?.split('@').first ?? l10n.usuario,
                                  style: GoogleFonts.plusJakartaSans(
                                    color: isDark
                                        ? Colors.white
                                        : AppTheme.textPrimary,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(width: 10),
                            CircleAvatar(
                              radius: 16,
                              backgroundColor: AppTheme.primaryColor,
                              child: Text(
                                user?.email?.substring(0, 1).toUpperCase() ??
                                    'U',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const LocalesPage()),
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: isDark ? AppTheme.darkCard : AppTheme.backgroundColor,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: isDark
                            ? AppTheme.darkBorder
                            : AppTheme.borderLightColor,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.store_rounded,
                          size: 18,
                          color: AppTheme.secondaryColor,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Consumer<LocalesViewModel>(
                            builder: (context, localesVM, child) {
                              final localActual = localesVM.localActual;
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    l10n.misLocales,
                                    style: GoogleFonts.plusJakartaSans(
                                      color: AppTheme.secondaryColor,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 11,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    localActual?.nombre ?? l10n.sinLocal,
                                    style: GoogleFonts.plusJakartaSans(
                                      color: isDark
                                          ? Colors.white
                                          : AppTheme.textPrimary,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                        const Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                          color: AppTheme.secondaryColor,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              _buildAlertasBanner(context),
              Expanded(
                child: IndexedStack(index: _currentIndex, children: _pages),
              ),
            ],
          ),
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              color: isDark ? AppTheme.darkSurface : Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 20,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                child: NavigationBar(
                  selectedIndex: _currentIndex,
                  labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  onDestinationSelected: (int index) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                  destinations: [
                    NavigationDestination(
                      icon: Icon(Icons.grid_view_outlined),
                      selectedIcon: Icon(Icons.grid_view_rounded),
                      label: l10n.home,
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.people_outline_rounded),
                      selectedIcon: Icon(Icons.people_rounded),
                      label: l10n.clientes,
                    ),
                    NavigationDestination(
                      icon: Consumer<PedidosProveedorViewModel>(
                        builder: (context, pedidosVM, child) {
                          final count = pedidosVM.countAlertas;
                          return Badge(
                            isLabelVisible: count > 0,
                            label: Text('$count'),
                            child: const Icon(Icons.local_shipping_outlined),
                          );
                        },
                      ),
                      selectedIcon: Consumer<PedidosProveedorViewModel>(
                        builder: (context, pedidosVM, child) {
                          final count = pedidosVM.countAlertas;
                          return Badge(
                            isLabelVisible: count > 0,
                            label: Text('$count'),
                            child: const Icon(Icons.local_shipping_rounded),
                          );
                        },
                      ),
                      label: l10n.proveedor,
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.inventory_2_outlined),
                      selectedIcon: Icon(Icons.inventory_2_rounded),
                      label: l10n.stock,
                    ),
                  ],
                ),
              ),
            ),
          ),
          floatingActionButton: _currentIndex == 0
              ? null
              : SpeedDialFab(
                  currentTab: _currentFabTab,
                  onScanBarcodePressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const BarcodeScannerPage(),
                    ),
                  ),
                  onVentaPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RegistrarVentaPage(),
                    ),
                  ),
                  onIngresoPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MovimientoFormPage(
                        initialType: mov_model.MovimientoType.ingreso,
                      ),
                    ),
                  ),
                  onEgresoPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MovimientoFormPage(
                        initialType: mov_model.MovimientoType.egreso,
                      ),
                    ),
                  ),
                  onRestockPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const BarcodeScannerPage(),
                    ),
                  ),
                  onClientePressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ClienteFormPage()),
                  ),
                  onProveedorPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProveedorFormPage(),
                    ),
                  ),
                  onPedidoPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PedidosProveedorPage(),
                    ),
                  ),
                  onProductoPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ProductoFormPage()),
                  ),
               ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        );
      },
    );
  }
}

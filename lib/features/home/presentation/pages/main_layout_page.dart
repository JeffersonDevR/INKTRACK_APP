import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:printing/printing.dart';
import 'package:InkTrack/core/theme/app_theme.dart';
import 'package:InkTrack/features/clientes/presentation/pages/clientes_page.dart';
import 'package:InkTrack/features/proveedores/presentation/pages/proveedores_page.dart';
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
import 'package:InkTrack/features/reportes/presentation/pages/reportes_page.dart';
import 'package:InkTrack/features/home/presentation/widgets/speed_dial_fab.dart';
import 'package:InkTrack/features/movimientos/presentation/viewmodels/movimientos_viewmodel.dart';
import 'package:InkTrack/features/inventario/presentation/viewmodels/inventario_viewmodel.dart';
import 'package:InkTrack/features/clientes/presentation/viewmodels/clientes_viewmodel.dart';
import 'package:InkTrack/core/services/pdf_export_service.dart';
import 'package:InkTrack/core/services/excel_export_service.dart';
import 'package:InkTrack/core/services/auth_service.dart';
import 'package:InkTrack/features/auth/presentation/pages/profile_page.dart';

class MainLayoutPage extends StatefulWidget {
  final AuthService? authService;

  const MainLayoutPage({super.key, this.authService});

  @override
  State<MainLayoutPage> createState() => _MainLayoutPageState();
}

class _MainLayoutPageState extends State<MainLayoutPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    HomePage(),
    ClientesPage(),
    ProveedoresPage(),
    InventarioPage(),
    ReportesPage(),
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
      case 4:
        return FabTab.reportes;
      default:
        return FabTab.home;
    }
  }

  void _navigateToReports() {
    setState(() {
      _currentIndex = 4;
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
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('PDF exportado: $filename')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error al exportar PDF: $e')));
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
      ], text: 'Reporte InkTrack');

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Excel exportado: $filename')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error al exportar Excel: $e')));
      }
    }
  }

  void _showExportOptions(String format) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.receipt_long),
              title: const Text('Movimientos'),
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
              title: const Text('Inventario'),
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
              title: const Text('Clientes'),
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

  @override
  Widget build(BuildContext context) {
    final authService = widget.authService;
    final user = authService?.currentUser;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Column(
        children: [
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
                          'InkTrack',
                          style: GoogleFonts.plusJakartaSans(
                            color: isDark ? Colors.white : AppTheme.textPrimary,
                            fontWeight: FontWeight.w900,
                            fontSize: 20,
                            letterSpacing: -1,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        [
                          'Panel de Inicio',
                          'Gestión de Clientes',
                          'Proveedores',
                          'Control de Inventario',
                          'Reportes de Negocio',
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
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: isDark ? AppTheme.darkCard : AppTheme.backgroundColor,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: isDark ? AppTheme.darkBorder : AppTheme.borderLightColor,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(width: 8),
                        Text(
                          user?.email?.split('@').first ?? 'User',
                          style: GoogleFonts.plusJakartaSans(
                            color: isDark ? Colors.white : AppTheme.textPrimary,
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(width: 10),
                        CircleAvatar(
                          radius: 16,
                          backgroundColor: AppTheme.primaryColor,
                          child: Text(
                            user?.email?.substring(0, 1).toUpperCase() ?? 'U',
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
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: NavigationBar(
              selectedIndex: _currentIndex,
              labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
              backgroundColor: Colors.transparent,
              elevation: 0,
              onDestinationSelected: (int index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.grid_view_outlined),
                  selectedIcon: Icon(Icons.grid_view_rounded),
                  label: 'Inicio',
                ),
                NavigationDestination(
                  icon: Icon(Icons.people_outline_rounded),
                  selectedIcon: Icon(Icons.people_rounded),
                  label: 'Clientes',
                ),
                NavigationDestination(
                  icon: Icon(Icons.local_shipping_outlined),
                  selectedIcon: Icon(Icons.local_shipping_rounded),
                  label: 'Proveedor',
                ),
                NavigationDestination(
                  icon: Icon(Icons.inventory_2_outlined),
                  selectedIcon: Icon(Icons.inventory_2_rounded),
                  label: 'Stock',
                ),
                NavigationDestination(
                  icon: Icon(Icons.analytics_outlined),
                  selectedIcon: Icon(Icons.analytics_rounded),
                  label: 'Reportes',
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: SpeedDialFab(
        currentTab: _currentFabTab,
        onExportPdfPressed: () => _showExportOptions('pdf'),
        onExportExcelPressed: () => _showExportOptions('excel'),
        onScanBarcodePressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const BarcodeScannerPage()),
        ),
        onOcrScanPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const RegistrarVentaPage()),
        ),
        onVentaPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const RegistrarVentaPage()),
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
          MaterialPageRoute(builder: (context) => const BarcodeScannerPage()),
        ),
        onClientePressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ClienteFormPage()),
        ),
        onProveedorPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ProveedorFormPage()),
        ),
        onProductoPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ProductoFormPage()),
        ),
        onReportesPressed: _navigateToReports,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

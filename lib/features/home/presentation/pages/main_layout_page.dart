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

    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 8,
              left: 16,
              right: 16,
              bottom: 12,
            ),
            decoration: BoxDecoration(
              color: AppTheme.darkBackground,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                // App Logo/Name
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'InkTrack',
                      style: GoogleFonts.plusJakartaSans(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 18,
                        letterSpacing: -1,
                      ),
                    ),
                    Text(
                      [
                        'Inicio',
                        'Clientes',
                        'Proveedores',
                        'Inventario',
                        'Reportes',
                      ][_currentIndex].toUpperCase(),
                      style: GoogleFonts.plusJakartaSans(
                        color: AppTheme.secondaryColor.withValues(alpha: 0.8),
                        fontWeight: FontWeight.w800,
                        fontSize: 9,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                // Administrator Info (Compact)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            user?.email?.split('@').first ?? 'User',
                            style: GoogleFonts.plusJakartaSans(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                            ),
                          ),
                          Text(
                            'Admin',
                            style: GoogleFonts.plusJakartaSans(
                              color: Colors.white70,
                              fontSize: 8,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 8),
                      InkWell(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const ProfilePage()),
                        ),
                        child: CircleAvatar(
                          radius: 12,
                          backgroundColor: AppTheme.tertiaryColor,
                          child: Text(
                            user?.email?.substring(0, 1).toUpperCase() ?? 'U',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ),
                    ],
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
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        onDestinationSelected: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Inicio',
          ),
          NavigationDestination(
            icon: Icon(Icons.people_alt_outlined),
            selectedIcon: Icon(Icons.people_alt),
            label: 'Clientes',
          ),
          NavigationDestination(
            icon: Icon(Icons.local_shipping_outlined),
            selectedIcon: Icon(Icons.local_shipping),
            label: 'Proveedor',
          ),
          NavigationDestination(
            icon: Icon(Icons.inventory_2_outlined),
            selectedIcon: Icon(Icons.inventory_2),
            label: 'Inventario',
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart_outlined),
            selectedIcon: Icon(Icons.bar_chart),
            label: 'Reportes',
          ),
        ],
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

import 'package:flutter/material.dart';
import 'package:InkTrack/features/clientes/presentation/pages/clientes_page.dart';
import 'package:InkTrack/features/proveedores/presentation/pages/proveedores_page.dart';
import 'package:InkTrack/features/ventas/presentation/pages/home_page.dart';
import 'package:InkTrack/features/inventario/presentation/pages/inventario_page.dart';
import 'package:InkTrack/features/movimientos/presentation/pages/movimientos_page.dart';
import 'package:InkTrack/features/movimientos/presentation/pages/movimiento_form_page.dart';
import 'package:InkTrack/features/movimientos/data/models/movimiento.dart' as mov_model;
import 'package:InkTrack/features/ventas/presentation/pages/registrar_venta_page.dart';
import 'package:InkTrack/features/clientes/presentation/pages/cliente_form_page.dart';
import 'package:InkTrack/features/proveedores/presentation/pages/proveedor_form_page.dart';
import 'package:InkTrack/features/inventario/presentation/pages/barcode_scanner_page.dart';
import 'package:InkTrack/features/inventario/presentation/pages/producto_form_page.dart';
import 'package:InkTrack/core/theme/app_theme.dart';

class MainLayoutPage extends StatefulWidget {
  const MainLayoutPage({super.key});

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
    MovimientosPage(),
  ];

  void _onFabPressed(BuildContext context) {
    // ALWAYS visible options (General)
    final List<_FabOption> options = [
      _FabOption(
        icon: Icons.add_circle_outline,
        title: 'Nuevo Ingreso',
        subtitle: 'Entrada de dinero casual',
        color: AppTheme.successColor,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const MovimientoFormPage(
              initialType: mov_model.MovimientoType.ingreso,
            ),
          ),
        ),
      ),
      _FabOption(
        icon: Icons.remove_circle_outline,
        title: 'Nuevo Egreso',
        subtitle: 'Gasto o pago realizado',
        color: AppTheme.errorColor,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const MovimientoFormPage(
              initialType: mov_model.MovimientoType.egreso,
            ),
          ),
        ),
      ),
    ];

    // CONTEXT-SPECIFIC options
    switch (_currentIndex) {
      case 0: // Home
        options.insert(0, _FabOption(
          icon: Icons.point_of_sale_rounded,
          title: 'Registrar Venta',
          subtitle: 'Con OCR y control de stock',
          color: AppTheme.primaryColor,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const RegistrarVentaPage()),
          ),
        ));
        break;
      case 1: // Clientes
        options.insert(0, _FabOption(
          icon: Icons.person_add_alt_1_rounded,
          title: 'Nuevo Cliente',
          subtitle: 'Registrar datos de contacto',
          color: AppTheme.primaryColor,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ClienteFormPage()),
          ),
        ));
        options.insert(0, _FabOption(
          icon: Icons.point_of_sale_rounded,
          title: 'Registrar Venta (OCR)',
          subtitle: 'Con escáner y buscador',
          color: AppTheme.primaryColor,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const RegistrarVentaPage()),
          ),
        ));
        break;
      case 2: // Proveedores
        options.add(_FabOption(
          icon: Icons.local_shipping_outlined,
          title: 'Nuevo Proveedor',
          subtitle: 'Para compras y pedidos',
          color: AppTheme.secondaryColor,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ProveedorFormPage()),
          ),
        ));
        break;
      case 3: // Inventario
        options.insert(0, _FabOption(
          icon: Icons.point_of_sale_rounded,
          title: 'Registrar Venta (OCR)',
          subtitle: 'Con escáner y buscador',
          color: AppTheme.primaryColor,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const RegistrarVentaPage()),
          ),
        ));
        options.addAll([
          _FabOption(
            icon: Icons.qr_code_scanner_rounded, // or Icons.barcode_reader
            title: 'Escanear Código',
            subtitle: 'Escanear código de barras o QR',
            color: AppTheme.secondaryColor,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const BarcodeScannerPage()),
            ),
          ),
          _FabOption(
            icon: Icons.inventory_2_outlined,
            title: 'Nuevo Producto',
            subtitle: 'Agregar ítem al inventario',
            color: AppTheme.accentColor,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProductoFormPage()),
            ),
          ),
        ]);
        break;
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _FabOptionsSheet(
        title: 'Nueva Operación',
        options: options,
      ),
    );
  }

  // Removed page-specific FAB options as they are now unified

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _pages),
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
            icon: Icon(Icons.history_outlined),
            selectedIcon: Icon(Icons.history),
            label: 'Historial',
          ),
        ],
      ),
      floatingActionButton: _buildFab(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildFab(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => _onFabPressed(context),
      elevation: 4,
      highlightElevation: 0,
      backgroundColor: AppTheme.primaryColor,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: const Icon(Icons.add_rounded, size: 32),
    );
  }
}

class _FabOptionsSheet extends StatelessWidget {
  final String title;
  final List<_FabOption> options;

  const _FabOptionsSheet({required this.title, required this.options});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 5,
                decoration: BoxDecoration(
                  color: AppTheme.textSecondary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: options
                      .map((option) => Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: AppTheme.backgroundColor.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                              leading: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: (option.color ?? AppTheme.primaryColor).withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(option.icon, color: option.color ?? AppTheme.primaryColor, size: 22),
                              ),
                              title: Text(option.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                              subtitle: Text(option.subtitle, style: const TextStyle(fontSize: 12)),
                              trailing: const Icon(Icons.chevron_right_rounded, size: 20, color: AppTheme.textSecondary),
                              onTap: () {
                                Navigator.pop(context);
                                option.onTap();
                              },
                            ),
                      ))
                      .toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FabOption {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color? color;
  final VoidCallback onTap;

  _FabOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.color,
    required this.onTap,
  });
}

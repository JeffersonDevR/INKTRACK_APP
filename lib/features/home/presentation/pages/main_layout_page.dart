import 'package:flutter/material.dart';
import '../../../clientes/pages/clientes_page.dart';
import '../../../clientes/pages/cliente_form_page.dart';
import '../../../proveedores/pages/proveedores_page.dart';
import '../../../proveedores/pages/proveedor_form_page.dart';
import '../../../ventas/pages/home_page.dart';
import '../../../inventario/pages/inventario_page.dart';
import '../../../inventario/pages/producto_form_page.dart';
import '../../../inventario/pages/barcode_scanner_page.dart';
import '../../../movimientos/pages/movimientos_page.dart';
import '../../../movimientos/pages/movimiento_form_page.dart';
import '../../../movimientos/models/movimiento.dart' as mov_model;
import '../../../../core/theme/app_theme.dart';

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
    switch (_currentIndex) {
      case 0:
        _showHomeFabOptions(context);
        break;
      case 1:
        _showClientesFabOptions(context);
        break;
      case 2:
        _showProveedoresFabOptions(context);
        break;
      case 3:
        _showInventarioFabOptions(context);
        break;
      case 4:
        _showMovimientosFabOptions(context);
        break;
    }
  }

  List<_FabOption> get _globalOptions => [
        _FabOption(
          icon: Icons.add_circle_outline,
          title: 'Nuevo ingreso',
          subtitle: 'Entrada de dinero casual o venta',
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
          title: 'Nuevo egreso',
          subtitle: 'Gasto o pago realizado',
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

  void _showHomeFabOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _FabOptionsSheet(
        title: 'Acciones globales',
        options: _globalOptions,
      ),
    );
  }

  void _showClientesFabOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _FabOptionsSheet(
        title: 'Acciones de clientes',
        options: [
          _FabOption(
            icon: Icons.person_add,
            title: 'Nuevo cliente',
            subtitle: 'Registrar nuevo contacto',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ClienteFormPage()),
            ),
          ),
          ..._globalOptions,
        ],
      ),
    );
  }

  void _showProveedoresFabOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _FabOptionsSheet(
        title: 'Acciones de proveedores',
        options: [
          _FabOption(
            icon: Icons.local_shipping,
            title: 'Nuevo proveedor',
            subtitle: 'Registrar nueva fuente',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProveedorFormPage()),
            ),
          ),
          ..._globalOptions,
        ],
      ),
    );
  }

  void _showMovimientosFabOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _FabOptionsSheet(
        title: 'Nuevo registro',
        options: _globalOptions,
      ),
    );
  }

  void _showInventarioFabOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _FabOptionsSheet(
        title: 'Gestión de inventario',
        options: [
          _FabOption(
            icon: Icons.edit,
            title: 'Añadir manualmente',
            subtitle: 'Completar formulario',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProductoFormPage()),
            ),
          ),
          _FabOption(
            icon: Icons.qr_code_scanner,
            title: 'Escanear código',
            subtitle: 'Código de barras o QR',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const BarcodeScannerPage()),
            ),
          ),
          ..._globalOptions,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
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
            icon: Icon(Icons.people_outlined),
            selectedIcon: Icon(Icons.people),
            label: 'Clientes',
          ),
          NavigationDestination(
            icon: Icon(Icons.local_shipping_outlined),
            selectedIcon: Icon(Icons.local_shipping),
            label: 'Proveedores',
          ),
          NavigationDestination(
            icon: Icon(Icons.inventory_2_outlined),
            selectedIcon: Icon(Icons.inventory_2),
            label: 'Inventario',
          ),
          NavigationDestination(
            icon: Icon(Icons.history_outlined),
            selectedIcon: Icon(Icons.history),
            label: 'Ingresos/Egresos',
          ),
        ],
      ),
      floatingActionButton: _buildFab(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildFab(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => _onFabPressed(context),
      child: const Icon(Icons.add),
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
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 16),
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: options
                      .map((option) => ListTile(
                            leading: CircleAvatar(
                              backgroundColor:
                                  AppTheme.primaryColor.withValues(alpha: 0.12),
                              child: Icon(option.icon, color: AppTheme.primaryColor),
                            ),
                            title: Text(option.title),
                            subtitle: Text(option.subtitle),
                            onTap: () {
                              Navigator.pop(context);
                              option.onTap();
                            },
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
  final VoidCallback onTap;

  _FabOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });
}

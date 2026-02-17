import 'package:flutter/material.dart';
import '../../../clientes/pages/clientes_page.dart';
import '../../../clientes/pages/cliente_form_page.dart';
import '../../../proveedores/pages/proveedores_page.dart';
import '../../../proveedores/pages/proveedor_form_page.dart';
import '../../../ventas/pages/home_page.dart';
import '../../../ventas/pages/registrar_venta_page.dart';
import '../../../inventario/pages/inventario_page.dart';
import '../../../inventario/pages/producto_form_page.dart';
import '../../../inventario/pages/barcode_scanner_page.dart';
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
  ];

  void _onFabPressed(BuildContext context) {
    switch (_currentIndex) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const RegistrarVentaPage()),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ClienteFormPage()),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ProveedorFormPage()),
        );
        break;
      case 3:
        _showInventarioFabOptions(context);
        break;
    }
  }

  void _showInventarioFabOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
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
              Text(
                'Añadir producto',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: AppTheme.primaryColor.withValues(
                    alpha: 0.12,
                  ),
                  child: Icon(Icons.edit, color: AppTheme.primaryColor),
                ),
                title: const Text('Añadir manualmente'),
                subtitle: const Text('Completar formulario'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProductoFormPage(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: AppTheme.primaryColor.withValues(
                    alpha: 0.12,
                  ),
                  child: Icon(
                    Icons.qr_code_scanner,
                    color: AppTheme.primaryColor,
                  ),
                ),
                title: const Text('Escanear código'),
                subtitle: const Text('Código de barras o QR'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const BarcodeScannerPage(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
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
        ],
      ),
      floatingActionButton: _buildFab(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildFab(BuildContext context) {
    final labels = const [
      'Nueva venta',
      'Nuevo cliente',
      'Nuevo proveedor',
      'Añadir producto',
      'Actualizar',
      'Actualizar',
    ];
    final icons = const [
      Icons.point_of_sale,
      Icons.person_add,
      Icons.local_shipping,
      Icons.add,
      Icons.refresh,
      Icons.refresh,
    ];
    return FloatingActionButton.extended(
      onPressed: () => _onFabPressed(context),
      icon: Icon(icons[_currentIndex]),
      label: Text(labels[_currentIndex]),
    );
  }
}

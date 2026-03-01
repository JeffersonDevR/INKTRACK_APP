import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:InkTrack/core/theme/app_theme.dart';

// Clientes
import 'package:InkTrack/features/clientes/data/repositories/clientes_repository.dart';
import 'package:InkTrack/features/clientes/presentation/viewmodels/clientes_viewmodel.dart';

// Proveedores
import 'package:InkTrack/features/proveedores/data/repositories/proveedores_repository.dart';
import 'package:InkTrack/features/proveedores/presentation/viewmodels/proveedores_viewmodel.dart';

// Inventario
import 'package:InkTrack/features/inventario/data/repositories/productos_repository.dart';
import 'package:InkTrack/features/inventario/presentation/viewmodels/inventario_viewmodel.dart';

// Movimientos
import 'package:InkTrack/features/movimientos/data/repositories/movimientos_repository.dart';
import 'package:InkTrack/features/movimientos/presentation/viewmodels/movimientos_viewmodel.dart';

// Ventas
import 'package:InkTrack/features/ventas/data/repositories/ventas_repository.dart';
import 'package:InkTrack/features/ventas/presentation/viewmodels/ventas_viewmodel.dart';

import 'package:InkTrack/features/home/presentation/pages/main_layout_page.dart';

void main() {
  runApp(const InkTrackApp());
}

class InkTrackApp extends StatelessWidget {
  const InkTrackApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Create Repositories
    final clientesRepo = ClientesRepository();
    final proveedoresRepo = ProveedoresRepository();
    final productosRepo = ProductosRepository();
    final movimientosRepo = MovimientosRepository();
    final ventasRepo = VentasRepository();

    return MultiProvider(
      providers: [
        // Provide Repositories (if needed directly in UI, though ViewModels should handle it)
        Provider.value(value: clientesRepo),
        Provider.value(value: proveedoresRepo),
        Provider.value(value: productosRepo),
        Provider.value(value: movimientosRepo),
        Provider.value(value: ventasRepo),

        // Provide ViewModels with Repo Injection
        ChangeNotifierProvider(create: (_) => VentasViewModel(ventasRepo)),
        ChangeNotifierProvider(create: (_) => ClientesViewModel(clientesRepo)),
        ChangeNotifierProvider(create: (_) => ProveedoresViewModel(proveedoresRepo)),
        ChangeNotifierProvider(create: (_) => InventarioViewModel(productosRepo)),
        ChangeNotifierProvider(create: (_) => MovimientosViewModel(movimientosRepo)),
      ],
      child: MaterialApp(
        title: 'InkTrack',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.light,
        home: const MainLayoutPage(),
      ),
    );
  }
}

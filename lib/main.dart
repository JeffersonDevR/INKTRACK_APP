import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:InkTrack/core/theme/app_theme.dart';
import 'package:InkTrack/core/data/local/database.dart';
import 'package:InkTrack/features/clientes/data/repositories/drift_clientes_repository.dart';
import 'package:InkTrack/features/proveedores/data/repositories/drift_proveedores_repository.dart';
import 'package:InkTrack/features/inventario/data/repositories/drift_productos_repository.dart';
import 'package:InkTrack/features/movimientos/data/repositories/drift_movimientos_repository.dart';
import 'package:InkTrack/features/ventas/data/repositories/drift_ventas_repository.dart';

// ViewModels
import 'package:InkTrack/features/clientes/presentation/viewmodels/clientes_viewmodel.dart';
import 'package:InkTrack/features/proveedores/presentation/viewmodels/proveedores_viewmodel.dart';
import 'package:InkTrack/features/inventario/presentation/viewmodels/inventario_viewmodel.dart';
import 'package:InkTrack/features/movimientos/presentation/viewmodels/movimientos_viewmodel.dart';
import 'package:InkTrack/features/ventas/presentation/viewmodels/ventas_viewmodel.dart';

import 'package:InkTrack/features/home/presentation/pages/main_layout_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final database = AppDatabase();
  runApp(InkTrackApp(database: database));
}

class InkTrackApp extends StatelessWidget {
  final AppDatabase database;
  const InkTrackApp({super.key, required this.database});

  @override
  Widget build(BuildContext context) {
    // Create Drift Repositories
    final clientesRepo = DriftClientesRepository(database);
    final proveedoresRepo = DriftProveedoresRepository(database);
    final productosRepo = DriftProductosRepository(database);
    final movimientosRepo = DriftMovimientosRepository(database);
    final ventasRepo = DriftVentasRepository(database);

    return MultiProvider(
      providers: [
        // Provide the Database itself (optional, but good for inspection)
        Provider.value(value: database),

        // Provide Repositories
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

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'features/ventas/viewmodels/ventas_viewmodel.dart';
import 'features/clientes/viewmodels/clientes_viewmodel.dart';
import 'features/proveedores/viewmodels/proveedores_viewmodel.dart';
import 'features/inventario/viewmodels/inventario_viewmodel.dart';
import 'features/movimientos/viewmodels/movimientos_viewmodel.dart';

import 'features/home/presentation/pages/main_layout_page.dart';

void main() {
  runApp(const InkTrackApp());
}

class InkTrackApp extends StatelessWidget {
  const InkTrackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => VentasViewModel()),
        ChangeNotifierProvider(create: (_) => ClientesViewModel()),
        ChangeNotifierProvider(create: (_) => ProveedoresViewModel()),
        ChangeNotifierProvider(create: (_) => InventarioViewModel()),
        ChangeNotifierProvider(create: (_) => MovimientosViewModel()),
      ],
      child: MaterialApp(
        title: 'InkTrack Proto',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.light,
        home: const MainLayoutPage(),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'features/ventas/ventas_viewmodel.dart';
import 'features/clientes/clientes_viewmodel.dart';
import 'features/proveedores/proveedores_viewmodel.dart';
import 'features/inventario/inventario_viewmodel.dart';

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
      ],
      child: MaterialApp(
        title: 'InkTrack Proto',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const MainLayoutPage(),
      ),
    );
  }
}

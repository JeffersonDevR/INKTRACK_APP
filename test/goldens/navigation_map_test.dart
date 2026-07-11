import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:InkTrack/features/auth/presentation/pages/login_page.dart';
import 'package:InkTrack/features/auth/presentation/pages/signup_page.dart';
import 'package:InkTrack/features/auth/presentation/pages/profile_page.dart';
import 'package:InkTrack/features/ventas/presentation/pages/home_page.dart';
import 'package:InkTrack/features/ventas/presentation/pages/registrar_venta_page.dart';
import 'package:InkTrack/features/clientes/presentation/pages/clientes_page.dart';
import 'package:InkTrack/features/clientes/presentation/pages/cliente_form_page.dart';
import 'package:InkTrack/features/clientes/presentation/pages/historial_acreedores_page.dart';
import 'package:InkTrack/features/proveedores/presentation/pages/proveedores_page.dart';
import 'package:InkTrack/features/proveedores/presentation/pages/proveedor_form_page.dart';
import 'package:InkTrack/features/proveedores/presentation/pages/pedidos_proveedor_page.dart';
import 'package:InkTrack/features/proveedores/presentation/pages/historial_visitas_page.dart';
import 'package:InkTrack/features/inventario/presentation/pages/inventario_page.dart';
import 'package:InkTrack/features/inventario/presentation/pages/producto_form_page.dart';
import 'package:InkTrack/features/movimientos/presentation/pages/movimiento_form_page.dart';
import 'package:InkTrack/features/movimientos/data/models/movimiento.dart' as mov_model;
import 'package:InkTrack/features/locales/presentation/pages/locales_page.dart';

import '../helpers/pump_app.dart';

void main() {
  late TestAppProviders providers;

  setUp(() {
    providers = TestAppProviders();
  });

  Future<void> pump(WidgetTester tester, Widget page) async {
    final shell = appShell(providers: providers);
    await runZoned(
      () async {
        await tester.pumpWidget(shell(page));
        await tester.pumpAndSettle();
      },
      zoneSpecification: ZoneSpecification(
        handleUncaughtError: (self, parent, zone, error, stack) {
          final msg = error.toString();
          if (msg.contains('GoogleFonts') || msg.contains('google_fonts')) return;
          parent.handleUncaughtError(zone, error, stack);
        },
      ),
    );
  }

  testWidgets('01_login_page', (tester) async {
    await pump(tester, LoginPage(onLoginSuccess: () {}));
    await expectLater(
      find.byType(LoginPage),
      matchesGoldenFile('screenshots/01_login_page.png'),
    );
  });

  testWidgets('02_signup_page', (tester) async {
    await pump(tester, SignupPage(onSignupSuccess: () {}));
    await expectLater(
      find.byType(SignupPage),
      matchesGoldenFile('screenshots/02_signup_page.png'),
    );
  });

  testWidgets('03_profile_page', (tester) async {
    await pump(tester, const ProfilePage());
    await expectLater(
      find.byType(ProfilePage),
      matchesGoldenFile('screenshots/03_profile_page.png'),
    );
  });

  testWidgets('04_home_page_dashboard', (tester) async {
    await pump(tester, const HomePage());
    await expectLater(
      find.byType(HomePage),
      matchesGoldenFile('screenshots/04_home_page_dashboard.png'),
    );
  });

  testWidgets('05_registrar_venta_page', (tester) async {
    await pump(tester, const RegistrarVentaPage());
    await expectLater(
      find.byType(RegistrarVentaPage),
      matchesGoldenFile('screenshots/05_registrar_venta_page.png'),
    );
  });

  testWidgets('06_clientes_page', (tester) async {
    await pump(tester, const ClientesPage());
    await expectLater(
      find.byType(ClientesPage),
      matchesGoldenFile('screenshots/06_clientes_page.png'),
    );
  });

  testWidgets('07_cliente_form_page_new', (tester) async {
    await pump(tester, const ClienteFormPage());
    await expectLater(
      find.byType(ClienteFormPage),
      matchesGoldenFile('screenshots/07_cliente_form_page.png'),
    );
  });

  testWidgets('08_historial_acreedores_page', (tester) async {
    await pump(tester, const HistorialAcreedoresPage());
    await expectLater(
      find.byType(HistorialAcreedoresPage),
      matchesGoldenFile('screenshots/08_historial_acreedores_page.png'),
    );
  });

  testWidgets('09_proveedores_page', (tester) async {
    await pump(tester, const ProveedoresPage());
    await expectLater(
      find.byType(ProveedoresPage),
      matchesGoldenFile('screenshots/09_proveedores_page.png'),
    );
  });

  testWidgets('10_proveedor_form_page_new', (tester) async {
    await pump(tester, const ProveedorFormPage());
    await expectLater(
      find.byType(ProveedorFormPage),
      matchesGoldenFile('screenshots/10_proveedor_form_page.png'),
    );
  });

  testWidgets('11_pedidos_proveedor_page', (tester) async {
    await pump(tester, const PedidosProveedorPage());
    await expectLater(
      find.byType(PedidosProveedorPage),
      matchesGoldenFile('screenshots/11_pedidos_proveedor_page.png'),
    );
  });

  testWidgets('12_historial_visitas_page', (tester) async {
    await pump(tester, const HistorialVisitasPage());
    await expectLater(
      find.byType(HistorialVisitasPage),
      matchesGoldenFile('screenshots/12_historial_visitas_page.png'),
    );
  });

  testWidgets('13_inventario_page', (tester) async {
    await pump(tester, const InventarioPage());
    await expectLater(
      find.byType(InventarioPage),
      matchesGoldenFile('screenshots/13_inventario_page.png'),
    );
  });

  testWidgets('14_producto_form_page_new', (tester) async {
    await pump(tester, const ProductoFormPage());
    await expectLater(
      find.byType(ProductoFormPage),
      matchesGoldenFile('screenshots/14_producto_form_page.png'),
    );
  });

  testWidgets('15_movimiento_form_page_ingreso', (tester) async {
    await pump(
      tester,
      const MovimientoFormPage(initialType: mov_model.MovimientoType.ingreso),
    );
    await expectLater(
      find.byType(MovimientoFormPage),
      matchesGoldenFile('screenshots/15_movimiento_form_page_ingreso.png'),
    );
  });

  testWidgets('16_movimiento_form_page_egreso', (tester) async {
    await pump(
      tester,
      const MovimientoFormPage(initialType: mov_model.MovimientoType.egreso),
    );
    await expectLater(
      find.byType(MovimientoFormPage),
      matchesGoldenFile('screenshots/16_movimiento_form_page_egreso.png'),
    );
  });

  testWidgets('17_locales_page', (tester) async {
    await pump(tester, const LocalesPage());
    await expectLater(
      find.byType(LocalesPage),
      matchesGoldenFile('screenshots/17_locales_page.png'),
    );
  });
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:InkTrack/core/services/auth_service.dart';
import 'package:InkTrack/core/services/theme_provider.dart';
import 'package:InkTrack/core/services/locale_provider.dart';
import 'package:InkTrack/core/theme/app_theme.dart';
import 'package:InkTrack/core/services/scanner_service.dart';
import 'package:InkTrack/core/data/local/database.dart';
import 'package:InkTrack/features/clientes/data/repositories/clientes_repository.dart';
import 'package:InkTrack/features/clientes/data/models/cliente.dart';
import 'package:InkTrack/features/clientes/presentation/viewmodels/clientes_viewmodel.dart';
import 'package:InkTrack/features/proveedores/data/repositories/proveedores_repository.dart';
import 'package:InkTrack/features/proveedores/data/models/proveedor.dart';
import 'package:InkTrack/features/proveedores/data/repositories/pedidos_repository.dart';
import 'package:InkTrack/features/proveedores/data/models/pedido_proveedor.dart';
import 'package:InkTrack/features/proveedores/presentation/viewmodels/proveedores_viewmodel.dart';
import 'package:InkTrack/features/proveedores/presentation/viewmodels/pedidos_viewmodel.dart';
import 'package:InkTrack/features/inventario/data/repositories/productos_repository.dart';
import 'package:InkTrack/features/inventario/data/models/producto.dart';
import 'package:InkTrack/features/inventario/presentation/viewmodels/inventario_viewmodel.dart';
import 'package:InkTrack/features/movimientos/data/repositories/movimientos_repository.dart';
import 'package:InkTrack/features/movimientos/data/models/movimiento.dart' as mov_model;
import 'package:InkTrack/features/movimientos/presentation/viewmodels/movimientos_viewmodel.dart';
import 'package:InkTrack/features/ventas/data/repositories/ventas_repository.dart';
import 'package:InkTrack/features/ventas/data/models/venta.dart';
import 'package:InkTrack/features/ventas/presentation/viewmodels/ventas_viewmodel.dart';
import 'package:InkTrack/features/locales/data/repositories/locales_repository.dart';
import 'package:InkTrack/features/locales/data/models/local.dart';
import 'package:InkTrack/features/locales/presentation/viewmodels/locales_viewmodel.dart';
import 'package:InkTrack/l10n/app_localizations.dart';

class FakeAuthService implements AuthService {
  final User? _currentUser;
  final bool _hasLocales;

  FakeAuthService({User? currentUser, bool hasLocales = true})
    : _currentUser = currentUser,
      _hasLocales = hasLocales;

  @override
  User? get currentUser => _currentUser;

  @override
  Stream<User?> get authStateChanges => const Stream.empty();

  @override
  Future<AuthResult> signIn({required String email, required String password}) async {
    return AuthResult(success: true, user: _currentUser);
  }

  @override
  Future<AuthResult> signUp({required String email, required String password, required String fullName}) async {
    return AuthResult(success: true, user: _currentUser);
  }

  @override
  Future<AuthResult> signOut() async => AuthResult(success: true);

  @override
  Future<AuthResult> resetPassword(String email) async {
    return AuthResult(success: true);
  }

  @override
  Future<String?> getUserRole() async => 'admin';

  @override
  Future<List<String>> getUserLocalesIds({bool includeLocalDb = false, AppDatabase? localDb}) async {
    if (_hasLocales) return ['local-1'];
    return [];
  }

  @override
  Future<bool> hasUserLocales({AppDatabase? localDb}) async => _hasLocales;

  @override
  bool get offlineMode => false;
}

class InMemoryLocalesRepository implements LocalesRepository {
  final List<Local> _items = [];

  @override
  Future<List<Local>> getAll() async => List.unmodifiable(_items.where((l) => l.isActivo));

  @override
  Future<Local?> getById(String id) async {
    try { return _items.firstWhere((l) => l.id == id && l.isActivo); } catch (_) { return null; }
  }

  @override
  Future<void> save(Local item) async { _items.add(item); }

  @override
  Future<void> update(String id, Local item) async {
    final i = _items.indexWhere((l) => l.id == id);
    if (i != -1) _items[i] = item;
  }

  @override
  Future<void> delete(String id) async { _items.removeWhere((l) => l.id == id); }

  @override
  Future<MigrationSummary> getOrphanedCounts() async =>
      const MigrationSummary(productos: 0, clientes: 0, proveedores: 0, movimientos: 0, ventas: 0, pedidos: 0);

  @override
  Future<void> assignLocalId(String localId) async {}
}

class InMemoryPedidosProveedorRepository implements PedidosProveedorRepository {
  final List<PedidoProveedor> _items = [];

  @override
  Future<List<PedidoProveedor>> getAll() async => List.unmodifiable(_items);

  @override
  Future<PedidoProveedor?> getById(String id) async {
    try { return _items.firstWhere((p) => p.id == id); } catch (_) { return null; }
  }

  @override
  Future<void> save(PedidoProveedor item) async { _items.add(item); }

  @override
  Future<void> update(String id, PedidoProveedor item) async {
    final i = _items.indexWhere((p) => p.id == id);
    if (i != -1) _items[i] = item;
  }

  @override
  Future<void> delete(String id) async { _items.removeWhere((p) => p.id == id); }

  @override
  Future<List<PedidoProveedor>> getPendientes() async =>
      _items.where((p) => !p.isEntregado).toList();

  @override
  Future<List<PedidoProveedor>> getPorProveedor(String proveedorId) async =>
      _items.where((p) => p.proveedorId == proveedorId).toList();

  @override
  Future<List<PedidoProveedor>> getEntregados() async =>
      _items.where((p) => p.isEntregado).toList();

  @override
  Future<void> marcarEntregado(String id) async {
    final i = _items.indexWhere((p) => p.id == id);
    if (i != -1) {
      _items[i] = _items[i].copyWith(isEntregado: true);
    }
  }

  void addPedido(PedidoProveedor pedido) { _items.add(pedido); }
}

final _now = DateTime(2026, 6, 25, 10, 30);
final _hourAgo = _now.subtract(const Duration(hours: 1));
final _twoDaysAgo = _now.subtract(const Duration(days: 2));
final _lastWeek = _now.subtract(const Duration(days: 7));

final seedLocale = Local(
  id: 'local-1',
  nombre: 'Tienda Principal',
  direccion: 'Calle 123, Centro',
  telefono: '555-0100',
  tipo: 'tienda',
);

final seedClientes = [
  Cliente(id: 'cli-1', nombre: 'Juan Pérez', telefono: '3001234567', email: 'juan@email.com', saldoPendiente: 15000),
  Cliente(id: 'cli-2', nombre: 'María García', telefono: '3007654321', email: 'maria@email.com', esFiado: true, saldoPendiente: 45000),
  Cliente(id: 'cli-3', nombre: 'Carlos López', telefono: '3009876543'),
  Cliente(id: 'cli-4', nombre: 'Ana Martínez', telefono: '3001112233', email: 'ana@email.com'),
];

final seedProveedores = [
  Proveedor(id: 'prov-1', nombre: 'Distribuidora ABC', telefono: '5551000', diasVisita: ['Lunes', 'Jueves'], periodoVisita: 1),
  Proveedor(id: 'prov-2', nombre: 'Comercial XYZ', telefono: '5552000', diasVisita: ['Martes'], ultimaVisita: _lastWeek, proximaVisita: _now.add(const Duration(days: 7))),
  Proveedor(id: 'prov-3', nombre: 'Mayorista El Sur', telefono: '5553000', diasVisita: ['Miércoles'], periodoVisita: 2),
];

final seedProductos = [
  Producto(id: 'prod-1', nombre: 'Arroz 1kg', cantidad: 50, precioVenta: 3200, precioCompra: 2500, categoria: 'Víveres', proveedorId: 'prov-1', proveedorNombre: 'Distribuidora ABC', codigoBarras: '7701001001', stockMinimo: 10),
  Producto(id: 'prod-2', nombre: 'Aceite Vegetal 900ml', cantidad: 3, precioVenta: 8500, precioCompra: 7000, categoria: 'Víveres', proveedorId: 'prov-1', proveedorNombre: 'Distribuidora ABC', codigoBarras: '7701001002', stockMinimo: 5),
  Producto(id: 'prod-3', nombre: 'Leche Entera 1L', cantidad: 24, precioVenta: 4200, precioCompra: 3500, categoria: 'Lácteos', proveedorId: 'prov-2', proveedorNombre: 'Comercial XYZ', codigoBarras: '7701001003'),
  Producto(id: 'prod-4', nombre: 'Panela x5', cantidad: 12, precioVenta: 2800, precioCompra: 2000, categoria: 'Víveres', proveedorId: 'prov-3', proveedorNombre: 'Mayorista El Sur', codigoBarras: '7701001004'),
  Producto(id: 'prod-5', nombre: 'Huevos x30', cantidad: 0, precioVenta: 15000, precioCompra: 12000, categoria: 'Lácteos', proveedorId: 'prov-2', proveedorNombre: 'Comercial XYZ', stockMinimo: 5),
];

final seedMovimientos = [
  mov_model.Movimiento(id: 'mov-1', monto: 3200, fecha: _hourAgo, tipo: mov_model.MovimientoType.ingreso, concepto: 'Venta Arroz 1kg', categoria: 'Ventas', productoId: 'prod-1', cantidad: 1),
  mov_model.Movimiento(id: 'mov-2', monto: 8500, fecha: _hourAgo.subtract(const Duration(minutes: 15)), tipo: mov_model.MovimientoType.ingreso, concepto: 'Venta Aceite', categoria: 'Ventas', productoId: 'prod-2', cantidad: 1),
  mov_model.Movimiento(id: 'mov-3', monto: 25000, fecha: _twoDaysAgo, tipo: mov_model.MovimientoType.egreso, concepto: 'Compra a Distribuidora ABC', categoria: 'Compras'),
  mov_model.Movimiento(id: 'mov-4', monto: 15000, fecha: _hourAgo, tipo: mov_model.MovimientoType.ingreso, concepto: 'Venta Huevos', categoria: 'Ventas', productoId: 'prod-5', cantidad: 1),
  mov_model.Movimiento(id: 'mov-5', monto: 30000, fecha: _lastWeek, tipo: mov_model.MovimientoType.egreso, concepto: 'Pago servicios', categoria: 'Servicios'),
];

final seedPedidos = [
  PedidoProveedor(
    id: 'ped-1', proveedorId: 'prov-1', proveedorNombre: 'Distribuidora ABC',
    fechaPedido: _twoDaysAgo, fechaEntrega: _now.add(const Duration(days: 2)),
    productos: [PedidoProducto(productoId: 'prod-1', nombre: 'Arroz 1kg', cantidad: 20, precioUnitario: 2500)],
    montoTotal: 50000, isEntregado: false,
  ),
  PedidoProveedor(
    id: 'ped-2', proveedorId: 'prov-2', proveedorNombre: 'Comercial XYZ',
    fechaPedido: _lastWeek, fechaEntrega: _now.add(const Duration(days: 5)),
    productos: [PedidoProducto(productoId: 'prod-3', nombre: 'Leche Entera 1L', cantidad: 12, precioUnitario: 3500)],
    montoTotal: 42000, isEntregado: false,
  ),
  PedidoProveedor(
    id: 'ped-3', proveedorId: 'prov-1', proveedorNombre: 'Distribuidora ABC',
    fechaPedido: _lastWeek, fechaEntrega: _twoDaysAgo,
    productos: [PedidoProducto(productoId: 'prod-2', nombre: 'Aceite Vegetal 900ml', cantidad: 10, precioUnitario: 7000)],
    montoTotal: 70000, isEntregado: true,
  ),
];

final seedVentas = [
  Venta(id: 'ven-1', monto: 3200, fecha: _hourAgo, clienteId: 'cli-1', cantidad: 1, concepto: 'Arroz 1kg'),
  Venta(id: 'ven-2', monto: 8500, fecha: _hourAgo.subtract(const Duration(minutes: 15)), cantidad: 1, concepto: 'Aceite'),
  Venta(id: 'ven-3', monto: 15000, fecha: _hourAgo.subtract(const Duration(minutes: 30)), clienteId: 'cli-2', cantidad: 1, concepto: 'Huevos x30', esFiado: true),
];

void _populateRepos({
  required InMemoryClientesRepository clientes,
  required InMemoryProveedoresRepository proveedores,
  required InMemoryProductosRepository productos,
  required InMemoryMovimientosRepository movimientos,
  required InMemoryVentasRepository ventas,
  required InMemoryLocalesRepository locales,
  required InMemoryPedidosProveedorRepository pedidos,
}) {
  for (final l in [seedLocale]) { locales.save(l); }
  for (final c in seedClientes) { clientes.save(c); }
  for (final p in seedProveedores) { proveedores.save(p); }
  for (final p in seedProductos) { productos.save(p); }
  for (final m in seedMovimientos) { movimientos.save(m); }
  for (final v in seedVentas) { ventas.save(v); }
  for (final p in seedPedidos) { pedidos.addPedido(p); }
}

Future<void> _loadTestFont(String family, String path) async {
  final file = File(path);
  if (!file.existsSync()) return;
  final bytes = file.readAsBytesSync();
  final loader = FontLoader(family);
  loader.addFont(Future.value(ByteData.view(bytes.buffer)));
  await loader.load();
}

void _suppressGoogleFontsErrors() {
  GoogleFonts.config.allowRuntimeFetching = false;
  final original = FlutterError.onError;
  FlutterError.onError = (details) {
    if (details.stack?.toString().contains('google_fonts') == true) return;
    original?.call(details);
  };
  _loadTestFont('PlusJakartaSans', 'test/assets/fonts/PlusJakartaSans-Regular.ttf');
}

class TestAppProviders {
  final clientesRepo = InMemoryClientesRepository();
  final proveedoresRepo = InMemoryProveedoresRepository();
  final productosRepo = InMemoryProductosRepository();
  final movimientosRepo = InMemoryMovimientosRepository();
  final ventasRepo = InMemoryVentasRepository();
  final localesRepo = InMemoryLocalesRepository();
  final pedidosRepo = InMemoryPedidosProveedorRepository();
  final authService = FakeAuthService(
    currentUser: User.fromJson({'id': 'user-1-test-id-12345678', 'email': 'admin@inktrack.app'}),
    hasLocales: true,
  );
  final scannerService = ScannerService();

  late final VentasViewModel ventasVM;
  late final ClientesViewModel clientesVM;
  late final ProveedoresViewModel proveedoresVM;
  late final LocalesViewModel localesVM;
  late final PedidosProveedorViewModel pedidosVM;
  late final InventarioViewModel inventarioVM;
  late final MovimientosViewModel movimientosVM;

  TestAppProviders() {
    _suppressGoogleFontsErrors();
    _populateRepos(
      clientes: clientesRepo,
      proveedores: proveedoresRepo,
      productos: productosRepo,
      movimientos: movimientosRepo,
      ventas: ventasRepo,
      locales: localesRepo,
      pedidos: pedidosRepo,
    );

    ventasVM = VentasViewModel(ventasRepo, scannerService);
    clientesVM = ClientesViewModel(clientesRepo);
    proveedoresVM = ProveedoresViewModel(proveedoresRepo);
    localesVM = LocalesViewModel(localesRepo);
    pedidosVM = PedidosProveedorViewModel(pedidosRepo);
    inventarioVM = InventarioViewModel(productosRepo);
    movimientosVM = MovimientosViewModel(movimientosRepo);
  }
}

Widget Function(Widget) appShell({TestAppProviders? providers}) {
  final p = providers ?? TestAppProviders();
  return (Widget child) {
    return MultiProvider(
      providers: [
        Provider<AuthService>.value(value: p.authService),
        Provider<ScannerService>.value(value: p.scannerService),
        Provider<ClientesRepository>.value(value: p.clientesRepo),
        Provider<ProveedoresRepository>.value(value: p.proveedoresRepo),
        Provider<ProductosRepository>.value(value: p.productosRepo),
        Provider<MovimientosRepository>.value(value: p.movimientosRepo),
        Provider<VentasRepository>.value(value: p.ventasRepo),
        Provider<LocalesRepository>.value(value: p.localesRepo),
        Provider<PedidosProveedorRepository>.value(value: p.pedidosRepo),
        ChangeNotifierProvider<VentasViewModel>.value(value: p.ventasVM),
        ChangeNotifierProvider<ClientesViewModel>.value(value: p.clientesVM),
        ChangeNotifierProvider<ProveedoresViewModel>.value(value: p.proveedoresVM),
        ChangeNotifierProvider<LocalesViewModel>.value(value: p.localesVM),
        ChangeNotifierProvider<PedidosProveedorViewModel>.value(value: p.pedidosVM),
        ChangeNotifierProvider<InventarioViewModel>.value(value: p.inventarioVM),
        ChangeNotifierProvider<MovimientosViewModel>.value(value: p.movimientosVM),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
      ],
      child: MaterialApp(
        locale: const Locale('es'),
        supportedLocales: const [Locale('es')],
        localizationsDelegates: const [
          AppLocalizations.delegate,
          ...GlobalMaterialLocalizations.delegates,
        ],
        theme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.light,
          colorSchemeSeed: AppTheme.primaryColor,
          scaffoldBackgroundColor: AppTheme.backgroundColor,
        ),
        home: Builder(
          builder: (context) => MediaQuery(
            data: const MediaQueryData(
              size: Size(360, 780),
              devicePixelRatio: 2.0,
            ),
            child: child,
          ),
        ),
      ),
    );
  };
}

Future<void> pumpPage(WidgetTester tester, Widget page, {TestAppProviders? providers}) async {
  final shell = appShell(providers: providers);
  await tester.pumpWidget(shell(page));
  await tester.pumpAndSettle();
}

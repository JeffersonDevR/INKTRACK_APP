import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:InkTrack/core/theme/app_theme.dart';
import 'package:InkTrack/core/data/local/database.dart';
import 'package:InkTrack/core/services/auth_service.dart';
import 'package:InkTrack/core/services/supabase_sync_service.dart';
import 'package:InkTrack/core/services/log_service.dart';
import 'package:InkTrack/core/services/analytics_service.dart';
import 'package:InkTrack/core/services/theme_provider.dart';
import 'package:InkTrack/core/services/locale_provider.dart';
import 'package:InkTrack/core/services/notification_service.dart';
import 'package:InkTrack/core/services/scanner_service.dart';
import 'package:InkTrack/features/clientes/data/repositories/drift_clientes_repository.dart';
import 'package:InkTrack/features/proveedores/data/repositories/drift_proveedores_repository.dart';
import 'package:InkTrack/features/inventario/data/repositories/drift_productos_repository.dart';
import 'package:InkTrack/features/movimientos/data/repositories/drift_movimientos_repository.dart';
import 'package:InkTrack/features/ventas/data/repositories/drift_ventas_repository.dart';
import 'package:InkTrack/features/proveedores/data/repositories/drift_pedidos_repository.dart';
import 'package:InkTrack/features/locales/data/repositories/drift_locales_repository.dart';

import 'package:InkTrack/features/clientes/presentation/viewmodels/clientes_viewmodel.dart';
import 'package:InkTrack/features/proveedores/presentation/viewmodels/proveedores_viewmodel.dart';
import 'package:InkTrack/features/proveedores/presentation/viewmodels/pedidos_viewmodel.dart';
import 'package:InkTrack/features/inventario/presentation/viewmodels/inventario_viewmodel.dart';
import 'package:InkTrack/features/movimientos/presentation/viewmodels/movimientos_viewmodel.dart';
import 'package:InkTrack/features/ventas/presentation/viewmodels/ventas_viewmodel.dart';
import 'package:InkTrack/features/locales/presentation/viewmodels/locales_viewmodel.dart';
import 'package:InkTrack/features/home/presentation/pages/main_layout_page.dart';
import 'package:InkTrack/features/auth/presentation/pages/login_page.dart';
import 'package:InkTrack/features/locales/presentation/pages/onboarding_local_page.dart';
import 'package:InkTrack/features/categorias/data/repositories/categorias_repository.dart';
import 'package:InkTrack/features/ventas/domain/use_cases/registrar_venta_use_case.dart';
import 'package:InkTrack/features/movimientos/domain/use_cases/crear_movimiento_use_case.dart';
import 'package:InkTrack/features/inventario/domain/use_cases/actualizar_stock_use_case.dart';
import 'package:InkTrack/features/clientes/domain/use_cases/auto_crear_cliente_use_case.dart';
import 'package:InkTrack/features/clientes/domain/use_cases/registrar_pago_cliente_use_case.dart';
import 'package:InkTrack/features/proveedores/domain/use_cases/marcar_pedido_entregado_use_case.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  debugRepaintRainbowEnabled = false;
  try {
    await initializeDateFormatting('es', null);
    // Load environment variables from .env file
    await dotenv.load(fileName: ".env", isOptional: false);

    // SECURITY: Get credentials from environment variables only
    // Never use hardcoded fallbacks
    final supabaseUrl = dotenv.env['SUPABASE_URL'];
    final supabaseKey = dotenv.env['SUPABASE_ANON_KEY'];

    if (supabaseUrl == null || supabaseKey == null) {
      throw Exception(
        'Missing required environment variables. '
        'Please configure SUPABASE_URL and SUPABASE_ANON_KEY in .env file'
      );
    }

    await Supabase.initialize(url: supabaseUrl, anonKey: supabaseKey);

    await LogService.instance.init();
    AnalyticsService.instance.init();
    AnalyticsService.instance.track('app_start');
    LogService.instance.info('App', 'InkTrack starting');

    await NotificationService().initialize();

    final database = AppDatabase();
    final supabase = Supabase.instance.client;
    final authService = AuthService(supabase);
    final currentUser = authService.currentUser;

    runApp(
      InkTrackApp(
        database: database,
        supabaseUrl: supabaseUrl,
        supabaseKey: supabaseKey,
        supabaseClient: supabase,
        authService: authService,
        currentUser: currentUser,
      ),
    );
  } catch (e) {
    debugPrint('Initialization error: $e');
    runApp(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text('Error: $e'),
            ),
          ),
        ),
      ),
    );
  }
}

class InkTrackApp extends StatefulWidget {
  final AppDatabase database;
  final String supabaseUrl;
  final String supabaseKey;
  final SupabaseClient supabaseClient;
  final AuthService authService;
  final User? currentUser;

  const InkTrackApp({
    super.key,
    required this.database,
    required this.supabaseUrl,
    required this.supabaseKey,
    required this.supabaseClient,
    required this.authService,
    this.currentUser,
  });

  @override
  State<InkTrackApp> createState() => _InkTrackAppState();
}

class _InkTrackAppState extends State<InkTrackApp> {
  bool _isLoggedIn = false;
  StreamSubscription<User?>? _authSubscription;

  late final DriftClientesRepository _clientesRepo;
  late final DriftProveedoresRepository _proveedoresRepo;
  late final DriftProductosRepository _productosRepo;
  late final DriftMovimientosRepository _movimientosRepo;
  late final DriftVentasRepository _ventasRepo;
  late final DriftPedidosProveedorRepository _pedidosRepo;
  late final DriftLocalesRepository _localesRepo;
  late final CategoriasRepository _categoriasRepo;
  late final RegistrarVentaUseCase _registrarVenta;
  late final CrearMovimientoUseCase _crearMovimiento;
  late final ActualizarStockUseCase _actualizarStock;
  late final AutoCrearClienteUseCase _autoCrearCliente;
  late final RegistrarPagoClienteUseCase _registrarPagoCliente;
  late final MarcarPedidoEntregadoUseCase _marcarPedidoEntregado;

  @override
  void initState() {
    super.initState();
    _isLoggedIn = widget.currentUser != null;

    _clientesRepo = DriftClientesRepository(widget.database);
    _proveedoresRepo = DriftProveedoresRepository(widget.database);
    _productosRepo = DriftProductosRepository(widget.database);
    _movimientosRepo = DriftMovimientosRepository(widget.database);
    _ventasRepo = DriftVentasRepository(widget.database);
    _pedidosRepo = DriftPedidosProveedorRepository(widget.database);
    _localesRepo = DriftLocalesRepository(widget.database);
    _categoriasRepo = CategoriasRepository(widget.database);

    _crearMovimiento = CrearMovimientoUseCase(_movimientosRepo);
    _actualizarStock = ActualizarStockUseCase(_productosRepo);
    _autoCrearCliente = AutoCrearClienteUseCase(
      _clientesRepo,
      _crearMovimiento,
    );
    _registrarPagoCliente = RegistrarPagoClienteUseCase(
      _clientesRepo,
      _crearMovimiento,
    );
    _marcarPedidoEntregado = MarcarPedidoEntregadoUseCase(
      pedidosRepo: _pedidosRepo,
      proveedoresRepo: _proveedoresRepo,
      actualizarStock: _actualizarStock,
      crearMovimiento: _crearMovimiento,
    );
    _registrarVenta = RegistrarVentaUseCase(
      ventasRepo: _ventasRepo,
      productosRepo: _productosRepo,
      clientesRepo: _clientesRepo,
      crearMovimiento: _crearMovimiento,
      actualizarStock: _actualizarStock,
      autoCrearCliente: _autoCrearCliente,
    );

    try {
      _authSubscription = widget.authService.authStateChanges.listen(
        (user) {
          if (mounted) {
            setState(() {
              _isLoggedIn = user != null;
            });
          }
        },
        onError: (error) {
          debugPrint('Auth stream error: $error');
        },
      );
    } catch (e) {
      debugPrint('Auth subscription error: $e');
    }
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }

  void _handleLoginSuccess() async {
    AnalyticsService.instance.track('login_success');
    final hasLocales = await widget.authService.hasUserLocales(
      localDb: widget.database,
    );
    if (hasLocales && mounted) {
      setState(() {
        _isLoggedIn = true;
      });
    } else if (mounted) {
      _showOnboarding();
    }
  }

  void _showOnboarding() {
    final userId = widget.authService.currentUser?.id;
    if (userId == null) {
      setState(() {
        _isLoggedIn = true;
      });
      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => MultiProvider(
          providers: [
            Provider.value(value: widget.database),
            Provider.value(value: widget.authService),
            Provider.value(value: _clientesRepo),
            Provider.value(value: _proveedoresRepo),
            Provider.value(value: _productosRepo),
            Provider.value(value: _movimientosRepo),
            Provider.value(value: _ventasRepo),
            Provider.value(value: _pedidosRepo),
            Provider.value(value: _localesRepo),
            Provider.value(value: _categoriasRepo),
            ChangeNotifierProvider(
              create: (_) => LocalesViewModel(_localesRepo),
            ),
            ChangeNotifierProvider(
              create: (_) => ClientesViewModel(
                _clientesRepo,
                _registrarPagoCliente,
                _crearMovimiento,
              ),
            ),
            ChangeNotifierProvider(
              create: (_) => ProveedoresViewModel(
                _proveedoresRepo,
                _crearMovimiento,
              ),
            ),
            ChangeNotifierProvider(
              create: (_) => InventarioViewModel(_productosRepo, _categoriasRepo),
            ),
            ChangeNotifierProvider(
              create: (_) => MovimientosViewModel(_movimientosRepo, _categoriasRepo),
            ),
            ChangeNotifierProvider(
              create: (_) => VentasViewModel(_ventasRepo, _registrarVenta, ScannerService()),
            ),
            ChangeNotifierProvider(
              create: (_) => PedidosProveedorViewModel(
                _pedidosRepo,
                _marcarPedidoEntregado,
                _crearMovimiento,
              ),
            ),
          ],
          child: _OnboardingWrapper(
            authService: widget.authService,
            onComplete: () {
              Navigator.of(context).pop();
              setState(() {
                _isLoggedIn = true;
              });
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider.value(value: widget.database),
        Provider.value(value: widget.authService),
        Provider.value(value: _clientesRepo),
        Provider.value(value: _proveedoresRepo),
        Provider.value(value: _productosRepo),
        Provider.value(value: _movimientosRepo),
        Provider.value(value: _ventasRepo),
        Provider.value(value: _pedidosRepo),
        Provider.value(value: _localesRepo),
        Provider(create: (_) => ScannerService()),
        Provider(create: (_) => _categoriasRepo),
        Provider(
          create: (_) => SupabaseSyncService(
            widget.database,
            widget.supabaseClient,
          ),
        ),
        ChangeNotifierProvider(
          create: (context) =>
              VentasViewModel(_ventasRepo, _registrarVenta, context.read<ScannerService>()),
        ),
        ChangeNotifierProvider(
          create: (_) => ClientesViewModel(
            _clientesRepo,
            _registrarPagoCliente,
            _crearMovimiento,
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => ProveedoresViewModel(
            _proveedoresRepo,
            _crearMovimiento,
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => LocalesViewModel(_localesRepo),
        ),
        ChangeNotifierProvider(
          create: (_) => PedidosProveedorViewModel(
            _pedidosRepo,
            _marcarPedidoEntregado,
            _crearMovimiento,
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => InventarioViewModel(_productosRepo, _categoriasRepo),
        ),
        ChangeNotifierProvider(
          create: (_) => MovimientosViewModel(_movimientosRepo, _categoriasRepo),
        ),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
      ],
      child: Consumer2<ThemeProvider, LocaleProvider>(
        builder: (context, themeProvider, localeProvider, child) {
          return MaterialApp(
            title: 'InkTrack',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.themeMode,
            locale: localeProvider.locale,
            supportedLocales: const [Locale('es')],
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            home: _isLoggedIn
                ? MainLayoutPage(authService: widget.authService)
                : LoginPage(onLoginSuccess: _handleLoginSuccess),
          );
        },
      ),
    );
  }
}

class _OnboardingWrapper extends StatelessWidget {
  final AuthService authService;
  final VoidCallback onComplete;

  const _OnboardingWrapper({
    required this.authService,
    required this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    final userId = authService.currentUser?.id;
    if (userId == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return OnboardingLocalPage(userId: userId, authService: authService);
  }
}

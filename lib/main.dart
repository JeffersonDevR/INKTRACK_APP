import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:InkTrack/core/theme/app_theme.dart';
import 'package:InkTrack/core/data/local/database.dart';
import 'package:InkTrack/core/services/auth_service.dart';
import 'package:InkTrack/core/services/supabase_sync_service.dart';
import 'package:InkTrack/core/services/theme_provider.dart';
import 'package:InkTrack/core/services/notification_service.dart';
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
import 'package:InkTrack/core/services/scanner_service.dart';
import 'package:InkTrack/features/home/presentation/pages/main_layout_page.dart';
import 'package:InkTrack/features/auth/presentation/pages/login_page.dart';
import 'package:InkTrack/features/locales/presentation/pages/onboarding_local_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('es', null);

  try {
    await dotenv.load(fileName: ".env", isOptional: true);

    final supabaseUrl =
        dotenv.env['SUPABASE_URL'] ??
        'https://favaqrjdxqytyjzlmxpd.supabase.co';
    final supabaseKey =
        dotenv.env['SUPABASE_ANON_KEY'] ??
        'sb_publishable_VXorai6dwJNKR1hcsvWV3Q_n2XEEP2p';

    await Supabase.initialize(url: supabaseUrl, anonKey: supabaseKey);

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
            ChangeNotifierProvider(
              create: (_) => LocalesViewModel(
                _localesRepo,
                productosRepo: _productosRepo,
                clientesRepo: _clientesRepo,
                proveedoresRepo: _proveedoresRepo,
              ),
            ),
            ChangeNotifierProvider(
              create: (_) => ClientesViewModel(_clientesRepo),
            ),
            ChangeNotifierProvider(
              create: (_) => ProveedoresViewModel(_proveedoresRepo),
            ),
            ChangeNotifierProvider(
              create: (_) => InventarioViewModel(_productosRepo),
            ),
            ChangeNotifierProvider(
              create: (_) => MovimientosViewModel(_movimientosRepo),
            ),
            ChangeNotifierProvider(
              create: (_) => VentasViewModel(_ventasRepo, ScannerService()),
            ),
            ChangeNotifierProvider(
              create: (_) => PedidosProveedorViewModel(_pedidosRepo),
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
        Provider(
          create: (_) => SupabaseSyncService(
            widget.database,
            widget.supabaseUrl,
            widget.supabaseKey,
          ),
        ),
        ChangeNotifierProvider(
          create: (context) =>
              VentasViewModel(_ventasRepo, context.read<ScannerService>()),
        ),
        ChangeNotifierProvider(create: (_) => ClientesViewModel(_clientesRepo)),
        ChangeNotifierProvider(
          create: (_) => ProveedoresViewModel(_proveedoresRepo),
        ),
        ChangeNotifierProvider(
          create: (_) => LocalesViewModel(
            _localesRepo,
            productosRepo: _productosRepo,
            clientesRepo: _clientesRepo,
            proveedoresRepo: _proveedoresRepo,
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => PedidosProveedorViewModel(_pedidosRepo),
        ),
        ChangeNotifierProvider(
          create: (_) => InventarioViewModel(_productosRepo),
        ),
        ChangeNotifierProvider(
          create: (_) => MovimientosViewModel(_movimientosRepo),
        ),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'InkTrack',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.themeMode,
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

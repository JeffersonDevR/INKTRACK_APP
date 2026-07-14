import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:InkTrack/core/theme/app_theme.dart';
import 'package:InkTrack/core/data/local/database.dart';
import 'package:InkTrack/core/services/auth_service.dart';
import 'package:InkTrack/core/services/supabase_sync_service.dart';
import 'package:InkTrack/core/services/theme_provider.dart';
import 'package:InkTrack/core/services/locale_provider.dart';
import 'package:InkTrack/core/services/notification_service.dart';
import 'package:InkTrack/core/services/scanner_service.dart';
import 'package:InkTrack/core/services/connectivity_service.dart';
import 'package:InkTrack/l10n/app_localizations.dart';
import 'package:InkTrack/features/clientes/data/repositories/drift_clientes_repository.dart';
import 'package:InkTrack/features/clientes/data/repositories/drift_abonos_repository.dart';

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
import 'package:InkTrack/features/sync/presentation/viewmodels/sync_queue_viewmodel.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('es', null);
  debugRepaintRainbowEnabled = false;
  try {
    // Load .env tolerantly. `.env` is NOT bundled as an asset (see pubspec),
    // so on a clean checkout this throws and we fall back to compile-time
    // (--dart-define) and runtime (Platform.environment) credentials below.
    // When a local .env exists, dotenv.env is populated as before.
    try {
      await dotenv.load(fileName: ".env", isOptional: true);
    } catch (_) {
      // Asset missing is fine; credentials resolved via layered fallback.
    }

    // Layered credential resolution (no hardcoded fallbacks):
    //   1. --dart-define (compile-time, via String.fromEnvironment)
    //   2. dotenv.env (local .env, when present)
    //   3. Platform.environment (runtime, desktop/CI)
    final supabaseCompileUrl =
        const String.fromEnvironment('SUPABASE_URL');
    final supabaseCompileKey =
        const String.fromEnvironment('SUPABASE_ANON_KEY');
    final supabaseUrl = supabaseCompileUrl.isNotEmpty
        ? supabaseCompileUrl
        : (dotenv.env['SUPABASE_URL'] ?? Platform.environment['SUPABASE_URL']);
    final supabaseKey = supabaseCompileKey.isNotEmpty
        ? supabaseCompileKey
        : (dotenv.env['SUPABASE_ANON_KEY'] ??
            Platform.environment['SUPABASE_ANON_KEY']);

    SupabaseClient? supabaseClient;
    final database = AppDatabase();
    AuthService authService;
    User? currentUser;

    if (supabaseUrl != null &&
        supabaseUrl.isNotEmpty &&
        supabaseKey != null &&
        supabaseKey.isNotEmpty) {
      // REMOTE mode: credentials present (unchanged behavior).
      await Supabase.initialize(
        url: supabaseUrl,
        anonKey: supabaseKey,
      );
      supabaseClient = Supabase.instance.client;
      authService = AuthService(supabaseClient, database: database);
      currentUser = authService.currentUser;
    } else {
      // LOCAL-ONLY mode: Supabase credentials absent. Cloud sync disabled.
      // Construct a no-network SupabaseClient adapter so AuthService (whose
      // supabase field is non-nullable) compiles; all its supabase calls are
      // already wrapped in try/catch, so local-only auth degrades to the
      // existing offline bcrypt cache path.
      debugPrint(
        '[InkTrack] Local-only mode: Supabase credentials not provided. '
        'Cloud sync disabled.',
      );
      final localClient = SupabaseClient('', '');
      authService = AuthService(localClient, database: database);
      currentUser = authService.currentUser;
    }

    await NotificationService().initialize();

    runApp(
      InkTrackApp(
        database: database,
        supabaseUrl: supabaseUrl,
        supabaseKey: supabaseKey,
        supabaseClient: supabaseClient,
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
  final String? supabaseUrl;
  final String? supabaseKey;
  final SupabaseClient? supabaseClient;
  final AuthService authService;
  final User? currentUser;

  const InkTrackApp({
    super.key,
    required this.database,
    this.supabaseUrl,
    this.supabaseKey,
    this.supabaseClient,
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
  late final DriftAbonosRepository _abonosRepo;
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
    _abonosRepo = DriftAbonosRepository(widget.database);
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
            Provider.value(value: _abonosRepo),
            Provider.value(value: _proveedoresRepo),
            Provider.value(value: _productosRepo),
            Provider.value(value: _movimientosRepo),
            Provider.value(value: _ventasRepo),
            Provider.value(value: _pedidosRepo),
            Provider.value(value: _localesRepo),
            ChangeNotifierProvider(
              create: (_) => LocalesViewModel(_localesRepo),
            ),
            ChangeNotifierProvider(
              create: (_) => ClientesViewModel(_clientesRepo, _abonosRepo),
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
        Provider.value(value: _abonosRepo),
        Provider.value(value: _proveedoresRepo),
        Provider.value(value: _productosRepo),
        Provider.value(value: _movimientosRepo),
        Provider.value(value: _ventasRepo),
        Provider.value(value: _pedidosRepo),
        Provider.value(value: _localesRepo),
        Provider(create: (_) => ScannerService()),
        Provider(create: (_) => ConnectivityService()),
        Provider(
          create: (_) => SupabaseSyncService(
            widget.database,
            widget.supabaseUrl ?? '',
            widget.supabaseKey ?? '',
            supabaseClient: widget.supabaseClient,
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => SyncQueueViewModel(
            syncService: context.read<SupabaseSyncService>(),
            connectivityService: context.read<ConnectivityService>(),
            db: widget.database,
          ),
        ),

        ChangeNotifierProvider(
          create: (context) =>
              VentasViewModel(_ventasRepo, context.read<ScannerService>()),
        ),
        ChangeNotifierProvider(create: (_) => ClientesViewModel(_clientesRepo, _abonosRepo)),
        ChangeNotifierProvider(
          create: (_) => ProveedoresViewModel(_proveedoresRepo),
        ),
        ChangeNotifierProvider(
          create: (_) => LocalesViewModel(_localesRepo),
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
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            builder: (context, child) {
              final isDark = Theme.of(context).brightness == Brightness.dark;
              return AnnotatedRegion<SystemUiOverlayStyle>(
                value: SystemUiOverlayStyle(
                  statusBarColor: Colors.transparent,
                  statusBarIconBrightness:
                      isDark ? Brightness.light : Brightness.dark,
                ),
                child: child!,
              );
            },
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

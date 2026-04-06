import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:InkTrack/core/theme/app_theme.dart';
import 'package:InkTrack/core/data/local/database.dart';
import 'package:InkTrack/core/services/auth_service.dart';
import 'package:InkTrack/core/services/supabase_sync_service.dart';
import 'package:InkTrack/core/services/theme_provider.dart';
import 'package:InkTrack/features/clientes/data/repositories/drift_clientes_repository.dart';
import 'package:InkTrack/features/proveedores/data/repositories/drift_proveedores_repository.dart';
import 'package:InkTrack/features/inventario/data/repositories/drift_productos_repository.dart';
import 'package:InkTrack/features/movimientos/data/repositories/drift_movimientos_repository.dart';
import 'package:InkTrack/features/ventas/data/repositories/drift_ventas_repository.dart';

import 'package:InkTrack/features/clientes/presentation/viewmodels/clientes_viewmodel.dart';
import 'package:InkTrack/features/proveedores/presentation/viewmodels/proveedores_viewmodel.dart';
import 'package:InkTrack/features/inventario/presentation/viewmodels/inventario_viewmodel.dart';
import 'package:InkTrack/features/movimientos/presentation/viewmodels/movimientos_viewmodel.dart';
import 'package:InkTrack/features/ventas/presentation/viewmodels/ventas_viewmodel.dart';
import 'package:InkTrack/core/services/scanner_service.dart';
import 'package:InkTrack/features/home/presentation/pages/main_layout_page.dart';
import 'package:InkTrack/features/auth/presentation/pages/login_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await dotenv.load(fileName: ".env", isOptional: true);

    final supabaseUrl =
        dotenv.env['SUPABASE_URL'] ??
        'https://favaqrjdxqytyjzlmxpd.supabase.co';
    final supabaseKey =
        dotenv.env['SUPABASE_ANON_KEY'] ??
        'sb_publishable_VXorai6dwJNKR1hcsvWV3Q_n2XEEP2p';

    await Supabase.initialize(url: supabaseUrl, anonKey: supabaseKey);

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

  @override
  void initState() {
    super.initState();
    _isLoggedIn = widget.currentUser != null;

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

  void _handleLoginSuccess() {
    setState(() {
      _isLoggedIn = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final clientesRepo = DriftClientesRepository(widget.database);
    final proveedoresRepo = DriftProveedoresRepository(widget.database);
    final productosRepo = DriftProductosRepository(widget.database);
    final movimientosRepo = DriftMovimientosRepository(widget.database);
    final ventasRepo = DriftVentasRepository(widget.database);

    return MultiProvider(
      providers: [
        Provider.value(value: widget.database),
        Provider.value(value: widget.authService),
        Provider.value(value: clientesRepo),
        Provider.value(value: proveedoresRepo),
        Provider.value(value: productosRepo),
        Provider.value(value: movimientosRepo),
        Provider.value(value: ventasRepo),
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
              VentasViewModel(ventasRepo, context.read<ScannerService>()),
        ),
        ChangeNotifierProvider(create: (_) => ClientesViewModel(clientesRepo)),
        ChangeNotifierProvider(
          create: (_) => ProveedoresViewModel(proveedoresRepo),
        ),
        ChangeNotifierProvider(
          create: (_) => InventarioViewModel(productosRepo),
        ),
        ChangeNotifierProvider(
          create: (_) => MovimientosViewModel(movimientosRepo),
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

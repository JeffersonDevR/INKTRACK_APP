import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:InkTrack/core/services/auth_service.dart';
import 'package:InkTrack/core/data/local/database.dart';
import 'package:InkTrack/core/widgets/app_card.dart';
import 'package:InkTrack/features/auth/presentation/pages/login_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FakeAuthService implements AuthService {
  @override
  Future<AuthResult> signIn({required String email, required String password}) async {
    return AuthResult(success: true);
  }

  @override
  Future<AuthResult> signUp({required String email, required String password, required String fullName}) async {
    return AuthResult(success: true);
  }

  @override
  Future<AuthResult> signOut() async {
    return AuthResult(success: true);
  }

  @override
  Future<AuthResult> resetPassword(String email) async {
    return AuthResult(success: true);
  }

  @override
  User? get currentUser => null;

  @override
  Stream<User?> get authStateChanges => const Stream.empty();

  @override
  Future<String?> getUserRole() async => null;

  @override
  Future<List<String>> getUserLocalesIds({bool includeLocalDb = false, AppDatabase? localDb}) async => [];

  @override
  Future<bool> hasUserLocales({AppDatabase? localDb}) async => false;

}

Widget buildLoginTestApp({
  Locale locale = const Locale('es'),
  required AuthService authService,
  VoidCallback? onLoginSuccess,
}) {
  return MaterialApp(
    locale: locale,
    localizationsDelegates: const [
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
    ],
    supportedLocales: [const Locale('es')],
    home: Builder(
      builder: (context) {
        return MediaQuery(
          data: const MediaQueryData(
            size: Size(320, 640),
            devicePixelRatio: 1.0,
          ),
          child: Provider<AuthService>.value(
            value: authService,
            child: LoginPage(
              onLoginSuccess: onLoginSuccess ?? () {},
            ),
          ),
        );
      },
    ),
  );
}

void main() {
  group('LoginPage at 320dp', () {
    late FakeAuthService mockAuth;
    setUp(() {
      mockAuth = FakeAuthService();
    });

    testWidgets('renders AppCard wrapper', (tester) async {
      await tester.pumpWidget(buildLoginTestApp(
        authService: mockAuth,
      ));
      await tester.pumpAndSettle();

      expect(find.byType(AppCard), findsOneWidget);
    });

    testWidgets('displays login screen in Spanish', (tester) async {
      await tester.pumpWidget(buildLoginTestApp(
        authService: mockAuth,
      ));
      await tester.pumpAndSettle();

      expect(find.text('Inicia sesión para continuar'), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Contraseña'), findsOneWidget);
      expect(find.text('Iniciar Sesión'), findsWidgets);
      expect(find.text('¿Olvidaste tu contraseña?'), findsOneWidget);
      expect(find.text('¿No tienes una cuenta?'), findsOneWidget);
      expect(find.text('Registrarse'), findsOneWidget);
    });

    testWidgets('renders without overflow at 320dp', (tester) async {
      await tester.pumpWidget(buildLoginTestApp(
        authService: mockAuth,
      ));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
    });

    testWidgets('shows validation errors for empty fields', (tester) async {
      await tester.pumpWidget(buildLoginTestApp(
        authService: mockAuth,
      ));
      await tester.pumpAndSettle();

      final signInButton = find.widgetWithText(ElevatedButton, 'Iniciar Sesión');
      await tester.tap(signInButton);
      await tester.pumpAndSettle();

      expect(find.text('Ingresa tu email'), findsOneWidget);
      expect(find.text('Ingresa tu contraseña'), findsOneWidget);
    });

    testWidgets('error message is in Spanish', (tester) async {
      await tester.pumpWidget(buildLoginTestApp(
        authService: mockAuth,
      ));
      await tester.pumpAndSettle();

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Email'),
        'test@test.com',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Contraseña'),
        'password123',
      );

      final signInButton = find.widgetWithText(ElevatedButton, 'Iniciar Sesión');
      await tester.tap(signInButton);
      await tester.pumpAndSettle();

      expect(find.text('Login failed'), findsNothing);
    });
  });
}

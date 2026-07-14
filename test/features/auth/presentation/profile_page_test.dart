import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:InkTrack/core/data/local/database.dart';
import 'package:InkTrack/core/services/auth_service.dart';
import 'package:InkTrack/core/services/locale_provider.dart';
import 'package:InkTrack/core/services/theme_provider.dart';
import 'package:InkTrack/features/auth/presentation/pages/profile_page.dart';
import 'package:InkTrack/l10n/app_localizations.dart';

class _FakeAuthService implements AuthService {
  @override
  User? get currentUser => User.fromJson({
    'id': 'user-1-test-id-12345678',
    'email': 'test@example.com',
  });

  @override
  Stream<User?> get authStateChanges => const Stream.empty();

  @override
  bool get offlineMode => false;

  @override
  Future<AuthResult> signIn({required String email, required String password}) async {
    return AuthResult(success: true);
  }

  @override
  Future<AuthResult> signUp({required String email, required String password, required String fullName}) async {
    return AuthResult(success: true);
  }

  @override
  Future<AuthResult> signOut() async => AuthResult(success: true);

  @override
  Future<AuthResult> resetPassword(String email) async => AuthResult(success: true);

  @override
  Future<String?> getUserRole() async => 'admin';

  @override
  Future<List<String>> getUserLocalesIds({bool includeLocalDb = false, AppDatabase? localDb}) async => [];

  @override
  Future<bool> hasUserLocales({AppDatabase? localDb}) async => false;
}

Widget _buildProfileTestApp() {
  return MultiProvider(
    providers: [
      Provider<AuthService>.value(value: _FakeAuthService()),
      ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ChangeNotifierProvider(create: (_) => LocaleProvider()),
    ],
    child: MaterialApp(
      locale: const Locale('es'),
      supportedLocales: const [Locale('es')],
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      home: const ProfilePage(),
    ),
  );
}

void main() {
  group('ProfilePage', () {
    testWidgets('does not render language toggle', (tester) async {
      await tester.pumpWidget(_buildProfileTestApp());
      await tester.pumpAndSettle();

      expect(find.text('Idioma'), findsNothing);
      expect(find.byIcon(Icons.language), findsNothing);
      expect(find.text('EN'), findsNothing);
      expect(find.text('ES'), findsNothing);
    });
  });
}

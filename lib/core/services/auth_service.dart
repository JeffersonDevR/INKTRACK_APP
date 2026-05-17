import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:InkTrack/core/data/local/database.dart';

class AuthService {
  final SupabaseClient _supabase;

  AuthService(this._supabase);

  User? get currentUser {
    try {
      return _supabase.auth.currentUser;
    } catch (e) {
      return null;
    }
  }

  Stream<User?> get authStateChanges {
    try {
      return _supabase.auth.onAuthStateChange.map((event) {
        try {
          return event.session?.user;
        } catch (e) {
          return null;
        }
      });
    } catch (e) {
      return const Stream.empty();
    }
  }

  Future<AuthResult> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      if (response.user != null) {
        return AuthResult(success: true, user: response.user);
      }
      return AuthResult(success: false, error: 'Login failed');
    } on AuthException catch (e) {
      return AuthResult(success: false, error: e.message);
    } catch (e) {
      return AuthResult(
        success: false,
        error: 'Connection error. Please check your internet.',
      );
    }
  }

  Future<AuthResult> signUp({
    required String email,
    required String password,
    required String fullName,
  }) async {
    try {
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
        data: {'full_name': fullName},
      );
      if (response.user != null) {
        return AuthResult(success: true, user: response.user);
      }
      return AuthResult(success: false, error: 'Signup failed');
    } on AuthException catch (e) {
      return AuthResult(success: false, error: e.message);
    } catch (e) {
      return AuthResult(
        success: false,
        error: 'Connection error. Please check your internet.',
      );
    }
  }

  Future<AuthResult> signOut() async {
    try {
      await _supabase.auth.signOut();
      return AuthResult(success: true);
    } on AuthException catch (e) {
      return AuthResult(success: false, error: e.message);
    } catch (e) {
      return AuthResult(success: false, error: e.toString());
    }
  }

  Future<AuthResult> resetPassword(String email) async {
    try {
      await _supabase.auth.resetPasswordForEmail(email);
      return AuthResult(success: true);
    } on AuthException catch (e) {
      return AuthResult(success: false, error: e.message);
    } catch (e) {
      return AuthResult(
        success: false,
        error: 'Connection error. Please check your internet.',
      );
    }
  }

  Future<String?> getUserRole() async {
    try {
      final user = currentUser;
      if (user == null) return null;

      final response = await _supabase
          .from('profiles')
          .select('role')
          .eq('id', user.id)
          .maybeSingle();

      return response?['role'] as String?;
    } catch (e) {
      return null;
    }
  }

  Future<List<String>> getUserLocalesIds({
    bool includeLocalDb = false,
    AppDatabase? localDb,
  }) async {
    try {
      final user = currentUser;
      if (user == null) return [];

      final List<String> result = [];

      if (includeLocalDb && localDb != null) {
        final query = localDb.select(localDb.locales)
          ..where((t) => t.userId.equals(user.id));
        final localLocales = await query.get();
        for (final loc in localLocales) {
          result.add(loc.id);
        }
      }

      try {
        final response = await _supabase
            .from('locales')
            .select('id')
            .eq('user_id', user.id);

        for (final e in (response as List)) {
          final id = e['id'] as String;
          if (!result.contains(id)) {
            result.add(id);
          }
        }
      } catch (_) {}

      return result;
    } catch (e) {
      return [];
    }
  }

  Future<bool> hasUserLocales({AppDatabase? localDb}) async {
    final user = currentUser;
    if (user == null) return false;

    if (localDb != null) {
      final query = localDb.select(localDb.locales)
        ..where((t) => t.userId.equals(user.id));
      final count = await query.get();
      if (count.isNotEmpty) return true;
    }

    try {
      final response = await _supabase
          .from('locales')
          .select('id')
          .eq('user_id', user.id)
          .limit(1);
      return (response as List).isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  static String? validatePassword(String password) {
    // Security: Use OWASP guidelines for password validation
    if (password.length < 12) {
      return 'Minimum 12 characters required';
    }
    if (password.length > 128) {
      return 'Maximum 128 characters';
    }
    // Check for uppercase letter
    if (!password.contains(RegExp(r'[A-Z]'))) {
      return 'Need at least one uppercase letter';
    }
    // Check for lowercase letter
    if (!password.contains(RegExp(r'[a-z]'))) {
      return 'Need at least one lowercase letter';
    }
    // Check for number
    if (!password.contains(RegExp(r'[0-9]'))) {
      return 'Need at least one number';
    }
    // Check for special character (ALLOW them - increases entropy)
    if (!password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>_\-+=\[\]{}]'))) {
      return 'Need at least one special character';
    }
    // Prevent common patterns
    if (password.contains('password') || password.contains('12345') || password.contains('qwerty')) {
      return 'Password contains common patterns';
    }
    // No spaces
    if (password.contains(' ')) {
      return 'Spaces are not allowed';
    }
    return null;
  }

  /// Validates email format using RFC 5322 standards
  static String? validateEmail(String email) {
    if (email.isEmpty) {
      return 'Email is required';
    }
    if (email.length > 254) {
      return 'Email is too long';
    }
    // RFC 5322 compliant regex (simplified but effective)
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9.!#$%&\*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$'
    );
    if (!emailRegex.hasMatch(email)) {
      return 'Please enter a valid email address';
    }
    return null;
  }
}

class AuthResult {
  final bool success;
  final User? user;
  final String? error;

  AuthResult({required this.success, this.user, this.error});
}

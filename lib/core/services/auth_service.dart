import 'package:supabase_flutter/supabase_flutter.dart';

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

  Future<List<String>> getUserLocalesIds() async {
    try {
      final user = currentUser;
      if (user == null) return [];

      final response = await _supabase
          .from('locales')
          .select('id')
          .eq('user_id', user.id);

      return (response as List).map((e) => e['id'] as String).toList();
    } catch (e) {
      return [];
    }
  }

  Future<bool> hasUserLocales() async {
    final ids = await getUserLocalesIds();
    return ids.isNotEmpty;
  }

  static String? validatePassword(String password) {
    if (password.length < 8) {
      return 'Minimum 8 characters';
    }
    if (!password.contains(RegExp(r'[A-Z]'))) {
      return 'Need at least 1 capital letter';
    }
    final numbers = password.replaceAll(RegExp(r'[^0-9]'), '');
    if (numbers.length < 3) {
      return 'Need at least 3 numbers';
    }
    if (password.contains(' ')) {
      return 'No spaces allowed';
    }
    if (RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) {
      return 'No special characters allowed';
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

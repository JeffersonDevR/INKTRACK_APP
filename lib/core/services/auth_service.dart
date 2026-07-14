import 'dart:async';
import 'dart:io';

import 'package:bcrypt/bcrypt.dart';
import 'package:drift/drift.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:InkTrack/core/data/local/database.dart';

class AuthService {
  final SupabaseClient _supabase;
  final AppDatabase? _database;

  /// Maximum number of locally cached users before LRU eviction.
  static const int _maxCachedUsers = 5;

  bool _offlineMode = false;

  /// Whether the last successful login was performed offline.
  bool get offlineMode => _offlineMode;

  AuthService(this._supabase, {AppDatabase? database})
      : _database = database;

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
        _offlineMode = false;
        await _cacheCredentials(response.user!.id, email, password);
        return AuthResult(success: true, user: response.user);
      }
      return AuthResult(success: false, error: 'Login failed');
    } on AuthException catch (e) {
      if (e is AuthRetryableFetchException) {
        final offlineResult = await _validateOffline(email, password);
        if (offlineResult.success) {
          _offlineMode = true;
        }
        return offlineResult;
      }
      return AuthResult(success: false, error: e.message);
    } on SocketException catch (_) {
      final offlineResult = await _validateOffline(email, password);
      if (offlineResult.success) {
        _offlineMode = true;
      }
      return offlineResult;
    } on TimeoutException catch (_) {
      final offlineResult = await _validateOffline(email, password);
      if (offlineResult.success) {
        _offlineMode = true;
      }
      return offlineResult;
    } catch (e, st) {
      print('AuthService.signIn: unexpected error $e\n$st');
      rethrow;
    }
  }

  /// Hashes [password] with bcrypt and stores/updates the credential in the
  /// LocalUsers table. After insert, evicts the oldest user if over limit.
  Future<void> _cacheCredentials(
    String userId,
    String email,
    String password,
  ) async {
    final db = _database;
    if (db == null) return;

    final hashed = BCrypt.hashpw(password, BCrypt.gensalt());
    await db.into(db.localUsers).insertOnConflictUpdate(
      LocalUsersCompanion(
        id: Value(userId),
        email: Value(email),
        hashedPassword: Value(hashed),
        lastLogin: Value(DateTime.now()),
      ),
    );

    await _evictIfNeeded(db);
  }

  /// Deletes the user with the oldest [lastLogin] when the cached count
  /// exceeds [_maxCachedUsers].
  Future<void> _evictIfNeeded(AppDatabase db) async {
    final count = await db.select(db.localUsers).get();
    if (count.length <= _maxCachedUsers) return;

    count.sort((a, b) => a.lastLogin.compareTo(b.lastLogin));
    await db.delete(db.localUsers).delete(count.first);
  }

  /// Looks up [email] in the local cache and verifies [password] with bcrypt.
  Future<AuthResult> _validateOffline(
    String email,
    String password,
  ) async {
    final db = _database;
    if (db == null) {
      return AuthResult(
        success: false,
        error: 'Database not available for offline login',
      );
    }

    final rows = await (db.select(db.localUsers)
          ..where((u) => u.email.equals(email)))
        .get();

    if (rows.isEmpty) {
      return AuthResult(
        success: false,
        error: 'Initial online login required',
      );
    }

    final cached = rows.first;
    if (BCrypt.checkpw(password, cached.hashedPassword)) {
      return AuthResult(success: true);
    }

    return AuthResult(success: false, error: 'Invalid credentials');
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

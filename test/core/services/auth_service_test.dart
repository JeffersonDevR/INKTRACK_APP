import 'dart:async';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:InkTrack/core/services/auth_service.dart';

// ---------------------------------------------------------------------------
// Manual mocks — implement the minimum surface needed to test catch-block
// behavior in AuthService.signIn().
// ---------------------------------------------------------------------------

class FakeAuthResponse implements AuthResponse {
  @override
  User? get user => null;

  @override
  Session? get session => null;
}

class FakeGoTrueClient implements GoTrueClient {
  final Object? throwable;

  FakeGoTrueClient({this.throwable});

  @override
  Future<AuthResponse> signInWithPassword({
    String? email,
    String? phone,
    required String password,
    String? captchaToken,
  }) async {
    if (throwable is Function) {
      throw (throwable as Function)();
    }
    if (throwable != null) {
      throw throwable as Object;
    }
    return FakeAuthResponse();
  }

  // ---- Satisfy GoTrueClient interface via noSuchMethod ----
  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

class FakeSupabaseClient implements SupabaseClient {
  final GoTrueClient _auth;

  FakeSupabaseClient(this._auth);

  @override
  GoTrueClient get auth => _auth;

  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

/// An AuthException that is NOT retryable (simulates wrong‑credential errors).
class NonRetryableAuthException extends AuthException {
  NonRetryableAuthException(super.message);

  @override
  String toString() => 'NonRetryableAuthException: $message';
}

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  group('AuthService.signIn — catch‑block behavior', () {
    late FakeGoTrueClient gotrue;
    late FakeSupabaseClient supabase;
    late AuthService authService;

    test(
      'BUG‑002: SocketException falls back to offline mode',
      () async {
        gotrue = FakeGoTrueClient(
          throwable: () => const SocketException('no network'),
        );
        supabase = FakeSupabaseClient(gotrue);
        authService = AuthService(supabase);

        final result = await authService.signIn(
          email: 'test@example.com',
          password: 'password123',
        );

        // Offline fallback runs; no cached credentials → fails gracefully.
        expect(result.success, isFalse);
        expect(
          result.error,
          anyOf(contains('Database'), contains('offline')),
          reason: 'SocketException should attempt offline fallback',
        );
      },
    );

    test(
      'BUG‑002: TimeoutException falls back to offline mode',
      () async {
        gotrue = FakeGoTrueClient(
          throwable: () => TimeoutException('connection timed out'),
        );
        supabase = FakeSupabaseClient(gotrue);
        authService = AuthService(supabase);

        final result = await authService.signIn(
          email: 'test@example.com',
          password: 'password123',
        );

        expect(result.success, isFalse);
        expect(
          result.error,
          anyOf(contains('Database'), contains('offline')),
          reason: 'TimeoutException should attempt offline fallback',
        );
      },
    );

    test(
      'BUG‑002: Non‑retryable AuthException propagates error message',
      () async {
        gotrue = FakeGoTrueClient(
          throwable: NonRetryableAuthException('Invalid credentials'),
        );
        supabase = FakeSupabaseClient(gotrue);
        authService = AuthService(supabase);

        final result = await authService.signIn(
          email: 'bad@example.com',
          password: 'wrong',
        );

        expect(result.success, isFalse);
        expect(
          result.error,
          contains('Invalid credentials'),
          reason:
              'AuthException should propagate the error, NOT fall to offline',
        );
      },
    );

    test(
      'BUG‑002: Unexpected exception rethrows instead of falling offline',
      () async {
        gotrue = FakeGoTrueClient(
          throwable: StateError('Unexpected internal error'),
        );
        supabase = FakeSupabaseClient(gotrue);
        authService = AuthService(supabase);

        await expectLater(
          authService.signIn(
            email: 'x@y.com',
            password: 'irrelevant',
          ),
          throwsA(isA<StateError>()),
          reason:
              'Non‑network, non‑auth exceptions must propagate, NOT fall to offline',
        );
      },
    );
  });
}

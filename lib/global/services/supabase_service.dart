import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  SupabaseService._();

  static bool _initialized = false;

  static String get url => dotenv.env['SUPABASE_URL']?.trim() ?? '';

  static String get anonKey => dotenv.env['SUPABASE_ANON_KEY']?.trim() ?? '';

  static bool get isConfigured => url.isNotEmpty && anonKey.isNotEmpty;

  static SupabaseClient? get client => isConfigured && _initialized ? Supabase.instance.client : null;

  static Future<void> initialize() async {
    if (!isConfigured || _initialized) return;

    await Supabase.initialize(
      url: url,
      publishableKey: anonKey,
    );
    _initialized = true;
  }

  static Future<bool> restoreSession({
    required String accessToken,
    required String refreshToken,
  }) async {
    if (!isConfigured) return false;

    try {
      await initialize();
      final response = await Supabase.instance.client.auth.setSession(refreshToken);
      return response.session != null || accessToken.isNotEmpty;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('SupabaseService.restoreSession failed: $e');
      }
      return false;
    }
  }

  static Future<AuthResponse?> signIn({
    required String email,
    required String password,
  }) async {
    if (!isConfigured) return null;

    await initialize();
    return Supabase.instance.client.auth.signInWithPassword(
      email: email.trim(),
      password: password,
    );
  }

  static Future<AuthResponse?> signUp({
    required String email,
    required String password,
    Map<String, dynamic>? data,
  }) async {
    if (!isConfigured) return null;

    await initialize();
    return Supabase.instance.client.auth.signUp(
      email: email.trim(),
      password: password,
      data: data,
    );
  }

  static Future<void> signOut() async {
    if (!isConfigured || !_initialized) return;
    await Supabase.instance.client.auth.signOut();
  }
}

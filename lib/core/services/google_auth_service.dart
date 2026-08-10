import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../config/app_config.dart';

class GoogleSignInResult {
  final String id;
  final String email;
  final String? displayName;
  final String? idToken;

  const GoogleSignInResult({
    required this.id,
    required this.email,
    this.displayName,
    this.idToken,
  });
}

/// Signs in with a real Google / Gmail account (google_sign_in v7+).
class GoogleAuthService {
  GoogleAuthService._();

  static bool _initialized = false;

  static Future<void> _ensureInit() async {
    if (_initialized) return;
    final serverId = AppConfig.googleServerClientId.trim();
    await GoogleSignIn.instance.initialize(
      serverClientId: serverId.isEmpty ? null : serverId,
    );
    _initialized = true;
  }

  static Future<GoogleSignInResult?> signIn() async {
    try {
      await _ensureInit();
      if (!GoogleSignIn.instance.supportsAuthenticate()) {
        throw Exception('google_sign_in_unsupported');
      }
      final account = await GoogleSignIn.instance.authenticate(
        scopeHint: const ['email', 'profile'],
      );
      final email = account.email.trim();
      if (email.isEmpty) {
        throw Exception('google_email_missing');
      }
      final idToken = account.authentication.idToken;
      return GoogleSignInResult(
        id: account.id,
        email: email,
        displayName: account.displayName,
        idToken: idToken,
      );
    } catch (e) {
      if (kDebugMode) debugPrint('GoogleAuthService.signIn: $e');
      rethrow;
    }
  }

  static Future<void> signOut() async {
    try {
      await _ensureInit();
      await GoogleSignIn.instance.signOut();
    } catch (_) {}
  }
}

// ============================================================
// KAYAN — Firebase Auth Repository
// حسابات حقيقية عبر جميع الأجهزة باستخدام Firebase Auth
//
// للتفعيل:
//   1. أنشئ مشروع Firebase على https://console.firebase.google.com
//   2. فعّل Authentication → Email/Password + Phone
//   3. حمّل google-services.json وضعه في android/app/
//   4. فكّ تعليق Firebase.initializeApp() في lib/main.dart
//   5. غيّر useFirebaseAuth = true في lib/core/config/app_config.dart
// ============================================================

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'auth_repository.dart';
import '../models/auth_models.dart';

class FirebaseAuthRepository implements AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  @override
  Future<AuthResult> loginWithEmail(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      final user = credential.user!;
      final token = await user.getIdToken() ?? '';
      final profileComplete = await _isProfileComplete(user.uid);

      return AuthResult(
        userId: user.uid,
        accessToken: token,
        refreshToken: token,
        isProfileComplete: profileComplete,
      );
    } on FirebaseAuthException catch (e) {
      throw Exception(_mapFirebaseError(e.code));
    }
  }

  @override
  Future<AuthResult> signUp({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      final user = credential.user!;

      // Update display name
      await user.updateDisplayName(name.trim());

      // Save profile to Firestore
      await _db.collection('users').doc(user.uid).set({
        'name': name.trim(),
        'email': email.trim().toLowerCase(),
        'phone': phone.trim(),
        'createdAt': FieldValue.serverTimestamp(),
        'profileComplete': true,
      });

      final token = await user.getIdToken() ?? '';
      return AuthResult(
        userId: user.uid,
        accessToken: token,
        refreshToken: token,
        isProfileComplete: true,
        isNewUser: true,
      );
    } on FirebaseAuthException catch (e) {
      throw Exception(_mapFirebaseError(e.code));
    }
  }

  @override
  Future<void> sendOtp(String phone) async {
    // Firebase phone auth — implemented via verifyPhoneNumber
    // For full OTP flow, use FirebaseAuth.verifyPhoneNumber
  }

  @override
  Future<AuthResult> verifyOtp(String phone, String code) async {
    // Needs PhoneAuthCredential from Firebase OTP flow
    throw UnimplementedError('Use Firebase Phone Auth flow');
  }

  @override
  Future<AuthResult> refreshToken(String refreshToken) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('not_authenticated');
    final token = await user.getIdToken(true) ?? '';
    return AuthResult(
      userId: user.uid,
      accessToken: token,
      refreshToken: token,
      isProfileComplete: await _isProfileComplete(user.uid),
    );
  }

  @override
  Future<void> logout() async {
    await _auth.signOut();
  }

  Future<bool> _isProfileComplete(String uid) async {
    try {
      final doc = await _db.collection('users').doc(uid).get();
      return doc.data()?['profileComplete'] as bool? ?? false;
    } catch (_) {
      return true;
    }
  }

  String _mapFirebaseError(String code) {
    switch (code) {
      case 'user-not-found':
        return 'user_not_found';
      case 'wrong-password':
      case 'invalid-credential':
        return 'wrong_password';
      case 'email-already-in-use':
        return 'email_already_exists';
      case 'invalid-email':
        return 'invalid_email';
      case 'weak-password':
        return 'password_too_short';
      case 'too-many-requests':
        return 'too_many_requests';
      case 'network-request-failed':
        return 'network_error';
      default:
        return 'auth_error';
    }
  }
}

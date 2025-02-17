import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class AuthService {
  AuthService({required FirebaseApp app, FirebaseAuth? auth})
      : _auth = auth ?? FirebaseAuth.instanceFor(app: app);

  final FirebaseAuth _auth;

  Future<void> signInAnonymously() async {
    try {
      final UserCredential credential = await _auth.signInAnonymously();
      if (kDebugMode) {
        log('User signed in anonymously: ${credential.user!.uid}');
      }
    } catch (e) {
      if (kDebugMode) {
        log('❌ Failed to sign in anonymously: $e');
      }
    }
  }
}

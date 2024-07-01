import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:guideme/utils/secure_storage_util.dart';

class TokenRefreshService {
  static Timer? _timer;

  static void start() {
    debugPrint('Refreshing token in 55 minutes..');
    _timer = Timer.periodic(const Duration(minutes: 55), (timer) async {
      _refreshToken();
    });
  }

  static Future<void> instantRefresh() async {
    await _refreshToken();
  }

  static void stop() {
    debugPrint('Refreshing token stopped.');
    _timer?.cancel();
  }

  static Future<void> _refreshToken() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        // Attempt to get a fresh ID token with force refresh
        final newIdToken = await user.getIdToken(true);
        debugPrint('ID token refreshed: $newIdToken');

        // Update secure storage with the new ID token
        await SecureStorageUtil.storage
            .write(key: 'id_token', value: newIdToken);
      } on FirebaseAuthException catch (e) {
        // Handle potential errors during ID token retrieval
        debugPrint('Error refreshing ID token: ${e.message}');
        // Consider additional error handling logic (e.g., showing a user-friendly message)
      }
    } else {
      debugPrint('No user signed in, cannot refresh token.');
    }
  }
}

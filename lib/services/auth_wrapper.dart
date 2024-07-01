import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:guideme/Screens/login_screen.dart';
import 'package:guideme/services/data_services.dart';

class AuthWrapper extends StatelessWidget {
  final Widget child;
  const AuthWrapper({super.key, required this.child});

  Future<bool> _checkToken() async {
    final token = await DataService.getAccessToken();
    if (token == null) return false;
    return await DataService.verifyAccessToken(token);
  }

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    return FutureBuilder<bool>(
      future: _checkToken(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData && snapshot.data == true) {
            return child; // Display the child screen if the token is verified
          } else {
            auth.signOut();
            return const LoginScreen(); // Redirect if no token or verification failed
          }
        } else {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}

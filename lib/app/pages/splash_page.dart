import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../modules/auth/pages/login_page.dart';
import '../../modules/home/pages/home_page.dart'; // 

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasData) {
          return const HomePage(); // Usuário logado
        } else {
          return const LoginPage(); // Usuário não logado
        }
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../modules/auth/pages/login_page.dart';
import '../../modules/home/pages/home_page.dart';
import '../../modules/profile/pages/profile_setup_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
          final user = snapshot.data!;
          return FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid)
                .get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }

              if (!snapshot.hasData || snapshot.data?.exists == false) {
                return const ProfileSetupPage(); // Primeira vez, pedir os dados
              }

              return const HomePage(); // Usuário já configurou o perfil
            },
          );
        } else {
          return const LoginPage(); // Usuário não logado
        }
      },
    );
  }
}

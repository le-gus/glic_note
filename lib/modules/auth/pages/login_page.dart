import 'package:flutter/material.dart';
import 'package:glic_note/modules/auth/pages/register_page.dart';
import '../../../modules/auth/controllers/login_controller.dart';
//import 'register_page.dart';
//import '../../../app/pages/splash_page.dart';
import '../../../shared/widgets/main_scaffold.dart'; //

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final controller = LoginController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool loading = false;
  String? error;

  void _login() async {
    setState(() {
      loading = true;
      error = null;
    });

    final result = await controller.login(
      emailController.text.trim(),
      passwordController.text.trim(),
    );

    setState(() {
      loading = false;
      error = result;
    });

    if (result == null) {
      // ignore: use_build_context_synchronously
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const MainScaffold()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Senha'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: loading ? null : _login,
              child: loading
                  ? const CircularProgressIndicator()
                  : const Text('Entrar'),
            ),
            if (error != null) ...[
              const SizedBox(height: 20),
              Text(error!, style: const TextStyle(color: Colors.red)),
            ],
            ElevatedButton.icon(
              onPressed: loading
                  ? null
                  : () async {
                      setState(() {
                        loading = true;
                        error = null;
                      });

                      final result = await controller.signInWithGoogle();

                      setState(() {
                        loading = false;
                        error = result;
                      });

                      if (result == null) {
                        // ignore: use_build_context_synchronously
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Login com Google bem-sucedido!')),
                        );
                      }
                    },
              icon: const Icon(Icons.login),
              label: const Text('Entrar com Google'),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const RegisterPage()),
                );
              },
              child: const Text('Criar nova conta'),
            ),
          ],
        ),
      ),
    );
  }
}

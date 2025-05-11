import 'package:flutter/material.dart';
import 'package:glic_note/modules/profile/pages/profile_setup_page.dart';
import '../controllers/register_controller.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final controller = RegisterController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool loading = false;
  String? error;

  void _register() async {
    setState(() {
      loading = true;
      error = null;
    });

    final result = await controller.register(
      emailController.text.trim(),
      passwordController.text.trim(),
    );

    setState(() {
      loading = false;
      error = result;
    });

    if (result == null && mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const ProfileSetupPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Criar Conta')),
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
              onPressed: loading ? null : _register,
              child: loading
                  ? const CircularProgressIndicator()
                  : const Text('Registrar'),
            ),
            if (error != null) ...[
              const SizedBox(height: 20),
              Text(error!, style: const TextStyle(color: Colors.red)),
            ]
          ],
        ),
      ),
    );
  }
}

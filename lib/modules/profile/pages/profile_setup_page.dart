import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../shared/widgets/main_scaffold.dart';

class ProfileSetupPage extends StatefulWidget {
  const ProfileSetupPage({super.key});

  @override
  State<ProfileSetupPage> createState() => _ProfileSetupPageState();
}

class _ProfileSetupPageState extends State<ProfileSetupPage> {
  final _nameController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  final _birthDateController = TextEditingController();
  final _medicationController = TextEditingController();
  final _diabetesTypeController = TextEditingController();

  bool _isSaving = false;

  Future<void> _saveProfile() async {
    final name = _nameController.text.trim();
    final height = _heightController.text.trim();
    final weight = _weightController.text.trim();
    final birthDate = _birthDateController.text.trim();
    final medication = _medicationController.text.trim();
    final diabetesType = _diabetesTypeController.text.trim();

    if (name.isEmpty || height.isEmpty || weight.isEmpty || birthDate.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Preencha todos os campos obrigatórios!'),
      ));
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'name': name,
          'height': height,
          'weight': weight,
          'birth_date': birthDate,
          'medication': medication,
          'diabetes_type': diabetesType,
        });

        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const MainScaffold()),
          (route) => false,
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Erro ao salvar os dados: $e'),
      ));
    } finally {
      setState(() {
        _isSaving = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Configurar Perfil')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Nome'),
            ),
            TextField(
              controller: _heightController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Altura (cm)'),
            ),
            TextField(
              controller: _weightController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Peso (kg)'),
            ),
            TextField(
              controller: _birthDateController,
              decoration:
                  const InputDecoration(labelText: 'Data de Nascimento'),
            ),
            TextField(
              controller: _medicationController,
              decoration:
                  const InputDecoration(labelText: 'Medicação (opcional)'),
            ),
            TextField(
              controller: _diabetesTypeController,
              decoration: const InputDecoration(
                  labelText: 'Tipo de Diabetes (opcional)'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isSaving ? null : _saveProfile,
              child: _isSaving
                  ? const CircularProgressIndicator()
                  : const Text('Salvar Perfil'),
            ),
          ],
        ),
      ),
    );
  }
}

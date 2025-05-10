import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:glic_note/modules/history/pages/history_page.dart';



/// Página de formulário para criar um novo registro de glicemia.
/// Localização: lib/modules/records/pages/record_form_page.dart
class RecordFormPage extends StatefulWidget {
  const RecordFormPage({super.key});

  @override
  State<RecordFormPage> createState() => _RecordFormPageState();
}

class _RecordFormPageState extends State<RecordFormPage> {
  // Controllers para capturar valores digitados
  final TextEditingController _valueController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  // Data e hora selecionadas (inicialmente agora)
  DateTime _selectedDateTime = DateTime.now();

  bool _isSaving = false;
  String? _error;

  /// Exibe um DatePicker e um TimePicker para o usuário escolher data/hora
  Future<void> _pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (date == null) return;

    final time = await showTimePicker(
      // ignore: use_build_context_synchronously
      context: context,
      initialTime: TimeOfDay.fromDateTime(_selectedDateTime),
    );
    if (time == null) return;

    setState(() {
      _selectedDateTime = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

  /// Salva o registro no Firestore
  Future<void> _saveRecord() async {
    final valueText = _valueController.text.trim();
    if (valueText.isEmpty) {
      setState(() => _error = 'Informe o valor da glicemia');
      return;
    }

      // Verifica se o usuário está autenticado
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        setState(() => _error = 'Você precisa estar logado para salvar.');
        return;
      }

    final value = double.tryParse(valueText);
    if (value == null) {
      setState(() => _error = 'Valor inválido');
      return;
    }

    setState(() {
      _isSaving = true;
      _error = null;
    });

    try {
      // Tenta salvar o registro no Firestore
      await FirebaseFirestore.instance.collection('records').add({
  'value': value,
  'notes': _notesController.text.trim(),
  'timestamp': _selectedDateTime,
});

// Redirecionar para a página de histórico após salvar o registro
if (mounted) {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (_) => const HistoryPage()),
  );
}
    } catch (e) {
      setState(() => _error = 'Erro ao salvar: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Novo Registro')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Campo para valor numérico
            TextField(
              controller: _valueController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Valor (mg/dL)',
              ),
            ),
            const SizedBox(height: 12),
            // Botão para escolher data e hora
            TextButton(
              onPressed: _pickDateTime,
              child: Text(
                'Data e hora: ${_selectedDateTime.toLocal().toString().split('.').first}',
              ),
            ),
            const SizedBox(height: 12),
            // Campo de observações
            TextField(
              controller: _notesController,
              decoration: const InputDecoration(
                labelText: 'Observações (opcional)',
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 20),
            // Exibe erro, se houver
            if (_error != null) ...[
              Text(_error!, style: const TextStyle(color: Colors.red)),
              const SizedBox(height: 12),
            ],
            // Botão de salvar
            ElevatedButton(
              onPressed: _isSaving ? null : _saveRecord,
              child: _isSaving
                  ? const CircularProgressIndicator()
                  : const Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }
}

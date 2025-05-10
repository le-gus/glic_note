import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Histórico de Registros')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('records') // Coleção de registros
            .orderBy('timestamp', descending: true) // Ordenar por data e hora
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          }

          final records = snapshot.data!.docs;
          if (records.isEmpty) {
            return const Center(child: Text('Nenhum registro encontrado.'));
          }

          return ListView.builder(
            itemCount: records.length,
            itemBuilder: (context, index) {
              final record = records[index];
              final value = record['value'];
              final timestamp = (record['timestamp'] as Timestamp).toDate();
              final notes = record['notes'] ?? 'Sem observações';

              return ListTile(
                title: Text('Valor: $value mg/dL'),
                subtitle: Text('Data: ${timestamp.toLocal()} - Observações: $notes'),
              );
            },
          );
        },
      ),
    );
  }
}

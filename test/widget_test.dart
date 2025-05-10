//import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:glic_note/app/app_widget.dart'; // ← importa seu widget

void main() {
  testWidgets('App inicia e exibe texto esperado', (WidgetTester tester) async {
    await tester.pumpWidget(const AppWidget());

    expect(find.text('GlicNote Iniciado!'), findsOneWidget);
  });
}

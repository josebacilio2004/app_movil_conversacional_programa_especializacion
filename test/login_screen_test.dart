import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app_especializacion/screens/auth/login_screen.dart';

void main() {
  testWidgets('LoginScreen should have email and password fields', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MaterialApp(home: LoginScreen()));

    // Verify fields exist
    expect(find.byType(TextFormField), findsNWidgets(2));
    expect(find.text('Inicio de Sesión'), findsOneWidget);
    expect(find.text('Iniciar Sesión'), findsOneWidget);
  });

  testWidgets('LoginScreen should show validation error on empty fields', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: LoginScreen()));

    // Tap login button
    await tester.tap(find.text('Iniciar Sesión'));
    await tester.pump();

    // Verify validation message
    expect(find.text('Ingresa un correo'), findsOneWidget);
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app_especializacion/screens/riasec/riasec_test_screen.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mockito/mockito.dart';

class MockUser extends Mock implements User {}

void main() {
  testWidgets('RiasecTestScreen should render the first question', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          Provider<User?>.value(value: null), // Mock user
        ],
        child: const MaterialApp(home: RiasecTestScreen()),
      ),
    );

    // Verify question text exists (first question from service)
    expect(find.textContaining('Me gusta reparar aparatos'), findsOneWidget);
    expect(find.text('Me gusta'), findsOneWidget);
    expect(find.text('No me gusta'), findsOneWidget);
  });
}

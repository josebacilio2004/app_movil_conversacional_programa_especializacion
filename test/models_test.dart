import 'package:flutter_test/flutter_test.dart';
import 'package:app_especializacion/models/user_model.dart';
import 'package:app_especializacion/models/specialization_model.dart';

void main() {
  group('Model Tests', () {
    test('AppUser fromMap should create a valid object', () {
      final data = {
        'email': 'test@continental.edu.pe',
        'intereses': ['IA', 'Cloud'],
        'perfilVocacional': {'R': 5, 'I': 10},
        'preferenciasGuardadas': ['spec_001']
      };
      final user = AppUser.fromMap(data, 'uid_123');

      expect(user.uid, 'uid_123');
      expect(user.email, 'test@continental.edu.pe');
      expect(user.riasecProfile['I'], 10);
    });

    test('Specialization fromMap should create a valid object', () {
      final data = {
        'name': 'IA Aplicada',
        'description': 'Test desc',
        'campoLaboral': 'Tech',
        'planEstudios': 'link',
        'categorias': ['Investigador']
      };
      final spec = Specialization.fromMap(data, 'spec_001');

      expect(spec.id, 'spec_001');
      expect(spec.name, 'IA Aplicada');
      expect(spec.categories.contains('Investigador'), true);
    });
  });
}

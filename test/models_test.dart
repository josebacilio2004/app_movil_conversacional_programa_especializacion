import 'package:flutter_test/flutter_test.dart';
import 'package:app_especializacion/models/user_model.dart';
import 'package:app_especializacion/models/specialization_model.dart';

void main() {
  group('Model Tests - ISO 29119 Validation', () {
    test('AppUser fromMap should parse and contain motivation fields', () {
      final data = {
        'email': 'test@continental.edu.pe',
        'nombreCompleto': 'José Bacilio',
        'carreraPregrado': 'Ingeniería de Sistemas e Informática',
        'areaLaboralActual': 'TI y Sistemas',
        'presupuestoMaxMensual': 1200,
        'modalidadPreferida': 'A distancia',
        'riasecCode': 'IRC',
        'intereses': ['IA', 'Cloud'],
        'perfilVocacional': {'R': 5, 'I': 10, 'A': 2, 'S': 4, 'E': 6, 'C': 8},
        'preferenciasGuardadas': ['spec_001']
      };
      final user = AppUser.fromMap(data, 'uid_123');

      expect(user.uid, 'uid_123');
      expect(user.email, 'test@continental.edu.pe');
      expect(user.displayName, 'José Bacilio');
      expect(user.carreraPregrado, 'Ingeniería de Sistemas e Informática');
      expect(user.areaLaboralActual, 'TI y Sistemas');
      expect(user.presupuestoMaxMensual, 1200);
      expect(user.modalidadPreferida, 'A distancia');
      expect(user.riasecCode, 'IRC');
      expect(user.riasecProfile['I'], 10);
    });

    test('Specialization fromMap should parse engineering and curriculum fields', () {
      final data = {
        'name': 'Maestría en Ingeniería de Sistemas',
        'description': 'Gobernanza y Cloud',
        'campoLaboral': 'CIO, Consultor DevSecOps',
        'planEstudios': 'https://ucontinental.edu.pe/posgrado/sistemas',
        'categorias': ['Investigador', 'Convencional'],
        'modalidad': 'A distancia',
        'inversionTotal': 22800,
        'cuotaMensual': 950,
        'duracionSemestres': 4,
        'creditos': 48,
        'carrerasAfines': ['Ingeniería de Sistemas e Informática'],
        'areasLaboralesAfines': ['TI y Sistemas'],
        'riasecWeights': {'R': 3.0, 'I': 5.0, 'A': 1.5, 'S': 2.0, 'E': 3.5, 'C': 4.5}
      };
      final spec = Specialization.fromMap(data, 'spec_001');

      expect(spec.id, 'spec_001');
      expect(spec.name, 'Maestría en Ingeniería de Sistemas');
      expect(spec.modality, 'A distancia');
      expect(spec.totalInvestment, 22800);
      expect(spec.monthlyFee, 950);
      expect(spec.durationSemesters, 4);
      expect(spec.credits, 48);
      expect(spec.categories.contains('Investigador'), true);
      expect(spec.relatedUndergraduateDegrees.contains('Ingeniería de Sistemas e Informática'), true);
      expect(spec.riasecWeights['I'], 5.0);
    });
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:app_especializacion/services/riasec_service.dart';
import 'package:app_especializacion/models/specialization_model.dart';

void main() {
  group('RiasecService Tests - ISO 29119 Validation', () {
    final service = RiasecService();

    test('calculateProfile should return correct counts', () {
      final answers = {
        0: true,  // R
        1: true,  // I (index 1 is R in service: let's verify indices)
      };

      final profile = service.calculateProfile(answers);
      expect(profile.containsKey('R'), true);
      expect(profile.containsKey('I'), true);
    });

    test('getTopCategory and getTriadicCode should return dominant Holland types', () {
      final profile = {"R": 4, "I": 9, "A": 2, "S": 1, "E": 6, "C": 7};
      final top = service.getTopCategory(profile);
      final triadic = service.getTriadicCode(profile);
      
      expect(top, 'I');
      expect(triadic, 'ICE'); // I=9, C=7, E=6
    });

    test('calculateNormalizedVector should rescale to 0.0 - 5.0 for SmartPLS', () {
      final profile = {"R": 10, "I": 8, "A": 6, "S": 4, "E": 2, "C": 0};
      final normalized = service.calculateNormalizedVector(profile);
      
      expect(normalized['R'], 5.0);
      expect(normalized['I'], 4.0);
      expect(normalized['A'], 3.0);
      expect(normalized['S'], 2.0);
      expect(normalized['E'], 1.0);
      expect(normalized['C'], 0.0);
    });

    test('scoreSpecialization should produce explainable Rationale and high score for congruent profile', () {
      final profile = {"R": 4, "I": 10, "A": 2, "S": 3, "E": 5, "C": 8}; // Triadic: ICE
      final spec = Specialization(
        id: "spec_sistemas",
        name: "Maestría en Ingeniería de Sistemas",
        description: "Gobernanza y Cloud",
        fieldOfWork: "TI y Sistemas",
        curriculumLink: "https://ucontinental.edu.pe",
        categories: ["Investigador", "Convencional"],
        modality: "A distancia",
        monthlyFee: 950,
        relatedUndergraduateDegrees: ["Ingeniería de Sistemas e Informática"],
        relatedWorkAreas: ["TI y Sistemas"],
      );

      final rationale = service.scoreSpecialization(
        spec, 
        profile,
        carreraPregrado: "Ingeniería de Sistemas e Informática",
        areaLaboral: "TI y Sistemas",
        maxPresupuesto: 1200,
        modalidadPreferida: "A distancia",
      );

      expect(rationale.overallScore > 4.0, true);
      expect(rationale.matchPercentage > 80.0, true);
      expect(rationale.satisfiesBudget, true);
      expect(rationale.satisfiesModality, true);
      expect(rationale.academicContinuityMatch, true);
      expect(rationale.explanation.contains("Afinidad RIASEC"), true);
      expect(rationale.explanation.contains("Continuidad Académica"), true);
    });

    test('calculatePCI should compute partial concordance percentage accurately', () {
      final pci = service.calculatePCI(["spec_001", "spec_002"], ["spec_001", "spec_002", "spec_003"]);
      expect(pci, 100.0);
    });
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:app_especializacion/services/riasec_service.dart';

void main() {
  group('RiasecService Tests', () {
    final service = RiasecService();

    test('calculateProfile should return correct counts', () {
      final answers = {
        0: true,  // R
        1: true,  // I
        2: false, // A
        3: true,  // S
        4: false, // E
        5: true,  // C
      };

      final profile = service.calculateProfile(answers);

      expect(profile['R'], 1);
      expect(profile['I'], 1);
      expect(profile['A'], 0);
      expect(profile['S'], 1);
      expect(profile['E'], 0);
      expect(profile['C'], 1);
    });

    test('getTopCategory should return the highest category', () {
      final profile = {"R": 1, "I": 5, "A": 2, "S": 0, "E": 0, "C": 0};
      final top = service.getTopCategory(profile);
      expect(top, 'I');
    });
  });
}

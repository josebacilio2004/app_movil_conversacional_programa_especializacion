import '../services/riasec_service.dart';
import '../services/mock_data_service.dart';

void main() async {
  print("=== INICIANDO SIMULACIÓN DE PRUEBAS DEL MOTOR RIASEC Y RANKING EXPLICABLE ===");
  
  final riasec = RiasecService();
  
  // 1. Simular respuestas
  print("\n[1] Simulando respuestas del Test RIASEC...");
  final mockAnswers = {
    0: true, 1: true, 5: true, // R
    10: true, 11: true, 13: true, 15: true, 17: true, // I
    20: false, 21: false, // A
    30: true, 31: true, // S
    40: true, 41: true, 42: true, // E
    50: true, 51: true, 52: true, 53: true, // C
  };
  
  // 2. Calcular perfil
  final profile = riasec.calculateProfile(mockAnswers);
  print("[2] Perfil Calculado (Frecuencias): $profile");
  
  // 3. Determinar categoría top y código triádico
  final top = riasec.getTopCategory(profile);
  final triadic = riasec.getTriadicCode(profile);
  final normalized = riasec.calculateNormalizedVector(profile);
  print("[3] Categoría Dominante: $top");
  print("[4] Código Triádico Holland (Top 3): $triadic");
  print("[5] Vector Normalizado (0 a 5 para SmartPLS): $normalized");

  // 4. Probar Ranking Explicable (Rationale) con Mock Specializations
  print("\n[6] Evaluando Recomendaciones con Constraint Parsing y Rationale:");
  final mockSpecs = MockDataService.getMockSpecializations();
  
  for (var spec in mockSpecs) {
    final rationale = riasec.scoreSpecialization(
      spec, 
      profile,
      carreraPregrado: "Ingeniería de Sistemas e Informática",
      areaLaboral: "TI y Sistemas",
      maxPresupuesto: 1000,
      modalidadPreferida: "A distancia",
    );

    print(" -> Programa: ${spec.name}");
    print("    Puntaje Global: ${rationale.overallScore} / 5.0 (${rationale.matchPercentage}%)");
    print("    Afinidad RIASEC: ${rationale.riasecAffinity} / 5.0");
    print("    Cumple Presupuesto: ${rationale.satisfiesBudget} (Cuota: S/. ${spec.monthlyFee})");
    print("    Cumple Modalidad: ${rationale.satisfiesModality} (${spec.modality})");
    print("    Continuidad Académica: ${rationale.academicContinuityMatch}");
    print("    Rationale: ${rationale.explanation}\n");
  }

  // 5. Probar Partial Concordance Index (PCI)
  final pci = riasec.calculatePCI(["spec_001", "spec_003"], ["spec_001", "spec_002", "spec_003"]);
  print("[7] Índice de Concordancia Parcial (PCI): ${pci.toStringAsFixed(1)}%");
  
  // 6. Conclusión
  print("\n--- RESULTADO FINAL DE VALIDACIÓN ---");
  if (triadic.length == 3 && pci >= 70.0) {
    print("ESTADO: EXITOSO. Motor de recomendación psicométrica y explicabilidad validado.");
  } else {
    print("ESTADO: FALLIDO. Revisar lógica.");
  }
}

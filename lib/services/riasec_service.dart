import 'dart:math' as math;
import '../models/specialization_model.dart';

class RiasecQuestion {
  final String text;
  final String category; // R, I, A, S, E, C

  RiasecQuestion({required this.text, required this.category});
}

class RecommendationRationale {
  final Specialization specialization;
  final double overallScore; // 0.0 a 5.0
  final double matchPercentage; // 0% a 100%
  final double riasecAffinity; // 0.0 a 5.0
  final bool satisfiesBudget;
  final bool satisfiesModality;
  final bool academicContinuityMatch;
  final bool laborAreaMatch;
  final String explanation; // Rationale transparente para el usuario

  RecommendationRationale({
    required this.specialization,
    required this.overallScore,
    required this.matchPercentage,
    required this.riasecAffinity,
    required this.satisfiesBudget,
    required this.satisfiesModality,
    required this.academicContinuityMatch,
    required this.laborAreaMatch,
    required this.explanation,
  });
}

class RiasecService {
  final List<RiasecQuestion> questions = [
    // Realista (R)
    RiasecQuestion(text: "Reparar aparatos mecánicos o eléctricos.", category: "R"),
    RiasecQuestion(text: "Operar maquinaria pesada o herramientas complejas.", category: "R"),
    RiasecQuestion(text: "Construir o fabricar objetos con madera o metal.", category: "R"),
    RiasecQuestion(text: "Trabajar al aire libre en actividades prácticas.", category: "R"),
    RiasecQuestion(text: "Realizar mantenimiento a vehículos o sistemas electrónicos.", category: "R"),
    RiasecQuestion(text: "Instalar y configurar redes de computadoras.", category: "R"),
    RiasecQuestion(text: "Utilizar planos y diagramas para armar equipos.", category: "R"),
    RiasecQuestion(text: "Trabajar en tareas que requieran coordinación física.", category: "R"),
    RiasecQuestion(text: "Manejar equipos de laboratorio o industriales.", category: "R"),
    RiasecQuestion(text: "Participar en la construcción de edificios o estructuras.", category: "R"),

    // Investigador (I)
    RiasecQuestion(text: "Resolver problemas matemáticos o lógicos complejos.", category: "I"),
    RiasecQuestion(text: "Realizar experimentos científicos en un laboratorio.", category: "I"),
    RiasecQuestion(text: "Investigar el origen y desarrollo de las enfermedades.", category: "I"),
    RiasecQuestion(text: "Analizar datos estadísticos para encontrar patrones.", category: "I"),
    RiasecQuestion(text: "Estudiar física, química o biología a nivel profundo.", category: "I"),
    RiasecQuestion(text: "Programar algoritmos y analizar arquitecturas de software.", category: "I"),
    RiasecQuestion(text: "Investigar teorías sobre el universo y la tecnología.", category: "I"),
    RiasecQuestion(text: "Leer artículos científicos y técnicos regularmente.", category: "I"),
    RiasecQuestion(text: "Trabajar de forma independiente en tareas intelectuales.", category: "I"),
    RiasecQuestion(text: "Desarrollar nuevas soluciones basadas en la investigación.", category: "I"),

    // Artístico (A)
    RiasecQuestion(text: "Escribir cuentos, poesías, guiones o blogs.", category: "A"),
    RiasecQuestion(text: "Tocar un instrumento musical o componer música.", category: "A"),
    RiasecQuestion(text: "Dibujar, pintar o realizar diseño gráfico digital.", category: "A"),
    RiasecQuestion(text: "Actuar en teatro o participar en producciones visuales.", category: "A"),
    RiasecQuestion(text: "Diseñar la decoración de interiores o escenografías.", category: "A"),
    RiasecQuestion(text: "Expresarse de forma creativa e innovadora.", category: "A"),
    RiasecQuestion(text: "Trabajar en publicidad o marketing creativo.", category: "A"),
    RiasecQuestion(text: "Analizar obras de arte, literatura o cine.", category: "A"),
    RiasecQuestion(text: "Fotografiar paisajes, personas o eventos.", category: "A"),
    RiasecQuestion(text: "Crear contenido multimedia original para redes sociales.", category: "A"),

    // Social (S)
    RiasecQuestion(text: "Ayudar a las personas a resolver sus problemas personales.", category: "S"),
    RiasecQuestion(text: "Enseñar o explicar temas complejos a otros.", category: "S"),
    RiasecQuestion(text: "Cuidar a enfermos o participar en voluntariado.", category: "S"),
    RiasecQuestion(text: "Trabajar en equipo para lograr un objetivo social.", category: "S"),
    RiasecQuestion(text: "Orientar a jóvenes sobre su futuro profesional.", category: "S"),
    RiasecQuestion(text: "Participar en actividades de servicio a la comunidad.", category: "S"),
    RiasecQuestion(text: "Facilitar talleres de desarrollo personal.", category: "S"),
    RiasecQuestion(text: "Escuchar activamente y empatizar con los demás.", category: "S"),
    RiasecQuestion(text: "Organizar eventos sociales o de integración.", category: "S"),
    RiasecQuestion(text: "Trabajar en recursos humanos o mediación de conflictos.", category: "S"),

    // Emprendedor (E)
    RiasecQuestion(text: "Liderar un grupo de personas para alcanzar metas.", category: "E"),
    RiasecQuestion(text: "Iniciar y dirigir mi propio negocio o proyecto.", category: "E"),
    RiasecQuestion(text: "Vender productos o ideas de forma persuasiva.", category: "E"),
    RiasecQuestion(text: "Organizar y supervisar el trabajo de otros.", category: "E"),
    RiasecQuestion(text: "Negociar contratos o acuerdos comerciales.", category: "E"),
    RiasecQuestion(text: "Hablar en público y dar presentaciones impactantes.", category: "E"),
    RiasecQuestion(text: "Tomar riesgos calculados para obtener beneficios.", category: "E"),
    RiasecQuestion(text: "Gestionar presupuestos y finanzas de una empresa.", category: "E"),
    RiasecQuestion(text: "Competir en entornos dinámicos y de alto rendimiento.", category: "E"),
    RiasecQuestion(text: "Influir en las decisiones de una organización.", category: "E"),

    // Convencional (C)
    RiasecQuestion(text: "Mantener registros detallados y ordenados.", category: "C"),
    RiasecQuestion(text: "Trabajar con sistemas de archivo o bases de datos.", category: "C"),
    RiasecQuestion(text: "Realizar tareas administrativas con precisión.", category: "C"),
    RiasecQuestion(text: "Seguir reglas y procedimientos establecidos.", category: "C"),
    RiasecQuestion(text: "Preparar informes financieros o contables.", category: "C"),
    RiasecQuestion(text: "Organizar horarios, agendas y flujos de trabajo.", category: "C"),
    RiasecQuestion(text: "Verificar la exactitud de cálculos y documentos.", category: "C"),
    RiasecQuestion(text: "Manejar software de oficina (Excel, ERPs) a nivel experto.", category: "C"),
    RiasecQuestion(text: "Trabajar en ambientes estructurados y predecibles.", category: "C"),
    RiasecQuestion(text: "Asegurar que las normativas se cumplan estrictamente.", category: "C"),
  ];

  /// Calcula las frecuencias afirmativas por dimensión RIASEC
  Map<String, int> calculateProfile(Map<int, bool> answers) {
    Map<String, int> profile = {"R": 0, "I": 0, "A": 0, "S": 0, "E": 0, "C": 0};
    
    answers.forEach((index, value) {
      if (value && index < questions.length) {
        String cat = questions[index].category;
        profile[cat] = (profile[cat] ?? 0) + 1;
      }
    });

    return profile;
  }

  /// Retorna la categoría individual dominante
  String getTopCategory(Map<String, int> profile) {
    if (profile.isEmpty) return "I";
    var sorted = profile.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
    return sorted.first.key;
  }

  /// [ETASR_13482] Código Triádico de Holland (Top 3 dimensiones, ej: "IRE")
  String getTriadicCode(Map<String, int> profile) {
    if (profile.isEmpty) return "IRC";
    var sorted = profile.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
    return sorted.take(3).map((e) => e.key).join();
  }

  /// Normaliza el perfil a escala métrica continua de 0.0 a 5.0 (para SmartPLS)
  Map<String, double> calculateNormalizedVector(Map<String, int> profile) {
    const int maxQuestionsPerCategory = 10;
    Map<String, double> normalized = {};
    for (var cat in ["R", "I", "A", "S", "E", "C"]) {
      int score = profile[cat] ?? 0;
      normalized[cat] = (score / maxQuestionsPerCategory) * 5.0;
    }
    return normalized;
  }

  /// Mapea nombres completos RIASEC a siglas
  String _categoryToLetter(String cat) {
    switch (cat.toLowerCase().trim()) {
      case "realista": return "R";
      case "investigador": return "I";
      case "artístico":
      case "artistico": return "A";
      case "social": return "S";
      case "emprendedor": return "E";
      case "convencional": return "C";
      default: return cat.toUpperCase();
    }
  }

  /// [Constraint Parsing + Ranking Explicable]
  /// Evalúa una especialización según las 3 motivaciones del egresado:
  /// 1. Afinidad Vocacional (RIASEC Triádico)
  /// 2. Continuidad Académica o Área Laboral
  /// 3. Viabilidad Económica (Presupuesto) y Modalidad
  RecommendationRationale scoreSpecialization(
    Specialization spec, 
    Map<String, int> profile, {
    String? carreraPregrado,
    String? areaLaboral,
    int? maxPresupuesto,
    String? modalidadPreferida,
  }) {
    final triadic = getTriadicCode(profile);
    final top1 = triadic.isNotEmpty ? triadic[0] : "I";
    final top2 = triadic.length > 1 ? triadic[1] : "R";
    final top3 = triadic.length > 2 ? triadic[2] : "C";

    // 1. Afinidad RIASEC (Ponderación triádica: 1º=50%, 2º=30%, 3º=20%)
    double riasecScore = 1.0;
    List<String> specLetters = spec.categories.map((c) => _categoryToLetter(c)).toList();

    if (specLetters.contains(top1)) riasecScore += 2.5;
    if (specLetters.contains(top2)) riasecScore += 1.5;
    if (specLetters.contains(top3)) riasecScore += 1.0;
    riasecScore = math.min(5.0, riasecScore);

    // 2. Motivación 1: Continuidad Académica (Pregrado)
    bool academicMatch = false;
    if (carreraPregrado != null && carreraPregrado.isNotEmpty && carreraPregrado != 'Sin configurar') {
      final cleanPregrado = carreraPregrado.toLowerCase();
      academicMatch = spec.relatedUndergraduateDegrees.any((d) => 
        cleanPregrado.contains(d.toLowerCase()) || d.toLowerCase().contains(cleanPregrado)
      ) || spec.name.toLowerCase().contains(cleanPregrado);
    }

    // 3. Motivación 2: Área Laboral Actual
    bool laborMatch = false;
    if (areaLaboral != null && areaLaboral.isNotEmpty) {
      final cleanLabor = areaLaboral.toLowerCase();
      laborMatch = spec.relatedWorkAreas.any((a) => 
        cleanLabor.contains(a.toLowerCase()) || a.toLowerCase().contains(cleanLabor)
      ) || spec.fieldOfWork.toLowerCase().contains(cleanLabor);
    }

    // 4. Motivación 3: Viabilidad Económica y Modalidad
    bool budgetSatisfied = true;
    if (maxPresupuesto != null && maxPresupuesto > 0) {
      budgetSatisfied = spec.monthlyFee <= maxPresupuesto;
    }

    bool modalitySatisfied = true;
    if (modalidadPreferida != null && modalidadPreferida.isNotEmpty && modalidadPreferida != 'Flexible') {
      modalitySatisfied = spec.modality.toLowerCase().contains(modalidadPreferida.toLowerCase());
    }

    // Ponderación global de la recomendación (0.0 a 5.0)
    // 45% RIASEC + 25% Continuidad/Área + 15% Presupuesto + 15% Modalidad
    double total = (riasecScore * 0.45);
    total += ((academicMatch || laborMatch) ? 5.0 : 2.5) * 0.25;
    total += (budgetSatisfied ? 5.0 : 2.0) * 0.15;
    total += (modalitySatisfied ? 5.0 : 2.0) * 0.15;
    total = math.min(5.0, math.max(1.0, total));

    double matchPct = (total / 5.0) * 100.0;

    // Generar Rationale transparente
    List<String> rationalePoints = [];
    rationalePoints.add("Afinidad RIASEC: Alta congruencia con tu perfil triádico '$triadic'");
    if (academicMatch) {
      rationalePoints.add("Continuidad Académica: Se alinea directamente a tu carrera de $carreraPregrado");
    } else if (laborMatch) {
      rationalePoints.add("Crecimiento Laboral: Potencia tus funciones actuales en el área de $areaLaboral");
    }
    if (budgetSatisfied) {
      rationalePoints.add("Viabilidad Económica: Cuota estimada S/. ${spec.monthlyFee}/mes dentro de tu presupuesto");
    } else {
      rationalePoints.add("Inversión: Cuota de S/. ${spec.monthlyFee}/mes (supera ligeramente tu presupuesto)");
    }
    rationalePoints.add("Modalidad: ${spec.modality} (${spec.durationSemesters} semestres)");

    return RecommendationRationale(
      specialization: spec,
      overallScore: double.parse(total.toStringAsFixed(2)),
      matchPercentage: double.parse(matchPct.toStringAsFixed(1)),
      riasecAffinity: double.parse(riasecScore.toStringAsFixed(2)),
      satisfiesBudget: budgetSatisfied,
      satisfiesModality: modalitySatisfied,
      academicContinuityMatch: academicMatch,
      laborAreaMatch: laborMatch,
      explanation: rationalePoints.join(" • "),
    );
  }

  /// [ETASR_13482] Índice de Concordancia Parcial (PCI)
  /// Compara el conjunto de recomendaciones generadas frente al criterio esperado
  double calculatePCI(List<String> recommendedIds, List<String> expectedIds) {
    if (recommendedIds.isEmpty || expectedIds.isEmpty) return 0.0;
    int matches = recommendedIds.where((id) => expectedIds.contains(id)).length;
    return (matches / math.min(recommendedIds.length, expectedIds.length)) * 100.0;
  }
}

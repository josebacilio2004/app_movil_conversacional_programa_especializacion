class Specialization {
  final String id;
  final String name;
  final String description;
  final String fieldOfWork;
  final String curriculumLink;
  final List<String> categories; // RIASEC categories, e.g., ["Realista", "Investigador"]
  final String modality; // 'A distancia', 'Semipresencial', 'Presencial'
  final int totalInvestment; // S/. Inversión total
  final int monthlyFee; // S/. Cuota mensual estimada
  final int durationSemesters; // Semestres académicos (ej: 3 o 4)
  final int credits; // Créditos académicos (ej: 48)
  final List<String> relatedUndergraduateDegrees; // Carreras pregrado afines (Motivación 1)
  final List<String> relatedWorkAreas; // Áreas de desempeño laboral afines (Motivación 2)
  final Map<String, double> riasecWeights; // Pesos por dimensión RIASEC (0.0 - 5.0)

  Specialization({
    required this.id,
    required this.name,
    required this.description,
    required this.fieldOfWork,
    required this.curriculumLink,
    required this.categories,
    this.modality = 'A distancia',
    this.totalInvestment = 21600,
    this.monthlyFee = 900,
    this.durationSemesters = 4,
    this.credits = 48,
    this.relatedUndergraduateDegrees = const [],
    this.relatedWorkAreas = const [],
    this.riasecWeights = const {},
  });

  factory Specialization.fromMap(Map<String, dynamic> data, String id) {
    return Specialization(
      id: id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      fieldOfWork: data['campoLaboral'] ?? '',
      curriculumLink: data['planEstudios'] ?? '',
      categories: List<String>.from(data['categorias'] ?? []),
      modality: data['modalidad'] ?? (data['name']?.toString().contains('Semipresencial') == true ? 'Semipresencial' : 'A distancia'),
      totalInvestment: _parseInt(data['inversionTotal'], fallback: 21600),
      monthlyFee: _parseInt(data['cuotaMensual'], fallback: 900),
      durationSemesters: _parseInt(data['duracionSemestres'], fallback: 4),
      credits: _parseInt(data['creditos'], fallback: 48),
      relatedUndergraduateDegrees: List<String>.from(data['carrerasAfines'] ?? []),
      relatedWorkAreas: List<String>.from(data['areasLaboralesAfines'] ?? []),
      riasecWeights: (data['riasecWeights'] is Map) 
          ? Map<String, double>.from((data['riasecWeights'] as Map).map((k, v) => MapEntry(k.toString(), (v as num).toDouble())))
          : {},
    );
  }

  static int _parseInt(dynamic value, {int fallback = 0}) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? fallback;
    return fallback;
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'campoLaboral': fieldOfWork,
      'planEstudios': curriculumLink,
      'categorias': categories,
      'modalidad': modality,
      'inversionTotal': totalInvestment,
      'cuotaMensual': monthlyFee,
      'duracionSemestres': durationSemesters,
      'creditos': credits,
      'carrerasAfines': relatedUndergraduateDegrees,
      'areasLaboralesAfines': relatedWorkAreas,
      'riasecWeights': riasecWeights,
    };
  }
}

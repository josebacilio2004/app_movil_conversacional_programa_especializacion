class Specialization {
  final String id;
  final String name;
  final String description;
  final String fieldOfWork;
  final String curriculumLink;
  final List<String> categories; // RIASEC categories, e.g., ["Realista", "Investigador"]

  Specialization({
    required this.id,
    required this.name,
    required this.description,
    required this.fieldOfWork,
    required this.curriculumLink,
    required this.categories,
  });

  factory Specialization.fromMap(Map<String, dynamic> data, String id) {
    return Specialization(
      id: id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      fieldOfWork: data['campoLaboral'] ?? '',
      curriculumLink: data['planEstudios'] ?? '',
      categories: List<String>.from(data['categorias'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'campoLaboral': fieldOfWork,
      'planEstudios': curriculumLink,
      'categorias': categories,
    };
  }
}

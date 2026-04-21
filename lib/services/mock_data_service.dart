import '../models/specialization_model.dart';

class MockDataService {
  static List<Specialization> getMockSpecializations() {
    return [
      Specialization(
        id: "spec_001",
        name: "Ingeniería de Software con IA",
        description: "Enfocada en el desarrollo de sistemas inteligentes y automatización.",
        fieldOfWork: "Empresas tecnológicas, startups, consultoría de software.",
        curriculumLink: "https://ejemplo.com/ia-plan",
        categories: ["Investigador", "Realista"],
      ),
      Specialization(
        id: "spec_002",
        name: "Gestión de Proyectos Ágiles",
        description: "Liderazgo de equipos técnicos bajo metodologías Scrum y Kanban.",
        fieldOfWork: "Gerencia de proyectos, Scrum Master, Product Owner.",
        curriculumLink: "https://ejemplo.com/agile-plan",
        categories: ["Emprendedor", "Social"],
      ),
      Specialization(
        id: "spec_003",
        name: "Análisis de Datos y Big Data",
        description: "Interpretación de grandes volúmenes de datos para la toma de decisiones.",
        fieldOfWork: "Analista de datos, científico de datos, BI.",
        curriculumLink: "https://ejemplo.com/data-plan",
        categories: ["Investigador", "Convencional"],
      ),
    ];
  }
}

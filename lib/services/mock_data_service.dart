import '../models/specialization_model.dart';

class MockDataService {
  static List<Specialization> getMockSpecializations() {
    return [
      Specialization(
        id: "spec_001",
        name: "Maestría en Ingeniería de Sistemas",
        description: "Enfocada en el desarrollo de sistemas inteligentes y automatización.",
        fieldOfWork: "Empresas tecnológicas, startups, consultoría de software.",
        curriculumLink: "https://ucontinental.edu.pe/posgrado/maestria-ingenieria-sistemas",
        categories: ["Investigador", "Realista"],
        modality: "A distancia",
        totalInvestment: 22800,
        monthlyFee: 950,
        durationSemesters: 4,
        credits: 48,
        relatedUndergraduateDegrees: ["Ingeniería de Sistemas e Informática", "Ingeniería de Software"],
        relatedWorkAreas: ["TI y Sistemas", "Ciberseguridad"],
        riasecWeights: {"R": 3.0, "I": 5.0, "A": 1.5, "S": 2.0, "E": 3.5, "C": 4.5},
      ),
      Specialization(
        id: "spec_002",
        name: "Maestría en Transformación Digital",
        description: "Liderazgo de equipos técnicos bajo metodologías ágiles e innovación.",
        fieldOfWork: "Gerencia de proyectos, Agile Coach, Product Owner.",
        curriculumLink: "https://ucontinental.edu.pe/posgrado/maestria-transformacion-digital",
        categories: ["Emprendedor", "Social"],
        modality: "A distancia",
        totalInvestment: 24000,
        monthlyFee: 1000,
        durationSemesters: 4,
        credits: 48,
        relatedUndergraduateDegrees: ["Ingeniería Industrial", "Ingeniería de Sistemas", "Administración"],
        relatedWorkAreas: ["Innovación Corporativa", "Gestión de Proyectos"],
        riasecWeights: {"R": 2.0, "I": 4.0, "A": 3.0, "S": 4.0, "E": 5.0, "C": 3.5},
      ),
      Specialization(
        id: "spec_003",
        name: "Maestría en Ingeniería de Datos",
        description: "Interpretación de grandes volúmenes de datos para la toma de decisiones.",
        fieldOfWork: "Analista de datos, científico de datos, BI.",
        curriculumLink: "https://ucontinental.edu.pe/posgrado/maestria-ingenieria-datos",
        categories: ["Investigador", "Convencional"],
        modality: "A distancia",
        totalInvestment: 24000,
        monthlyFee: 1000,
        durationSemesters: 4,
        credits: 48,
        relatedUndergraduateDegrees: ["Ingeniería de Sistemas e Informática", "Estadística"],
        relatedWorkAreas: ["Data Engineering", "Machine Learning"],
        riasecWeights: {"R": 4.0, "I": 5.0, "A": 2.0, "S": 1.5, "E": 3.0, "C": 4.0},
      ),
    ];
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DataSeeder {
  static Future<void> seedSpecializations(BuildContext context) async {
    final CollectionReference specs = FirebaseFirestore.instance.collection('specializations');

    final List<Map<String, dynamic>> dataset = [
      {
        "name": "Maestría en Ingeniería de Sistemas (A distancia)",
        "riasec": "Investigador, Convencional",
        "categorias": ["Investigador", "Convencional"],
        "description": "Dirigido a profesionales de TI que buscan liderar proyectos de gobernanza digital, ciberseguridad avanzada e inteligencia de negocios.",
        "curriculum": "Gobernanza de TI (COBIT/ITIL), Inteligencia de Negocios, Ciberseguridad Estratégica, Arquitectura Cloud.",
        "planEstudios": "Gobernanza de TI (COBIT/ITIL), Inteligencia de Negocios, Ciberseguridad Estratégica, Arquitectura Cloud.",
        "skills": "Arquitectura empresarial de TI, análisis de riesgos digitales, alineamiento estratégico de negocio.",
        "labor_market": "Director de TI (CIO), Jefe de Proyectos Cloud, Auditor de Sistemas de Información, Consultor DevSecOps.",
        "campoLaboral": "Director de TI (CIO), Jefe de Proyectos Cloud, Auditor de Sistemas de Información, Consultor DevSecOps.",
        "level": "postgrado"
      },
      {
        "name": "Maestría en Ingeniería de Datos (A distancia)",
        "riasec": "Investigador, Realista",
        "categorias": ["Investigador", "Realista"],
        "description": "Forma expertos en el procesamiento masivo de datos (Big Data), diseño de pipelines de datos y modelos de aprendizaje automático.",
        "curriculum": "Big Data Analytics, Pipelines de Datos, Machine Learning, Almacenamiento NoSQL, Ciencia de Datos.",
        "planEstudios": "Big Data Analytics, Pipelines de Datos, Machine Learning, Almacenamiento NoSQL, Ciencia de Datos.",
        "skills": "Modelamiento cuantitativo, programación en Python/R, diseño de pipelines ETL avanzados.",
        "labor_market": "Ingeniero de Datos (Data Engineer), Arquitecto de Big Data, Científico de Datos (Data Scientist).",
        "campoLaboral": "Ingeniero de Datos (Data Engineer), Arquitecto de Big Data, Científico de Datos (Data Scientist).",
        "level": "postgrado"
      },
      {
        "name": "Maestría en Ingeniería Industrial (A distancia)",
        "riasec": "Emprendedor, Realista",
        "categorias": ["Emprendedor", "Realista"],
        "description": "Optimiza y dirige sistemas de producción, manufactura esbelta y proyectos industriales complejos con eficiencia operativa.",
        "curriculum": "Optimización de Operaciones, Lean Manufacturing, Dirección Industrial, Gestión de la Calidad (Six Sigma).",
        "planEstudios": "Optimización de Operaciones, Lean Manufacturing, Dirección Industrial, Gestión de la Calidad (Six Sigma).",
        "skills": "Reingeniería de procesos, liderazgo de proyectos industriales, control de calidad Six Sigma.",
        "labor_market": "Gerente de Planta, Director de Operaciones Industriales, Consultor de Productividad y Eficiencia.",
        "campoLaboral": "Gerente de Planta, Director de Operaciones Industriales, Consultor de Productividad y Eficiencia.",
        "level": "postgrado"
      },
      {
        "name": "Maestría en Ingeniería Biomédica (A distancia)",
        "riasec": "Investigador, Realista",
        "categorias": ["Investigador", "Realista"],
        "description": "Integra principios de ingeniería y biología para el diseño, mantenimiento y gestión de equipamiento médico y software de salud.",
        "curriculum": "Instrumentación Biomédica, Gestión de Tecnología en Salud, Procesamiento de Señales Biológicas, Telemedicina.",
        "planEstudios": "Instrumentación Biomédica, Gestión de Tecnología en Salud, Procesamiento de Señales Biológicas, Telemedicina.",
        "skills": "Diseño de sensores biomédicos, mantenimiento de equipo médico crítico, formulación de proyectos e-Health.",
        "labor_market": "Jefe de Ingeniería Clínica en hospitales, desarrollador de software de diagnóstico, consultor biomédico.",
        "campoLaboral": "Jefe de Ingeniería Clínica en hospitales, desarrollador de software de diagnóstico, consultor biomédico.",
        "level": "postgrado"
      },
      {
        "name": "Maestría en Finanzas (A distancia)",
        "riasec": "Convencional, Emprendedor",
        "categorias": ["Convencional", "Emprendedor"],
        "description": "Domina la gestión de tesorería, mercado de capitales, valorización de empresas y toma de decisiones de inversión estratégica.",
        "curriculum": "Dirección Financiera, Valorización de Empresas, Gestión de Portafolio, Ingeniería Financiera, Mercado de Capitales.",
        "planEstudios": "Dirección Financiera, Valorización de Empresas, Gestión de Portafolio, Ingeniería Financiera, Mercado de Capitales.",
        "skills": "Matemática financiera avanzada, evaluación de proyectos de inversión, análisis cuantitativo de riesgos.",
        "labor_market": "Gerente de Finanzas (CFO), Asesor Financiero en banca corporativa, Gestor de Portafolio de Inversión.",
        "campoLaboral": "Gerente de Finanzas (CFO), Asesor Financiero en banca corporativa, Gestor de Portafolio de Inversión.",
        "level": "postgrado"
      },
      {
        "name": "Maestría en Gestión de la Cadena de Suministro (A distancia)",
        "riasec": "Realista, Convencional",
        "categorias": ["Realista", "Convencional"],
        "description": "Planifica y optimiza la adquisición, almacenamiento y distribución internacional de mercancías utilizando analítica y tecnología.",
        "curriculum": "Supply Chain Management, Logística Global, Gestión de Inventarios y Compras, Transporte y Distribución.",
        "planEstudios": "Supply Chain Management, Logística Global, Gestión de Inventarios y Compras, Transporte y Distribución.",
        "skills": "Planificación agregada de demanda, negociación de fletes, diseño de redes de distribución.",
        "labor_market": "Director de Logística y Suministros, Consultor en Supply Chain, Jefe de Distribución Internacional.",
        "campoLaboral": "Director de Logística y Suministros, Consultor en Supply Chain, Jefe de Distribución Internacional.",
        "level": "postgrado"
      },
      {
        "name": "Maestría en Gerencia Pública (Semipresencial)",
        "riasec": "Social, Emprendedor",
        "categorias": ["Social", "Emprendedor"],
        "description": "Lidera la modernización de instituciones públicas mediante el diseño de políticas inclusivas y presupuestos por resultados eficientes.",
        "curriculum": "Gestión Pública Estratégica, Presupuesto por Resultados, Contrataciones Estatales, Ética y Anticorrupción.",
        "planEstudios": "Gestión Pública Estratégica, Presupuesto por Resultados, Contrataciones Estatales, Ética y Anticorrupción.",
        "skills": "Diseño de proyectos de inversión pública (Invierte.pe), negociación política, auditoría gubernamental.",
        "labor_market": "Director en ministerios, Gerente Municipal, Asesor de Gobierno, Consultor de Políticas Públicas.",
        "campoLaboral": "Director en ministerios, Gerente Municipal, Asesor de Gobierno, Consultor de Políticas Públicas.",
        "level": "postgrado"
      },
      {
        "name": "Maestría en Políticas Públicas (A distancia)",
        "riasec": "Social, Investigador",
        "categorias": ["Social", "Investigador"],
        "description": "Especializa en la formulación, evaluación de impacto y monitoreo científico de programas sociales y regulaciones gubernamentales.",
        "curriculum": "Diseño de Políticas Públicas, Evaluación de Impacto Cualitativa y Cuantitativa, Análisis de Datos Públicos.",
        "planEstudios": "Diseño de Políticas Públicas, Evaluación de Impacto Cualitativa y Cuantitativa, Análisis de Datos Públicos.",
        "skills": "Metodología del marco lógico, análisis estadístico de bases públicas, formulación de regulaciones.",
        "labor_market": "Analista de Políticas en ONGs, Consultor de Programas Sociales, Especialista en Monitoreo Estatal.",
        "campoLaboral": "Analista de Políticas en ONGs, Consultor de Programas Sociales, Especialista en Monitoreo Estatal.",
        "level": "postgrado"
      },
      {
        "name": "Maestría en Gestión de Salud y Hospitales (A distancia)",
        "riasec": "Social, Convencional",
        "categorias": ["Social", "Convencional"],
        "description": "Especialización para dirigir centros de salud optimizando recursos y garantizando la calidad y seguridad del paciente.",
        "curriculum": "Administración de Clínicas y Hospitales, Gestión de la Calidad en Salud, Presupuesto Sanitario.",
        "planEstudios": "Administración de Clínicas y Hospitales, Gestión de la Calidad en Salud, Presupuesto Sanitario.",
        "skills": "Planificación hospitalaria, evaluación de indicadores de calidad médica, gestión de personal sanitario.",
        "labor_market": "Director de Clínicas o Hospitales, Administrador de Redes de Salud, Consultor en Auditoría Médica.",
        "campoLaboral": "Director de Clínicas o Hospitales, Administrador de Redes de Salud, Consultor en Auditoría Médica.",
        "level": "postgrado"
      },
      {
        "name": "Maestría en Gestión Pública y Privada de la Salud (Semipresencial)",
        "riasec": "Social, Emprendedor",
        "categorias": ["Social", "Emprendedor"],
        "description": "Integra los marcos regulatorios y operativos de los sistemas de salud públicos y de las redes de clínicas privadas.",
        "curriculum": "Políticas de Salud, Alianzas Público-Privadas (APP) en Salud, Aseguramiento Universal, Gestión de Operaciones Médicas.",
        "planEstudios": "Políticas de Salud, Alianzas Público-Privadas (APP) en Salud, Aseguramiento Universal, Gestión de Operaciones Médicas.",
        "skills": "Formulación de convenios de salud público-privados, auditoría de sistemas de aseguramiento (SUSALUD).",
        "labor_market": "Gerente en EPS o Aseguradoras, Gestor de Alianzas Médicas, Directivo de Hospitales de Asociación Público-Privada.",
        "campoLaboral": "Gerente en EPS o Aseguradoras, Gestor de Alianzas Médicas, Directivo de Hospitales de Asociación Público-Privada.",
        "level": "postgrado"
      },
      {
        "name": "Maestría en Gestión de Negocios Internacionales (A distancia)",
        "riasec": "Emprendedor, Convencional",
        "categorias": ["Emprendedor", "Convencional"],
        "description": "Desarrolla habilidades directivas para planificar el ingreso a mercados internacionales, importación, exportación y comercio global.",
        "curriculum": "Negocios Globales, Comercio Exterior, Inteligencia de Mercados Internacionales, Finanzas Internacionales.",
        "planEstudios": "Negocios Globales, Comercio Exterior, Inteligencia de Mercados Internacionales, Finanzas Internacionales.",
        "skills": "Negociación intercultural, estructuración de contratos de comercio exterior (Incoterms), planeamiento de exportación.",
        "labor_market": "Gerente de Exportaciones/Importaciones, Consultor de Comercio Internacional, Gestor de Aduanas.",
        "campoLaboral": "Gerente de Exportaciones/Importaciones, Consultor de Comercio Internacional, Gestor de Aduanas.",
        "level": "postgrado"
      },
      {
        "name": "Maestría en Agronegocios (A distancia)",
        "riasec": "Emprendedor, Realista",
        "categorias": ["Emprendedor", "Realista"],
        "description": "Lidera la cadena de valor agroalimentaria, tecnificación del campo, exportación de productos agrícolas y finanzas rurales.",
        "curriculum": "Gestión de Agronegocios, Cadena Agroalimentaria, Finanzas Agrícolas, Comercio Internacional de Commodities.",
        "planEstudios": "Gestión de Agronegocios, Cadena Agroalimentaria, Finanzas Agrícolas, Comercio Internacional de Commodities.",
        "skills": "Evaluación técnica de proyectos agrícolas, comercio internacional agropecuario, logística de perecederos.",
        "labor_market": "Gerente de Agroexportadora, Administrador de Fincas Tecnificadas, Consultor en Desarrollo Rural.",
        "campoLaboral": "Gerente de Agroexportadora, Administrador de Fincas Tecnificadas, Consultor en Desarrollo Rural.",
        "level": "postgrado"
      },
      {
        "name": "Maestría en Turismo (A distancia)",
        "riasec": "Emprendedor, Artístico",
        "categorias": ["Emprendedor", "Artístico"],
        "description": "Innovación en el diseño de experiencias de viaje sostenibles, marketing turístico digital y gestión de proyectos hoteleros.",
        "curriculum": "Marketing Turístico, Planificación de Destinos Sostenibles, Gestión de Servicios de Hospitalidad.",
        "planEstudios": "Marketing Turístico, Planificación de Destinos Sostenibles, Gestión de Servicios de Hospitalidad.",
        "skills": "Branding de destinos turísticos, formulación de proyectos eco-turísticos, control de calidad en hotelería.",
        "labor_market": "Gerente de Hoteles o Resorts, Planificador de Destinos Turísticos en Gobiernos, Consultor de Ecoturismo.",
        "campoLaboral": "Gerente de Hoteles o Resorts, Planificador de Destinos Turísticos en Gobiernos, Consultor de Ecoturismo.",
        "level": "postgrado"
      },
      {
        "name": "Maestría en Marketing Digital (A distancia)",
        "riasec": "Artístico, Emprendedor",
        "categorias": ["Artístico", "Emprendedor"],
        "description": "Especialidad en el diseño de campañas digitales efectivas, analítica web, SEO/SEM y estrategias de redes sociales.",
        "curriculum": "Inbound Marketing, SEO/SEM y Paid Media, Analítica Web (Google Analytics), Estrategia de Redes Sociales.",
        "planEstudios": "Inbound Marketing, SEO/SEM y Paid Media, Analítica Web (Google Analytics), Estrategia de Redes Sociales.",
        "skills": "Diseño de campañas publicitarias digitales, analítica de métricas de conversión (ROI/CAC), redacción persuasiva.",
        "labor_market": "Director de Marketing Digital, Consultor SEO/SEM, Jefe de Canales Digitales, Growth Hacker.",
        "campoLaboral": "Director de Marketing Digital, Consultor SEO/SEM, Jefe de Canales Digitales, Growth Hacker.",
        "level": "postgrado"
      },
      {
        "name": "Maestría en Transformación Digital (A distancia)",
        "riasec": "Investigador, Emprendedor",
        "categorias": ["Investigador", "Emprendedor"],
        "description": "Lidera la adopción de tecnologías exponenciales, rediseño de procesos organizacionales y metodologías ágiles.",
        "curriculum": "Cultura y Cambio Organizacional, Tecnologías Exponenciales (AI/IoT), Metodologías Ágiles (Scrum/Design Thinking).",
        "planEstudios": "Cultura y Cambio Organizacional, Tecnologías Exponenciales (AI/IoT), Metodologías Ágiles (Scrum/Design Thinking).",
        "skills": "Facilitación del cambio cultural, diseño de productos de software ágiles, análisis de procesos corporativos.",
        "labor_market": "Director de Transformación Digital, Scrum Master / Agile Coach, Consultor de Innovación Tecnológica.",
        "campoLaboral": "Director de Transformación Digital, Scrum Master / Agile Coach, Consultor de Innovación Tecnológica.",
        "level": "postgrado"
      },
      {
        "name": "Maestría en Psicología Organizacional (A distancia)",
        "riasec": "Social, Investigador",
        "categorias": ["Social", "Investigador"],
        "description": "Desarrolla estrategias de bienestar y salud ocupacional, selección avanzada por competencias y cultura corporativa.",
        "curriculum": "Comportamiento Organizacional, Clima y Cultura, Gestión del Desempeño, Selección de Personal por Competencias.",
        "planEstudios": "Comportamiento Organizacional, Clima y Cultura, Gestión del Desempeño, Selección de Personal por Competencias.",
        "skills": "Diagnóstico de clima laboral, diseño de planes de incentivos y desarrollo de planes de carrera corporativos.",
        "labor_market": "Gerente de Recursos Humanos, Especialista en Clima y Cultura Laboral, Consultor en Atracción del Talento.",
        "campoLaboral": "Gerente de Recursos Humanos, Especialista en Clima y Cultura Laboral, Consultor en Atracción del Talento.",
        "level": "postgrado"
      },
      {
        "name": "Maestría en Neurociencia Cognitiva (A distancia)",
        "riasec": "Investigador, Social",
        "categorias": ["Investigador", "Social"],
        "description": "Estudia los procesos cognitivos y sus bases biológicas para aplicarlos en neuroeducación, neuromarketing y neurorehabilitación.",
        "curriculum": "Bases Neurobiológicas de la Cognición, Neuropsicología, Neuroeducación, Métodos de Investigación Cerebral.",
        "planEstudios": "Bases Neurobiológicas de la Cognición, Neuropsicología, Neuroeducación, Métodos de Investigación Cerebral.",
        "skills": "Diseño de experimentos cognitivos, evaluación neuropsicológica, redacción de artículos científicos de neurociencia.",
        "labor_market": "Investigador en neurociencia, asesor en neuroeducación escolar, diseñador de campañas de neuromarketing.",
        "campoLaboral": "Investigador en neurociencia, asesor en neuroeducación escolar, diseñador de campañas de neuromarketing.",
        "level": "postgrado"
      },
      {
        "name": "Maestría en Psicopatología (A distancia)",
        "riasec": "Investigador, Social",
        "categorias": ["Investigador", "Social"],
        "description": "Especialización avanzada en el diagnóstico clínico, abordaje y prevención de trastornos y problemas de salud mental.",
        "curriculum": "Manuales de Diagnóstico (CIE/DSM), Psicopatología Clínica Infantil y de Adultos, Abordaje Psicoterapéutico.",
        "planEstudios": "Manuales de Diagnóstico (CIE/DSM), Psicopatología Clínica Infantil y de Adultos, Abordaje Psicoterapéutico.",
        "skills": "Entrevista de diagnóstico clínico profundo, diseño de planes de prevención comunitaria en salud mental.",
        "labor_market": "Terapeuta clínico especializado, consultor en centros de salud mental, docente de educación superior.",
        "campoLaboral": "Terapeuta clínico especializado, consultor en centros de salud mental, docente de educación superior.",
        "level": "postgrado"
      },
      {
        "name": "Maestría en Ciencias con mención en Gestión Ambiental y Desarrollo Sostenible (Semipresencial)",
        "riasec": "Investigador, Realista",
        "categorias": ["Investigador", "Realista"],
        "description": "Forma investigadores para el análisis de problemas ambientales, impacto ecológico, economía circular y sostenibilidad industrial.",
        "curriculum": "Evaluación de Impacto Ambiental, Economía Circular, Gestión y Tratamiento de Residuos, Normativa Ambiental.",
        "planEstudios": "Evaluación de Impacto Ambiental, Economía Circular, Gestión y Tratamiento de Residuos, Normativa Ambiental.",
        "skills": "Evaluación ecológica de entornos, muestreo científico de contaminantes, diseño de planes de sostenibilidad.",
        "labor_market": "Jefe de Sostenibilidad Ambiental, Auditor de Gestión Ecológica, Consultor de Proyectos de Impacto Ambiental.",
        "campoLaboral": "Jefe de Sostenibilidad Ambiental, Auditor de Gestión Ecológica, Consultor de Proyectos de Impacto Ambiental.",
        "level": "postgrado"
      },
      {
        "name": "Maestría en Ciencias con mención en Gestión de Riesgo de Desastres y Responsabilidad Social (Semipresencial)",
        "riasec": "Social, Realista",
        "categorias": ["Social", "Realista"],
        "description": "Especialidad en planes de prevención de desastres, mitigación de emergencias naturales y políticas de responsabilidad social.",
        "curriculum": "Análisis de Vulnerabilidad y Riesgos, Planes de Emergencia y Contingencia, Responsabilidad Social Comunitaria.",
        "planEstudios": "Análisis de Vulnerabilidad y Riesgos, Planes de Emergencia y Contingencia, Responsabilidad Social Comunitaria.",
        "skills": "Diseño de mapas de evacuación y riesgo, formulación de planes de respuesta humanitaria, auditoría social.",
        "labor_market": "Coordinador de Defensa Civil, Jefe de Responsabilidad Social Empresarial, Gestor de Emergencias en ONGs.",
        "campoLaboral": "Coordinador de Defensa Civil, Jefe de Responsabilidad Social Empresarial, Gestor de Emergencias en ONGs.",
        "level": "postgrado"
      },
      {
        "name": "Maestría en Derecho Ambiental (A distancia)",
        "riasec": "Investigador, Social",
        "categorias": ["Investigador", "Social"],
        "description": "Especialización jurídica en leyes ambientales, regulación del sector minero y energético, y solución de conflictos socioambientales.",
        "curriculum": "Derecho Ambiental Comparado, Regulación Sectorial de Recursos Naturales, Arbitraje y Conflictos Socioambientales.",
        "planEstudios": "Derecho Ambiental Comparado, Regulación Sectorial de Recursos Naturales, Arbitraje y Conflictos Socioambientales.",
        "skills": "Defensa jurídica ambiental, mediación en mesas de diálogo socioambiental, auditoría legal ambiental corporativa.",
        "labor_market": "Asesor legal ambiental, consultor en fiscalización (OEFA), abogado de mediación comunitaria.",
        "campoLaboral": "Asesor legal ambiental, consultor en fiscalización (OEFA), abogado de mediación comunitaria.",
        "level": "postgrado"
      }
    ];

    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      // Limpiar colección previa para poblar con datos actualizados de posgrado
      var snapshots = await specs.get();
      for (var doc in snapshots.docs) {
        await doc.reference.delete();
      }

      for (var data in dataset) {
        await specs.add(data);
      }

      Navigator.pop(context); // Cerrar loader
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Base de datos de posgrados poblada exitosamente.")),
      );
    } catch (e) {
      Navigator.pop(context); // Cerrar loader
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al poblar: $e")),
      );
    }
  }
}

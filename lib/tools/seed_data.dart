import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DataSeeder {
  static Future<void> seedSpecializations(BuildContext context) async {
    final CollectionReference specs = FirebaseFirestore.instance.collection('specializations');

    final List<Map<String, dynamic>> dataset = [
      {
        "name": "Ingeniería de Sistemas e Informática",
        "riasec": "Investigador, Realista",
        "description": "Lidera la transformación digital mediante el diseño de sistemas complejos y soluciones de software de alto impacto.",
        "curriculum": "Algoritmos, Estructura de Datos, Arquitectura de Computadoras, Redes, IA, Gestión de Proyectos TI.",
        "skills": "Programación avanzada, resolución de problemas lógicos, diseño de arquitecturas cloud.",
        "labor_market": "Empresas tech globales, consultoría TI, startups de software, sector bancario."
      },
      {
        "name": "Ingeniería de Software",
        "riasec": "Realista, Investigador",
        "description": "Especialízate en el ciclo de vida completo del desarrollo de software con estándares internacionales.",
        "curriculum": "Ingeniería de Requerimientos, Diseño de Software, DevOps, Calidad de Software, Aplicaciones Móviles.",
        "skills": "Codificación limpia, metodologías ágiles, pruebas automatizadas.",
        "labor_market": "Arquitecto de software, Lead Developer, QA Engineer, Consultor de Transformación Digital."
      },
      {
        "name": "Ingeniería Mecatrónica",
        "riasec": "Realista, Investigador",
        "description": "Combina mecánica, electrónica e informática para crear sistemas inteligentes y robóticos.",
        "curriculum": "Mecánica de Sólidos, Circuitos Electrónicos, Control Automático, Robótica Industrial, Microcontroladores.",
        "skills": "Diseño CAD, programación de PLC, ensamble de prototipos electrónicos.",
        "labor_market": "Industria automotriz, minería automatizada, robótica médica, plantas de manufactura."
      },
      {
        "name": "Administración y Negocios Internacionales",
        "riasec": "Emprendedor, Convencional",
        "description": "Gestiona organizaciones en entornos globales y crea modelos de negocios exponenciales.",
        "curriculum": "Microeconomía, Marketing Global, Finanzas Corporativas, Logística Internacional, Inteligencia de Negocios.",
        "skills": "Liderazgo, negociación, análisis financiero, visión estratégica.",
        "labor_market": "Gerencia de exportaciones, trading internacional, consultoría de negocios, emprendimiento propio."
      },
      {
        "name": "Psicología",
        "riasec": "Social, Investigador",
        "description": "Comprende la mente humana y promueve el bienestar emocional en diversos contextos sociales.",
        "curriculum": "Neuropsicología, Psicología Cognitiva, Evaluación Psicológica, Terapia Familiar, Psicología Organizacional.",
        "skills": "Empatía, escucha activa, diagnóstico clínico básico, facilitación de grupos.",
        "labor_market": "Clínicas privadas, departamentos de RR.HH., centros educativos, ONGs de desarrollo social."
      },
      {
        "name": "Diseño Gráfico y Digital",
        "riasec": "Artístico, Emprendedor",
        "description": "Crea identidades visuales memorables y experiencias de usuario centradas en la innovación.",
        "curriculum": "Teoría del Color, Tipografía, Ilustración Digital, UX/UI Design, Animación 2D/3D.",
        "skills": "Dominio de Adobe Suite, creatividad disruptiva, prototipado de interfaces.",
        "labor_market": "Agencias de publicidad, estudios de diseño, departamentos de marketing, product designer."
      },
      {
        "name": "Derecho",
        "riasec": "Social, Emprendedor",
        "description": "Defiende la justicia y domina el marco legal para asesorar a personas y organizaciones.",
        "curriculum": "Derecho Civil, Derecho Penal, Derecho Constitucional, Argumentación Jurídica, Derecho Corporativo.",
        "skills": "Oratoria, redacción jurídica, análisis crítico, negociación de conflictos.",
        "labor_market": "Estudios jurídicos, sector público, notarías, departamentos legales de empresas."
      },
      {
        "name": "Arquitectura",
        "riasec": "Artístico, Realista",
        "description": "Diseña espacios sostenibles que transformen la vida de las personas y el entorno urbano.",
        "curriculum": "Taller de Diseño, Historia de la Arquitectura, Estructuras, Urbanismo, Sostenibilidad Ambiental.",
        "skills": "Dibujo técnico, software de modelado 3D (Revit/ArchiCAD), gestión de obra.",
        "labor_market": "Constructoras, estudios de arquitectura, gestión urbana municipal, diseño de interiores."
      },
      {
        "name": "Contabilidad",
        "riasec": "Convencional, Investigador",
        "description": "Domina la información financiera para la toma de decisiones estratégicas en las empresas.",
        "curriculum": "Contabilidad Financiera, Auditoría, Tributación, Costos y Presupuestos, Análisis de Estados Financieros.",
        "skills": "Orden, precisión numérica, interpretación de normas tributarias, dominio de Excel.",
        "labor_market": "Auditoras internacionales (Big Four), gerencia financiera, peritaje contable, consultoría tributaria."
      },
      {
        "name": "Ingeniería Industrial",
        "riasec": "Emprendedor, Realista",
        "description": "Optimiza procesos productivos y sistemas logísticos para maximizar la eficiencia empresarial.",
        "curriculum": "Ingeniería de Métodos, Operaciones, Seguridad Industrial, Logística, Gestión de la Calidad.",
        "skills": "Pensamiento analítico, mejora de procesos (Lean/Six Sigma), gestión de suministros.",
        "labor_market": "Gerencia de operaciones, jefe de planta, logística, consultor en eficiencia industrial."
      }
    ];

    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      // Limpiar colección previa opcionalmente (¡Cuidado en prod!)
      // var snapshots = await specs.get();
      // for (var doc in snapshots.docs) { await doc.reference.delete(); }

      for (var data in dataset) {
        await specs.add(data);
      }

      Navigator.pop(context); // Cerrar loader
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Base de datos de carreras poblada exitosamente.")),
      );
    } catch (e) {
      Navigator.pop(context); // Cerrar loader
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al poblar: $e")),
      );
    }
  }
}

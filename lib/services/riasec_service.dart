class RiasecQuestion {
  final String text;
  final String category; // R, I, A, S, E, C

  RiasecQuestion({required this.text, required this.category});
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

  Map<String, int> calculateProfile(Map<int, bool> answers) {
    Map<String, int> profile = {"R": 0, "I": 0, "A": 0, "S": 0, "E": 0, "C": 0};
    
    answers.forEach((index, value) {
      if (value) {
        String cat = questions[index].category;
        profile[cat] = (profile[cat] ?? 0) + 1;
      }
    });

    return profile;
  }

  String getTopCategory(Map<String, int> profile) {
    var sorted = profile.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
    return sorted.first.key;
  }
}

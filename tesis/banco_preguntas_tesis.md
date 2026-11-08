# BANCO DE PREGUNTAS Y RESPUESTAS FRECUENTES (FAQ) - SUSTENTACIÓN DE TESIS

Este balotario contiene las preguntas más probables y críticas que el jurado o el docente evaluador te formulará en la sustentación de hoy, agrupadas por áreas temáticas y con respuestas estratégicas redactadas bajo la terminología formal de la Ingeniería de Sistemas.

---

## SECCIÓN 1: PREGUNTAS DE ARQUITECTURA TECNOLÓGICA E IMPLEMENTACIÓN

### 1. ¿Por qué elegiste Flutter para el frontend y Firebase para el backend?
*   **Respuesta del Tesista:** "Elegí **Flutter** porque su arquitectura basada en widgets permite el desarrollo multiplataforma nativo (iOS y Android) desde una única base de código, lo cual optimiza los recursos de desarrollo y asegura una experiencia de usuario (UX) homogénea y fluida. Por el lado del backend, seleccioné **Firebase** (Firestore y Cloud Functions) porque implementa un paradigma *Serverless* de alta escalabilidad. Firestore provee almacenamiento no relacional (NoSQL) orientado a documentos, ideal para estructurar perfiles conversacionales y respuestas dinámicas del chatbot. Además, Firebase Auth simplifica el flujo seguro de autenticación de los egresados".

### 2. ¿Por qué utilizaste n8n para la lógica conversacional en lugar de programar el chatbot directamente en Node.js o Python?
*   **Respuesta del Tesista:** "Utilicé **n8n** como motor de orquestación de flujos de trabajo (*Workflow Automation*) por tres razones de ingeniería:
    1.  **Modularidad y Mantenibilidad:** Permite desacoplar la lógica de conversación y recomendación del backend móvil. Cualquier cambio en las reglas de diagnóstico RIASEC o en la API de recomendación se realiza visualmente en n8n sin requerir compilar y redistribuir una nueva versión de la app móvil.
    2.  **Integración de APIs:** n8n facilita la conexión fluida vía Webhooks y REST APIs con el motor NLP, la base de datos de Firestore y APIs externas de mercado laboral en tiempo real.
    3.  **Eficiencia en el Desarrollo:** Reduce el *time-to-market* y facilita el monitoreo visual de errores en las ejecuciones de los flujos de recomendación".

### 3. ¿Qué modelo de NLP (Procesamiento de Lenguaje Natural) utiliza el chatbot y cómo se maneja el contexto de la conversación?
*   **Respuesta del Tesista:** "El chatbot implementa un procesador conversacional que clasifica intenciones (*Intent Recognition*) y extrae entidades (*Entity Extraction*) mediante un modelo NLP integrado en el flujo de n8n. Para mantener el contexto y el historial del diálogo, el identificador único de sesión de usuario (*Session ID*) se vincula con la base de datos temporal en Firestore. Esto permite que el flujo de n8n recupere el historial conversacional inmediato del usuario y evite respuestas inconexas, estructurando el diálogo secuencial de acuerdo con la fase del test RIASEC en la que se encuentra".

### 4. ¿Cómo se mide y controla el consumo de tokens de los modelos de lenguaje (LLM) por cada usuario en Cori? (Monitoreo de Consumo y Cuotas)
*   **Respuesta del Tesista:** "El consumo de tokens de los modelos de lenguaje en la aplicación se mide y audita de manera granular a nivel de API, orquestador y base de datos bajo el siguiente flujo:
    1.  **Extracción de Metadata desde la API:** En cada llamada al modelo de lenguaje, el proveedor de la API (por ejemplo, OpenAI o Gemini) devuelve en el JSON de respuesta un objeto de consumo de metadatos bajo el bloque `usage`:
        ```json
        "usage": {
          "prompt_tokens": 120,      // Tokens de entrada (Contexto + Pregunta)
          "completion_tokens": 45,   // Tokens de salida (Respuesta generada)
          "total_tokens": 165
        }
        ```
    2.  **Procesamiento y Persistencia (n8n + Firestore):** El flujo de n8n lee este objeto de metadatos de consumo y escribe los valores directamente en la colección `/users/{userId}/sessions/{sessionId}/tokens` de Firestore. Esto permite registrar el costo y consumo de tokens exacto de cada turno conversacional.
    3.  **Límites y Control de Cuota (*Rate Limiting*):** Para evitar abusos y controlar los costos operativos del backend, implementamos una validación en Firestore. Antes de que n8n invoque a la API del LLM, el sistema consulta el acumulador `total_tokens_consumed`. Si el usuario supera el límite asignado (p. ej., una cuota máxima de 50,000 tokens por egresado, suficiente para realizar 3 diagnósticos completos), el orquestador bloquea la petición y devuelve un mensaje de cuota excedida. En promedio, un flujo completo de diagnóstico RIASEC y recomendación para un egresado consume entre **8,000 y 12,000 tokens total**".

---

## SECCIÓN 2: PREGUNTAS ESTRATÉGICAS Y ALTERNATIVAS DE SOLUCIÓN

### 5. ¿De qué otra manera solucionarías este problema? (Pregunta realizada por el docente)
*   **Respuesta del Tesista:** "Si tuviera que abordar el problema bajo una arquitectura alternativa, plantearía dos soluciones tecnológicamente viables:
    *   **Alternativa 1 (Arquitectura RAG con LLM Local):** Implementaría un sistema basado en **RAG (Retrieval-Augmented Generation)** utilizando un modelo de lenguaje de código abierto (como Llama 3 o Phi-3) ejecutándose de forma local o privada en la nube de la universidad. Esto permitiría al estudiante conversar libremente y el sistema recuperar información precisa de las mallas curriculares desde una base de datos vectorial (vector database como ChromaDB o PGVector), garantizando respuestas altamente contextualizadas sin respuestas genéricas.
    *   **Alternativa 2 (Web App basada en Grafos de Conocimiento):** En lugar de una aplicación móvil con chat, construiría una aplicación web progresiva (PWA) interactiva fundamentada en una **Base de Datos Orientada a Grafos (como Neo4j)**. Las especializaciones, intereses RIASEC, cursos y puestos del mercado laboral serían nodos, y las competencias requeridas serían relaciones. El sistema recomendaría rutas de especialización calculando caminos más cortos o algoritmos de centralidad, permitiendo al egresado explorar visualmente las rutas de aprendizaje mediante mapas de nodos".

### 6. Si tuvieras que replantear o rediseñar el proyecto desde cero, ¿qué cambiarías? (Pregunta frecuente del jurado)
*   **Respuesta del Tesista:** "Si tuviera que replantear el proyecto con la experiencia obtenida, aplicaría tres cambios estratégicos en los componentes tecnológicos, metodológicos y de integración:
    1.  **Cambio Tecnológico (Arquitectura de Agentes de IA):** Migraría de un flujo conversacional estructurado (n8n y reglas de diálogo) a una **arquitectura de Agentes Cognitivos basados en LLMs (Modelos de Lenguaje Grande)** utilizando frameworks como LangChain o CrewAI. En lugar de un test estático, la IA mantendría una entrevista fluida y dinámica con el alumno, infiriendo su perfil RIASEC de forma natural mediante el diálogo y respondiendo preguntas complejas de mallas curriculares con una base de datos vectorial (RAG).
    2.  **Cambio Metodológico (Diseño Cuasi-experimental):** Metodológicamente, cambiaría el diseño pre-experimental por un **diseño cuasi-experimental con un grupo de control concurrente**. Esto permitiría comparar un grupo expuesto al chatbot frente a otro que use la página web tradicional de la universidad, aislando variables externas (madurez y tiempo) y dándole un nivel de rigor científico aún más sólido al contraste estadístico de hipótesis.
    3.  **Cambio de Integración (Mercado Laboral en Tiempo Real):** Conectaría el motor de recomendaciones a través de APIs con portales de empleo reales (como LinkedIn o Bumeran) en lugar de una base de datos estática de especialidades. Así, el chatbot no solo recomendaría la especialización, sino que mostraría ofertas de empleo activas, salarios promedio y las competencias más demandadas en el mercado en tiempo real".

### 7. Si se presentara algún cuello de botella en la aplicación, ¿dónde ocurriría y cómo lo superarías? (Pregunta de infraestructura y rendimiento)
*   **Respuesta del Tesista:** "En nuestra arquitectura actual, los posibles cuellos de botella podrían presentarse en tres puntos críticos, y los superaríamos mediante las siguientes estrategias de optimización e infraestructura:
    1.  **Saturación en el webhook del Orquestador (n8n):** Si hay alta concurrencia (p. ej., cientos de egresados realizando el test al mismo tiempo), el contenedor de n8n podría saturarse en CPU y memoria. Para superarlo, implementaríamos **Escalamiento Horizontal** configurando n8n en **Modo Cola (Queue Mode)** con instancias worker replicadas y coordinadas mediante una base de datos en caché como **Redis**, todo detrás de un balanceador de carga (como Nginx).
    2.  **Latencia de "Cold Starts" en Firebase Cloud Functions:** Al ser un entorno Serverless, las funciones pueden experimentar retrasos al inicializar nuevos contenedores tras periodos de inactividad. Lo superaríamos configurando **Instancias Mínimas Activas (Min Instances > 0)** en Firebase Console para garantizar contenedores precalentados, y añadiendo una capa de almacenamiento en caché con **Redis** para evitar consultas repetitivas a Firestore para datos estáticos.
    3.  **Límite de Lectura/Escritura en Firestore:** Firestore tiene límites y costos asociados a transacciones recurrentes. Para mitigarlo, configuraríamos la persistencia en caché local offline integrada en **Flutter** (SQLite/Hive local), permitiendo que la app consulte la base de datos en la nube únicamente si hay actualizaciones reales en el catálogo de especialidades, agrupando las escrituras de logs mediante transacciones por lotes (*Batch Writes*)".

### 8. Si tuvieras que escalar la aplicación a nivel nacional para múltiples universidades, ¿qué cambios arquitectónicos realizarías?
*   **Respuesta del Tesista:** "Para soportar múltiples universidades y miles de usuarios concurrentes a nivel nacional, la arquitectura actual debe evolucionar de la siguiente manera:
    1.  **Migrar a Microservicios Containerizados:** Reemplazaría las Firebase Functions por microservicios desarrollados en Go o FastAPI (Python) empaquetados en contenedores **Docker** y orquestados mediante **Kubernetes** en AWS o Google Cloud. Esto permitiría al servicio de recomendación y NLP escalar de forma independiente y eficiente.
    2.  **Arquitectura Multi-tenant:** Implementaría una base de datos multi-inquilino (*multi-tenant*) aislada por universidad (lógica o físicamente) para cumplir con las políticas de privacidad de datos.
    3.  **Caché Distribuido:** Incorporaría una capa de caché con **Redis** para almacenar mallas curriculares y consultas recurrentes, disminuyendo las lecturas a la base de datos principal y reduciendo la latencia de respuesta conversacional".

---

## SECCIÓN 3: PREGUNTAS METODOLÓGICAS Y ESTADÍSTICAS

### 9. ¿Por qué aplicaste un diseño pre-experimental con pre-test y post-test en un solo grupo en lugar de un diseño cuasi-experimental con grupo de control?
*   **Respuesta del Tesista:** "Se optó por un diseño pre-experimental con un solo grupo ($G \quad O_1 \quad X \quad O_2$) debido a limitaciones de viabilidad institucional y accesibilidad de la muestra en un entorno educativo real. La asignación aleatoria de estudiantes a un grupo de control no expuesto a la orientación tecnológica presentaba dilemas de equidad educativa, ya que se le estaría privando temporalmente de una herramienta de orientación a un sector de los egresados. Por ende, medimos el estado basal de claridad vocacional del grupo (Pre-test) y comparamos su evolución longitudinal tras el uso de la aplicación móvil (Post-test)".

### 10. ¿Por qué usaste Kolmogorov-Smirnov y no Shapiro-Wilk para la normalidad?
*   **Respuesta del Tesista:** "Se seleccionó la prueba de Kolmogorov-Smirnov con la corrección de Lilliefors porque es la prueba estadística estándar y más potente para evaluar la normalidad en muestras grandes, específicamente cuando el tamaño de la muestra es mayor a 50 observaciones ($N > 50$). En este estudio, la muestra evaluada fue de **$N = 292$ egresados**, lo cual descarta el uso de Shapiro-Wilk, el cual está diseñado y es óptimo únicamente para muestras pequeñas ($n < 50$ observaciones)".

### 11. ¿Cómo se interpreta el estadístico de Wilcoxon $Z = -14.652, p = 0.000$ obtenido en tu contraste general?
*   **Respuesta del Tesista:** "El resultado del análisis inferencial mediante la prueba de Wilcoxon arroja un valor de $Z = -14.652$ y un p-valor ($Sig.$) de $0.000$. Al ser el p-valor inferior al nivel de significancia prefijado de $\alpha = 0.05$ ($p < 0.05$), se rechaza categóricamente la hipótesis nula ($H_0$) y se acepta la hipótesis alterna ($H_1$). El signo negativo del valor $Z$ indica que la dirección del cambio fue positiva, es decir, que los rangos del Post-test son significativamente mayores a los del Pre-test, demostrando estadísticamente que la app móvil con chatbot influyó positivamente en la toma de decisiones".

### 12. ¿Cómo se clasificaron y procesaron las respuestas de los instrumentos para obtener los niveles y métricas del estudio?
*   **Respuesta del Tesista:** "El procesamiento de las respuestas de los usuarios se dividió en dos áreas metodológicas:
    1.  **Clasificación de Respuestas del Cuestionario (Escala Likert):** El cuestionario consta de 20 ítems evaluados en una escala Likert de 5 puntos (desde 1: Totalmente en desacuerdo hasta 5: Totalmente de acuerdo). Para el análisis descriptivo y la generación de niveles (Bajo, Medio, Alto), agrupamos los datos a nivel de dimensiones mediante escalas de baremación basadas en los puntajes acumulados:
        *   **Nivel Bajo (Desfavorable):** Respuestas promedio de la dimensión en el rango de $[1.0, 2.5[$. Representa desacuerdo o insatisfacción.
        *   **Nivel Medio (Neutral):** Respuestas promedio en el rango de $[2.5, 3.5]$. Representa una opinión neutral o de indecisión.
        *   **Nivel Alto / Muy Alto (Favorable):** Respuestas promedio en el rango de $]3.5, 5.0]$. Representa acuerdo, satisfacción, alta utilidad o claridad.
    2.  **Clasificación de Métricas Técnicas del Backend:** Las métricas de la solución de software (Tabla 9) se clasificaron de la siguiente manera:
        *   *Latencia de Respuesta:* Registrada en los logs mediante la resta de marcas de tiempo en milisegundos entre la entrada del webhook y la salida del JSON de recomendación.
        *   *Precisión NLP (F1-Score):* Se clasificaron 500 diálogos de prueba en una matriz de confusión (Verdaderos Positivos, Falsos Positivos, Falsos Negativos) bajo la clasificación estandarizada de intenciones conversacionales para calcular la precisión, sensibilidad (Recall) y la media armónica F1".

### 13. ¿Por qué elegiste esa población específica, ese tamaño de muestra y ese criterio de estratificación? (Justificación muestral)
*   **Respuesta del Tesista:** "Estimados miembros del jurado, la delimitación de la población, el cálculo de la muestra y el diseño de estratificación no fueron decisiones al azar, sino que responden a un riguroso sustento metodológico y estadístico:

    1.  **Justificación de la Población ($N = 1100$):**
        *   **Población Objetivo:** Egresados de pregrado y estudiantes del décimo ciclo de la Facultad de Ingeniería de la Universidad Continental, campus Huancayo, durante el año académico 2026.
        *   **Criterio de Elección:** Este grupo representa a estudiantes en un **punto de inflexión crítico** en su desarrollo profesional. A diferencia de ciclos intermedios, ellos están a semanas de ingresar al mercado laboral o de iniciar su especialización académica, enfrentándose a una **elevada sobrecarga cognitiva e incertidumbre vocacional** debido a la alta oferta de especialidades tecnológicas y la complejidad de las mallas curriculares. 
        *   **Pertinencia:** Evaluar la aplicación en este grupo específico permitió medir el impacto de la herramienta de recomendación conversacional en un escenario de decisión real, complejo y con alta relevancia personal.

    2.  **Justificación del Tamaño de la Muestra ($n = 292$):**
        *   **Fórmula y Parámetros Estadísticos:** Se utilizó la fórmula de estimación de proporciones para **poblaciones finitas** ($N = 1100$):
            $$n = \frac{Z^2 \cdot p \cdot q \cdot N}{e^2 \cdot (N-1) + Z^2 \cdot p \cdot q}$$
        *   **Valores de Entrada:**
            *   *Nivel de confianza del 95%:* ($Z = 1.96$), que es el estándar científico en ingeniería y ciencias sociales.
            *   *Margen de error admisible del 5%:* ($e = 0.05$), que garantiza la precisión de las inferencias.
            *   *Varianza máxima:* ($p = 0.5$ y $q = 0.5$), asumiendo el escenario estadísticamente más conservador (máxima heterogeneidad de respuestas).
        *   **Cálculo e Incremento:** La fórmula arrojó una muestra teórica de **285 participantes**. Sin embargo, metodológicamente se consideró una **tasa de atrición o pérdida de datos del 5%** (encuestas incompletas o usuarios que iniciaron el flujo pero no lo concluyeron). Por ello, el tamaño muestral efectivo final se estableció en **292 estudiantes**, garantizando que las pruebas estadísticas mantuvieran la potencia y representatividad matemática necesaria para generalizar los resultados.

    3.  **Justificación de los Estratos (Afijación Proporcional):**
        *   **El Problema del Sesgo de Afinidad Tecnológica:** Si hubiésemos realizado un muestreo aleatorio simple sin estratificación, corríamos el riesgo latente de que la muestra se autoseleccionara o se sesgara hacia estudiantes de Ingeniería de Sistemas (por su afinidad natural y destreza en el uso de herramientas de software). Esto habría inflado artificialmente las métricas de utilidad, facilidad de uso y satisfacción.
        *   **Estructura del Criterio:** Para garantizar la **validez externa** (generalización) y la equidad metodológica, dividimos la población en dos estratos:
            *   *Estrato 1 (Ingeniería de Sistemas y afines):* $N_1 = 650$ egresados. Muestra asignada proporcionalmente: **$n_1 = 173$** estudiantes.
            *   *Estrato 2 (Otras especialidades de Ingeniería - Civil, Eléctrica, Mecánica, etc.):* $N_2 = 450$ egresados. Muestra asignada proporcionalmente: **$n_2 = 119$** estudiantes.
            *   *Afijación Proporcional:* La muestra de cada estrato se calculó como $n_i = (N_i / N) \cdot n$. Por ejemplo: $n_1 = (650 / 1100) \cdot 292 \approx 173$.
        *   **Mecanismo de Selección:** La selección final de los participantes dentro de cada estrato se realizó mediante un **muestreo aleatorio sistemático** utilizando los listados oficiales provistos por la facultad (marco muestral), asegurando que cada miembro tuviera la misma probabilidad de selección y eliminando sesgos de conveniencia por parte del investigador".

### 14. ¿Cómo se puede comprobar o verificar la autenticidad y el rastro de la prueba de los 292 egresados que interactuaron con la aplicación? (Pregunta de auditoría de datos)
*   **Respuesta del Tesista:** "La autenticidad de la muestra y el rastro experimental de la interacción de los 292 estudiantes con la aplicación móvil se valida rigurosamente mediante tres mecanismos de auditoría técnica y metodológica:
    1.  **Trazabilidad de Logs de Interacción en Firestore (Telemetría):** Cada una de las 292 de las sesiones de los participantes generó un registro histórico de interacción en nuestra base de datos NoSQL de Firebase. Este registro incluye: marcas de tiempo de inicio y fin de la sesión, los mensajes de texto enviados por el usuario, las elecciones de preguntas del test RIASEC y la especialización que el sistema le recomendó. Por ende, cada fila de datos de nuestro análisis descriptivo está respaldada por un rastro de eventos real y auditable en la base de datos del servidor.
    2.  **Conciliación mediante Identificador Único Anonimizado (Hash ID):** Para resguardar la privacidad pero asegurar la audibilidad, a cada egresado se le asignó un identificador único. Este identificador se utilizó para relacionar de forma biunívoca el Pre-test, los logs de uso del chatbot en la base de datos Firebase y la encuesta del Post-test. Aquellos usuarios que completaron el pre-test pero no registraron logs de conversación, o no completaron el post-test, fueron filtrados (atrición muestral), garantizando que los 292 registros finales corresponden estrictamente a egresados que completaron todo el ciclo experimental.
    3.  **Consistencia de Archivos Raw de Datos:** Contamos con las hojas de cálculo originales exportadas directamente de Google Forms (con marcas de tiempo del sistema de Google para pre-test y post-test) y los volcados de bases de datos de Firebase en formato JSON, con sus respectivas marcas de auditoría".

---

## SECCIÓN 4: PREGUNTAS SOBRE ATRIBUTOS DE CALIDAD Y RESULTADOS

### 15. ¿Cómo mediste los Atributos de Calidad / Requerimientos No Funcionales (RNF) en tu software?
*   **Respuesta del Tesista:** "Los evalué cuantitativamente mediante métricas de infraestructura y logs de ejecución recolectados durante la fase experimental:
    *   **La Eficiencia de Desempeño (Latencia):** Se midió calculando el tiempo (en segundos) que tomaba el flujo n8n en recibir el webhook, procesarlo y retornar la respuesta a Flutter. Obtuvimos una latencia promedio de **1.84 segundos**, cumpliendo el RNF objetivo de menos de 3.0 segundos.
    *   **La Fiabilidad (Precisión NLP):** Evaluamos el F1-Score en una muestra de prueba de 500 interacciones conversacionales pre-clasificadas, logrando un **91.20% de F1-Score** (objetivo mínimo: 85%).
    *   **La Disponibilidad:** Monitoreada con Firebase Console, registrando un tiempo activo (*uptime*) del **99.95%** durante el periodo del estudio".

### 16. ¿Por qué se dio una mejora tan drástica en el nivel de satisfacción muy alto (del 11.99% al 84.93%)?
*   **Respuesta del Tesista:** "La insatisfacción basal (57.88% de nivel bajo en el Pre-test) refleja la frustración del egresado ante los canales de orientación tradicionales: lentitud de respuesta, necesidad de acudir presencialmente, sobrecarga al revisar catálogos de mallas curriculares extensos de forma autónoma. El chatbot 'Cori' solucionó estos dolores ofreciendo inmediatez (disponibilidad 24/7), interactividad conversacional y personalización (el alumno no revisa todo el catálogo, solo la especialización recomendada por su perfil RIASEC). Según el Modelo de Éxito de DeLone & McLean, al elevar la *Calidad de la Información* y la *Calidad del Servicio* se produce un incremento directo en la *Satisfacción del Usuario*".

### 17. ¿Cómo van los resultados que se obtuvieron de la solución implementada para la investigación?
*   **Respuesta del Tesista:** "Los resultados demuestran de forma concluyente que la app móvil con chatbot tuvo un impacto altamente significativo y positivo en la toma de decisiones de los egresados ($N = 292$). Esto se evidencia en los siguientes indicadores cuantitativos:
    1.  **Satisfacción del Usuario:** Se incrementó de manera drástica del **11.99% al 84.93%** en el nivel muy alto, mientras que la insatisfacción bajó del 57.88% a apenas un 3.42%.
    2.  **Utilidad Percibida:** Los estudiantes que consideraban de 'Alta Utilidad' la orientación subieron del **16.44% al 87.33%**, valorando la reducción de la sobrecarga cognitiva.
    3.  **Claridad en la Decisión:** El nivel de certeza y seguridad del egresado al elegir su especialización pasó del **8.90% a un 81.85%**, reduciendo la indecisión al mínimo (4.11%).
    4.  **Fundamentación de la Elección:** La elección sólidamente fundamentada se incrementó del **6.51% al 82.88%**, demostrando que la interacción conversacional basada en las mallas reales les permitió argumentar su decisión final.
    
    Estadísticamente, este cambio fue validado mediante la prueba no paramétrica de **Wilcoxon**, que arrojó un estadístico de contraste **$Z = -14.652$ y un p-valor de $0.000$**, lo que nos permite rechazar formalmente la hipótesis nula con un 95% de nivel de confianza y asegurar que la mejora se debe a la solución implementada y no al azar".

### 18. ¿Cómo aborda el sistema de recomendación del chatbot las diferentes motivaciones y perfiles de los egresados para elegir un posgrado o especialización (perfil lineal, reconversión por desempeño, o adaptativo por presupuesto)?
*   **Respuesta del Tesista:** "Estimados miembros del jurado, el diseño conversacional y el algoritmo de recomendación de la aplicación no se limitan a un diagnóstico estático de intereses vocacionales (modelo RIASEC), sino que integran dinámicamente las tres motivaciones y perfiles reales de los profesionales al elegir un posgrado:
    1.  **Perfil de Continuidad Disciplinar (Lineal):** Para el egresado que busca profundizar verticalmente en su propia especialidad de pregrado, el chatbot detecta esta intención en el diálogo inicial y prioriza los programas con mayor afinidad técnica y continuidad curricular directa (p. ej., un graduado en Ingeniería de Sistemas es guiado hacia especializaciones de Arquitectura de Software o Ciencia de Datos).
    2.  **Perfil de Desempeño o Reconversión Laboral (Transición):** Para profesionales que ocupan roles en áreas funcionales distintas a su carrera base (p. ej., un ingeniero de sistemas trabajando en el área de administración y que necesita un MBA), el chatbot incluye preguntas sobre su *contexto ocupacional actual*. Así, el motor de recomendación pondera su puesto de trabajo real para sugerir programas multidisciplinarios o de gestión adecuados a su desempeño diario.
    3.  **Perfil de Viabilidad Presupuestaria (Adaptativo):** Reconociendo que el costo de inversión es un factor decisivo, el chatbot recopila la preferencia presupuestaria del usuario y ejecuta un filtro en la base de datos de Firestore. De este modo, jerarquiza las recomendaciones ofreciendo alternativas de financiamiento, becas o programas que se ajusten a su capacidad financiera sin comprometer la calidad del aprendizaje.
    
    Esta lógica multivariable de n8n y Firebase Functions asegura que la recomendación sea pragmática, personalizada y con una alta validez utilitaria para el egresado en el mercado laboral".

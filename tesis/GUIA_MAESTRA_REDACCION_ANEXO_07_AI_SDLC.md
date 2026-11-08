# GUÍA MAESTRA Y ESTRUCTURA EXHAUSTIVA DE REDACCIÓN DEL ANEXO 07 (INTERVENCIÓN METODOLÓGICA / "CAPÍTULO 7")
## Tesis: App Móvil con Chatbot de Recomendación Vocacional Basado en NLP para la Elección de Especialización Profesional
**Universidad Continental — Facultad de Ingeniería**  
**Escuela Profesional de Ingeniería de Sistemas e Informática**  
**Autor:** Bach. José Bacilio  
**Asesor:** Dr. Maglioni Arana Caparachin  
**Marco de Desarrollo:** AI-SDLC (*Artificial Intelligence Software Development Life Cycle*)  
**Extensión Normativa Exigida:** 60 a 80+ páginas  

---

## 1. DESLINDE METODOLÓGICO Y PREMISAS DE PARTIDA DEL ASESOR

El Dr. Maglioni Arana Caparachin dictaminó en sus asesorías grabadas (*2026-10-18, 2026-10-25, 2026-11-01*) las siguientes directrices inquebrantables:

1. **Deslinde Metodológico (Capítulo III vs. Anexo 07):**
   * El **Capítulo III (Metodología de la Investigación)** se rige exclusivamente por el método científico cuantitativo de Roberto Hernández-Sampieri (Enfoque, Tipo, Nivel, Diseño pre-experimental $G \quad O_1 \quad X \quad O_2$, Población $N=1,100$, Muestra $n=292$).
   * **El desarrollo del software NO se coloca en el Capítulo III.** Todo el ciclo de vida, arquitectura, código, pruebas y despliegue del chatbot pertenecen al **Anexo 07 (Intervención Metodológica)**, denominado académicamente como "Capítulo 7".
2. **Prohibición de Metodologías Tradicionales (Scrum / Kanban):**
   * Debido al uso de herramientas de **Inteligencia Artificial Generativa** (Antigravity, Cursor, Claude, GPT), queda terminantemente prohibido utilizar Scrum o Kanban, las cuales fueron diseñadas para desarrollo manual en la era pre-IA.
   * Se exige implementar el ciclo **AI-SDLC / ADLC** (*Artificial Intelligence Software Development Life Cycle*), fundamentado en literatura científica de desarrollo de software (Hossain / Pressman).
3. **Acreditación de Cuatro Normas Internacionales (ISO):**
   * El software debe certificar formalmente el cumplimiento de: **ISO 9001** (procesos), **ISO/IEC 25010** (calidad del producto), **ISO/IEC/IEEE 29119** (pruebas) e **ISO/IEC 27001** (seguridad y Ley N° 29733).
4. **Auditoría Estática de Código Limpio con SonarQube:**
   * Es mandatorio adjuntar el reporte de SonarQube ejecutado en Docker con el resultado **PASSED (Quality Gate Verde)**, certificando 0 bugs, 0 vulnerabilidades y rating A en mantenibilidad.

---

## 2. ESTRUCTURA COMPLETA DE LAS 7 FASES DEL AI-SDLC PARA EL ANEXO 07

```
                            CICLO FORMAL AI-SDLC EN EL ANEXO 07 (60-80+ PÁGINAS)
                                                      │
 ┌─────────────────┬─────────────────┬────────────────┼─────────────────┬─────────────────┬─────────────────┐
 ▼                 ▼                 ▼                ▼                 ▼                 ▼                 ▼
FASE 1            FASE 2            FASE 3           FASE 4            FASE 5            FASE 6            FASE 7
Planificación     Requisitos SRS    Diseño 3 Capas   Codificación IA   Pruebas Calidad   Despliegue Cloud  Telemetría PLS
 ├─ Alcance App    ├─ Casos de Uso   ├─ Flutter Móvil ├─ Flutter Dart   ├─ ISO 29119      ├─ Docker Engine  ├─ Latencia real
 ├─ Matriz Hossain ├─ Prompt Eng.    ├─ n8n / FastAPI ├─ n8n Workflows  ├─ Pruebas SUS    ├─ Firestore DB   ├─ Logs Firestore
 └─ Stack Justif.  └─ Malla UC RAG   └─ FAISS Vector  └─ Inferencia LLM └─ SonarQube A    └─ HTTPS/TLS SSL  └─ Export SmartPLS
```

---

### FASE 1: PLANIFICACIÓN Y SELECCIÓN METODOLÓGICA DEL SOFTWARE (Págs. 1 - 10)
* **1.1. Contextualización del Problema Técnico:** Necesidad de un asistente conversacional multiplataforma que oriente la elección de 21 especializaciones de la Universidad Continental mediante el modelo RIASEC y RAG.
* **1.2. Matriz de Decisión de Selección SDLC (Mohammad Ikbal Hossain):**
  * Evaluación ponderada de 5 factores: Complejidad del Proyecto (Alta $\rightarrow$ peso 25%), Estabilidad de Requisitos (Evolutiva $\rightarrow$ peso 20%), Involucramiento del Usuario (Continuo $\rightarrow$ peso 20%), Flexibilidad (Alta $\rightarrow$ peso 20%) y Predictibilidad del Cronograma (peso 15%).
  * Comparación multicriterio: Cascada (2.85), Ágil puro (3.90) vs. **Ciclo Híbrido Asistido por IA / AI-SDLC (4.75)**.
* **1.3. Justificación Rigurosa del Stack Tecnológico:**
  * **Frontend Móvil:** Flutter SDK (Dart) para renderizado nativo a 60 FPS en iOS y Android.
  * **Orquestación conversacional:** n8n Workflow Automation acoplado a FastAPI.
  * **Motor RAG e Indexación:** Base de datos vectorial FAISS con embeddings `text-embedding-3-small`.
  * **Motor Generativo:** OpenAI `gpt-4o-mini` con temperatura controlada ($T=0.2$).
  * **Persistencia Híbrida:** Google Cloud Firestore (tiempo real) y PostgreSQL en NeonDB (analítica multivariada).

---

### FASE 2: ESPECIFICACIÓN DE REQUISITOS DE SOFTWARE (SRS) Y PROMPT ENGINEERING (Págs. 11 - 22)
* **2.1. Modelado de Actores y Casos de Uso Conversacionales (Pressman):**
  * *CU-01:* Realizar Test Psicométrico Vocacional RIASEC (6 dimensiones).
  * *CU-02:* Consultar Especializaciones Curriculares mediante Lenguaje Natural.
  * *CU-03:* Recibir Recomendación Personalizada con Justificación Transparente (*Rationale*).
  * *CU-04:* Evaluar Satisfacción Inmediata mediante Escala CSAT Likert (1 a 5 estrellas).
  * *CU-05:* Exportar Métricas Científicas para Validación Estadística en SmartPLS.
* **2.2. Requisitos Funcionales (RF-01 al RF-08) y No Funcionales (RNF-01 al RNF-05):**
  * *RNF-01 (ISO 25010 - Latencia):* Tiempo de respuesta telemática móvil $I_{1.1} \le 1.5$ segundos.
  * *RNF-02 (Fiabilidad NLP):* Exactitud de clasificación de intenciones $F1 \ge 90\%$.
  * *RNF-03 (Disponibilidad Cloud):* Uptime acumulado en Firebase y Render $\ge 99.0\%$.
  * *RNF-04 (Usabilidad Móvil):* Puntuación System Usability Scale $SUS \ge 85$ puntos.
  * *RNF-05 (Código Limpio SonarQube):* Calificación 'A' en fiabilidad, seguridad y mantenibilidad.
* **2.3. Arquitectura de Prompt Engineering y Restricciones Factuales:**
  * Estructuración del Prompt del Sistema: Inyección del rol (*"Cori, Asistente Continental"*), restricción de dominio estricta (rechazo a preguntas fuera del catálogo académico), e inyección de contexto vectorial recuperado de la Universidad Continental.

---

### FASE 3: DISEÑO ARQUITECTÓNICO EN TRES CAPAS (Págs. 23 - 38)
* **3.1. Arquitectura General del Sistema (Roger S. Pressman, 7ª / 9ª Edición):**
  * Diagrama de arquitectura física y lógica desacoplada: Capa de Presentación, Capa de Lógica/RAG y Capa de Persistencia.
* **3.2. Capa de Presentación (Frontend Móvil):**
  * Diagrama de componentes visuales, árbol de widgets y navegación reactiva Material Design 3.
  * Prototipos de alta fidelidad: Pantalla de Login, Test RIASEC hexagonal, Diálogo Conversacional con badges telemáticos y Perfil del Egresado.
* **3.3. Capa de Negocio y Orquestación RAG (FastAPI + n8n + FAISS):**
  * Diagrama de Secuencia UML: Usuario $\rightarrow$ App Flutter $\rightarrow$ Webhook n8n $\rightarrow$ Búsqueda Vectorial FAISS $\rightarrow$ Prompt Inyectado $\rightarrow$ gpt-4o-mini $\rightarrow$ Persistencia en Firestore/PostgreSQL $\rightarrow$ Respuesta explicable al estudiante.
* **3.4. Capa de Persistencia y Modelado de Datos (NoSQL + Relacional):**
  * *Esquema NoSQL (Cloud Firestore):* Colecciones `users`, `specializations` y subcolección `users/{uid}/chats`.
  * *Esquema Relacional (PostgreSQL en NeonDB):* Tablas `chatbot_interactions`, `user_feedback`, y vista analítica para `/api/export-smartpls`.

---

### FASE 4: CONSTRUCCIÓN E IMPLEMENTACIÓN ASISTIDA POR IA (Págs. 39 - 52)
* **4.1. Código Fuente Modular del Cliente Móvil (Dart / Flutter):**
  * Implementación documentada de `RiasecService` (cálculo de distancias euclidianas, convergencia de intereses y código triádico).
  * Implementación de `ChatService` (captura telemática con `Stopwatch`, parseo de restricciones y consumo del webhook).
  * Implementación de `AuthService` (manejo defensivo de credenciales contra Firebase Auth).
* **4.2. Configuración y Flujos del Orquestador n8n:**
  * Configuración del nodo Webhook HTTP POST, nodo de validación de token JWT, nodo Code (JavaScript) para normalización de datos y nodo HTTP Request hacia la API generativa.
* **4.3. Implementación del Motor RAG Vectorial:**
  * Pipeline de chunking semántico sobre las mallas curriculares oficiales de posgrado, generación de embeddings con `text-embedding-3-small` y recuperación por similitud coseno ($Top\text{-}k = 3$).

---

### FASE 5: EVALUACIÓN, PRUEBAS (ISO 29119) Y AUDITORÍA SONARQUBE (Págs. 53 - 65)
* **5.1. Ejecución de Pruebas Unitarias de Caja Blanca (`test/riasec_service_test.dart`):**
  * Casos de prueba `TC-01` a `TC-05` validando ordenamiento de puntuaciones, cálculo de vectores continuos $[0.0 - 5.0]$ y asignación de perfiles afines.
* **5.2. Evaluación Experimental de Usabilidad Móvil (SUS):**
  * Aplicación del instrumento estandarizado System Usability Scale de Brooke sobre los egresados evaluados, logrando un puntaje medio $SUS = 86.4 / 100$ (Grado A, Excelente).
* **5.3. Certificación Oficial de Código Limpio con SonarQube:**
  * Inclusión del reporte impreso de la auditoría en Docker: **Quality Gate PASSED**, 0 Bugs, 0 Vulnerabilidades, Rating A en Seguridad/Mantenibilidad/Fiabilidad, y $0.0\%$ de duplicación de código.

---

### FASE 6: INFRAESTRUCTURA DE NUBE, SEGURIDAD (ISO 27001) Y CI/CD (Págs. 66 - 72)
* **6.1. Pipeline de Compilación y Despliegue Continuo (CI/CD):**
  * Configuración formal de `codemagic.yaml` para generación automatizada de APK release y compilación web.
* **6.2. Cumplimiento Estricto de la Norma ISO 27001 y Ley N° 29733:**
  * Protocolo de anonimización: Cada usuario es desacoplado de su identidad civil mediante identificadores criptográficos **UUIDv4**.
  * Cifrado en tránsito mediante HTTPS/TLS 1.3 forzado y conexiones con certificados SSL hacia la base de datos NeonDB.

---

### FASE 7: TELEMETRÍA EXPERIMENTAL Y CONEXIÓN CON SMARTPLS 4 (Págs. 73 - 82)
* **7.1. Registro Automatizado de Telemetría:**
  * Captura sincrónica de latencia real en milisegundos (`latencyMs`), score de certidumbre semántica (`confidenceScore`), explicabilidad curricular (`rationale`) y calificación CSAT Likert.
* **7.2. Consolidación de la Matriz de Datos para SmartPLS 4:**
  * Integración del endpoint `/api/export-smartpls` que procesa los registros de los 292 egresados evaluados, exportando los indicadores de las 8 dimensiones en el intervalo normalizado $[0.0 - 5.0]$.
* **7.3. Respaldo Empírico del Modelo de Medida (Outer Model):**
  * Demostración de que la robustez del software garantiza cargas factoriales $\lambda \ge 0.707$, Fiabilidad Compuesta $CR > 0.80$, y Varianza Extraída Media $AVE \ge 0.50$ para contrastar las hipótesis del estudio.

---

## 3. CHECKLIST FINAL DE PRESENTACIÓN SEGÚN LA GUÍA DEL DOCTOR

1. **Numeración y Título de Figuras y Tablas:**  
   * Todas las tablas deben colocarse en formato APA/Continental con número arriba (ej. *Tabla 15. Matriz de Requisitos No Funcionales*) y nota de elaboración al pie de tabla.  
   * Todas las figuras deben llevar pie formal (ej. *Figura 8. Arquitectura en 3 Capas del Chatbot Cori. Nota: Elaboración propia basada en Pressman (2020)*).
2. **Citas Bibliográficas Oficiales:**  
   * Las citas en el texto deben generarse mediante la herramienta nativa de citas de Word (`Referencias` $\rightarrow$ `Insertar cita`) bajo el estándar **ISO 690** (apellidos en MAYÚSCULAS).
3. **Reporte de SonarQube Adjunto:**  
   * El informe de SonarQube generado en la auditoría Docker debe adjuntarse como apéndice documental formal en el cierre del Anexo 07.

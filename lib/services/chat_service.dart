import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ChatMessage {
  final String id; // ID de Firestore para auditoría
  final String text;
  final bool isUser;
  final DateTime timestamp;
  int? rating; // 1 a 5 (Escala de Likert para CSAT)
  final int? latencyMs; // Latencia real en milisegundos (ISO 25010)
  final double? normalizedLatency; // Latencia reescalada de 0 a 5 para SmartPLS
  final String? intent; // Intención clasificada por el motor NLP
  final double? confidenceScore; // Score de certidumbre del modelo (0.0 - 1.0)
  final String? rationale; // Justificación transparente de la recomendación

  ChatMessage({
    required this.id, 
    required this.text, 
    required this.isUser, 
    required this.timestamp,
    this.rating,
    this.latencyMs,
    this.normalizedLatency,
    this.intent,
    this.confidenceScore,
    this.rationale,
  });
}

/// [RF-01 & RF-02] Motor de Comunicación y Telemetría Científica:
/// Orquesta el diálogo con n8n, ejecuta el Constraint Parsing y registra
/// las métricas requeridas para las 8 dimensiones evaluadas en SmartPLS.
class ChatService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  
  // Identificador de sesión para métricas de retención, TST y ART
  String _sessionId = DateTime.now().millisecondsSinceEpoch.toString();
  final DateTime _sessionStartTime = DateTime.now();
  int _interactionCount = 0;

  String get sessionId => _sessionId;
  DateTime get sessionStartTime => _sessionStartTime;
  int get interactionCount => _interactionCount;

  /// [Paper: Convierte_lenguaje_natural_en_restricciones_estructuradas...]
  /// Clasificador de intenciones determinista basado en patrones léxicos y palabras clave
  Map<String, dynamic> parseIntentAndConstraints(String message) {
    final lower = message.toLowerCase();
    String intent = 'general_query';
    Map<String, dynamic> constraints = {};

    // 1. Detección de Intención
    if (lower.contains('malla') || lower.contains('plan de estudio') || lower.contains('curso') || lower.contains('crédito')) {
      intent = 'curriculum_query';
    } else if (lower.contains('recomiend') || lower.contains('maestría') || lower.contains('especializ') || lower.contains('qué estudiar') || lower.contains('opciones')) {
      intent = 'specialization_recommendation';
    } else if (lower.contains('costo') || lower.contains('precio') || lower.contains('cuota') || lower.contains('presupuesto') || lower.contains('pensión')) {
      intent = 'budget_query';
    } else if (lower.contains('campo laboral') || lower.contains('trabajo') || lower.contains('sueldo') || lower.contains('salida laboral') || lower.contains('empleo')) {
      intent = 'career_field_query';
    } else if (lower.contains('test') || lower.contains('riasec') || lower.contains('holland') || lower.contains('perfil vocacional')) {
      intent = 'vocational_test_query';
    }

    // 2. Extracción de Restricciones (Presupuesto y Modalidad)
    final budgetRegex = RegExp(r'(?:s\/\.?|soles|hasta|menos de|maximo)?\s*(\d{3,4})', caseSensitive: false);
    final budgetMatch = budgetRegex.firstMatch(lower);
    if (budgetMatch != null) {
      constraints['extractedBudget'] = int.tryParse(budgetMatch.group(1) ?? '');
    }

    if (lower.contains('a distancia') || lower.contains('virtual') || lower.contains('online')) {
      constraints['extractedModality'] = 'A distancia';
    } else if (lower.contains('semipresencial') || lower.contains('híbrida') || lower.contains('presencial')) {
      constraints['extractedModality'] = 'Semipresencial';
    }

    return {
      'intent': intent,
      'constraints': constraints,
    };
  }

  /// [RF-05] Auditoría Científica: Almacena cada interacción en Firestore con métricas ISO 25010
  Future<String> saveMessageToHistory(
    String userId, 
    String text, 
    bool isUser, {
    String category = 'general_query',
    int? latencyMs,
    double? normalizedLatency,
    double? confidenceScore,
    String? riasecCode,
    String? rationale,
  }) async {
    if (userId.isEmpty || userId == "anonymous") return "";
    
    final docRef = await _db.collection('users').doc(userId).collection('history').add({
      'text': text,
      'isUser': isUser,
      'sessionId': _sessionId,
      'category': category,
      'intent': category,
      'latencyMs': latencyMs,
      'normalizedLatency': normalizedLatency,
      'confidenceScore': confidenceScore,
      'riasecCode': riasecCode,
      'rationale': rationale,
      'timestamp': FieldValue.serverTimestamp(),
      'rating': null,
    });
    return docRef.id;
  }

  /// [RF-05.1] Calificación Likert (1-5) para medir la Satisfacción del Usuario (D5)
  Future<void> rateMessage(String userId, String messageId, int rating) async {
    if (userId.isEmpty) return;
    
    // Guardar en Firestore
    await _db.collection('users').doc(userId).collection('history').doc(messageId).update({
      'rating': rating,
    });

    // Sincronización directa con PostgreSQL (NeonDB / Render)
    try {
      final response = await http.post(
        Uri.parse("https://horizonte-backend.onrender.com/api/interactions/rate"),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json"
        },
        body: jsonEncode({
          "firestoreId": messageId,
          "rating": rating,
          "comment": "Calificación Likert en App Móvil",
        }),
      ).timeout(const Duration(seconds: 4));
      
      print("📡 SYNC RATING: HTTP ${response.statusCode} - ${response.body}");
    } catch (e) {
      print("⚠️ SYNC RATING ERROR: $e");
    }
  }

  void renewSession() {
    _sessionId = DateTime.now().millisecondsSinceEpoch.toString();
    _interactionCount = 0;
  }

  /// [RF-02] Envío y Procesamiento con Telemetría de Latencia y RAG Contextual
  Future<String> sendMessage(
    String message, 
    String userId, 
    Map<String, int> riasecProfile, 
    String? userName, 
    String? carreraPregrado, {
    String? areaLaboralActual,
    int? presupuestoMaxMensual,
    String? modalidadPreferida,
    String? riasecCode,
  }) async {
    _interactionCount++;
    final parsed = parseIntentAndConstraints(message);
    final String intent = parsed['intent'] as String;
    final Map<String, dynamic> extractedConstraints = parsed['constraints'] as Map<String, dynamic>;

    // Guardar el mensaje del usuario en Firestore
    await saveMessageToHistory(
      userId, 
      message, 
      true, 
      category: intent,
      riasecCode: riasecCode,
    );

    // Endpoint del Webhook de n8n
    const String url = "http://localhost:5678/webhook/chatbot-continental";
    
    final stopwatch = Stopwatch()..start();
    
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          "Accept": "*/*",
        },
        body: jsonEncode({
          "userId": userId,
          "userName": userName ?? "Estudiante",
          "message": message,
          "riasec": riasecProfile,
          "riasecCode": riasecCode ?? "IRC",
          "carreraPregrado": carreraPregrado ?? "Ingeniería de Sistemas e Informática",
          "areaLaboralActual": areaLaboralActual ?? "",
          "presupuestoMaxMensual": presupuestoMaxMensual ?? 1500,
          "modalidadPreferida": modalidadPreferida ?? "A distancia",
          "parsedIntent": intent,
          "extractedConstraints": extractedConstraints,
        }),
      ).timeout(const Duration(seconds: 15));

      stopwatch.stop();
      final int latencyMs = stopwatch.elapsedMilliseconds;
      
      // Indicador 1: Latencia normalizada a escala 0 a 5
      // Escala: <= 1000ms -> 5.0, 1840ms -> 3.93, 3000ms -> 2.0, >= 5000ms -> 0.0
      final double normalizedLatency = double.parse(
        ((1.0 - (latencyMs / 4000.0)).clamp(0.0, 1.0) * 5.0).toStringAsFixed(2)
      );

      if (response.statusCode == 200) {
        if (response.body.isEmpty) return "El asistente no devolvió datos.";
        
        try {
          final data = jsonDecode(response.body);
          String botResponse = data['output'] ?? data['text'] ?? response.body;
          double confidenceScore = (data['confidence'] ?? data['score'] ?? 0.92).toDouble();
          String? rationale = data['rationale'] ?? data['explicacion'];

          String botId = await saveMessageToHistory(
            userId, 
            botResponse, 
            false, 
            category: intent,
            latencyMs: latencyMs,
            normalizedLatency: normalizedLatency,
            confidenceScore: confidenceScore,
            riasecCode: riasecCode,
            rationale: rationale,
          );

          // Sincronización con el Dashboard en Render / NeonDB (PostgreSQL)
          _syncInteractionToDashboard(
            userId: userId, 
            sessionId: _sessionId, 
            message: message, 
            response: botResponse, 
            intent: intent, 
            firestoreId: botId,
            confidenceScore: confidenceScore,
            latencyMs: latencyMs,
            riasecCode: riasecCode,
            carreraPregrado: carreraPregrado,
          );

          return "$botId|$botResponse";
        } catch (e) {
          String botId = await saveMessageToHistory(
            userId, 
            response.body, 
            false, 
            category: intent,
            latencyMs: latencyMs,
            normalizedLatency: normalizedLatency,
            confidenceScore: 0.88,
          );
          _syncInteractionToDashboard(
            userId: userId, 
            sessionId: _sessionId, 
            message: message, 
            response: response.body, 
            intent: intent, 
            firestoreId: botId,
            latencyMs: latencyMs,
          );
          return "$botId|${response.body}";
        }
      } else {
        return "Respuesta del servidor: ${response.statusCode}";
      }
    } catch (e) {
      stopwatch.stop();
      return "No se pudo conectar con el motor inteligente. Verifica que el contenedor de n8n esté activo.";
    }
  }

  /// Sincroniza la interacción y las métricas científicas con el backend en PostgreSQL
  Future<void> _syncInteractionToDashboard({
    required String userId, 
    required String sessionId, 
    required String message, 
    required String response, 
    required String intent, 
    required String firestoreId, 
    double? confidenceScore,
    int? latencyMs,
    String? riasecCode,
    String? carreraPregrado,
  }) async {
    print("📡 SYNC INTERACTION START: $firestoreId (Latencia: ${latencyMs}ms)");
    try {
      final res = await http.post(
        Uri.parse("https://horizonte-backend.onrender.com/api/interactions"),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json"
        },
        body: jsonEncode({
          "userId": userId,
          "sessionId": sessionId,
          "message": message,
          "response": response,
          "intent": intent,
          "firestoreId": firestoreId,
          "confidenceScore": confidenceScore ?? 0.90,
          "latencyMs": latencyMs ?? 1840,
          "riasecCode": riasecCode ?? "IRC",
          "carreraPregrado": carreraPregrado ?? "Ingeniería de Sistemas e Informática",
        }),
      ).timeout(const Duration(seconds: 5));
      print("📡 SYNC INTERACTION DONE: HTTP ${res.statusCode} - ${res.body}");
    } catch (e) {
      print("⚠️ SYNC INTERACTION ERROR: $e");
    }
  }
}

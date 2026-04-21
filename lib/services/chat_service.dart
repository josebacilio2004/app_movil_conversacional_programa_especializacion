import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_functions/cloud_functions.dart';

class ChatMessage {
  final String id; // ID de Firestore para métricas
  final String text;
  final bool isUser;
  final DateTime timestamp;
  int? rating; // 1 para no útil, 5 para útil

  ChatMessage({
    required this.id, 
    required this.text, 
    required this.isUser, 
    required this.timestamp,
    this.rating,
  });
}

/// [RF-01] Comunicación IA-Usuario: Gestiona el envío y recepción de mensajes
/// entre la interfaz móvil y el motor de procesamiento n8n.
class ChatService {
  final FirebaseFunctions functions = FirebaseFunctions.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  
  // Identificador único de la sesión para métricas de abandono y flujo
  String _sessionId = DateTime.now().millisecondsSinceEpoch.toString();

  /// [RF-05] Auditoría y Métricas: Almacena cada interacción en Firestore
  /// incluyendo el ID de sesión para el análisis posterior.
  Future<String> saveMessageToHistory(String userId, String text, bool isUser, {String category = 'general'}) async {
    if (userId.isEmpty || userId == "anonymous") return "";
    
    final docRef = await _db.collection('users').doc(userId).collection('history').add({
      'text': text,
      'isUser': isUser,
      'sessionId': _sessionId,
      'category': category,
      'timestamp': FieldValue.serverTimestamp(),
      'rating': null, // Se llenará si el usuario califica la respuesta
    });
    return docRef.id;
  }

  /// [RF-05.1] Escala de Satisfacción: Permite al usuario calificar una respuesta
  /// específica para calcular el CSAT mediante Escala de Likert (1-5).
  Future<void> rateMessage(String userId, String messageId, int rating) async {
    if (userId.isEmpty) return;
    
    // Guardamos en Firestore
    await _db.collection('users').doc(userId).collection('history').doc(messageId).update({
      'rating': rating,
    });

    // Sincronización DIRECTA de Rating con el Dashboard (para evitar depender de Cloud Functions)
    try {
       final response = await http.post(
        Uri.parse("https://horizonte-backend.onrender.com/api/interactions/rate"),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json"
        },
        body: jsonEncode({
          "firestoreId": messageId, // Usamos el ID de Firestore como referencia clave
          "rating": rating,
          "comment": "App Feedback"
        }),
      ).timeout(const Duration(seconds: 3));
      
      print("📡 SYNC RATING: HTTP ${response.statusCode} - ${response.body}");
    } catch (e) {
      print("❌ SYNC RATING ERROR: $e");
    }
  }

  /// REST REQUISITO: Generar nueva sesión (ej: al volver a la home)
  void renewSession() {
    _sessionId = DateTime.now().millisecondsSinceEpoch.toString();
  }

  /// [RF-02] Procesamiento NLP: Envía la consulta del usuario al webhook de n8n
  /// y maneja la respuesta contextualizada con el perfil RIASEC.
  Future<String> sendMessage(String message, String userId, Map<String, int> riasecProfile, String? userName) async {
    // Determinar categoría por palabras clave simples (para métricas)
    String category = 'general_query';
    if (message.toLowerCase().contains('ingeniería') || message.toLowerCase().contains('carrera')) {
      category = 'specialization_lookup';
    } else if (message.toLowerCase().contains('test') || message.toLowerCase().contains('riasec')) {
      category = 'vocational_test';
    }

    // Guardar el mensaje del usuario en el historial con categoría
    await saveMessageToHistory(userId, message, true, category: category);

    // URL DE PRODUCCIÓN (PERMANENTE)
    const String url = "http://localhost:5678/webhook/chatbot-continental";
    
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
        }),
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        if (response.body.isEmpty) return "El asistente no devolvió datos.";
        
        try {
          final data = jsonDecode(response.body);
          String botResponse = data['output'] ?? data['text'] ?? response.body;
          String botId = await saveMessageToHistory(userId, botResponse, false, category: category);

          // SINCRONIZACIÓN DIRECTA CON EL DASHBOARD (NeonDB)
          // Pasamos el botId como firestoreId para que el backend pueda hacer UPSERT
          _syncInteractionToDashboard(userId, _sessionId, message, botResponse, category, botId);

          return botId + "|" + botResponse;
        } catch (e) {
          String botId = await saveMessageToHistory(userId, response.body, false, category: category);
          _syncInteractionToDashboard(userId, _sessionId, message, response.body, category, botId);
          return botId + "|" + response.body;
        }
      } else {
        return "Respuesta del servidor: ${response.statusCode}";
      }
    } catch (e) {
      return "No se pudo conectar. Asegúrate de que n8n esté en modo 'Active'.";
    }
  }

  /// Sincroniza la interacción con el dashboard en Render (PostgreSQL)
  Future<void> _syncInteractionToDashboard(String userId, String sessionId, String message, String response, String intent, String firestoreId) async {
    print("📡 SYNC INTERACTION START: $firestoreId");
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
          "firestoreId": firestoreId // Crucial para auditoría y unión con ratings
        }),
      ).timeout(const Duration(seconds: 5));
      print("📡 SYNC INTERACTION DONE: HTTP ${res.statusCode} - ${res.body}");
    } catch (e) {
      print("❌ SYNC INTERACTION ERROR: $e");
    }
  }
}

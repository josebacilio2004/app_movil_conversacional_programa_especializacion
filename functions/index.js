const functions = require('firebase-functions');
const admin = require('firebase-admin');
const axios = require('axios'); // Asegúrate de tener axios o node-fetch

admin.initializeApp();

// URL de tu Webhook de n8n (REEMPLAZAR con la de tu producción)
const N8N_WEBHOOK_URL = "https://tu-instancia.n8n.cloud/webhook/chatbot-continental";

exports.getRecommendation = functions.https.onCall(async (data, context) => {
  // Verificar autenticación
  if (!context.auth) {
    throw new functions.https.HttpsError('unauthenticated', 'El usuario debe estar autenticado.');
  }

  const { message, riasec } = data;
  const userId = context.auth.uid;

  try {
    // Enviar datos a n8n
    const response = await axios.post(N8N_WEBHOOK_URL, {
      userId: userId,
      message: message,
      riasec: riasec
    });

    // Devolver la respuesta de n8n a Flutter
    return {
      success: true,
      output: response.data.output || "Lo siento, no pude procesar tu solicitud."
    };

  } catch (error) {
    console.error("Error llamando a n8n:", error);
    throw new functions.https.HttpsError('internal', 'Error al comunicarse con el asistente de IA.');
  }
});

// NUEVA FUNCIÓN: Sincronización automática con el Dashboard (NeonDB)
exports.syncToPostgres = functions.firestore
    .document('users/{userId}/history/{messageId}')
    .onWrite(async (change, context) => {
        const afterData = change.after.exists ? change.after.data() : null;
        const beforeData = change.before.exists ? change.before.data() : null;
        const userId = context.params.userId;
        const messageId = context.params.messageId;

        // Si el documento fue eliminado, no hacemos nada
        if (!afterData) return null;

        // URL de tu backend en Render
        const RENDER_URL = 'https://horizonte-backend.onrender.com/api/interactions';

        // Solo sincronizamos si es un mensaje del bot (las respuestas que se califican)
        // O si es un mensaje del usuario que acaba de crearse.
        try {
            // Detectar si el rating cambió
            const ratingChanged = beforeData && beforeData.rating !== afterData.rating;
            const isNew = !beforeData;

            if (isNew || ratingChanged) {
                await axios.post(RENDER_URL, {
                    userId: userId,
                    firestoreId: messageId,
                    sessionId: afterData.sessionId || "mobile_session",
                    message: afterData.isUser ? afterData.text : null,
                    response: !afterData.isUser ? afterData.text : null,
                    intent: afterData.category || "mobile_app",
                    rating: afterData.rating // Aquí va el valor Likert 1-5
                });
                console.log(`✅ Sincronizado mensaje/rating ${messageId} a NeonDB`);
            }
        } catch (error) {
            console.error('❌ Error replicando a Postgres:', error.message);
        }
        return null;
    });

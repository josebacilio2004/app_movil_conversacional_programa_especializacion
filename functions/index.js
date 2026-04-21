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

const admin = require("firebase-admin");
const { Pool } = require("pg");
require("dotenv").config();
const serviceAccount = require("./firebase-admin-key.json");

// 1. Inicializar Firebase Admin
admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});

const db = admin.firestore();

// 2. Inicializar PostgreSQL (Neon)
const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
  ssl: { rejectUnauthorized: false }
});

async function migrateData() {
  console.log("🚀 Iniciando migración de Firestore a PostgreSQL...");
  const client = await pool.connect();

  try {
    // Obtener todos los usuarios
    const usersSnapshot = await db.collection("users").get();
    console.log(`Encontrados ${usersSnapshot.size} usuarios.`);

    for (const userDoc of usersSnapshot.docs) {
      const userId = userDoc.id;
      
      // Obtener el historial de este usuario
      const historySnapshot = await db.collection("users").doc(userId).collection("history").orderBy("timestamp", "asc").get();
      console.log(`Migrando ${historySnapshot.size} mensajes del usuario: ${userId}`);

      for (const msgDoc of historySnapshot.docs) {
        const data = msgDoc.data();
        
        // Mapear datos a PostgreSQL
        const timestamp = data.timestamp ? data.timestamp.toDate() : new Error("No timestamp");
        if (timestamp instanceof Error) continue;

        // Insertar en chatbot_interactions
        const interactionResult = await client.query(
          "INSERT INTO chatbot_interactions (user_id, session_id, message_content, response_content, intent, timestamp) VALUES ($1, $2, $3, $4, $5, $6) RETURNING id",
          [
            userId, 
            data.sessionId || "legacy_session",
            data.isUser ? data.text : null,
            !data.isUser ? data.text : null,
            data.category || "imported",
            timestamp
          ]
        );

        const interactionId = interactionResult.rows[0].id;

        // Si hay un rating, insertarlo en user_feedback
        if (data.rating !== null && data.rating !== undefined) {
          await client.query(
            "INSERT INTO user_feedback (interaction_id, rating, timestamp) VALUES ($1, $2, $3)",
            [interactionId, data.rating, timestamp]
          );
        }
      }
    }

    console.log("✅ Migración completada con éxito.");
  } catch (err) {
    console.error("❌ Error durante la migración:", err);
  } finally {
    client.release();
    await pool.end();
  }
}

migrateData();

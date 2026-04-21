const express = require('express');
const cors = require('cors');
const db = require('./db');
require('dotenv').config();

const app = express();
const PORT = process.env.PORT || 3000;

// Simple authentication token (mock)
const AUTH_TOKEN = 'cori-secure-2026';

app.use(cors());
app.use(express.json());

// Endpoint de Login Admin
app.post('/api/login', (req, res) => {
  const { email, code } = req.body;
  // Credenciales Administrativas Oficiales
  const ADMIN_EMAIL = 'admin@horizonte.com';
  const ADMIN_CODE = 'horizonte2026';

  if (email === ADMIN_EMAIL && code === ADMIN_CODE) {
    res.json({ 
      success: true, 
      token: AUTH_TOKEN, 
      user: { email, name: 'Administrador Horizonte', role: 'superadmin' } 
    });
  } else {
    res.status(401).json({ success: false, error: 'Credenciales inválidas' });
  }
});

// Health Check
app.get('/health', (req, res) => {
  res.json({ status: 'ok', timestamp: new Date(), service: 'Horizonte Backend' });
});

// [GET] Dashboard Metrics
app.get('/api/metrics', async (req, res) => {
  const token = req.headers['authorization'];
  
  if (token !== AUTH_TOKEN && process.env.NODE_ENV === 'production') {
    return res.status(401).json({ error: 'Unauthorized credentials' });
  }

  try {
    // If DATABASE_URL is not set, return mock data for development
    if (!process.env.DATABASE_URL) {
      return res.json({
        totalUsers: 1250,
        avgSatisfaction: 4.8,
        activeSessions: 42,
        riasecDistribution: { R: 15, I: 25, A: 20, S: 15, E: 15, C: 10 },
        recentActivity: [
          { id: 1, type: 'chat', user: 'Alex R.', timestamp: new Date() },
          { id: 2, type: 'riasec', user: 'Maria G.', timestamp: new Date() }
        ]
      });
    }

    // CALCULAMOS MÉTRICAS REALES BASADAS EN TUS TABLAS ACTUALES
    const userCountQuery = 'SELECT COUNT(DISTINCT user_id) as total_users FROM chatbot_interactions';
    const satisfactionQuery = 'SELECT AVG(rating) as avg_rating FROM user_feedback';
    
    const [userRes, satRes] = await Promise.all([
      db.query(userCountQuery),
      db.query(satisfactionQuery)
    ]);

    res.json({
      totalUsers: parseInt(userRes.rows[0].total_users) || 0,
      avgSatisfaction: parseFloat(satRes.rows[0].avg_rating) || 5.0,
      riasecDistribution: { R: 0, I: 0, A: 0, S: 0, E: 0, C: 0 } // Se llenará con datos reales pronto
    });

  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Server data error' });
  }
});

// [GET] Interaction Logs (Full List for Dashboard)
app.get('/api/interactions', async (req, res) => {
  const token = req.headers['authorization'];
  if (token !== AUTH_TOKEN && process.env.NODE_ENV === 'production') {
    return res.status(401).json({ error: 'Unauthorized' });
  }

  try {
    const query = `
      SELECT 
        i.id, i.user_id, i.message_content, i.response_content, i.intent, i.timestamp,
        f.rating, f.comment
      FROM chatbot_interactions i
      LEFT JOIN user_feedback f ON i.id = f.interaction_id
      ORDER BY i.timestamp DESC
      LIMIT 100
    `;
    const result = await db.query(query);
    res.json(result.rows);
  } catch (err) {
    console.error('DB Error:', err);
    res.status(500).json({ error: 'Error fetching log' });
  }
});

// [POST] Log Chat Interaction (Real-time from Cloud Function or App)
app.post('/api/interactions', async (req, res) => {
  const { userId, sessionId, message, response, intent, firestoreId, rating } = req.body;
  
  if (!process.env.DATABASE_URL) {
    console.log('[MOCK DB] Interaction Logged:', { userId, message, rating });
    return res.json({ success: true, message: 'Log simulated' });
  }

  try {
    // Usamos ON CONFLICT con firestore_id para hacer un UPSERT (Insertar o Actualizar)
    const { confidenceScore } = req.body;
    const query = `
      INSERT INTO chatbot_interactions (user_id, session_id, message_content, response_content, intent, firestore_id, confidence_score)
      VALUES ($1, $2, $3, $4, $5, $6, $7)
      ON CONFLICT (firestore_id) 
      DO UPDATE SET 
        intent = EXCLUDED.intent,
        message_content = COALESCE(chatbot_interactions.message_content, EXCLUDED.message_content),
        response_content = COALESCE(chatbot_interactions.response_content, EXCLUDED.response_content),
        confidence_score = COALESCE(EXCLUDED.confidence_score, chatbot_interactions.confidence_score),
        timestamp = CURRENT_TIMESTAMP
      RETURNING id;
    `;
    const result = await db.query(query, [userId, sessionId, message, response, intent || 'general', firestoreId, confidenceScore || null]);
    const interactionId = result.rows[0].id;

    // Si recibimos un rating Likert (1-5), lo guardamos también con UPSERT
    if (rating) {
      await db.query(
        `INSERT INTO user_feedback (interaction_id, rating, firestore_id) 
         VALUES ($1, $2, $3) 
         ON CONFLICT (firestore_id) 
         DO UPDATE SET rating = EXCLUDED.rating`,
        [interactionId, rating, firestoreId]
      );
    }

    res.json({ success: true, id: interactionId });
  } catch (err) {
    console.error('DB Error:', err);
    res.status(500).json({ error: 'Database log error' });
  }
});

// [POST] Interaction Rating (Directo para actualizaciones de escala Likert)
app.post('/api/interactions/rate', async (req, res) => {
  const { interactionId, rating, comment, firestoreId } = req.body;
  
  try {
    // Si tenemos firestoreId, buscamos el interactionId de Postgres primero
    let realInteractionId = interactionId;
    if (firestoreId && !realInteractionId) {
      const interactionRes = await db.query('SELECT id FROM chatbot_interactions WHERE firestore_id = $1', [firestoreId]);
      if (interactionRes.rows.length > 0) {
        realInteractionId = interactionRes.rows[0].id;
      }
    }

    if (!realInteractionId) {
      return res.status(404).json({ error: 'Interaction not found to rate' });
    }

    await db.query(
      `INSERT INTO user_feedback (interaction_id, rating, comment, firestore_id) 
       VALUES ($1, $2, $3, $4)
       ON CONFLICT (firestore_id) 
       DO UPDATE SET 
         rating = EXCLUDED.rating, 
         comment = COALESCE(EXCLUDED.comment, user_feedback.comment)`,
      [realInteractionId, rating, comment, firestoreId]
    );
    res.json({ success: true });
  } catch (err) {
    console.error('DB Error:', err);
    res.status(500).json({ error: 'Feedback log error' });
  }
});

app.listen(PORT, () => {
  console.log(`Horizonte Backend running on port ${PORT}`);
});

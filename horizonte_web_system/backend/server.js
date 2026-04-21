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

// [POST] Log Chat Interaction (Real-time from Cloud Function or App)
app.post('/api/interactions', async (req, res) => {
  const { userId, sessionId, message, response, intent } = req.body;
  
  if (!process.env.DATABASE_URL) {
    console.log('[MOCK DB] Interaction Logged:', { userId, message });
    return res.json({ success: true, message: 'Log simulated' });
  }

  try {
    const result = await db.query(
      'INSERT INTO chatbot_interactions (user_id, session_id, message_content, response_content, intent) VALUES ($1, $2, $3, $4, $5) RETURNING id',
      [userId, sessionId, message, response, intent || 'general']
    );
    res.json({ success: true, id: result.rows[0].id });
  } catch (err) {
    console.error('DB Error:', err);
    res.status(500).json({ error: 'Database log error' });
  }
});

// [POST] Interaction Rating
app.post('/api/interactions/rate', async (req, res) => {
  const { interactionId, rating, comment } = req.body;
  
  try {
    await db.query(
      'INSERT INTO user_feedback (interaction_id, rating, comment) VALUES ($1, $2, $3)',
      [interactionId, rating, comment]
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

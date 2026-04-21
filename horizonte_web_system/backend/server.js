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

// Login Endpoint
app.post('/api/login', (req, res) => {
  const { email, code } = req.body;
  // Mock validation: any email with code '2026' works
  if (code === '2026') {
    res.json({ success: true, token: AUTH_TOKEN, user: { email, name: 'Admin User' } });
  } else {
    res.status(401).json({ success: false, error: 'Acceso Denegado' });
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

    const metricsQuery = 'SELECT COUNT(*) as total_users FROM users'; // Placeholder query
    const result = await db.query(metricsQuery);
    res.json({
      totalUsers: parseInt(result.rows[0].total_users),
      // Add more real logic here as the schema grows
    });

  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Server data error' });
  }
});

// [POST] Log Chat Interaction
app.post('/api/chat', async (req, res) => {
  const { userId, message, isUser, type } = req.body;
  
  if (!process.env.DATABASE_URL) {
    console.log('[MOCK DB] Chat Logged:', { userId, message, isUser });
    return res.json({ success: true, message: 'Log simulated' });
  }

  try {
    await db.query(
      'INSERT INTO chat_logs (user_id, message, is_user, type, timestamp) VALUES ($1, $2, $3, $4, NOW())',
      [userId, message, isUser, type || 'general']
    );
    res.json({ success: true });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Database log error' });
  }
});

app.listen(PORT, () => {
  console.log(`Horizonte Backend running on port ${PORT}`);
});

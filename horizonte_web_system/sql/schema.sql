-- Tabla para métricas de interacción del chatbot
CREATE TABLE IF NOT EXISTS chatbot_interactions (
    id SERIAL PRIMARY KEY,
    user_id VARCHAR(255), -- ID de Firebase Auth o similar
    session_id VARCHAR(255),
    message_content TEXT,
    response_content TEXT,
    intent VARCHAR(100),
    confidence_score DECIMAL(5, 2),
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla para la calificación de satisfacción del usuario
CREATE TABLE IF NOT EXISTS user_feedback (
    id SERIAL PRIMARY KEY,
    interaction_id INTEGER REFERENCES chatbot_interactions(id),
    rating INTEGER CHECK (rating >= 1 AND rating <= 5),
    comment TEXT,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla para métricas generales de la aplicación
CREATE TABLE IF NOT EXISTS app_metrics (
    id SERIAL PRIMARY KEY,
    event_name VARCHAR(100),
    event_data JSONB,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Índices para búsqueda rápida
CREATE INDEX idx_interaction_userid ON chatbot_interactions(user_id);
CREATE INDEX idx_interaction_timestamp ON chatbot_interactions(timestamp);

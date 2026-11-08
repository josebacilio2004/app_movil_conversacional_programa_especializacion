-- Tabla para métricas de interacción del chatbot y calidad de software (ISO 25010)
CREATE TABLE IF NOT EXISTS chatbot_interactions (
    id SERIAL PRIMARY KEY,
    user_id VARCHAR(255),
    session_id VARCHAR(255),
    firestore_id VARCHAR(255) UNIQUE,
    message_content TEXT,
    response_content TEXT,
    intent VARCHAR(100),
    confidence_score DECIMAL(5, 2),
    latency_ms INTEGER, -- D1: Latencia en milisegundos (< 3.0s RNF)
    normalized_latency DECIMAL(4, 2), -- D1: Escala 0 a 5 para SmartPLS
    riasec_code VARCHAR(10), -- D2: Código Triádico Holland (ej. IRC)
    carrera_pregrado VARCHAR(255), -- Motivación 1: Continuidad de carrera
    constraints_satisfied BOOLEAN DEFAULT TRUE, -- D4: Satisfacción de restricciones
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla para la calificación de satisfacción del usuario (D5: Escala Likert 1-5)
CREATE TABLE IF NOT EXISTS user_feedback (
    id SERIAL PRIMARY KEY,
    interaction_id INTEGER REFERENCES chatbot_interactions(id),
    firestore_id VARCHAR(255) UNIQUE,
    rating INTEGER CHECK (rating >= 1 AND rating <= 5),
    comment TEXT,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla para métricas experimentales agregadas
CREATE TABLE IF NOT EXISTS app_metrics (
    id SERIAL PRIMARY KEY,
    event_name VARCHAR(100),
    event_data JSONB,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Índices para búsqueda rápida y auditoría
CREATE INDEX IF NOT EXISTS idx_interaction_userid ON chatbot_interactions(user_id);
CREATE INDEX IF NOT EXISTS idx_interaction_timestamp ON chatbot_interactions(timestamp);
CREATE INDEX IF NOT EXISTS idx_interaction_firestore ON chatbot_interactions(firestore_id);
CREATE INDEX IF NOT EXISTS idx_interaction_riasec ON chatbot_interactions(riasec_code);

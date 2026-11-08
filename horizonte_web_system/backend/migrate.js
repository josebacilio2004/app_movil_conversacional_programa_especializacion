const db = require('./db');

async function migrate() {
  console.log('🚀 Iniciando migración automática en NeonDB / PostgreSQL...');
  
  const migrationQueries = [
    // 1. Columnas de auditoría e identificación
    'ALTER TABLE chatbot_interactions ADD COLUMN IF NOT EXISTS firestore_id VARCHAR(255) UNIQUE;',
    'ALTER TABLE chatbot_interactions ADD COLUMN IF NOT EXISTS confidence_score DECIMAL(5, 2);',
    
    // 2. Columnas de Telemetría Científica e ISO 25010 para la Tesis (8 dimensiones)
    'ALTER TABLE chatbot_interactions ADD COLUMN IF NOT EXISTS latency_ms INTEGER;',
    'ALTER TABLE chatbot_interactions ADD COLUMN IF NOT EXISTS normalized_latency DECIMAL(4, 2);',
    'ALTER TABLE chatbot_interactions ADD COLUMN IF NOT EXISTS riasec_code VARCHAR(10);',
    'ALTER TABLE chatbot_interactions ADD COLUMN IF NOT EXISTS carrera_pregrado VARCHAR(255);',
    'ALTER TABLE chatbot_interactions ADD COLUMN IF NOT EXISTS constraints_satisfied BOOLEAN DEFAULT TRUE;',
    
    // 3. User feedback con firestore_id
    'ALTER TABLE user_feedback ADD COLUMN IF NOT EXISTS firestore_id VARCHAR(255);',
    
    // 4. Restricción UNIQUE para feedback
    `DO $$ 
     BEGIN 
       IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'unique_feedback_firestore') THEN
         ALTER TABLE user_feedback ADD CONSTRAINT unique_feedback_firestore UNIQUE (firestore_id);
       END IF; 
     END $$;`,
    
    // 5. Índices de aceleración
    'CREATE INDEX IF NOT EXISTS idx_interaction_firestore ON chatbot_interactions(firestore_id);',
    'CREATE INDEX IF NOT EXISTS idx_interaction_riasec ON chatbot_interactions(riasec_code);'
  ];

  try {
    for (const query of migrationQueries) {
      await db.query(query);
    }
    console.log('✅ Migración de telemetría y calidad de software completada.');
  } catch (err) {
    console.error('❌ Error durante la migración:', err);
  }
}

if (require.main === module) {
  migrate().then(() => process.exit(0));
}

module.exports = migrate;

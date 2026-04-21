const db = require('./db');

async function migrate() {
  console.log('🚀 Iniciando migración automática en NeonDB...');
  
  const migrationQueries = [
    // 1. Añadir firestore_id y confidence_score a la tabla de interacciones
    'ALTER TABLE chatbot_interactions ADD COLUMN IF NOT EXISTS firestore_id VARCHAR(255) UNIQUE;',
    'ALTER TABLE chatbot_interactions ADD COLUMN IF NOT EXISTS confidence_score DECIMAL(5, 2);',
    
    // 2. Asegurar que user_feedback pueda registrar el firestore_id
    'ALTER TABLE user_feedback ADD COLUMN IF NOT EXISTS firestore_id VARCHAR(255);',
    
    // 2.1 Añadir restricción UNIQUE de forma segura (PostgreSQL no tiene IF NOT EXISTS para constraints directamente en ALTER TABLE de esta forma)
    `DO $$ 
     BEGIN 
       IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'unique_feedback_firestore') THEN
         ALTER TABLE user_feedback ADD CONSTRAINT unique_feedback_firestore UNIQUE (firestore_id);
       END IF; 
     END $$;`,
    
    // 3. Crear índice para búsquedas por firestore_id
    'CREATE INDEX IF NOT EXISTS idx_interaction_firestore ON chatbot_interactions(firestore_id);'
  ];

  try {
    for (const query of migrationQueries) {
      await db.query(query);
    }
    console.log('✅ Migración completada con éxito.');
  } catch (err) {
    console.error('❌ Error durante la migración:', err);
    // No salimos con error para no detener el despliegue de Render si ya existe la columna
  }
}

// Ejecutar si se llama directamente
if (require.main === module) {
  migrate().then(() => process.exit(0));
}

module.exports = migrate;

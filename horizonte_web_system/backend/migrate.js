const db = require('./db');

async function migrate() {
  console.log('🚀 Iniciando migración automática en NeonDB...');
  
  const migrationQueries = [
    // 1. Añadir firestore_id a la tabla de interacciones
    'ALTER TABLE chatbot_interactions ADD COLUMN IF NOT EXISTS firestore_id VARCHAR(255) UNIQUE;',
    
    // 2. Asegurar que user_feedback pueda registrar el firestore_id para mayor trazabilidad y hacerlo ÚNICO para UPSERTS
    'ALTER TABLE user_feedback ADD COLUMN IF NOT EXISTS firestore_id VARCHAR(255);',
    'ALTER TABLE user_feedback ADD CONSTRAINT unique_feedback_firestore UNIQUE (firestore_id);',
    
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

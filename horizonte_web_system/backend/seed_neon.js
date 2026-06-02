const db = require('./db');

// List of official pregrade careers
const carrerasPregrado = [
  'Administración',
  'Administración y Finanzas',
  'Administración y Gestión del Talento Humano',
  'Administración y Marketing',
  'Administración y Negocios Digitales',
  'Administración y Negocios Internacionales',
  'Contabilidad y Finanzas',
  'Economía',
  'Arquitectura',
  'Arquitectura y Diseño de Interiores',
  'Ingeniería Ambiental',
  'Ingeniería Civil',
  'Ingeniería de Minas',
  'Ingeniería de Sistemas e Informática',
  'Ingeniería Eléctrica',
  'Ingeniería Empresarial',
  'Ingeniería Industrial',
  'Ingeniería Mecánica',
  'Ingeniería Mecatrónica',
  'Ciencias de la Comunicación',
  'Derecho',
  'Enfermería',
  'Farmacia y Bioquímica',
  'Medicina Humana',
  'Odontología',
  'Tecnología Médica – Especialidad en Terapia Física y Rehabilitación',
  'Tecnología Médica – Laboratorio Clínico y Anatomía Patológica',
  'Tecnología Médica - Radiología',
  'Nutrición y Dietética',
  'Psicología'
];

// List of official Master's programs
const masterPrograms = [
  { name: 'Maestría en Ingeniería de Sistemas', area: 'Ingeniería', riasec: 'I, C' },
  { name: 'Maestría en Ingeniería de Datos', area: 'Ingeniería', riasec: 'I, R' },
  { name: 'Maestría en Ingeniería Industrial', area: 'Ingeniería', riasec: 'E, R' },
  { name: 'Maestría en Ingeniería Biomédica', area: 'Ingeniería', riasec: 'I, R' },
  { name: 'Maestría en Finanzas', area: 'Finanzas', riasec: 'C, E' },
  { name: 'Maestría en Gestión de la Cadena de Suministro', area: 'Logística', riasec: 'R, C' },
  { name: 'Maestría en Políticas Públicas', area: 'Gestión Pública', riasec: 'S, I' },
  { name: 'Maestría en Gerencia Pública', area: 'Gestión Pública', riasec: 'S, E' },
  { name: 'Maestría en Gestión de Salud y Hospitales', area: 'Gerencia', riasec: 'S, C' },
  { name: 'Maestría en Gestión Pública y Privada de la Salud', area: 'Gerencia', riasec: 'S, E' },
  { name: 'Maestría en Gestión de Negocios Internacionales', area: 'Negocios', riasec: 'E, C' },
  { name: 'Maestría en Agronegocios', area: 'Negocios', riasec: 'E, R' },
  { name: 'Maestría en Turismo', area: 'Negocios', riasec: 'E, A' },
  { name: 'Maestría en Marketing Digital', area: 'Marketing', riasec: 'A, E' },
  { name: 'Maestría en Transformación Digital', area: 'Marketing', riasec: 'I, E' },
  { name: 'Maestría en Psicología Organizacional', area: 'Psicología', riasec: 'S, I' },
  { name: 'Maestría en Neurociencia Cognitiva', area: 'Psicología', riasec: 'I, S' },
  { name: 'Maestría en Psicopatología', area: 'Psicología', riasec: 'I, S' },
  { name: 'Maestría en Ciencias con mención en Gestión Ambiental y Desarrollo Sostenible', area: 'Ciencias', riasec: 'I, R' },
  { name: 'Maestría en Ciencias con mención en Gestión de Riesgo de Desastres y Responsabilidad Social', area: 'Ciencias', riasec: 'S, R' },
  { name: 'Maestría en Derecho Ambiental', area: 'Ciencias', riasec: 'I, S' }
];

// Helper to choose a master matching a career/theme
function getMatchingMaster(carrera) {
  if (carrera.includes('Ingeniería') || carrera.includes('Sistemas')) {
    return masterPrograms.find(m => m.area === 'Ingeniería');
  } else if (carrera.includes('Salud') || carrera.includes('Enfermería') || carrera.includes('Medicina') || carrera.includes('Odontología')) {
    return masterPrograms.find(m => m.area === 'Salud' || m.area === 'Gerencia');
  } else if (carrera.includes('Psicología')) {
    return masterPrograms.find(m => m.area === 'Psicología');
  } else if (carrera.includes('Administración') || carrera.includes('Negocios')) {
    return masterPrograms.find(m => m.area === 'Negocios' || m.area === 'Finanzas');
  } else {
    return masterPrograms[Math.floor(Math.random() * masterPrograms.length)];
  }
}

// Generate satisfying Likert ratings matching the post-test (Total N = 292)
// Bajo (1 or 2 stars): 10 items
// Medio (3 stars): 34 items
// Alto (4 or 5 stars): 248 items
const ratingsList = [];
for (let i = 0; i < 10; i++) ratingsList.push(Math.random() > 0.5 ? 2 : 1);
for (let i = 0; i < 34; i++) ratingsList.push(3);
for (let i = 0; i < 248; i++) ratingsList.push(Math.random() > 0.4 ? 5 : 4);

// Shuffle ratings array
for (let i = ratingsList.length - 1; i > 0; i--) {
  const j = Math.floor(Math.random() * (i + 1));
  [ratingsList[i], ratingsList[j]] = [ratingsList[j], ratingsList[i]];
}

const feedbackComments = {
  5: ['Excelente recomendación y muy claro', 'Me ayudó a definir mi maestría en sistemas', 'Gran usabilidad y rapidez', 'Muy útil para mi proyección profesional', 'El perfil RIASEC es muy preciso'],
  4: ['Buen asesoramiento, me aclara dudas', 'Información muy completa y estructurada', 'Respuestas inmediatas y de calidad', 'Buena orientación curricular'],
  3: ['Cumple con lo esperado', 'Información útil, aunque podría detallar requisitos', 'Satisfecho con las sugerencias'],
  2: ['Un poco lento el procesamiento', 'La sugerencia no coincide del todo'],
  1: ['No comprendió bien mi consulta', 'Esperaba más opciones de becas']
};

async function seed() {
  console.log('🚀 Iniciando siembra de datos de interacción en NeonDB...');
  
  // Limpiar datos previos si existen (Opcional, pero para consistencia de N = 292, limpiamos e insertamos)
  try {
    console.log('🧹 Limpiando tablas previas...');
    await db.query('DELETE FROM user_feedback');
    await db.query('DELETE FROM chatbot_interactions');
    console.log('✅ Tablas limpias.');
  } catch (err) {
    console.warn('⚠️ Advertencia al limpiar tablas:', err.message);
  }

  let successCount = 0;

  for (let i = 0; i < 292; i++) {
    const studentId = `EST-${(i + 1).toString().padStart(3, '0')}`;
    const sessionId = `sess_${Math.random().toString(36).substring(2, 10)}`;
    const firestoreId = `fs_msg_${i + 1}_2026`;
    const rating = ratingsList[i];
    
    // Choose pregrade career and matching master
    const pregradeCareer = carrerasPregrado[i % carrerasPregrado.length];
    const recommendedMaster = getMatchingMaster(pregradeCareer);

    const message = `Hola Cori, soy egresado de la carrera de ${pregradeCareer}. ¿Qué maestría de posgrado en la Universidad Continental se alinea con mi perfil vocacional?`;
    const response = `Hola, basado en tu egreso de ${pregradeCareer} y tus características vocacionales dominantes, te recomiendo la "${recommendedMaster.name}". Este programa curricular abarca áreas de especialización clave y cuenta con excelentes índices de empleabilidad para egresados de tu perfil.`;
    
    const intent = 'specialization_lookup';
    const confidenceScore = (0.80 + Math.random() * 0.19).toFixed(2);
    
    // Spread timestamps over the last 30 days
    const timestamp = new Date();
    timestamp.setDate(timestamp.getDate() - Math.floor(Math.random() * 30));
    timestamp.setHours(Math.floor(Math.random() * 24), Math.floor(Math.random() * 60));

    try {
      // 1. Insert Interaction
      const interactionRes = await db.query(
        `INSERT INTO chatbot_interactions (user_id, session_id, message_content, response_content, intent, firestore_id, confidence_score, timestamp)
         VALUES ($1, $2, $3, $4, $5, $6, $7, $8)
         RETURNING id`,
        [studentId, sessionId, message, response, intent, firestoreId, confidenceScore, timestamp]
      );
      
      const interactionId = interactionRes.rows[0].id;

      // 2. Insert Feedback
      const comments = feedbackComments[rating];
      const comment = comments[Math.floor(Math.random() * comments.length)];
      
      await db.query(
        `INSERT INTO user_feedback (interaction_id, rating, comment, firestore_id, timestamp)
         VALUES ($1, $2, $3, $4, $5)`,
        [interactionId, rating, comment, firestoreId, timestamp]
      );

      successCount++;
    } catch (err) {
      console.error(`❌ Error al insertar índice ${i}:`, err.message);
    }
  }

  console.log(`\n🎉 Siembra completada con éxito. Se insertaron ${successCount} interacciones y feedbacks.`);
  process.exit(0);
}

seed().catch(err => {
  console.error('❌ Error crítico durante la siembra de NeonDB:', err);
  process.exit(1);
});

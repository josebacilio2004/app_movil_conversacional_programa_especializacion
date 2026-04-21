# Horizonte Continental Web System

Sistema web de validación e interacción para el chatbot vocacional "Cori". Basado en el sistema de diseño "The Ethereal Mentor".

## Estructura del Proyecto

- `/docs`: Código estático (HTML/CSS/JS) para desplegar en **GitHub Pages**.
- `/horizonte_web_system/backend`: API en Node.js para desplegar en **Render**.
- `/horizonte_web_system/sql`: Esquemas de base de datos para **NeonDB**.

## Instrucciones de Despliegue

### 1. Base de Datos (NeonDB)
1. Crea un proyecto en [Neon.tech](https://neon.tech).
2. Ejecuta el script en `/horizonte_web_system/sql/schema.sql`.
3. Copia tu `Connection String`.

### 2. Backend (Render)
1. Conecta este repositorio a Render.
2. Crea un nuevo `Web Service` apuntando al subdirectorio `horizonte_web_system/backend`.
3. Configura las siguientes variables de entorno:
   - `DATABASE_URL`: Tu connection string de NeonDB.
   - `PORT`: 3000 (o el que Render asigne).
4. Copia la URL de tu servicio desplegado (ej: `https://horizonte-api.onrender.com`).

### 3. Frontend (GitHub Pages)
1. En `docs/js/api.js`, actualiza `BASE_URL` con tu URL de Render.
2. Sube los cambios a GitHub.
3. En los ajustes de tu repositorio de GitHub, ve a **Settings > Pages**.
4. En **Build and deployment > Branch**, selecciona:
   - Branch: `main`
   - Folder: `/docs`
5. Haz clic en **Save**.
6. ¡Listo! Tu frontend estará disponible en `https://josebacilio2004.github.io/app_movil_conversacional_programa_especializacion/`.

## Desarrollo Local

1. Navega a `horizonte_web_system/backend/`.
2. Instala dependencias: `npm install`.
3. Inicia el servidor: `npm start`.
4. Abre `docs/index.html` en tu navegador.

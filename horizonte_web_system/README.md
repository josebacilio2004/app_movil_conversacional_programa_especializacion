# Horizonte Continental Web System

Sistema web de validación y interacción para el chatbot vocacional "Cori". Basado en el sistema de diseño "The Ethereal Mentor".

## Estructura del Proyecto

- `/frontend`: Código estático (HTML/CSS/JS) para desplegar en **GitHub Pages**.
- `/backend`: API en Node.js para desplegar en **Render**.
- `/sql`: Esquemas de base de datos para **NeonDB**.

## Instrucciones de Despliegue

### 1. Base de Datos (NeonDB)
1. Crea un proyecto en [Neon.tech](https://neon.tech).
2. Ejecuta el script en `/sql/schema.sql` (disponible abajo).
3. Copia tu `Connection String`.

### 2. Backend (Render)
1. Sube este repositorio a GitHub.
2. En Render, crea un nuevo `Web Service` apuntando a la carpeta `backend/`.
3. Configura las siguientes variables de entorno:
   - `DATABASE_URL`: Tu connection string de NeonDB.
   - `PORT`: 3000 (o el que Render asigne).
4. Copia la URL de tu servicio desplegado (ej: `https://horizonte-api.onrender.com`).

### 3. Frontend (GitHub Pages)
1. En `frontend/js/api.js`, actualiza `BASE_URL` con tu URL de Render.
2. En los ajustes de tu repositorio de GitHub, ve a `Pages`.
3. Selecciona la rama `main` y la carpeta `frontend/` (o usa una GitHub Action si prefieres subdirectorio).
4. ¡Listo! Tu frontend estará disponible en `tu-usuario.github.io/tu-repo`.

## Desarrollo Local

1. Navega a `backend/`.
2. Instala dependencias: `npm install`.
3. Inicia el servidor: `npm start`.
4. Abre `frontend/index.html` en tu navegador.

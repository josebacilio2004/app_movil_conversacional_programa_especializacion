#!/bin/sh
set -e

# Si la variable N8N_ENCRYPTION_KEY está configurada en las variables de entorno de Render,
# generar el archivo de configuración dinámicamente en tiempo de ejecución.
# De esta manera ninguna clave secreta se expone en el código fuente ni en GitHub.
if [ -n "$N8N_ENCRYPTION_KEY" ]; then
  mkdir -p /home/node/.n8n
  echo "{\"encryptionKey\":\"$N8N_ENCRYPTION_KEY\"}" > /home/node/.n8n/config
  chmod 600 /home/node/.n8n/config
fi

# Delegar la ejecución al entrypoint oficial de n8n
exec /docker-entrypoint.sh "$@"

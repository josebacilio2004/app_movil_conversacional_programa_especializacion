import firebase_admin
from firebase_admin import credentials, firestore
import pandas as pd
import matplotlib.pyplot as plt
import os

# 1. Configuración de Firebase
# Asegúrate de que el archivo JSON esté en el mismo directorio o especifica la ruta
SERVICE_ACCOUNT_PATH = "../appmovilespecializacion-firebase-adminsdk-fsvc-1073e97b66.json"

if not os.path.exists(SERVICE_ACCOUNT_PATH):
    print(f"ERROR: No se encontró el archivo de credenciales en {SERVICE_ACCOUNT_PATH}")
    exit()

cred = credentials.Certificate(SERVICE_ACCOUNT_PATH)
firebase_admin.initialize_app(cred)
db = firestore.client()

def fetch_metrics_data():
    print("Recuperando datos de Firestore...")
    all_data = []
    
    # Recorrer todos los usuarios
    users_ref = db.collection('users')
    users = users_ref.stream()
    
    for user in users:
        # Recorrer el historial de cada usuario
        history_ref = user.reference.collection('history')
        messages = history_ref.stream()
        
        for msg in messages:
            data = msg.to_dict()
            if not data.get('isUser'): # Solo analizamos respuestas del BOT para satisfacción
                all_data.append({
                    'sessionId': data.get('sessionId', 'N/A'),
                    'category': data.get('category', 'general'),
                    'rating': data.get('rating'), # 1 o 5
                    'timestamp': data.get('timestamp')
                })
    
    return pd.DataFrame(all_data)

def generate_charts(df):
    if df.empty:
        print("No hay datos suficientes para generar gráficos.")
        return

    # Limpieza de datos: Eliminar nulos en rating para el cálculo de CSAT
    df_ratings = df.dropna(subset=['rating'])
    
    # --- GRÁFICO 1: SATISFACCIÓN POR CATEGORÍA (CSAT) ---
    plt.figure(figsize=(10, 6))
    csat_by_cat = df_ratings.groupby('category')['rating'].mean()
    csat_by_cat.plot(kind='bar', color='#7630f3', alpha=0.8)
    plt.title('Índice de Satisfacción (CSAT) por Categoría', fontsize=14)
    plt.ylabel('Puntuación Media (1-5)', fontsize=12)
    plt.xlabel('Categoría de Consulta', fontsize=12)
    plt.xticks(rotation=45)
    plt.grid(axis='y', linestyle='--', alpha=0.7)
    plt.tight_layout()
    plt.savefig('csat_by_category.png')
    print("Gráfico 'csat_by_category.png' generado.")

    # --- GRÁFICO 2: VOLUMEN DE CONSULTAS ---
    plt.figure(figsize=(10, 6))
    volume_by_cat = df['category'].value_counts()
    volume_by_cat.plot(kind='pie', autopct='%1.1f%%', colors=['#4f46e5', '#7630f3', '#10b981', '#f59e0b'])
    plt.title('Distribución de Consultas por Categoría', fontsize=14)
    plt.ylabel('')
    plt.tight_layout()
    plt.savefig('query_volume_pie.png')
    print("Gráfico 'query_volume_pie.png' generado.")

if __name__ == "__main__":
    df = fetch_metrics_data()
    generate_charts(df)
    print("\n--- PROCESO COMPLETADO ---")
    print("Los gráficos han sido guardados en el directorio actual.")

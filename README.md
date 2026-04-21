# Proyecto: App de Recomendación de Especialización Profesional

Este proyecto móvil está desarrollado con Flutter y Firebase, orientado a ayudar a los egresados de la Universidad Continental a elegir su especialización mediante un chatbot inteligente.

## Requisitos Previos

1.  **Flutter SDK**: Asegúrate de tener Flutter instalado y configurado en tu `PATH`.
2.  **Firebase Project**: Crea un proyecto en la consola de Firebase.
3.  **Configuración de Android**: Descarga el archivo `google-services.json` y colócalo en `android/app/`.
4.  **Configuración de iOS**: Descarga el archivo `GoogleService-Info.plist` y colócalo en `ios/Runner/`.

## Estructura del Proyecto

-   `lib/main.dart`: Punto de entrada y gestión del estado de autenticación.
-   `lib/services/auth_service.dart`: Lógica de autenticación con Firebase.
-   `lib/screens/auth/login_screen.dart`: Interfaz de usuario para el inicio de sesión.

## Cómo Ejecutar

1.  Instala las dependencias:
    ```bash
    flutter pub get
    ```
2.  Ejecuta la aplicación:
    ```bash
    flutter run
    ```

## Próximos Pasos (Sprints)

-   **Implementación del Test RIASEC**: Creación de la encuesta para determinar el perfil vocacional.
-   **Integración con n8n**: Configuración de webhooks para el flujo del chatbot.
-   **Sistema de Recomendación**: Lógica en Firebase Functions para sugerir especializaciones basadas en RIASEC.

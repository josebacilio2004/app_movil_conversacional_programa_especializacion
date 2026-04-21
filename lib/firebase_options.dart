// Archivo generado como plantilla para permitir que la Web inicie.
// En una app real, este archivo se genera con "flutterfire configure".
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  // REEMPLAZAR con tus claves de Firebase Console si el Mock no es suficiente
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBILcoJ2qvZsLKnVQkh84WPXxd-L0RwXlE',
    appId: '1:444686619856:web:6373cc6d744d117a30fad5',
    messagingSenderId: '444686619856',
    projectId: 'appmovilespecializacion',
    authDomain: 'appmovilespecializacion.firebaseapp.com',
    storageBucket: 'appmovilespecializacion.firebasestorage.app',
    measurementId: 'G-4CTE3MM96X',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA...',
    appId: '1:...',
    messagingSenderId: '...',
    projectId: '...',
    storageBucket: '...',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyA...',
    appId: '1:...',
    messagingSenderId: '...',
    projectId: '...',
    storageBucket: '...',
    iosBundleId: 'com.example.appEspecializacion',
  );
}

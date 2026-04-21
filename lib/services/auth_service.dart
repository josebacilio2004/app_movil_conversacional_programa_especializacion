import 'package:firebase_auth/firebase_auth.dart';

/// [RF-03] Gestión de Acceso: Proporciona servicios de autenticación segura
/// integrados con Firebase Auth para usuarios de la Universidad Continental.
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Stream de estado de autenticación
  Stream<User?> get user => _auth.authStateChanges();

  /// [RF-03.1] Inicio de Sesión: Valida credenciales contra Firebase Auth.
  Future<User?> signInWithEmailPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email, 
        password: password
      );
      return result.user;
    } on FirebaseAuthException catch (e) {
      print('Error en Authentication (Sign In): ${e.message}');
      throw e; // Relanzamos para manejarlo en la UI
    }
  }

  /// [RF-03.2] Registro de Usuarios: Crea nuevas cuentas en la plataforma.
  Future<User?> registerWithEmailPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email, 
        password: password
      );
      return result.user;
    } on FirebaseAuthException catch (e) {
      print('Error en Authentication (Register): ${e.message}');
      throw e;
    }
  }

  /// [RF-03.3] Cierre de Sesión: Finaliza la sesión activa del usuario.
  Future<void> signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}

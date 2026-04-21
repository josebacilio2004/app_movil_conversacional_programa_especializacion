import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../models/specialization_model.dart';

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Colección de Usuarios
  final CollectionReference usersCollection = FirebaseFirestore.instance.collection('users');
  // Colección de Especializaciones
  final CollectionReference specializationsCollection = FirebaseFirestore.instance.collection('specializations');

  // Guardar/Actualizar Perfil de Usuario
  Future<void> updateUserData(AppUser user) async {
    return await usersCollection.doc(user.uid).set(user.toMap(), SetOptions(merge: true));
  }

  // Obtener Perfil de Usuario
  Stream<AppUser> userData(String uid) {
    return usersCollection.doc(uid).snapshots().map((doc) {
      return AppUser.fromMap(doc.data() as Map<String, dynamic>, uid);
    });
  }

  // Obtener lista de Especializaciones
  Stream<List<Specialization>> get specializations {
    return specializationsCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Specialization.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }

  // Guardar Resultado RIASEC
  Future<void> saveRiasecResult(String uid, Map<String, int> profile) async {
    return await usersCollection.doc(uid).set({
      'perfilVocacional': profile,
    }, SetOptions(merge: true));
  }

  // Utilidad de Semilla (Seed) para Especializaciones
  Future<void> seedSpecializations(List<Specialization> specs) async {
    for (var spec in specs) {
      await specializationsCollection.doc(spec.id).set(spec.toMap());
    }
  }
}

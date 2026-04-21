class AppUser {
  final String uid;
  final String email;
  final String displayName; // Nuevo campo
  final List<String> interests;
  final Map<String, int> riasecProfile;
  final List<String> savedSpecializations;

  AppUser({
    required this.uid,
    required this.email,
    this.displayName = '', // Valor por defecto
    this.interests = const [],
    this.riasecProfile = const {},
    this.savedSpecializations = const [],
  });

  factory AppUser.fromMap(Map<String, dynamic> data, String uid) {
    return AppUser(
      uid: uid,
      email: data['email'] ?? '',
      displayName: data['nombreCompleto'] ?? '',
      interests: List<String>.from(data['intereses'] ?? []),
      riasecProfile: Map<String, int>.from(data['perfilVocacional'] ?? {}),
      savedSpecializations: List<String>.from(data['preferenciasGuardadas'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'nombreCompleto': displayName,
      'intereses': interests,
      'perfilVocacional': riasecProfile,
      'preferenciasGuardadas': savedSpecializations,
    };
  }
}

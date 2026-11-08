class AppUser {
  final String uid;
  final String email;
  final String displayName;
  final String carreraPregrado; // 1. Continuidad académica
  final String areaLaboralActual; // 2. Desempeño laboral actual
  final int presupuestoMaxMensual; // 3. Viabilidad económica (tope mensual en S/.)
  final String modalidadPreferida; // 'A distancia', 'Semipresencial', 'Flexible'
  final String riasecCode; // Código triádico Holland (ej. 'IRE', 'SEC')
  final List<String> interests;
  final Map<String, int> riasecProfile;
  final List<String> savedSpecializations;

  AppUser({
    required this.uid,
    required this.email,
    this.displayName = '',
    this.carreraPregrado = '',
    this.areaLaboralActual = '',
    this.presupuestoMaxMensual = 1500,
    this.modalidadPreferida = 'A distancia',
    this.riasecCode = '',
    this.interests = const [],
    this.riasecProfile = const {},
    this.savedSpecializations = const [],
  });

  factory AppUser.fromMap(Map<String, dynamic> data, String uid) {
    return AppUser(
      uid: uid,
      email: data['email'] ?? '',
      displayName: data['nombreCompleto'] ?? '',
      carreraPregrado: data['carreraPregrado'] ?? '',
      areaLaboralActual: data['areaLaboralActual'] ?? '',
      presupuestoMaxMensual: data['presupuestoMaxMensual'] is num 
          ? (data['presupuestoMaxMensual'] as num).toInt() 
          : int.tryParse(data['presupuestoMaxMensual']?.toString() ?? '1500') ?? 1500,
      modalidadPreferida: data['modalidadPreferida'] ?? 'A distancia',
      riasecCode: data['riasecCode'] ?? '',
      interests: List<String>.from(data['intereses'] ?? []),
      riasecProfile: Map<String, int>.from(
        (data['perfilVocacional'] as Map?)?.map((k, v) => MapEntry(k.toString(), (v as num).toInt())) ?? {}
      ),
      savedSpecializations: List<String>.from(data['preferenciasGuardadas'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'nombreCompleto': displayName,
      'carreraPregrado': carreraPregrado,
      'areaLaboralActual': areaLaboralActual,
      'presupuestoMaxMensual': presupuestoMaxMensual,
      'modalidadPreferida': modalidadPreferida,
      'riasecCode': riasecCode,
      'intereses': interests,
      'perfilVocacional': riasecProfile,
      'preferenciasGuardadas': savedSpecializations,
    };
  }

  AppUser copyWith({
    String? email,
    String? displayName,
    String? carreraPregrado,
    String? areaLaboralActual,
    int? presupuestoMaxMensual,
    String? modalidadPreferida,
    String? riasecCode,
    List<String>? interests,
    Map<String, int>? riasecProfile,
    List<String>? savedSpecializations,
  }) {
    return AppUser(
      uid: uid,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      carreraPregrado: carreraPregrado ?? this.carreraPregrado,
      areaLaboralActual: areaLaboralActual ?? this.areaLaboralActual,
      presupuestoMaxMensual: presupuestoMaxMensual ?? this.presupuestoMaxMensual,
      modalidadPreferida: modalidadPreferida ?? this.modalidadPreferida,
      riasecCode: riasecCode ?? this.riasecCode,
      interests: interests ?? this.interests,
      riasecProfile: riasecProfile ?? this.riasecProfile,
      savedSpecializations: savedSpecializations ?? this.savedSpecializations,
    );
  }
}

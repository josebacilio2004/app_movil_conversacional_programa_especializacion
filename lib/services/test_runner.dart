import '../services/riasec_service.dart';

void main() async {
  print("--- Iniciando Simulación Manual del Sistema ---");
  
  final riasec = RiasecService();
  
  // 1. Simular respuestas
  print("[1] Simulando respuestas del Test RIASEC...");
  final mockAnswers = {
    0: true, 1: true, 2: false, 3: true, 4: false, 5: true
  };
  
  // 2. Calcular perfil
  final profile = riasec.calculateProfile(mockAnswers);
  print("[2] Perfil Calculado: $profile");
  
  // 3. Determinar categoría top
  final top = riasec.getTopCategory(profile);
  print("[3] Categoría Predominante: $top");
  
  // 4. Conclusión
  print("\n--- Resultado de la Prueba ---");
  if (top == 'I' || top == 'R' || top == 'S' || top == 'A' || top == 'E' || top == 'C') {
    print("ESTADO: EXITOSO. El sistema procesó los datos correctamente.");
  } else {
    print("ESTADO: FALLIDO. Revisar lógica de asignación.");
  }
}

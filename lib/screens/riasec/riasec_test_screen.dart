import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/riasec_service.dart';
import '../../services/database_service.dart';

class RiasecTestScreen extends StatefulWidget {
  const RiasecTestScreen({super.key});

  @override
  State<RiasecTestScreen> createState() => _RiasecTestScreenState();
}

class _RiasecTestScreenState extends State<RiasecTestScreen> {
  final RiasecService _riasecService = RiasecService();
  final DatabaseService _db = DatabaseService();
  final Map<int, bool> _answers = {};
  int _currentQuestionIndex = 0;

  @override
  Widget build(BuildContext context) {
    final questions = _riasecService.questions;
    final theme = Theme.of(context);

    return Scaffold(
      body: Stack(
        children: [
          // Background Gradient
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF7630f3), Color(0xFF4f46e5)],
              ),
            ),
          ),
          
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                      Text(
                        'Paso ${_currentQuestionIndex + 1} de ${questions.length}',
                        style: const TextStyle(color: Colors.white70, fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Progress Bar
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: (_currentQuestionIndex + 1) / questions.length,
                      minHeight: 8,
                      backgroundColor: Colors.white24,
                      valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                  const Spacer(),
                  // Question Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(32),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 30,
                          offset: const Offset(0, 15),
                        )
                      ],
                    ),
                    child: Column(
                      children: [
                        const Icon(Icons.psychology_alt_rounded, size: 48, color: Color(0xFF7630f3)),
                        const SizedBox(height: 24),
                        Text(
                          questions[_currentQuestionIndex].text,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E293B),
                            height: 1.4,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 40),
                        // Action Buttons
                        Column(
                          children: [
                            _buildOptionButton(
                              context, 
                              label: "Me gusta / Me interesa", 
                              value: true, 
                              color: const Color(0xFF7630f3),
                              icon: Icons.check_circle_rounded,
                            ),
                            const SizedBox(height: 12),
                            _buildOptionButton(
                              context, 
                              label: "No me interesa", 
                              value: false, 
                              color: Colors.grey.shade400,
                              icon: Icons.cancel_rounded,
                              isGhost: true,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Spacer(flex: 2),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionButton(BuildContext context, {
    required String label, 
    required bool value, 
    required Color color,
    required IconData icon,
    bool isGhost = false,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: isGhost ? Colors.transparent : color,
          foregroundColor: isGhost ? Colors.grey.shade700 : Colors.white,
          side: isGhost ? BorderSide(color: Colors.grey.shade300) : null,
          elevation: isGhost ? 0 : 2,
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        onPressed: () {
          setState(() {
            _answers[_currentQuestionIndex] = value;
            if (_currentQuestionIndex < _riasecService.questions.length - 1) {
              _currentQuestionIndex++;
            } else {
              _handleCompletion();
            }
          });
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 20),
            const SizedBox(width: 12),
            Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  void _handleCompletion() async {
    final user = Provider.of<User?>(context, listen: false);
    final profile = _riasecService.calculateProfile(_answers);
    final top = _riasecService.getTopCategory(profile);

    if (user != null) {
      await _db.saveRiasecResult(user.uid, profile);
    }

    if (!mounted) return;

    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(32),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.stars_rounded, color: Colors.amber, size: 64),
            const SizedBox(height: 16),
            const Text(
              '¡Test Completado!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Tu perfil dominante es: $top',
              style: const TextStyle(fontSize: 18, color: Color(0xFF7630f3), fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'Hemos analizado tus respuestas y tu perfil vocacional ya está disponible para el Asistente Continental.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Cerrar bottom sheet
                Navigator.pop(context); // Volver a Home
              },
              child: const Text('Comenzar Recomendaciones'),
            ),
          ],
        ),
      ),
    );
  }
}

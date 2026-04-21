import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../models/user_model.dart';
import '../../services/database_service.dart';

class ProfileScreen extends StatefulWidget {
  final AppUser user;

  const ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late TextEditingController _nameController;
  final DatabaseService _db = DatabaseService();
  bool _isEditing = false;
  late AppUser _currentUser;

  @override
  void initState() {
    super.initState();
    _currentUser = widget.user;
    _nameController = TextEditingController(text: _currentUser.displayName);
  }

  Future<void> _saveName() async {
    final updatedUser = AppUser(
      uid: _currentUser.uid,
      email: _currentUser.email,
      displayName: _nameController.text,
      interests: _currentUser.interests,
      riasecProfile: _currentUser.riasecProfile,
      savedSpecializations: _currentUser.savedSpecializations,
    );

    await _db.updateUserData(updatedUser);
    setState(() {
      _currentUser = updatedUser;
      _isEditing = false;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Perfil actualizado con éxito'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Color(0xFF6D23F9),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: Stack(
        children: [
          // Background Blobs (Sincronizado con Home)
          Positioned(
            top: -50,
            right: -50,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.05),
                shape: BoxShape.circle,
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 70, sigmaY: 70),
                child: Container(color: Colors.transparent),
              ),
            ),
          ),

          CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 160,
                pinned: true,
                elevation: 0,
                backgroundColor: theme.colorScheme.background,
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  title: Text(
                    'Mi Perfil', 
                    style: TextStyle(
                      color: theme.colorScheme.primary, 
                      fontWeight: FontWeight.w900,
                      fontSize: 18,
                    ),
                  ),
                  background: Stack(
                    alignment: Alignment.center,
                    children: [
                      Positioned(
                        top: 60,
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            border: Border.all(color: theme.colorScheme.primary.withOpacity(0.1), width: 4),
                            boxShadow: [
                              BoxShadow(color: theme.colorScheme.primary.withOpacity(0.1), blurRadius: 20)
                            ],
                          ),
                          child: Icon(Icons.person_rounded, size: 40, color: theme.colorScheme.primary),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionTitle('Información Personal'),
                      const SizedBox(height: 16),
                      _buildGlassProfileCard(),
                      const SizedBox(height: 32),
                      _buildSectionTitle('Tu Perfil Vocacional'),
                      const SizedBox(height: 16),
                      _buildRiasecResultsCard(),
                      const SizedBox(height: 32),
                      _buildInspirationQuote(),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 14, 
        fontWeight: FontWeight.w800, 
        letterSpacing: 1.2, 
        color: Color(0xFF494456),
      ),
    );
  }

  Widget _buildGlassProfileCard() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.6),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withOpacity(0.3), width: 1.5),
          ),
          child: Column(
            children: [
              _buildInfoRow(Icons.email_outlined, 'CORREO ELECTRÓNICO', _currentUser.email),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Divider(height: 1, color: Color(0xFFE2E8F0)),
              ),
              _buildNameField(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNameField() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF6D23F9).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.badge_outlined, color: Color(0xFF6D23F9), size: 18),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('NOMBRE COMPLETO', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Color(0xFF64748B))),
              const SizedBox(height: 4),
              _isEditing
                ? TextField(
                    controller: _nameController,
                    autofocus: true,
                    decoration: const InputDecoration(
                      isDense: true,
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                  )
                : Text(
                    _currentUser.displayName.isEmpty ? 'Sin configurar' : _currentUser.displayName,
                    style: TextStyle(
                      fontSize: 15, 
                      fontWeight: FontWeight.w700,
                      color: _currentUser.displayName.isEmpty ? Colors.grey : const Color(0xFF1E293B),
                    ),
                  ),
            ],
          ),
        ),
        IconButton(
          onPressed: () {
            if (_isEditing) {
              _saveName();
            } else {
              setState(() => _isEditing = true);
            }
          },
          icon: Icon(
            _isEditing ? Icons.check_circle : Icons.edit_rounded,
            color: const Color(0xFF6D23F9),
            size: 20,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: const Color(0xFF64748B), size: 18),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Color(0xFF64748B))),
            const SizedBox(height: 4),
            Text(value, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Color(0xFF1E293B))),
          ],
        ),
      ],
    );
  }

  Widget _buildRiasecResultsCard() {
    if (_currentUser.riasecProfile.isEmpty) {
      return _buildEmptyResults();
    }

    final values = [
      (_currentUser.riasecProfile['R'] ?? 0).toDouble(),
      (_currentUser.riasecProfile['I'] ?? 0).toDouble(),
      (_currentUser.riasecProfile['A'] ?? 0).toDouble(),
      (_currentUser.riasecProfile['S'] ?? 0).toDouble(),
      (_currentUser.riasecProfile['E'] ?? 0).toDouble(),
      (_currentUser.riasecProfile['C'] ?? 0).toDouble(),
    ];

    return ClipRRect(
      borderRadius: BorderRadius.circular(32),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.6),
            borderRadius: BorderRadius.circular(32),
            border: Border.all(color: Colors.white.withOpacity(0.3), width: 1.5),
          ),
          child: Column(
            children: [
              SizedBox(
                height: 300,
                child: RadarChart(
                  RadarChartData(
                    radarShape: RadarShape.polygon,
                    radarBackgroundColor: Colors.transparent,
                    borderData: FlBorderData(show: false),
                    radarBorderData: const BorderSide(color: Colors.transparent),
                    titlePositionPercentageOffset: 0.15,
                    tickCount: 3,
                    ticksTextStyle: const TextStyle(color: Colors.transparent),
                    tickBorderData: const BorderSide(color: Color(0xFFF1F5F9), width: 1),
                    gridBorderData: const BorderSide(color: Color(0xFFF1F5F9), width: 1.5),
                    getTitle: (index, angle) {
                      const labels = ['Realista', 'Investigador', 'Artístico', 'Social', 'Emprendedor', 'Convencional'];
                      return RadarChartTitle(text: labels[index], angle: angle);
                    },
                    titleTextStyle: const TextStyle(color: Color(0xFF64748B), fontSize: 10, fontWeight: FontWeight.w700),
                    dataSets: [
                      RadarDataSet(
                        fillColor: const Color(0xFF6D23F9).withOpacity(0.15),
                        borderColor: const Color(0xFF6D23F9),
                        entryRadius: 4,
                        dataEntries: values.map((e) => RadarEntry(value: e)).toList(),
                        borderWidth: 2.5,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Este gráfico muestra la intensidad de tus intereses según el modelo RIASEC.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyResults() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.5),
        borderRadius: BorderRadius.circular(32),
      ),
      child: Column(
        children: [
          Icon(Icons.analytics_outlined, size: 48, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          const Text('Diagnóstico pendiente', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF494456))),
          const SizedBox(height: 8),
          const Text('Completa el test para descubrir tu perfil vocacional.', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey, fontSize: 13)),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, '/riasec'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6D23F9),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              minimumSize: const Size(0, 0),
            ),
            child: const Text('Comenzar Test'),
          ),
        ],
      ),
    );
  }

  Widget _buildInspirationQuote() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(32),
      ),
      child: const Column(
        children: [
          Icon(Icons.auto_awesome, color: Color(0xFF6D23F9), size: 32),
          SizedBox(height: 16),
          Text(
            "“El éxito consiste en obtener lo que se desea. La felicidad, en disfrutar lo que se obtiene.”",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              fontStyle: FontStyle.italic,
              color: Colors.white,
              height: 1.5,
            ),
          ),
          SizedBox(height: 8),
          Text("- Ralph Waldo Emerson", style: TextStyle(color: Colors.white54, fontSize: 11, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

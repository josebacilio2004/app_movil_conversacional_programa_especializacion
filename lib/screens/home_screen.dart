import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../services/auth_service.dart';
import '../models/user_model.dart';
import '../screens/profile/profile_screen.dart';
import '../tools/seed_data.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    final AppUser? appUser = Provider.of<AppUser?>(context);
    final theme = Theme.of(context);
    final String userName = appUser?.displayName.split(' ')[0] ?? appUser?.email.split('@')[0] ?? 'Estudiante';

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: Stack(
        children: [
          // Background Organic Blobs
          Positioned(
            top: -100,
            left: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
                child: Container(color: Colors.transparent),
              ),
            ),
          ),
          Positioned(
            bottom: -50,
            right: -50,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                color: theme.colorScheme.secondary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
                child: Container(color: Colors.transparent),
              ),
            ),
          ),

          CustomScrollView(
            slivers: [
              // Premium Glass Header
              SliverAppBar(
                expandedHeight: 120,
                floating: false,
                pinned: true,
                elevation: 0,
                backgroundColor: theme.colorScheme.background.withOpacity(0.8),
                flexibleSpace: FlexibleSpaceBar(
                  background: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(color: Colors.transparent),
                  ),
                ),
                title: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: theme.colorScheme.primary.withOpacity(0.2), width: 2),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: appUser != null 
                          ? Image.asset('brand/logo.png', fit: BoxFit.contain)
                          : const Icon(Icons.person),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Horizonte UC',
                      style: TextStyle(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w900,
                        fontSize: 20,
                        letterSpacing: -1,
                      ),
                    ),
                  ],
                ),
                actions: [
                  IconButton(
                    icon: Icon(Icons.person_outline, color: theme.colorScheme.primary),
                    onPressed: () {
                      if (appUser != null) {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) => ProfileScreen(user: appUser),
                        ));
                      }
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.logout_rounded, color: theme.colorScheme.primary),
                    onPressed: () async => await _auth.signOut(),
                  ),
                ],
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      const Text(
                        'TU LIENZO DE CRECIMIENTO',
                        style: TextStyle(
                          fontSize: 12, 
                          fontWeight: FontWeight.w800, 
                          letterSpacing: 2, 
                          color: Color(0xFF494456),
                        ),
                      ),
                      const SizedBox(height: 8),
                      RichText(
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: 36, 
                            fontWeight: FontWeight.w800, 
                            color: theme.colorScheme.onBackground,
                            letterSpacing: -1,
                          ),
                          children: [
                            const TextSpan(text: 'Bienvenido, '),
                            TextSpan(
                              text: userName,
                              style: TextStyle(color: theme.colorScheme.primary),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 40),
                      
                      // RIASEC Talent Matrix Card
                      _buildGlassContainer(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Matriz de Talento RIASEC',
                                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        'Tu ADN vocacional visualizado',
                                        style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                                if (appUser != null && appUser.riasecProfile.isNotEmpty)
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: theme.colorScheme.secondary.withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      _getDominantTrait(appUser),
                                      style: TextStyle(
                                        color: theme.colorScheme.secondary,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            Center(
                              child: SizedBox(
                                height: 220,
                                child: (appUser != null && appUser.riasecProfile.isNotEmpty)
                                  ? _buildRadarChart(appUser)
                                  : Container(
                                      alignment: Alignment.center,
                                      child: Icon(Icons.auto_awesome, color: theme.colorScheme.primary.withOpacity(0.3), size: 40),
                                    ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Center(
                              child: TextButton(
                                onPressed: () => Navigator.pushNamed(context, '/riasec'),
                                child: const Text('Ver detalle completo'),
                              ),
                            )
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),
                      
                      // Next Milestone & Skill Gap
                      Row(
                        children: [
                          Expanded(
                            child: _buildActionCard(
                              title: "Hito Siguiente",
                              subtitle: "Simulación: Liderazgo",
                              hint: "80% Match",
                              icon: Icons.psychology_rounded,
                              color: theme.colorScheme.primary,
                              onTap: () {},
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildActionCard(
                              title: "Brecha de Habilidades",
                              subtitle: "Storytelling Estratégico",
                              hint: "URGENTE",
                              icon: Icons.hub_rounded,
                              color: theme.colorScheme.secondary,
                              onTap: () {},
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 40),
                      const Text(
                        'Acciones Rápidas',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      
                      GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 2,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        childAspectRatio: 1.5,
                        children: [
                          _buildQuickActionButton(
                            icon: Icons.edit_note_rounded,
                            label: "ACTUALIZAR PERFIL",
                            onTap: () {
                              if (appUser != null) {
                                Navigator.push(context, MaterialPageRoute(
                                  builder: (context) => ProfileScreen(user: appUser),
                                ));
                              }
                            },
                          ),
                          _buildQuickActionButton(
                            icon: Icons.history_edu_rounded,
                            label: "REPETIR TEST",
                            onTap: () => Navigator.pushNamed(context, '/riasec'),
                          ),
                          _buildQuickActionButton(
                            icon: Icons.diversity_3_rounded,
                            label: "BUSCAR MENTORES",
                            onTap: () {},
                          ),
                          _buildQuickActionButton(
                            icon: Icons.emoji_events_rounded,
                            label: "CERTIFICACIONES",
                            onTap: () {},
                          ),
                        ],
                      ),

                      const SizedBox(height: 32),
                      // System Tools Card
                      _buildGlassContainer(
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.blueGrey.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const Icon(Icons.cloud_upload_rounded, color: Colors.blueGrey),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Poblar Dataset',
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    'Cargar información profesional',
                                    style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                            TextButton(
                              onPressed: () => DataSeeder.seedSpecializations(context),
                              child: const Text('Ejecutar'),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 120), // Padding lower nav
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Custom Bottom Navigation Bar
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildBottomNav(context),
          ),

          // Floating Action Button Style Bot
          Positioned(
            bottom: 100,
            right: 24,
            child: FloatingActionButton.large(
              onPressed: () => Navigator.pushNamed(context, '/chat'),
              backgroundColor: theme.colorScheme.primary,
              child: const Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 40),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGlassContainer({required Widget child}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(32),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.4),
            borderRadius: BorderRadius.circular(32),
            border: Border.all(color: Colors.white.withOpacity(0.3), width: 1.5),
          ),
          child: child,
        ),
      ),
    );
  }

  Widget _buildActionCard({
    required String title,
    required String subtitle,
    required String hint,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 8),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: Colors.white, size: 28),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
            ),
            Text(
              subtitle,
              style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 11),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                hint,
                style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w900),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionButton({required IconData icon, required String label, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10)
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Theme.of(context).colorScheme.primary, size: 26),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 20, offset: const Offset(0, -5))
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _navItem(Icons.auto_awesome_mosaic_rounded, "Guía", isActive: true),
          _navItem(Icons.analytics_rounded, "Talento"),
          _navItem(Icons.chat_bubble_rounded, "Coach"),
          _navItem(Icons.explore_rounded, "Explorar"),
        ],
      ),
    );
  }

  Widget _navItem(IconData icon, String label, {bool isActive = false}) {
    final color = isActive ? Theme.of(context).colorScheme.primary : Colors.grey.shade400;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  String _getDominantTrait(AppUser user) {
    String topTrait = 'R';
    int maxScore = -1;
    user.riasecProfile.forEach((key, value) {
      if (value > maxScore) {
        maxScore = value;
        topTrait = key;
      }
    });
    final traitNames = {
      'R': 'REALISTA DOMINANTE',
      'I': 'INVESTIGADOR DOMINANTE',
      'A': 'ARTÍSTICO DOMINANTE',
      'S': 'SOCIAL DOMINANTE',
      'E': 'EMPRENDEDOR DOMINANTE',
      'C': 'CONVENCIONAL DOMINANTE',
    };
    return traitNames[topTrait] ?? 'PERFIL PROFESIONAL';
  }

  Widget _buildRadarChart(AppUser user) {
    final values = [
      (user.riasecProfile['R'] ?? 0).toDouble(),
      (user.riasecProfile['I'] ?? 0).toDouble(),
      (user.riasecProfile['A'] ?? 0).toDouble(),
      (user.riasecProfile['S'] ?? 0).toDouble(),
      (user.riasecProfile['E'] ?? 0).toDouble(),
      (user.riasecProfile['C'] ?? 0).toDouble(),
    ];

    return RadarChart(
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
          const labels = ['R', 'I', 'A', 'S', 'E', 'C'];
          return RadarChartTitle(text: labels[index], angle: angle);
        },
        titleTextStyle: const TextStyle(color: Color(0xFF64748B), fontSize: 12, fontWeight: FontWeight.w800),
        dataSets: [
          RadarDataSet(
            fillColor: const Color(0xFF6D23F9).withOpacity(0.15),
            borderColor: const Color(0xFF6D23F9),
            entryRadius: 3,
            dataEntries: values.map((e) => RadarEntry(value: e)).toList(),
            borderWidth: 2,
          ),
        ],
      ),
    );
  }
}


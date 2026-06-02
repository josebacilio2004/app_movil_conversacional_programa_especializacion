import 'dart:ui';
import 'package:flutter/material.dart';

class Mentor {
  final String name;
  final String role;
  final String company;
  final String area;
  final String description;
  final String riasecType;

  Mentor({
    required this.name,
    required this.role,
    required this.company,
    required this.area,
    required this.description,
    required this.riasecType,
  });
}

class MentorsScreen extends StatefulWidget {
  const MentorsScreen({super.key});

  @override
  State<MentorsScreen> createState() => _MentorsScreenState();
}

class _MentorsScreenState extends State<MentorsScreen> {
  final List<Mentor> _mentors = [
    Mentor(
      name: "Dr. Carlos Mendoza",
      role: "CIO & Director de Transformación Cloud",
      company: "Interbank",
      area: "Ingeniería",
      description: "Asesor de posgrado en TI, experto en gobierno de datos y arquitecturas empresariales.",
      riasecType: "Investigador",
    ),
    Mentor(
      name: "Dra. Sofía Alva",
      role: "Gerente de Desarrollo Organizacional",
      company: "Alicorp",
      area: "Psicología",
      description: "Mentora en gestión del talento, coaching ejecutivo y cultura laboral de posgrado.",
      riasecType: "Social",
    ),
    Mentor(
      name: "Mag. Roberto Lazo",
      role: "Director de Operaciones & Supply Chain",
      company: "DP World Callao",
      area: "Logística / Negocios",
      description: "Especialista en cadena de suministros global y metodologías Lean Six Sigma.",
      riasecType: "Realista / Convencional",
    ),
    Mentor(
      name: "Dra. Patricia Ortiz",
      role: "Supervisora de Calidad en Gestión de Salud",
      company: "EsSalud",
      area: "Salud",
      description: "Asesora en modernización de gestión hospitalaria y políticas de salud pública.",
      riasecType: "Social / Convencional",
    ),
    Mentor(
      name: "Mag. Luis Felipe Soto",
      role: "Consultor de Políticas Públicas",
      company: "PCM / Banco Mundial",
      area: "Gestión Pública",
      description: "Experto en diseño de presupuestos por resultados y modernización del Estado.",
      riasecType: "Social / Emprendedor",
    ),
  ];

  String _selectedFilter = 'Todos';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final filteredMentors = _selectedFilter == 'Todos'
        ? _mentors
        : _mentors.where((m) => m.area.contains(_selectedFilter) || m.riasecType.contains(_selectedFilter)).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Red de Mentores', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF6D23F9),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Stack(
        children: [
          // Background Blob
          Positioned(
            top: -50,
            right: -50,
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.04),
                shape: BoxShape.circle,
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
                child: Container(color: Colors.transparent),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'CONECTA CON LÍDERES',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.5,
                    color: Color(0xFF64748B),
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Mentores de Posgrado',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: Color(0xFF1E293B)),
                ),
                const SizedBox(height: 16),

                // Filter chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: ['Todos', 'Ingeniería', 'Psicología', 'Salud', 'Negocios'].map((filter) {
                      final isSelected = _selectedFilter == filter;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: ChoiceChip(
                          label: Text(filter),
                          selected: isSelected,
                          onSelected: (val) {
                            setState(() {
                              _selectedFilter = filter;
                            });
                          },
                          selectedColor: const Color(0xFF6D23F9),
                          labelStyle: TextStyle(color: isSelected ? Colors.white : const Color(0xFF64748B)),
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 20),

                // List
                Expanded(
                  child: filteredMentors.isEmpty
                      ? const Center(child: Text('No se encontraron mentores en esta área.'))
                      : ListView.builder(
                          itemCount: filteredMentors.length,
                          itemBuilder: (context, index) {
                            final mentor = filteredMentors[index];
                            return _buildMentorCard(mentor, theme);
                          },
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMentorCard(Mentor mentor, ThemeData theme) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: const Color(0xFF6D23F9).withOpacity(0.08),
                child: const Icon(Icons.person_outline_rounded, color: Color(0xFF6D23F9), size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      mentor.name,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${mentor.role} en ${mentor.company}',
                      style: const TextStyle(fontSize: 12, color: Color(0xFF64748B), fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            mentor.description,
            style: const TextStyle(fontSize: 13, height: 1.4, color: Color(0xFF475569)),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF6D23F9).withOpacity(0.06),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'RIASEC: ${mentor.riasecType}',
                  style: const TextStyle(color: Color(0xFF6D23F9), fontSize: 10, fontWeight: FontWeight.w800),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Solicitud de mentoría enviada a ${mentor.name} 📧'),
                      backgroundColor: const Color(0xFF6D23F9),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6D23F9),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  minimumSize: const Size(0, 0),
                ),
                child: const Text('Contactar', style: TextStyle(fontSize: 12)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

import 'dart:ui';
import 'package:flutter/material.dart';

class Certification {
  final String title;
  final String provider;
  final String category; // RIASEC category mapping
  final String description;
  final String demandLevel;
  final double matchPercentage;

  Certification({
    required this.title,
    required this.provider,
    required this.category,
    required this.description,
    required this.demandLevel,
    required this.matchPercentage,
  });
}

class CertificationsScreen extends StatefulWidget {
  const CertificationsScreen({super.key});

  @override
  State<CertificationsScreen> createState() => _CertificationsScreenState();
}

class _ProfileScreenState extends State<CertificationsScreen> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class _CertificationsScreenState extends State<CertificationsScreen> {
  final List<Certification> _certs = [
    Certification(
      title: "Project Management Professional (PMP)",
      provider: "Project Management Institute (PMI)",
      category: "Convencional / Emprendedor",
      description: "La certificación líder mundial en gestión de proyectos. Muy valorada para egresados de Administración e Ingeniería.",
      demandLevel: "ALTA",
      matchPercentage: 0.95,
    ),
    Certification(
      title: "AWS Certified Solutions Architect",
      provider: "Amazon Web Services (AWS)",
      category: "Investigador / Realista",
      description: "Valida la capacidad técnica para diseñar e implementar sistemas robustos y seguros en la nube de Amazon.",
      demandLevel: "EXTREMA",
      matchPercentage: 0.90,
    ),
    Certification(
      title: "Scrum Master Professional Certificate",
      provider: "Scrum.org / Scrum Alliance",
      category: "Social / Emprendedor",
      description: "Acredita el dominio del marco ágil Scrum para facilitar el trabajo en equipos multifuncionales.",
      demandLevel: "ALTA",
      matchPercentage: 0.85,
    ),
    Certification(
      title: "Google Data Analytics Professional",
      provider: "Google / Coursera",
      category: "Investigador / Convencional",
      description: "Especialización práctica en procesamiento de datos, análisis predictivo,SQL y lenguajes como R.",
      demandLevel: "ALTA",
      matchPercentage: 0.88,
    ),
    Certification(
      title: "HubSpot Inbound Marketing Certification",
      provider: "HubSpot Academy",
      category: "Artístico / Emprendedor",
      description: "Certificación clave en metodologías de atracción digital, automatización y estrategias de contenido creativo.",
      demandLevel: "MEDIA",
      matchPercentage: 0.80,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Certificaciones Recomendadas', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF6D23F9),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Stack(
        children: [
          // Background Blob
          Positioned(
            bottom: -50,
            left: -50,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: theme.colorScheme.secondary.withOpacity(0.04),
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
                  'POTENCIA TU PERFIL',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.5,
                    color: Color(0xFF64748B),
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Certificaciones Clave',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: Color(0xFF1E293B)),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Cursos recomendados para destacar en tu postulación de posgrado.',
                  style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
                ),
                const SizedBox(height: 20),

                Expanded(
                  child: ListView.builder(
                    itemCount: _certs.length,
                    itemBuilder: (context, index) {
                      final cert = _certs[index];
                      return _buildCertCard(cert, theme);
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

  Widget _buildCertCard(Certification cert, ThemeData theme) {
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF6D23F9).withOpacity(0.08),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  cert.provider,
                  style: const TextStyle(color: Color(0xFF6D23F9), fontSize: 10, fontWeight: FontWeight.w900),
                ),
              ),
              Text(
                '${(cert.matchPercentage * 100).toInt()}% Match',
                style: const TextStyle(color: Colors.green, fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            cert.title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
          ),
          const SizedBox(height: 8),
          Text(
            cert.description,
            style: const TextStyle(fontSize: 13, height: 1.4, color: Color(0xFF475569)),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('DEMANDA LABORAL', style: TextStyle(fontSize: 8, color: Color(0xFF94A3B8), fontWeight: FontWeight.bold)),
                  const SizedBox(height: 2),
                  Text(
                    cert.demandLevel,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                      color: cert.demandLevel == 'EXTREMA' ? Colors.red : Colors.orange,
                    ),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Redireccionando al portal oficial de ${cert.provider} 🔗'),
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
                child: const Text('Explorar Curso', style: TextStyle(fontSize: 12)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

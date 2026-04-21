import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  String email = '';
  String password = '';
  String error = '';
  bool loading = false;
  bool _isLogin = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      body: Stack(
        children: [
          // Background Gradient - Sincronizado con Horizonte UC
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF6D23F9), Color(0xFF4f46e5)],
              ),
            ),
          ),
          
          // Content
          loading 
            ? const Center(child: CircularProgressIndicator(color: Colors.white))
            : Positioned.fill(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 60.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Mascot section
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          shape: BoxShape.circle,
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: ClipOval(
                            child: Lottie.network(
                              'https://assets2.lottiefiles.com/packages/lf20_1pxqjqps.json',
                              height: 100,
                              width: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),

                      Text(
                        'Horizonte UC',
                        style: GoogleFonts.manrope(
                          color: Colors.white,
                          fontSize: 40,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -1.5,
                          height: 1,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Asistente Continental',
                        style: TextStyle(
                          color: Colors.white70, 
                          fontSize: 16, 
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 48),
                      
                      // Login Card (Glassmorphism sutil)
                      Container(
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
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _isLogin ? 'Bienvenido' : 'Crear Cuenta',
                                style: const TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF1E293B),
                                  letterSpacing: -0.5,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _isLogin 
                                  ? 'Tu futuro profesional está a un paso.'
                                  : 'Únete a la comunidad de egresados.',
                                style: const TextStyle(color: Color(0xFF64748B), fontSize: 14),
                              ),
                              const SizedBox(height: 32),
                              
                              TextFormField(
                                decoration: const InputDecoration(
                                  labelText: 'Correo Institucional',
                                  prefixIcon: Icon(Icons.email_outlined),
                                ),
                                validator: (val) => val!.isEmpty ? 'Ingresa tu correo' : null,
                                onChanged: (val) => setState(() => email = val),
                              ),
                              const SizedBox(height: 20),
                              
                              TextFormField(
                                obscureText: true,
                                decoration: const InputDecoration(
                                  labelText: 'Contraseña',
                                  prefixIcon: Icon(Icons.lock_outline),
                                ),
                                validator: (val) => val!.length < 6 ? 'Mínimo 6 caracteres' : null,
                                onChanged: (val) => setState(() => password = val),
                              ),
                              
                              const SizedBox(height: 12),
                              if (error.isNotEmpty)
                                Center(
                                  child: Text(
                                    error,
                                    style: const TextStyle(color: Colors.red, fontSize: 13, fontWeight: FontWeight.w600),
                                  ),
                                ),
                                
                              const SizedBox(height: 32),
                              
                              ElevatedButton(
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    setState(() => loading = true);
                                    try {
                                      dynamic result;
                                      if (_isLogin) {
                                        result = await _auth.signInWithEmailPassword(email, password);
                                      } else {
                                        result = await _auth.registerWithEmailPassword(email, password);
                                      }
                                      if (result == null) {
                                        setState(() {
                                          error = 'Error de autenticación';
                                          loading = false;
                                        });
                                      }
                                    } catch (e) {
                                      setState(() {
                                        error = 'Ocurrió un error inesperado';
                                        loading = false;
                                      });
                                    }
                                  }
                                },
                                child: Text(
                                  _isLogin ? 'Iniciar Sesión' : 'Empieza Ahora',
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                                ),
                              ),
                              
                              const SizedBox(height: 24),
                              
                              Center(
                                child: TextButton(
                                  onPressed: () => setState(() {
                                    _isLogin = !_isLogin;
                                    error = '';
                                  }),
                                  child: RichText(
                                    text: TextSpan(
                                      style: const TextStyle(color: Color(0xFF64748B), fontSize: 14),
                                      children: [
                                        TextSpan(text: _isLogin ? '¿Nuevo aquí? ' : '¿Ya eres parte? '),
                                        TextSpan(
                                          text: _isLogin ? 'Regístrate' : 'Inicia Sesión',
                                          style: const TextStyle(
                                            color: Color(0xFF6D23F9),
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                      Image.asset('brand/logo.png', height: 40, opacity: const AlwaysStoppedAnimation(0.6)),
                    ],
                  ),
                ),
              ),
        ],
      ),
    );
  }
}


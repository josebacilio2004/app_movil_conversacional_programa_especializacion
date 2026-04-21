import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'screens/auth/login_screen.dart';
import 'screens/riasec/riasec_test_screen.dart';
import 'screens/profile/profile_screen.dart';
import 'screens/chat/chat_screen.dart';
import 'services/auth_service.dart';
import 'services/database_service.dart';
import 'screens/home_screen.dart';
import 'models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    print("Firebase initialization skipped or failed: $e");
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<User?>.value(value: AuthService().user, initialData: null),
      ],
      child: MaterialApp(
        title: 'Horizonte UC',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          textTheme: GoogleFonts.manropeTextTheme(
            Theme.of(context).textTheme,
          ),
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF6D23F9),
            primary: const Color(0xFF6D23F9),
            onPrimary: Colors.white,
            secondary: const Color(0xFF10B981), // Emerald Green from design
            surface: const Color(0xFFF7F9FB),
            background: const Color(0xFFF7F9FB),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6D23F9),
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 56),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 0,
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: const Color(0xFFECEEF0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Color(0xFF6D23F9), width: 1.5),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            hintStyle: TextStyle(color: const Color(0xFF494456).withOpacity(0.5)),
          ),
        ),
        home: const Wrapper(),
        routes: {
          '/riasec': (context) => const RiasecTestScreen(),
          '/chat': (context) => const ChatScreen(),
        },
      ),
    );
  }
}

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);

    if (user == null) {
      return const LoginScreen();
    } else {
      return StreamBuilder<AppUser>(
        stream: DatabaseService().userData(user.uid),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Provider<AppUser>.value(
              value: snapshot.data!,
              child: const HomeScreen(),
            );
          } else {
            return const HomeScreen(); 
          }
        },
      );
    }
  }
}

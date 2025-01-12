import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:google_fonts/google_fonts.dart'; // Importa o GoogleFonts
import 'package:shared_preferences/shared_preferences.dart';

import 'app_module.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final initialRoute = await _getInitialRoute();
  runApp(ModularApp(
    module: AppModule(initialRoute: initialRoute),
    child: const MyApp(),
  ));
}

Future<String> _getInitialRoute() async {
  final prefs = await SharedPreferences.getInstance();
  final userLogin = prefs.getString('login');
  if (userLogin != null) {
    return '/profile';
  }
  return '/home';
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Search d_evs',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          surface: Colors.white,
        ),
        textTheme: TextTheme(
          titleLarge: GoogleFonts.inter(
            fontWeight: FontWeight.w700,
            fontSize: 20,
            color: const Color(0xFF171923),
          ),
          bodyMedium: GoogleFonts.inter(
            fontWeight: FontWeight.w400,
            fontSize: 14,
            color: const Color(0xFF2D3748),
          ),
          bodySmall: GoogleFonts.inter(
            fontWeight: FontWeight.w400,
            fontSize: 14,
            color: const Color(0xFF4A5568),
          ),
          bodyLarge: GoogleFonts.inter(
            fontWeight: FontWeight.w400,
            fontSize: 16,
            color: const Color(0xFF4A5568),
          ),
        ),
        useMaterial3: true,
      ),
      routeInformationParser: Modular.routeInformationParser,
      routerDelegate: Modular.routerDelegate,
    );
  }
}

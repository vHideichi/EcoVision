import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'models/models.dart';

/// Ponto de entrada do aplicativo EcoVision.
/// Configura o tema visual e a tela inicial.
void main() {
  runApp(const EcoVisionApp());
}

class EcoVisionApp extends StatelessWidget {
  const EcoVisionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EcoVision',
      debugShowCheckedModeBanner: false,

      // Tema visual do aplicativo (verde - conexão com natureza)
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2E7D32), // Verde escuro
          primary: const Color(0xFF2E7D32),
          secondary: const Color(0xFF81C784), // Verde claro
          tertiary: const Color(0xFF1B5E20), // Verde muito escuro
          background: const Color(0xFFF1F8E9), // Fundo verde bem claro
        ),
        useMaterial3: true,
        fontFamily: 'Roboto',

        // Estilo do AppBar
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF2E7D32),
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
        ),

        // Estilo dos botões principais
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2E7D32),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),

        // Estilo dos campos de texto
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF2E7D32), width: 2),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
      ),

      // Define a tela inicial como Login
      home: const LoginScreen(),

      // Rotas nomeadas para navegação
      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => HomeScreen(
          usuario: Usuario(
            id: 1,
            nome: 'Victor',
            email: 'victor@ecovision.com',
            pontuacaoTotal: 150,
            totalScans: 3,
          ),
        ),
      },
    );
  }
}
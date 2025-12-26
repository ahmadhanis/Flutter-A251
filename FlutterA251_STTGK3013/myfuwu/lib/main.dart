import 'package:flutter/material.dart';
import 'package:myfuwu/views/splashpage.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

 @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF5F7FA),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1F3C88),
          primary: const Color(0xFF1F3C88),
          secondary: const Color(0xFF2EC4B6),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1F3C88),
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
        ),
        textTheme: const TextTheme(
          headlineMedium: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF1F3C88),
          ),
          bodyMedium: TextStyle(
            color: Color(0xFF2B2D42),
          ),
        ),
      ),
      home: const SplashPage(),
    );
  }
}

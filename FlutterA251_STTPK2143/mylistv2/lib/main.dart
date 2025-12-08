import 'package:flutter/material.dart';
import 'package:mylistv2/loginscreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFF8E3B8E)),
        useMaterial3: true,
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFF8E3B8E),
          foregroundColor: Colors.white,
          elevation: 5,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF8E3B8E),
            foregroundColor: Colors.white,
            elevation: 5,
          ),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Color(0xFF8E3B8E),
          foregroundColor: Colors.white,
          elevation: 5,
        ),
      ),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Animation Setup
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _controller.forward();

    // Navigate after delay
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,

        /// 🌈 Modern Gradient
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF8E3B8E), Color(0xFF6A1B9A)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),

        /// 🌟 Center Content (Animated)
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /// App Icon / Logo Placeholder
              Container(
                height: screenHeight * 0.18,
                width: screenHeight * 0.18,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white24, width: 2),
                ),
                child: const Icon(
                  Icons.check_circle_outline,
                  color: Colors.white,
                  size: 80,
                ),
              ),

              const SizedBox(height: 25),

              /// App Title
              const Text(
                "MyList V2",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),

              const SizedBox(height: 10),

              /// Subtitle
              Text(
                "Organize your tasks beautifully",
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.85),
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 30),

              /// Loading Indicator (subtle + modern)
              const CircularProgressIndicator(
                color: Colors.white70,
                strokeWidth: 3,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

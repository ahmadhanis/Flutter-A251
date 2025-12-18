import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/spots_provider.dart';
import 'providers/location_provider.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SpotsProvider()),
        ChangeNotifierProvider(create: (_) => LocationProvider()),
      ],
      child: const SweetSpotApp(),
    ),
  );
}

class SweetSpotApp extends StatelessWidget {
  const SweetSpotApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SweetSpot',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      home: const SplashScreen(),
    );
  }
}

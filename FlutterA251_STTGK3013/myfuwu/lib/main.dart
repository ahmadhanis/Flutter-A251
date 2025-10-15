import 'package:flutter/material.dart';
import 'package:myfuwu/splashpage.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(useMaterial3: true, primaryColor: Colors.blue),
      home: SplashPage(),
    );
  }
}

import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    double size = 16;
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("My First App"),
          backgroundColor: Colors.blue,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Hello Flutter",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              Text(
                "Welcome to Flutter Development",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              Text("Let's build something amazing!"),
              Text("Flutter makes it easy and fun!"),
              SizedBox(height: size),
              Text("Happy Coding!"),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.star, color: Colors.yellow, size: size),
                  Icon(Icons.star, color: Colors.blue, size: size),
                  Icon(Icons.star, color: Colors.red, size: size),
                  Icon(Icons.star, color: Colors.green, size: size),
                  Icon(Icons.star, color: Colors.grey, size: size),
                  Icon(Icons.star, color: Colors.purple, size: size),
                ],
              ),
              ElevatedButton(onPressed: () {
                print("Button Pressed");
              }, child: Text('PressMe')),
            ],
          ),
        ),
      ),
    );
  }
}

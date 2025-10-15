import 'package:flutter/material.dart';
import 'package:myfuwu/registerpage.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Main Page')),
      body: Center(child: Text('Main Page')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Action for the button
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const RegisterScreen()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

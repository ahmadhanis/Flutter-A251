import 'package:flutter/material.dart';
import 'package:mylistv2/newitemscreen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("MyList V2")),
      body: Center(child: Text("MyList V2", style: TextStyle(fontSize: 30))),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NewItemScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

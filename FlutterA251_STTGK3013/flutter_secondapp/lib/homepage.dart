import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String name = "Ahmad Hanis";
  TextEditingController num1controller = TextEditingController();
  TextEditingController num2controller = TextEditingController();
  int sum = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Flutter App')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(32, 0, 32, 0),
          child: Column(
            children: [
              Text('Hello, $name!'),
              Text('Welcome to Flutter.'),
              const SizedBox(height: 20),
              TextField(
                controller: num1controller,
                decoration: InputDecoration(
                  hintText: "Enter Number 1",
                  border: OutlineInputBorder(),
                  labelText: "Number 1",
                  prefixIcon: Icon(Icons.numbers),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 10),
              TextField(
                controller: num2controller,
                decoration: InputDecoration(
                  hintText: "Enter Number 2",
                  border: OutlineInputBorder(),
                  labelText: "Number 2",
                  prefixIcon: Icon(Icons.numbers),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: calculateMe,
                  child: Text("Press Me"),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Total:$sum',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void calculateMe() {
    int num1 = int.parse(num1controller.text);
    int num2 = int.parse(num2controller.text);
    sum = num1 + num2;
    setState(() {});
  }
}

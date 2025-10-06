import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController num1controller = TextEditingController();
  TextEditingController num2controller = TextEditingController();
  int result = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("My First App"), backgroundColor: Colors.blue),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: num1controller,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: "Enter first number",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.numbers),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: num2controller,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: "Enter second number",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.numbers),
                ),
              ),
              SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: calculateMe,
                  child: Text("Calculate"),
                ),
              ),
              SizedBox(height: 20),
              Text(
                result.toString(),
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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
    result = num1 + num2;
    setState(() {});
  }
}

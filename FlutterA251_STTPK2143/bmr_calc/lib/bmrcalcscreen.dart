import 'package:flutter/material.dart';

class BMRCalcScreen extends StatefulWidget {
  const BMRCalcScreen({super.key});

  @override
  State<BMRCalcScreen> createState() => _BMRCalcScreenState();
}

class _BMRCalcScreenState extends State<BMRCalcScreen> {
  String gender = 'Male';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BMR Calculator'),
        backgroundColor: Colors.red,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            margin: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(10),
            ),
        
            height: 350,
            width: 300,
            child: Column(
              children: [
                Row(
                  children: [
                    SizedBox(width: 80, child: Text('Age')),
                    SizedBox(
                      width: 100,
                      child: TextField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: 'Age',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Text('Ages 16-80'),
                  ],
                ),
                SizedBox(height: 5),
                Row(
                  children: [
                    SizedBox(width: 80, child: Text('Gender')),
                    DropdownButton<String>(
                      value: gender,
                      items: <String>['Male', 'Female'].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        gender = newValue!;
                        setState(() {});
                      },
                    ),
                  ],
                ),
                SizedBox(height: 5),
                Row(
                  children: [
                    SizedBox(width: 80, child: Text('Height')),
                    SizedBox(
                      width: 100,
                      child: TextField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: 'Height',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Text('cm'),
                  ],
                ),
                SizedBox(height: 5),
                Row(
                  children: [
                    SizedBox(width: 80, child: Text('Weight')),
                    SizedBox(
                      width: 100,
                      child: TextField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: 'Weight',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Text('Kg'),
                  ],
                ),
                SizedBox(height: 5),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      child: Text('Calculate BMR'),
                    ),
                    SizedBox(width: 20),
                    ElevatedButton(onPressed: () {}, child: Text('Reset')),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

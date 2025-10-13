import 'package:flutter/material.dart';

class BMRCalcScreen extends StatefulWidget {
  const BMRCalcScreen({super.key});

  @override
  State<BMRCalcScreen> createState() => _BMRCalcScreenState();
}

class _BMRCalcScreenState extends State<BMRCalcScreen> {
  TextEditingController ageController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  String gender = 'Male';
  double bmrResult = 0.0;

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

            height: 400,
            width: 300,
            child: Column(
              children: [
                Row(
                  children: [
                    SizedBox(width: 80, child: Text('Age')),
                    SizedBox(
                      width: 100,
                      child: TextField(
                        controller: ageController,
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
                        controller: heightController,
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
                        controller: weightController,
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
                      onPressed: calculateBMR,
                      child: Text('Calculate BMR'),
                    ),
                    SizedBox(width: 20),
                    ElevatedButton(onPressed: () {}, child: Text('Reset')),
                  ],
                ),
                SizedBox(height: 20),
                Text(
                  'Your BMR is: ${bmrResult.toStringAsFixed(2)} kcal/day',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void calculateBMR() {
    int age = int.parse(ageController.text);
    double height = double.parse(heightController.text);
    double weight = double.parse(weightController.text);

    if (gender == 'Male') {
      bmrResult = 88.362 + (13.397 * weight) + (4.799 * height) - (5.677 * age);
    } else {
      bmrResult = 447.593 + (9.247 * weight) + (3.098 * height) - (4.330 * age);
    }

    setState(() {});
  }
}

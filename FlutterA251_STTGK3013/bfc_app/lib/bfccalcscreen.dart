import 'dart:math';

import 'package:flutter/material.dart';

class BFCCalcScreen extends StatefulWidget {
  const BFCCalcScreen({super.key});

  @override
  State<BFCCalcScreen> createState() => _BFCCalcScreenState();
}

class _BFCCalcScreenState extends State<BFCCalcScreen> {
  String gender = 'Male';
  TextEditingController ageController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  TextEditingController neckController = TextEditingController();
  TextEditingController waistController = TextEditingController();
  TextEditingController hipController = TextEditingController();
  double bfp = 0.0;
  FocusNode ageFocusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BFC Calc Screen', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.red,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(16.0),
            margin: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(8.0),
              color: Colors.lightGreenAccent,
            ),
            width: 350,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    SizedBox(width: 100, child: Text('Gender')),
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
                    SizedBox(width: 100, child: Text('Age')),
                    SizedBox(
                      width: 200,
                      child: TextField(
                        keyboardType: TextInputType.number,
                        focusNode: ageFocusNode,
                        controller: ageController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Enter Age',
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5),
                Row(
                  children: [
                    SizedBox(width: 100, child: Text('Weight')),
                    SizedBox(
                      width: 200,
                      child: TextField(
                        keyboardType: TextInputType.number,
                        controller: weightController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Weight (kg)',
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5),
                Row(
                  children: [
                    SizedBox(width: 100, child: Text('Height')),
                    SizedBox(
                      width: 200,
                      child: TextField(
                        controller: heightController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Height (cm)',
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5),
                Row(
                  children: [
                    SizedBox(width: 100, child: Text('Neck')),
                    SizedBox(
                      width: 200,
                      child: TextField(
                        controller: neckController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Neck ( cm )',
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5),
                Row(
                  children: [
                    SizedBox(width: 100, child: Text('Waist')),
                    SizedBox(
                      width: 200,
                      child: TextField(
                        controller: waistController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Waist ( cm )',
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5),
                Row(
                  children: [
                    SizedBox(width: 100, child: Text('Hip')),
                    SizedBox(
                      width: 200,
                      child: TextField(
                        controller: hipController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Hip ( cm )',
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: calculateBF,
                      child: Text('Calculate BF'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        ageController.clear();
                        weightController.clear();
                        heightController.clear();
                        neckController.clear();
                        waistController.clear();
                        hipController.clear();
                        gender = 'Male';
                        //setfocus to age

                        FocusScope.of(context).requestFocus(ageFocusNode);
                        ageFocusNode.requestFocus();

                        bfp = 0.0;
                        setState(() {});
                      },
                      child: Text('Reset'),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Text(
                  'Body Fat Percentage: $bfp%',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void calculateBF(String gender) {
    // Conversion constant: 1 cm = 0.393701 inches
    const double cmToInches = 0.393701;

    // --- 1. Parse Inputs (in cm/kg) ---
    // Note: age and weight (kg) are NOT used in the Navy BF% formula,
    // but are parsed here for completeness based on your variable list.
    // int age = int.parse(ageController.text);
    // double weightKg = double.parse(weightController.text);

    // Measurements parsed in centimeters (cm)
    double heightCm = double.parse(heightController.text);
    double neckCm = double.parse(neckController.text);
    double waistCm = double.parse(waistController.text);
    double hipCm = double.parse(hipController.text);

    // --- 2. Convert CM to Inches (Required for the Navy Formula) ---
    double height = heightCm * cmToInches;
    double neck = neckCm * cmToInches;
    double waist = waistCm * cmToInches;
    double hip = hipCm * cmToInches;

    double bodyFatPercentage;
    final standardizedGender = gender.toLowerCase();

    // --- 3. Apply U.S. Navy Body Fat Formula ---
    if (standardizedGender == 'male') {
      // Formula for Men (Measurements MUST be in Inches):
      // BF% = 495 / (1.0324 - 0.19077 * log10(waist - neck) + 0.15456 * log10(height)) - 450

      // Note: Dart's log() is natural log (base e). We convert to log base 10 using log(x) / log(10).
      final double log10WaistNeck = log(waist - neck) / log(10);
      final double log10Height = log(height) / log(10);

      final double density =
          1.0324 - (0.19077 * log10WaistNeck) + (0.15456 * log10Height);

      bodyFatPercentage = (495 / density) - 450;
    } else if (standardizedGender == 'female') {
      // Formula for Women (Measurements MUST be in Inches):
      // BF% = 495 / (1.29579 - 0.35004 * log10(waist + hip - neck) + 0.22100 * log10(height)) - 450

      final double log10Sum = log(waist + hip - neck) / log(10);
      final double log10Height = log(height) / log(10);

      final double density =
          1.29579 - (0.35004 * log10Sum) + (0.22100 * log10Height);

      bodyFatPercentage = (495 / density) - 450;
    } else {
      // Handle invalid gender input
      // If possible, set an error state here.
      return;
    }

    // Final Body Fat Percentage (rounded to two decimal places)
    double finalBF = double.parse(bodyFatPercentage.toStringAsFixed(2));

    // --- 4. Update State ---
    // This assumes you are inside a State class and bfp is a state variable.
    setState(() {
      bfp = finalBF;
    });
  }
}

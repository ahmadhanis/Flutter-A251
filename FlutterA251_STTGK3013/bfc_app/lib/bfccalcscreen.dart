import 'package:flutter/material.dart';

class BFCCalcScreen extends StatefulWidget {
  const BFCCalcScreen({super.key});

  @override
  State<BFCCalcScreen> createState() => _BFCCalcScreenState();
}

class _BFCCalcScreenState extends State<BFCCalcScreen> {
  String gender = 'Male';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BFC Calc Screen', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.red,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Text('Gender'),
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
            Row(
              children: [
                Text('Age'),
                SizedBox(
                  width: 200,
                  child: TextField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Enter Age',
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

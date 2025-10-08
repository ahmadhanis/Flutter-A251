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
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Enter Weight',
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
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Enter Height',
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
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Enter Neck',
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
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Enter Waist',
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(onPressed: () {}, child: Text('Calculate BF')),
                  ElevatedButton(onPressed: () {}, child: Text('Reset')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

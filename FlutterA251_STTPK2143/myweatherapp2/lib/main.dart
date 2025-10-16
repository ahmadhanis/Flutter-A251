import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: MyWeatherScreen());
  }
}

class MyWeatherScreen extends StatefulWidget {
  const MyWeatherScreen({super.key});

  @override
  State<MyWeatherScreen> createState() => _MyWeatherScreenState();
}

class _MyWeatherScreenState extends State<MyWeatherScreen> {
  TextEditingController locationController = TextEditingController();
  String status = "Status here";
  bool vis = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Weather App'), backgroundColor: Colors.blue),
      body: Center(
        child: Column(
          children: [
            Text('Weather Information will be displayed here'),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: locationController,
                decoration: InputDecoration(
                  hintText: 'Enter location',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ),

            Visibility(visible: vis, child: CircularProgressIndicator()),

            ElevatedButton(onPressed: getWeather, child: Text('Get Weather')),
            SizedBox(height: 20),
            Text(status, style: TextStyle(fontSize: 20)),
          ],
        ),
      ),
    );
  }
  //https://api.data.gov.my/weather/forecast/?contains=$loc@location__location_name

  void getWeather() async {
    status = 'Getting weather...';
    vis = true;
    setState(() {});
    String loc = locationController.text;
    print('Getting weather $loc');
    var response = await http
        .get(
          Uri.parse(
            'https://api.data.gov.my/weather/forecast/?contains=$loc@location__location_name',
          ),
        )
        .timeout(
          const Duration(seconds: 5),
          onTimeout: () {
            log('Error getting weather: Timeout');
            status = 'Error getting weather: Timeout';
            vis = false;
            setState(() {});
            return http.Response('Error', 408); // Request Timeout response
          },
        );

    if (response.statusCode != 200) {
      log('Error getting weather: ${response.statusCode}');
      status = 'Error getting weather: ${response.statusCode}';
      setState(() {});
      return;
    }
    if (response.body.isEmpty) {
      log('Error getting weather: Empty response');
      status = 'Error getting weather: Empty response';
      setState(() {});
      return;
    }
    if (response.body.contains('error')) {
      log('Error getting weather: ${response.body}');
      status = 'Error getting weather: ${response.body}';
      setState(() {});
      return;
    }
    var data = json.decode(response.body);
    if (data.length == 0) {
      log('Error getting weather: Location not found');
      status = 'Error getting weather: Location not found';
      setState(() {});
      return;
    }
    log(response.body.toString());
    status = 'Success';
    vis = false;
    setState(() {});
  }
}

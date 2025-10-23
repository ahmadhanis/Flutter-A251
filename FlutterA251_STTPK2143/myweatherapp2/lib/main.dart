import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:myweatherapp2/location.dart';

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
  String status = "Search for weather by location";
  bool vis = false;
  List<dynamic> weatherData = [];
  String loc = '';
  final dateformat = DateFormat('dd/MM/yyyy');
  late double screenWidth, screenHeight;
  Mylocation mylocation = Mylocation();
  String selectedloc = 'Jitra';

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    if (screenWidth > 600) {
      screenWidth = 600; //limit max width for better readability
    }
    return Scaffold(
      appBar: AppBar(title: Text('Weather App'), backgroundColor: Colors.blue),
      body: Center(
        child: SizedBox(
          width: screenWidth,
          child: Column(
            children: [
              // Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: TextField(
              //     controller: locationController,
              //     decoration: InputDecoration(
              //       hintText: 'Enter location',
              //       border: OutlineInputBorder(
              //         borderRadius: BorderRadius.circular(10.0),
              //       ),
              //     ),
              //   ),
              // ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Select Location',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  items: mylocation.allLocations.map((String location) {
                    return DropdownMenuItem<String>(
                      value: location,
                      child: Text(location),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedloc = newValue!;
                    });
                  },
                ),
              ),

              Visibility(visible: vis, child: CircularProgressIndicator()),

              SizedBox(
                width: screenWidth,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    textStyle: TextStyle(fontSize: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  onPressed: getWeather,
                  child: Text('Get Weather'),
                ),
              ),
              SizedBox(height: 20),
              weatherData.isEmpty
                  ? Center(child: Text(status, style: TextStyle(fontSize: 20)))
                  : Expanded(
                      child: ListView.builder(
                        itemCount: weatherData.length,
                        itemBuilder: (context, index) {
                          String date = dateformat
                              .format(
                                DateTime.parse(weatherData[index]['date']),
                              )
                              .toString(); // Convert the date string to a DateTime object and format it weatherData[index]['date'];
                          String morning =
                              weatherData[index]['morning_forecast'];
                          String afternoon =
                              weatherData[index]['afternoon_forecast'];
                          String night = weatherData[index]['night_forecast'];
                          String summary =
                              weatherData[index]['summary_forecast'];
                          String min = weatherData[index]['min_temp']
                              .toString();
                          String max = weatherData[index]['max_temp']
                              .toString();
                          String locid =
                              weatherData[index]['location']['location_id'];
                          return Card(
                            child: InkWell(
                              onTap: () {
                                // Handle tap if needed
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text(
                                        'Weather Details for $loc on $date',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(height: 10),
                                          Text(
                                            'Min Temp: $min °C | Max Temp: $max °C',
                                          ),
                                          SizedBox(height: 10),
                                          Text('Morning: $morning'),
                                          Text('Afternoon: $afternoon'),
                                          Text('Night: $night'),
                                          SizedBox(height: 10),
                                          Text('Summary: $summary'),
                                        ],
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text('Close'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              child: ListTile(
                                leading: CircleAvatar(
                                  child: Text('${index + 1}'),
                                ),
                                title: Text('Date: $date'),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Weather station id: $locid'),
                                    Text('Summary: $summary'),
                                  ],
                                ),
                                trailing: Icon(Icons.arrow_forward_ios),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
  //https://api.data.gov.my/weather/forecast/?contains=$loc@location__location_name

  void getWeather() async {
    weatherData = [];
    vis = true;
    setState(() {});
    loc = selectedloc;
    if (loc.isEmpty) {
      status = 'Please enter a location';
      vis = false;
      setState(() {});
      return;
    }
    status = 'Getting $loc weather';

    var response = await http
        .get(
          Uri.parse(
            'http://api.data.gov.my/weather/forecast/?contains=$loc@location__location_name',
          ),
        )
        .timeout(
          const Duration(seconds: 20),
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
      vis = false;
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
      vis = false;
      setState(() {});
      return;
    }

    weatherData = json.decode(response.body);

    if (weatherData.isEmpty) {
      log('Error getting weather: Location not found');
      status = 'Error getting weather: Location not found';
      vis = false;
      weatherData = []; //reset data
      setState(() {});
      return;
    }

    // log(response.body.toString());
    status = 'Weather for $loc ';
    vis = false;
    setState(() {});
  }
}

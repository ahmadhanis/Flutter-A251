import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_cors_image/flutter_cors_image.dart';
import 'package:http/http.dart' as http;

class PersonPage extends StatefulWidget {
  const PersonPage({super.key});

  @override
  State<PersonPage> createState() => _PersonPageState();
}

class _PersonPageState extends State<PersonPage> {
  late double screenWidth, screenHeight;
  List<dynamic> personList = [];
  String status = "Press the button to fetch persons";

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth > 600) {
      screenWidth = 600; //limit max width for better readability
    }
    return Scaffold(
      appBar: AppBar(title: Text('Person Page')),
      body: Center(
        child: SizedBox(
          width: screenWidth,
          child: Column(
            children: [
              Text(
                'Welcome to the Person Page!',
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(
                width: screenWidth,
                child: ElevatedButton(
                  onPressed: () {
                    fethPerson();
                  },
                  child: Text('Fetch Random Persons'),
                ),
              ),
              personList.isEmpty
                  ? SizedBox(height: 100, child: Center(child: Text(status)))
                  : Expanded(
                      child: ListView.builder(
                        itemCount: personList.length,
                        itemBuilder: (context, index) {
                          String name =
                              '${personList[index]['name']['title']} ${personList[index]['name']['first']} ${personList[index]['name']['last']}';
                          String email = personList[index]['email'];
                          String phone = personList[index]['phone'];
                          String imageUrl =
                              personList[index]['picture']['large'];
                          String country =
                              personList[index]['location']['country'];
                          return Card(
                            elevation: 2,
                            shadowColor: Colors.red,
                            margin: EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 8,
                            ),
                            child: ListTile(
                              leading: CustomNetworkImage(
                                url: imageUrl,
                                width: 50,
                                height: 50,
                                fit: BoxFit.contain,
                                webStorageCacheConfig: WebStorageCacheConfig(
                                  enabled: true, // Enable persistent caching
                                  maxCacheSize:
                                      100 * 1024 * 1024, // 100MB cache limit
                                  cacheExpirationHours:
                                      168, // 7 days expiration
                                ),
                                errorWidget: Icon(Icons.error),
                              ),

                              title: Text(name),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(email),
                                  Text(phone),
                                  Text(country),
                                ],
                              ),
                              trailing: IconButton(
                                icon: Icon(Icons.arrow_forward_ios),
                                onPressed: () {
                                  // Implement call functionality here
                                },
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

  /*************  ✨ Windsurf Command ⭐  *************/
  /// Fetches a list of 20 random persons from the API and updates the state.
  /// If the fetch is successful, the list of persons is updated and the
  /// UI is rebuilt to display the new list. If the fetch fails, a message
  /// is printed to the console.

  /*******  8e0e54c6-4e0a-4364-a846-5d5815d52f92  *******/
  void fethPerson() {
    status = "Fetching persons...";
    setState(() {});
    http.get(Uri.parse('https://randomuser.me/api/?results=50')).then((
      response,
    ) {
      if (response.statusCode == 200) {
        // print(response.body);
        var data = response.body;
        //log(data);
        personList = [];
        personList = json.decode(data)['results'];
        log(personList.length.toString());
        // print(personList.toString());
        setState(() {});
      } else {
        print('Failed to load persons');
        status = "Failed to load persons. Please try again later.";
        setState(() {});
      }
    });
  }
}

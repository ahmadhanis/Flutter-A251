import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:midterm_prj/mylocation.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<MyLocation> myLocation = [];
  String status = "Loading..";
  late double screenWidth;
  late double screenHeight;
  String selectedState = "Perak";
  var states = [
    "Perak",
    "Selangor",
    "Pahang",
    "Negeri Sembilan",
    "Kelantan",
    "Terengganu",
    "Melaka",
    "Johor",
    "Kedah",
    "Perlis",
    "Sabah",
    "Sarawak",
    "Kuala Lumpur",
    "Labuan",
    "Putrajaya",
  ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadLocations();
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    if (screenWidth < 600) {
      screenWidth = 500;
    } else {
      screenWidth = 800;
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Visit Malaysia'),
        actions: [
          IconButton(
            onPressed: () {
              loadLocations();
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Center(
        child: SizedBox(
          width: screenWidth,
          child: Column(
            children: [
              Container(
                child: Column(
                  children: [
                    DropdownButtonFormField(
                      items: states
                          .map(
                            (e) => DropdownMenuItem(value: e, child: Text(e)),
                          )
                          .toList(),
                      value: selectedState,
                      onChanged: (value) {
                        setState(() {
                          selectedState = value.toString();
                          loadLocations();
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),

              myLocation.isEmpty
                  ? Center(child: Text(status))
                  : Expanded(
                      child: ListView.builder(
                        itemCount: myLocation.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            leading: SizedBox(
                              height: 50,
                              width: 50,
                              child: Image.network(
                                cacheHeight: 50,
                                cacheWidth: 50,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(
                                    Icons.error,
                                    color: Colors.red,
                                    size: 50,
                                  );
                                },
                                myLocation[index].imageUrl.toString(),
                              ),
                            ),
                            title: Text(myLocation[index].name.toString()),
                            subtitle: Text(myLocation[index].state.toString()),
                            trailing: IconButton(
                              onPressed: () {
                                loadLocationDetailsDialog(index);
                              },
                              icon: const Icon(Icons.arrow_forward_ios),
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

  void loadLocations() {
    // TODO: implement loadLocations
    http
        .get(
          Uri.parse(
            'https://slumberjer.com/teaching/a251/locations.php?state=$selectedState',
          ),
        )
        .then((response) {
          if (response.statusCode == 200) {
            var jsonData = jsonDecode(response.body);
            myLocation.clear();
            for (var item in jsonData) {
              myLocation.add(MyLocation.fromJson(item));
            }
            status = "";
            setState(() {});
            // myLocation = jsonData.map<MyLocation>((json) {
            //   return MyLocation.fromJson(json);
            // }).toList();
          }
        });
  }

  void loadLocationDetailsDialog(int index) {
    // TODO: implement loadLocationDetailsDialog
    showDialog(
      context: context,
      builder: (context) {
        return SizedBox(
          width: screenWidth * 0.9,
          child: AlertDialog(
            scrollable: true,
            title: Text(myLocation[index].name.toString()),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.network(
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.error, color: Colors.red, size: 50);
                  },
                  myLocation[index].imageUrl.toString(),
                ),
                Text(myLocation[index].state.toString()),
                Text(myLocation[index].category.toString()),
                Text(myLocation[index].description.toString()),
                Text(myLocation[index].contact.toString()),
                Text(myLocation[index].rating.toString()),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Close'),
              ),
            ],
          ),
        );
      },
    );
  }
}

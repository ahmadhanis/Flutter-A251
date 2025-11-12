import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:myfuwu/models/myservice.dart';
import 'package:myfuwu/myconfig.dart';
import 'package:myfuwu/views/loginpage.dart';
import 'package:myfuwu/models/user.dart';
import 'package:myfuwu/views/myservicepage.dart';

class MainPage extends StatefulWidget {
  final User? user;

  const MainPage({super.key, required this.user});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List<MyService> listServices = [];
  String status = "Loading...";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadServices();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Main Page'),
        actions: [
          IconButton(
            onPressed: () {
              loadServices();
            },
            icon: Icon(Icons.refresh),
          ),

          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
            icon: Icon(Icons.login),
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            listServices.isEmpty
                ? Center(child: Text(status))
                : Expanded(
                    child: ListView.builder(
                      itemCount: listServices.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                          elevation: 5,
                          child: ListTile(
                            // contentPadding: EdgeInsets.all(8),
                            leading: SizedBox(
                              child: Image.network(
                                '${MyConfig.baseUrl}/myfuwu/assets/services/service_${listServices[index].serviceId}.PNG',
                                fit: BoxFit.cover,
                              ),
                            ),
                            title: Text(
                              listServices[index].serviceTitle.toString(),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  listServices[index].serviceDesc.toString(),
                                ),
                                Text(
                                  listServices[index].serviceDistrict
                                      .toString(),
                                ),
                              ],
                            ),
                            trailing: IconButton(
                              onPressed: () {},
                              icon: Icon(Icons.arrow_forward_ios),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Action for the button
          if (widget.user?.userId == '0') {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Please login first/or register first"),
                backgroundColor: Colors.red,
              ),
            );
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const LoginPage()),
            );
          } else {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MyServicePage(user: widget.user),
              ),
            );
            loadServices();
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void loadServices() {
    // TODO: implement loadServices
    http.get(Uri.parse('${MyConfig.baseUrl}/myfuwu/api/loadservices.php')).then(
      (response) {
        if (response.statusCode == 200) {
          var jsonResponse = response.body;
          var data = jsonDecode(jsonResponse);
          listServices.clear();
          for (var item in data['data']) {
            listServices.add(MyService.fromJson(item));
          }
          setState(() {
            status = "";
          });
          // print(jsonResponse);
        } else {
          setState(() {
            status = "Failed to load services";
          });
        }
      },
    );
  }
}

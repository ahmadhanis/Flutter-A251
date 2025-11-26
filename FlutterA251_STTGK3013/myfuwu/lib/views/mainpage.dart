import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:myfuwu/models/myservice.dart';
import 'package:myfuwu/myconfig.dart';
import 'package:myfuwu/views/loginpage.dart';
import 'package:myfuwu/models/user.dart';
import 'package:myfuwu/shared/mydrawer.dart';
import 'package:myfuwu/views/newservicepage.dart';
import 'package:url_launcher/url_launcher.dart';

class MainPage extends StatefulWidget {
  final User? user;

  const MainPage({super.key, required this.user});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List<MyService> listServices = [];
  String status = "Loading...";
  DateFormat formatter = DateFormat('dd/MM/yyyy hh:mm a');
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadServices('');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Main Page'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearchDialog();
            },
          ),
          IconButton(
            onPressed: () {
              loadServices('');
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
                              onPressed: () async {
                                User owner;
                                //get service owner details before show details
                                owner = await getServiceOwnerDetails(index);
                                showDetailsDialog(index, owner);
                              },
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
                builder: (context) => NewServicePage(user: widget.user),
              ),
            );
            loadServices('');
          }
        },
        child: Icon(Icons.add),
      ),
      drawer: MyDrawer(user: widget.user),
    );
  }

  void loadServices(String searchQuery) {
    // TODO: implement loadServices
    http
        .get(
          Uri.parse(
            '${MyConfig.baseUrl}/myfuwu/api/loadservices.php?search=$searchQuery',
          ),
        )
        .then((response) {
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
        });
  }

  void showSearchDialog() {
    TextEditingController searchController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Search'),
          content: TextField(
            controller: searchController,
            decoration: InputDecoration(hintText: 'Enter search query'),
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Search'),
              onPressed: () {
                String search = searchController.text;
                if (search.isEmpty) {
                  loadServices('');
                } else {
                  loadServices(search);
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void showDetailsDialog(int index, User owner) {
    String formattedDate = formatter.format(
      DateTime.parse(listServices[index].serviceDate.toString()),
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(listServices[index].serviceTitle.toString()),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.network(
                  '${MyConfig.baseUrl}/myfuwu/assets/services/service_${listServices[index].serviceId}.PNG',
                  fit: BoxFit.cover,
                ),
                SizedBox(height: 10),
                Table(
                  border: TableBorder.all(
                    color: Colors.grey,
                    width: 1.0,
                    style: BorderStyle.solid,
                  ),
                  columnWidths: {
                    0: FixedColumnWidth(100.0),
                    1: FlexColumnWidth(),
                  },
                  children: [
                    TableRow(
                      children: [
                        TableCell(
                          // Use TableCell to apply consistent styling/padding
                          verticalAlignment: TableCellVerticalAlignment.middle,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('Title'),
                          ),
                        ),
                        TableCell(
                          verticalAlignment: TableCellVerticalAlignment.middle,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              listServices[index].serviceTitle.toString(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        TableCell(
                          verticalAlignment: TableCellVerticalAlignment.middle,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('Description'),
                          ),
                        ),
                        TableCell(
                          verticalAlignment: TableCellVerticalAlignment.middle,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              listServices[index].serviceDesc.toString(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        TableCell(
                          verticalAlignment: TableCellVerticalAlignment.middle,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('Type'),
                          ),
                        ),
                        TableCell(
                          verticalAlignment: TableCellVerticalAlignment.middle,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              listServices[index].serviceType.toString(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        TableCell(
                          verticalAlignment: TableCellVerticalAlignment.middle,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('District'),
                          ),
                        ),
                        TableCell(
                          verticalAlignment: TableCellVerticalAlignment.middle,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              listServices[index].serviceDistrict.toString(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        TableCell(
                          verticalAlignment: TableCellVerticalAlignment.middle,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('Rate'),
                          ),
                        ),
                        TableCell(
                          verticalAlignment: TableCellVerticalAlignment.middle,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              listServices[index].serviceRate.toString(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        TableCell(
                          verticalAlignment: TableCellVerticalAlignment.middle,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('Date'),
                          ),
                        ),
                        TableCell(
                          verticalAlignment: TableCellVerticalAlignment.middle,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(formattedDate),
                          ),
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        TableCell(
                          verticalAlignment: TableCellVerticalAlignment.middle,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('Provider'),
                          ),
                        ),
                        TableCell(
                          verticalAlignment: TableCellVerticalAlignment.middle,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(owner.userName.toString()),
                          ),
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        TableCell(
                          verticalAlignment: TableCellVerticalAlignment.middle,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('Phone'),
                          ),
                        ),
                        TableCell(
                          verticalAlignment: TableCellVerticalAlignment.middle,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(owner.userPhone.toString()),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                      onPressed: () async {
                        await launchUrl(
                          Uri.parse('tel:${owner.userPhone.toString()}'),
                          mode: LaunchMode.externalApplication,
                        );
                      },
                      icon: Icon(Icons.call),
                    ),
                    IconButton(
                      onPressed: () async {
                        await launchUrl(
                          Uri.parse(
                            'sms:${owner.userPhone.toString()}',
                          ),
                          mode: LaunchMode.externalApplication,
                        );
                      },
                      icon: Icon(Icons.message),
                    ),
                    IconButton(
                      onPressed: () async {
                        await launchUrl(
                          Uri.parse('mailto:${owner.userEmail.toString()}'),
                          mode: LaunchMode.externalApplication,
                        );
                      },
                      icon: Icon(Icons.email),
                    ),
                    IconButton(
                      onPressed: () async {
                        await launchUrl(
                          Uri.parse(
                            'https://wa.me/${owner.userPhone.toString()}',
                          ),
                          mode: LaunchMode.externalApplication,
                        );
                      },
                      icon: Icon(Icons.wechat),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<User> getServiceOwnerDetails(int index) async {
    String ownerid = listServices[index].userId.toString();
    User owner = User();
    try {
      final response = await http.get(
        Uri.parse(
          '${MyConfig.baseUrl}/myfuwu/api/getuserdetails.php?userid=$ownerid',
        ),
      );
      if (response.statusCode == 200) {
        var jsonResponse = response.body;
        var resarray = jsonDecode(jsonResponse);
        if (resarray['status'] == 'success') {
          owner = User.fromJson(resarray['data'][0]);
        }
      }
    } catch (e) {
      print('Error fetching user details: $e');
    }
    return owner;
  }
}

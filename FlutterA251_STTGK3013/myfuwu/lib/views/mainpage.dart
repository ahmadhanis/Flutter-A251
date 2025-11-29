import 'dart:convert';
import 'dart:developer';
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
  late double screenWidth, screenHeight;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadServices('');
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    if (screenWidth > 600) {
      screenWidth = 600;
    } else {
      screenWidth = screenWidth;
    }

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
        child: SizedBox(
          width: screenWidth,
          child: Column(
            children: [
              listServices.isEmpty
                  ? Expanded(
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.find_in_page_outlined, size: 64),
                            SizedBox(height: 12),
                            Text(
                              status,
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Expanded(
                      child: ListView.builder(
                        itemCount: listServices.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Card(
                            elevation: 4,
                            margin: const EdgeInsets.symmetric(
                              vertical: 6,
                              horizontal: 8,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // IMAGE
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Container(
                                      width:
                                          screenWidth * 0.28, // more responsive
                                      height:
                                          screenWidth *
                                          0.22, // balanced aspect ratio
                                      color: Colors.grey[200],
                                      child: Image.network(
                                        '${MyConfig.baseUrl}/myfuwu/assets/services/service_${listServices[index].serviceId}.PNG',
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                              return const Icon(
                                                Icons.broken_image,
                                                size: 60,
                                                color: Colors.grey,
                                              );
                                            },
                                      ),
                                    ),
                                  ),

                                  const SizedBox(width: 12),

                                  // TEXT AREA
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // TITLE
                                        Text(
                                          listServices[index].serviceTitle
                                              .toString(),
                                          style: const TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),

                                        const SizedBox(height: 4),

                                        // DESCRIPTION
                                        Text(
                                          listServices[index].serviceDesc
                                              .toString(),
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.black87,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),

                                        const SizedBox(height: 6),

                                        // DISTRICT TAG
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.blueGrey.withOpacity(
                                              0.15,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          child: Text(
                                            listServices[index].serviceDistrict
                                                .toString(),
                                            style: const TextStyle(
                                              fontSize: 13,
                                              color: Colors.blueGrey,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // TRAILING ARROW BUTTON
                                  IconButton(
                                    onPressed: () {
                                      showDetailsDialog(index);
                                    },
                                    icon: const Icon(
                                      Icons.arrow_forward_ios,
                                      size: 18,
                                    ),
                                  ),
                                ],
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
    listServices.clear();
    setState(() {
      status = "Loading...";
    });
    http
        .get(
          Uri.parse(
            '${MyConfig.baseUrl}/myfuwu/api/loadservices.php?search=$searchQuery',
          ),
        )
        .then((response) {
          if (response.statusCode == 200) {
            var jsonResponse = jsonDecode(response.body);

            if (jsonResponse['status'] == 'success' &&
                jsonResponse['data'] != null &&
                jsonResponse['data'].isNotEmpty) {
              // has data → load to list
              listServices.clear();
              for (var item in jsonResponse['data']) {
                listServices.add(MyService.fromJson(item));
              }

              setState(() {
                status = "";
              });
            } else {
              // success but EMPTY data
              setState(() {
                listServices.clear();
                status = "Not Available";
              });
            }
          } else {
            // request failed
            setState(() {
              listServices.clear();
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

  void showDetailsDialog(int index) {
    String formattedDate = formatter.format(
      DateTime.parse(listServices[index].serviceDate.toString()),
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(listServices[index].serviceTitle.toString()),
          content: SizedBox(
            width: screenWidth,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    child: Image.network(
                      '${MyConfig.baseUrl}/myfuwu/assets/services/service_${listServices[index].serviceId}.PNG',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.broken_image,
                          size: 128,
                          color: Colors.grey,
                        );
                      },
                    ),
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
                            verticalAlignment:
                                TableCellVerticalAlignment.middle,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('Title'),
                            ),
                          ),
                          TableCell(
                            verticalAlignment:
                                TableCellVerticalAlignment.middle,
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
                            verticalAlignment:
                                TableCellVerticalAlignment.middle,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('Description'),
                            ),
                          ),
                          TableCell(
                            verticalAlignment:
                                TableCellVerticalAlignment.middle,
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
                            verticalAlignment:
                                TableCellVerticalAlignment.middle,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('Type'),
                            ),
                          ),
                          TableCell(
                            verticalAlignment:
                                TableCellVerticalAlignment.middle,
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
                            verticalAlignment:
                                TableCellVerticalAlignment.middle,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('District'),
                            ),
                          ),
                          TableCell(
                            verticalAlignment:
                                TableCellVerticalAlignment.middle,
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
                            verticalAlignment:
                                TableCellVerticalAlignment.middle,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('Rate/Hour'),
                            ),
                          ),
                          TableCell(
                            verticalAlignment:
                                TableCellVerticalAlignment.middle,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'RM ${listServices[index].serviceRate}',
                              ),
                            ),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          TableCell(
                            verticalAlignment:
                                TableCellVerticalAlignment.middle,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('Date'),
                            ),
                          ),
                          TableCell(
                            verticalAlignment:
                                TableCellVerticalAlignment.middle,
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
                            verticalAlignment:
                                TableCellVerticalAlignment.middle,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('Provider'),
                            ),
                          ),
                          TableCell(
                            verticalAlignment:
                                TableCellVerticalAlignment.middle,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                listServices[index].userName.toString(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          TableCell(
                            verticalAlignment:
                                TableCellVerticalAlignment.middle,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('Phone'),
                            ),
                          ),
                          TableCell(
                            verticalAlignment:
                                TableCellVerticalAlignment.middle,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                listServices[index].userPhone.toString(),
                              ),
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
                            Uri.parse(
                              'tel:${listServices[index].userPhone.toString()}',
                            ),
                            mode: LaunchMode.externalApplication,
                          );
                        },
                        icon: Icon(Icons.call),
                      ),
                      IconButton(
                        onPressed: () async {
                          await launchUrl(
                            Uri.parse(
                              'sms:${listServices[index].userPhone.toString()}',
                            ),
                            mode: LaunchMode.externalApplication,
                          );
                        },
                        icon: Icon(Icons.message),
                      ),
                      IconButton(
                        onPressed: () async {
                          await launchUrl(
                            Uri.parse(
                              'mailto:${listServices[index].userEmail.toString()}',
                            ),
                            mode: LaunchMode.externalApplication,
                          );
                        },
                        icon: Icon(Icons.email),
                      ),
                      IconButton(
                        onPressed: () async {
                          await launchUrl(
                            Uri.parse(
                              'https://wa.me/${listServices[index].userPhone.toString()}',
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

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:myfuwu/models/myservice.dart';
import 'package:myfuwu/models/user.dart';
import 'package:myfuwu/myconfig.dart';
import 'package:myfuwu/shared/animated_route.dart';
import 'package:myfuwu/shared/mydrawer.dart';
import 'package:http/http.dart' as http;
import 'package:myfuwu/views/editservicepage.dart';
import 'package:myfuwu/views/loginpage.dart';
import 'package:myfuwu/views/newservicepage.dart';

class MyServicePage extends StatefulWidget {
  final User? user;

  const MyServicePage({super.key, this.user});

  @override
  State<MyServicePage> createState() => _MyServicePageState();
}

class _MyServicePageState extends State<MyServicePage> {
  List<MyService> myServices = [];
  late double screenWidth, screenHeight;
  String status = "Loading...";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loaduserservices();
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: () async {
        return await _showExitDialog();
      },
      child: Scaffold(
        appBar: buildModernAppBar(),
        body: widget.user!.userId.toString() == '0'
            ? buildNotLoggedInState(context)
            : Center(
                child: SizedBox(
                  width: screenWidth,
                  child: Column(
                    children: [
                      myServices.isEmpty
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
                                itemCount: myServices.length,
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // IMAGE
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                            child: Container(
                                              width:
                                                  screenWidth *
                                                  0.28, // more responsive
                                              height:
                                                  screenWidth *
                                                  0.22, // balanced aspect ratio
                                              color: Colors.grey[200],
                                              child: Image.network(
                                                '${MyConfig.baseUrl}/myfuwu/assets/services/service_${myServices[index].serviceId}.png',
                                                fit: BoxFit.cover,
                                                errorBuilder:
                                                    (
                                                      context,
                                                      error,
                                                      stackTrace,
                                                    ) {
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
                                                  myServices[index].serviceTitle
                                                      .toString(),
                                                  style: const TextStyle(
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),

                                                const SizedBox(height: 4),

                                                // DESCRIPTION
                                                Text(
                                                  myServices[index].serviceDesc
                                                      .toString(),
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.black87,
                                                  ),
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),

                                                const SizedBox(height: 6),

                                                // DISTRICT TAG
                                                Container(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 8,
                                                        vertical: 4,
                                                      ),
                                                  decoration: BoxDecoration(
                                                    color: Colors.blueGrey
                                                        .withOpacity(0.15),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          8,
                                                        ),
                                                  ),
                                                  child: Text(
                                                    myServices[index]
                                                        .serviceDistrict
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
                                          Column(
                                            children: [
                                              IconButton(
                                                onPressed: () {
                                                  MyService myService =
                                                      MyService.fromJson(
                                                        myServices[index]
                                                            .toJson(),
                                                      );
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          EditServicePage(
                                                            myService:
                                                                myService,
                                                          ),
                                                    ),
                                                  );
                                                },
                                                icon: const Icon(
                                                  Icons.edit,
                                                  size: 18,
                                                ),
                                              ),
                                              // TRAILING ARROW BUTTON
                                              IconButton(
                                                onPressed: () {
                                                  deleteDialog(index);
                                                },
                                                icon: const Icon(
                                                  Icons.delete,
                                                  size: 18,
                                                ),
                                              ),
                                            ],
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

        drawer: MyDrawer(user: widget.user),
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
              loaduserservices();
            }
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }

  AppBar buildModernAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: const Color(0xFF1F3C88),
      foregroundColor: Colors.white,
      titleSpacing: 16,

      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            "MyFuwu",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
          SizedBox(height: 2),
          Text(
            "MyServices",
            style: TextStyle(fontSize: 12, color: Colors.white70),
          ),
        ],
      ),

      actions: [
        _buildAppBarIcon(
          icon: Icons.refresh,
          tooltip: "Refresh",
          onTap: () => loaduserservices(),
        ),

        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildAppBarIcon({
    required IconData icon,
    required VoidCallback onTap,
    String? tooltip,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Tooltip(
          message: tooltip ?? '',
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 20),
          ),
        ),
      ),
    );
  }

  void loaduserservices() {
    // TODO: implement loaduserservices
    //implement progress dialog
    // showDialog(
    //   context: context,
    //   builder: (context) => const Center(child: CircularProgressIndicator()),
    //   barrierDismissible: false,
    // );
    setState(() {
      myServices.clear();
    });
    http
        .get(
          Uri.parse(
            '${MyConfig.baseUrl}/myfuwu/api/loaduserservices.php?userid=${widget.user!.userId} ',
          ),
        )
        .then((response) {
          // log(response.body);
          if (response.statusCode == 200) {
            var jsonResponse = jsonDecode(response.body);
            // log(jsonResponse.toString());
            if (jsonResponse['status'] == 'success' &&
                jsonResponse['data'] != null &&
                jsonResponse['data'].isNotEmpty) {
              // has data → load to list
              myServices.clear();
              for (var item in jsonResponse['data']) {
                myServices.add(MyService.fromJson(item));
              }
              setState(() {});
            }
          }
        });

    //remove progress dialog
    // Navigator.pop(context);
  }

  void deleteDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Delete"),
          content: const Text("Are you sure you want to delete this service?"),
          actions: [
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("Delete"),
              onPressed: () {
                deleteService(index);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget buildNotLoggedInState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.blueGrey.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.lock_outline,
                size: 56,
                color: Color(0xFF1F3C88),
              ),
            ),

            const SizedBox(height: 20),

            // Title
            const Text(
              "You're not logged in",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 8),

            // Subtitle
            Text(
              "Please login to access this feature and manage your services.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            ),

            const SizedBox(height: 24),

            // Action button
            SizedBox(
              width: 200,
              height: 45,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1F3C88),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.login),
                label: const Text(
                  "Login",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    AnimatedRoute.slideFromRight(const LoginPage()),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void deleteService(int index) {
    http
        .post(
          Uri.parse('${MyConfig.baseUrl}/myfuwu/api/deleteservice.php'),
          body: {
            'userid': widget.user!.userId.toString(),
            'serviceid': myServices[index].serviceId.toString(),
          },
        )
        .then((response) {
          log(response.body);
          if (response.statusCode == 200) {
            var jsonResponse = response.body;
            var resarray = jsonDecode(jsonResponse);
            if (resarray['status'] == 'success') {
              loaduserservices();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Service deleted successfully"),
                  backgroundColor: Colors.green,
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Service deletion failed"),
                  backgroundColor: Colors.red,
                ),
              );
            }
            setState(() {});
          }
        });
  }

  Future<bool> _showExitDialog() async {
    return await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Text("Exit App"),
            content: const Text("Are you sure you want to exit MyFuwu?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text("Exit"),
              ),
            ],
          ),
        ) ??
        false;
  }
}

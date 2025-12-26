// ignore_for_file: prefer_typing_uninitialized_variables

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
  int numofpage = 1;
  int curpage = 1;
  int numofresult = 0;
  var color;
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

    final contentWidth = screenWidth > 900 ? 900.0 : screenWidth;

    return WillPopScope(
      onWillPop: () async {
        return await _showExitDialog();
      },
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,

        // ────────────────── APP BAR ──────────────────
        appBar: buildModernAppBar(),

        // ────────────────── BODY ──────────────────
        body: Center(
          child: SizedBox(
            width: contentWidth,
            child: Column(
              children: [
                Expanded(
                  child: listServices.isEmpty
                      ? _buildEmptyState()
                      : _buildServiceList(),
                ),

                // ───────── PAGINATION ─────────
              ],
            ),
          ),
        ),
        // 🔥 MOVE PAGINATION HERE
        bottomNavigationBar: listServices.isNotEmpty
            ? Container(
                height: 56,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 6,
                      color: Colors.black.withValues(alpha: 0.08),
                    ),
                  ],
                ),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: numofpage,
                  itemBuilder: (context, index) {
                    final isActive = (curpage - 1) == index;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: isActive
                              ? const Color(0xFF1F3C88)
                              : Colors.grey.shade200,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          curpage = index + 1;
                          loadServices('');
                        },
                        child: Text(
                          '${index + 1}',
                          style: TextStyle(
                            color: isActive ? Colors.white : Colors.black,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              )
            : null,
        // ────────────────── FAB ──────────────────
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: const Color(0xFF2EC4B6),
          icon: const Icon(Icons.add),
          label: const Text("New Service"),
          onPressed: () async {
            if (widget.user?.userId == '0') {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Please login or register first"),
                  backgroundColor: Colors.red,
                ),
              );
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const LoginPage()),
              );
            } else {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => NewServicePage(user: widget.user),
                ),
              );
              loadServices('');
            }
          },
        ),

        drawer: MyDrawer(user: widget.user),
      ),
    );
  }

  Widget _buildServiceList() {
    return ListView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: listServices.length,
      itemBuilder: (context, index) {
        return Card(
          elevation: 3,
          margin: const EdgeInsets.symmetric(vertical: 6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: () => showDetailsDialog(index),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  // IMAGE
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      width: 110,
                      height: 90,
                      color: Colors.grey.shade200,
                      child: Image.network(
                        '${MyConfig.baseUrl}/myfuwu/assets/services/service_${listServices[index].serviceId}.png',
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const Icon(
                          Icons.camera_alt_outlined,
                          size: 40,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  // TEXT
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          listServices[index].serviceTitle.toString(),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          listServices[index].serviceDesc.toString(),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade700,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(
                              0xFF1F3C88,
                            ).withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            listServices[index].serviceDistrict.toString(),
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF1F3C88),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.search, size: 72, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            status.isEmpty ? "No services available" : status,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, color: Colors.grey.shade700),
          ),
        ],
      ),
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
            '${MyConfig.baseUrl}/myfuwu/api/loadservices.php?search=$searchQuery&curpage=$curpage',
          ),
        )
        .then((response) {
          if (response.statusCode == 200) {
            var jsonResponse = jsonDecode(response.body);
            log(jsonResponse.toString());
            if (jsonResponse['status'] == 'success' &&
                jsonResponse['data'] != null &&
                jsonResponse['data'].isNotEmpty) {
              // has data → load to list
              listServices.clear();
              for (var item in jsonResponse['data']) {
                listServices.add(MyService.fromJson(item));
              }
              numofpage = int.parse(jsonResponse['numofpage'].toString());
              numofresult = int.parse(
                jsonResponse['numberofresult'].toString(),
              );
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
            "Your One Stop Services",
            style: TextStyle(fontSize: 12, color: Colors.white70),
          ),
        ],
      ),

      actions: [
        _buildAppBarIcon(
          icon: Icons.search,
          tooltip: "Search",
          onTap: showSearchDialog,
        ),
        _buildAppBarIcon(
          icon: Icons.refresh,
          tooltip: "Refresh",
          onTap: () => loadServices(''),
        ),
        _buildAppBarIcon(
          icon: Icons.login,
          tooltip: "Login",
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => LoginPage()),
            );
          },
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
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 20),
          ),
        ),
      ),
    );
  }

  void showSearchDialog() {
    TextEditingController searchController = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // TITLE
                const Text(
                  "Search Services",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),

                const SizedBox(height: 12),

                // SEARCH FIELD
                TextField(
                  controller: searchController,
                  autofocus: true,
                  textInputAction: TextInputAction.search,
                  onSubmitted: (value) {
                    _performSearch(value);
                  },
                  decoration: InputDecoration(
                    hintText: "e.g. Cleaning, Plumbing, Repair",
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              searchController.clear();
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // ACTION BUTTONS
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Cancel"),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1F3C88),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        _performSearch(searchController.text);
                      },
                      child: const Text("Search"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _performSearch(String query) {
    Navigator.pop(context);

    if (query.trim().isEmpty) {
      loadServices('');
    } else {
      loadServices(query.trim());
    }
  }

  void showDetailsDialog(int index) {
    final service = listServices[index];
    final formattedDate = formatter.format(
      DateTime.parse(service.serviceDate.toString()),
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.85,
          minChildSize: 0.6,
          maxChildSize: 0.95,
          builder: (_, controller) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: SingleChildScrollView(
                controller: controller,
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // DRAG HANDLE
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade400,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),

                    // IMAGE
                    ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: AspectRatio(
                        aspectRatio: 5 / 3,
                        child: Image.network(
                          '${MyConfig.baseUrl}/myfuwu/assets/services/service_${service.serviceId}.png',
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            color: Colors.grey.shade200,
                            child: const Icon(
                              Icons.broken_image,
                              size: 80,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // TITLE
                    Text(
                      service.serviceTitle.toString(),
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 6),

                    // DISTRICT + RATE
                    Row(
                      children: [
                        _chip(
                          Icons.location_on,
                          service.serviceDistrict.toString(),
                        ),
                        const SizedBox(width: 8),
                        _chip(
                          Icons.attach_money,
                          "RM ${service.serviceRate}/hr",
                        ),
                      ],
                    ),

                    const SizedBox(height: 14),

                    // DESCRIPTION
                    Text(
                      service.serviceDesc.toString(),
                      style: const TextStyle(fontSize: 15),
                    ),

                    const SizedBox(height: 20),

                    const Divider(),

                    // INFO SECTION
                    _infoRow("Service Type", service.serviceType),
                    _infoRow("Posted On", formattedDate),
                    _infoRow("Provider", service.userName),
                    _infoRow("Phone", service.userPhone),
                    _infoRow("Email", service.userEmail),

                    const SizedBox(height: 20),

                    // CONTACT ACTIONS
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _actionIcon(
                          Icons.call,
                          () => launchUrl(
                            Uri.parse('tel:${service.userPhone}'),
                            mode: LaunchMode.externalApplication,
                          ),
                        ),
                        _actionIcon(
                          Icons.message,
                          () => launchUrl(
                            Uri.parse('sms:${service.userPhone}'),
                            mode: LaunchMode.externalApplication,
                          ),
                        ),
                        _actionIcon(
                          Icons.email,
                          () => launchUrl(
                            Uri.parse('mailto:${service.userEmail}'),
                            mode: LaunchMode.externalApplication,
                          ),
                        ),
                        _actionIcon(
                          Icons.wechat,
                          () => launchUrl(
                            Uri.parse('https://wa.me/${service.userPhone}'),
                            mode: LaunchMode.externalApplication,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _chip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.blueGrey.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.blueGrey),
          const SizedBox(width: 4),
          Text(text, style: const TextStyle(fontSize: 13)),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700,
              ),
            ),
          ),
          Expanded(child: Text(value ?? "-")),
        ],
      ),
    );
  }

  Widget _actionIcon(IconData icon, VoidCallback onTap) {
    return InkResponse(
      onTap: onTap,
      radius: 28,
      child: CircleAvatar(
        radius: 22,
        backgroundColor: Colors.blueGrey.withValues(alpha: 0.15),
        child: Icon(icon, color: Colors.blueGrey),
      ),
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
      log(e.toString());
    }
    return owner;
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

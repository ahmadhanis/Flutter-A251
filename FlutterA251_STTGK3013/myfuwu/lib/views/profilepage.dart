import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:myfuwu/models/user.dart';
import 'package:myfuwu/myconfig.dart';
import 'package:myfuwu/shared/mydrawer.dart';
import 'package:myfuwu/views/paymentpage.dart';

class ProfilePage extends StatefulWidget {
  User user;
  ProfilePage({super.key, required this.user});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();

  bool isLoading = false;
  String? latitude;
  String? longitude;
  DateFormat dateFormat = DateFormat('dd/MM/yyyy HH:mm a');

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() {
    nameController.text = widget.user.userName.toString() ?? '';
    phoneController.text = widget.user.userPhone ?? '';
    addressController.text = widget.user.userAddress ?? '';
    latitude = widget.user.userLatitude;
    longitude = widget.user.userLongitude;
  }

  // ================= LOCATION =================
  Future<void> _updateLocation() async {
    setState(() => isLoading = true);

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );
    Placemark place = placemarks.first;

    addressController.text =
        "${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.country}";
    latitude = position.latitude.toString();
    longitude = position.longitude.toString();

    setState(() => isLoading = false);
  }

  // ================= UPDATE PROFILE =================
  Future<void> _updateProfile() async {
    if (nameController.text.isEmpty ||
        phoneController.text.isEmpty ||
        addressController.text.isEmpty ||
        latitude == null ||
        longitude == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill in all fields"),
          backgroundColor: Colors.red,
        ),
      );
      setState(() => isLoading = false);
      return;
    }
    setState(() => isLoading = true);
    final response = await http.post(
      Uri.parse('${MyConfig.baseUrl}/myfuwu/api/updateprofile.php'),
      body: {
        'user_id': widget.user.userId,
        'user_name': nameController.text,
        'user_phone': phoneController.text,
        'user_address': addressController.text,
        'user_latitude': latitude,
        'user_longitude': longitude,
      },
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['status'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Profile updated successfully"),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(data['message'] ?? "Update failed"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
    loadProfile();
    setState(() => isLoading = false);
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width > 500
        ? 500.0
        : MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF1F3C88),
        foregroundColor: Colors.white,
        titleSpacing: 16,

        title: const Text(
          "My Profile",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),

        actions: [
          IconButton(
            onPressed: () {
              loadProfile();
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Stack(
        children: [
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: width),
                child: Card(
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        // AVATAR
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: const Color(0xFF1F3C88),
                          child: Text(
                            widget.user.userName
                                    ?.substring(0, 1)
                                    .toUpperCase() ??
                                '',
                            style: const TextStyle(
                              fontSize: 32,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        _readonlyField("User ID", widget.user.userId),
                        _readonlyField("Email", widget.user.userEmail),
                        _readonlyField(
                          "Registered",
                          dateFormat.format(
                            DateTime.parse(
                              widget.user.userRegdate ?? '0000-00-00',
                            ),
                          ),
                        ),
                        const Divider(height: 30),

                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.06),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Header
                              Row(
                                children: [
                                  const Icon(
                                    Icons.account_balance_wallet_outlined,
                                    color: Color(0xFF1F3C88),
                                  ),
                                  const SizedBox(width: 8),
                                  const Text(
                                    "My Credit",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 12),

                              // Credit value
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    widget.user.userCredit?.toString() ?? '0',
                                    style: const TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF1F3C88),
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    "credits",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                  const Spacer(),

                                  // Buy Credit button
                                  ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF1F3C88),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 14,
                                        vertical: 10,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    icon: const Icon(Icons.add, size: 18),
                                    label: const Text(
                                      "Buy",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    onPressed: () {
                                      // TODO: navigate to Buy Credit page
                                      showBuyCreditDialog();
                                    },
                                  ),
                                ],
                              ),

                              const SizedBox(height: 6),

                              // Hint
                              Text(
                                "Credits are used to post or promote services",
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Divider(height: 30),
                        const SizedBox(height: 8),
                        _inputField(
                          controller: nameController,
                          label: "Name",
                          icon: Icons.person,
                          keyboard: TextInputType.name,
                        ),
                        const SizedBox(height: 12),
                        _inputField(
                          controller: phoneController,
                          label: "Phone Number",
                          icon: Icons.phone_outlined,
                          keyboard: TextInputType.phone,
                        ),

                        const SizedBox(height: 12),

                        TextField(
                          controller: addressController,
                          maxLines: 3,
                          decoration: InputDecoration(
                            labelText: "Address",
                            prefixIcon: const Icon(Icons.location_on_outlined),
                            suffixIcon: IconButton(
                              tooltip: "Use current location",
                              icon: const Icon(Icons.my_location),
                              onPressed: () async {
                                Position mypostion = await _determinePosition();
                                final placemarks =
                                    await placemarkFromCoordinates(
                                      mypostion.latitude,
                                      mypostion.longitude,
                                    );
                                final place = placemarks.first;
                                addressController.text =
                                    "${place.name}, ${place.street},\n"
                                    "${place.postalCode} ${place.locality}, "
                                    "${place.administrativeArea}, ${place.country}";
                                latitude = mypostion.latitude.toString();
                                longitude = mypostion.longitude.toString();
                                setState(() {});
                              },
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1F3C88),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: _updateProfile,
                            child: const Text(
                              "Save Changes",

                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // LOADING OVERLAY
          if (isLoading)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
      drawer: MyDrawer(user: widget.user),
    );
  }

  // ================= HELPERS =================
  Widget _readonlyField(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextField(
        readOnly: true,
        controller: TextEditingController(text: value ?? "-"),
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: const Icon(Icons.lock_outline),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  void showBuyCreditDialog() {
    int selectedCredit = 10;

    final Map<int, double> creditPriceMap = {
      5: 5.0,
      10: 10.0,
      15: 15.0,
      20: 20.0,
      30: 30.0,
      40: 40.0,
      50: 50.0,
      100: 100.0,
    };

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Row(
                children: const [
                  Icon(
                    Icons.account_balance_wallet_outlined,
                    color: Color(0xFF1F3C88),
                  ),
                  SizedBox(width: 8),
                  Text("Buy Credits"),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Select a credit package",
                    style: TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 12),

                  // DROPDOWN
                  DropdownButtonFormField<int>(
                    initialValue: selectedCredit,
                    decoration: InputDecoration(
                      labelText: "Credit Amount",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    items: creditPriceMap.keys.map((credit) {
                      return DropdownMenuItem<int>(
                        value: credit,
                        child: Text("$credit credits"),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setDialogState(() {
                        selectedCredit = value!;
                      });
                    },
                  ),

                  const SizedBox(height: 16),

                  // PRICE DISPLAY
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        const Text("Total:", style: TextStyle(fontSize: 15)),
                        const Spacer(),
                        Text(
                          "RM ${creditPriceMap[selectedCredit]!.toStringAsFixed(2)}",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1F3C88),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1F3C88),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () async {
                    Navigator.pop(context);

                    // TODO: send selectedCredit & amount to payment page
                    // Example:
                    if (widget.user != null) {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PaymentPage(
                            user: widget.user!,
                            credits: selectedCredit,
                          ),
                        ),
                      );
                    }
                    loadProfile();
                  },
                  child: const Text(
                    "Continue",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _inputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboard = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboard,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.',
      );
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    setState(() {
      addressController.text = "Searching...";
    });

    return await Geolocator.getCurrentPosition();
  }

  void loadProfile() {
    http
        .get(
          Uri.parse(
            '${MyConfig.baseUrl}/myfuwu/api/getuserdetails.php?userid=${widget.user.userId}',
          ),
        )
        .then((response) {
          if (response.statusCode == 200) {
            var jsonResponse = response.body;
            var resarray = jsonDecode(jsonResponse);
            log(response.body);
            if (resarray['status'] == 'success') {
              //print(resarray['data'][0]);
              User user = User.fromJson(resarray['data'][0]);
              widget.user = user;
              setState(() {});
            }
          }
          // Handle successful login here
        });
  }
}

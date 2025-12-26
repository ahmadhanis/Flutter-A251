import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myfuwu/models/user.dart';
import 'package:myfuwu/myconfig.dart';

class NewServicePage extends StatefulWidget {
  final User? user;

  const NewServicePage({super.key, required this.user});

  @override
  State<NewServicePage> createState() => _MyServicePageState();
}

class _MyServicePageState extends State<NewServicePage> {
  List<String> myservices = [
    'Cleaning',
    'Plumbing',
    'Electrical',
    'Painting',
    'Car Service',
    'Gardening',
    'Handyman',
    'Installation',
    'Maid Service',
    'Other',
  ];

  List<String> kdhdistricts = [
    'Kubang Pasu',
    'Bukit Kayu Hitam',
    'Baling',
    'Bandar Baru',
    'Kota Setar',
    'Kuala Muda',
    'Padang Terap',
    'Pokok Sena',
    'Yan',
    'Sik',
  ];
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController hourlyrateController = TextEditingController();
  String selectedservice = 'Cleaning';
  String selecteddistrict = 'Kubang Pasu';
  File? image;
  Uint8List? webImage; // for web
  late double height, width;

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final screenWidth = media.size.width;
    final screenHeight = media.size.height;
    final maxWidth = screenWidth > 600 ? 600.0 : screenWidth;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: const Color(0xFF1F3C88),
        title: const Text(
          "Create Service",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // IMAGE CARD
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: GestureDetector(
                    onTap: () {
                      if (kIsWeb) {
                        openGallery();
                      } else {
                        pickimagedialog();
                      }
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        height: screenHeight * 0.28,
                        color: Colors.grey.shade200,
                        child: _buildImagePreview(),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // FORM CARD
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        _inputField(
                          controller: titleController,
                          label: "Service Title",
                          icon: Icons.title,
                        ),
                        const SizedBox(height: 12),

                        DropdownButtonFormField<String>(
                          value: selectedservice,
                          decoration: _dropdownDecoration(
                            "Service Category",
                            Icons.design_services_outlined,
                          ),
                          items: myservices
                              .map(
                                (s) =>
                                    DropdownMenuItem(value: s, child: Text(s)),
                              )
                              .toList(),
                          onChanged: (v) =>
                              setState(() => selectedservice = v!),
                        ),

                        const SizedBox(height: 12),

                        DropdownButtonFormField<String>(
                          value: selecteddistrict,
                          decoration: _dropdownDecoration(
                            "Service Location",
                            Icons.location_on_outlined,
                          ),
                          items: kdhdistricts
                              .map(
                                (d) =>
                                    DropdownMenuItem(value: d, child: Text(d)),
                              )
                              .toList(),
                          onChanged: (v) =>
                              setState(() => selecteddistrict = v!),
                        ),

                        const SizedBox(height: 12),

                        _inputField(
                          controller: hourlyrateController,
                          label: "Hourly Rate (RM)",
                          icon: Icons.attach_money,
                          keyboard: TextInputType.number,
                        ),

                        const SizedBox(height: 12),

                        TextField(
                          controller: descriptionController,
                          maxLines: 4,
                          decoration: InputDecoration(
                            labelText: "Service Description",
                            prefixIcon: const Icon(Icons.description_outlined),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // SUBMIT BUTTON
                SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1F3C88),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: showSubmitDialog,
                    child: const Text(
                      "Submit Service",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImagePreview() {
    if (image != null && !kIsWeb) {
      return Image.file(image!, fit: BoxFit.cover);
    } else if (webImage != null) {
      return Image.memory(webImage!, fit: BoxFit.cover);
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Icon(Icons.camera_alt_outlined, size: 72, color: Colors.grey),
        SizedBox(height: 10),
        Text(
          "Tap to add image",
          style: TextStyle(color: Colors.grey, fontSize: 15),
        ),
      ],
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

  InputDecoration _dropdownDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    );
  }

  void pickimagedialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag handle
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),

              const Text(
                "Add Image",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              Text(
                "Choose image source",
                style: TextStyle(color: Colors.grey.shade600),
              ),

              const SizedBox(height: 20),

              _imageOption(
                icon: Icons.camera_alt_outlined,
                label: "Take Photo",
                onTap: () {
                  Navigator.pop(context);
                  openCamera();
                },
              ),

              const SizedBox(height: 12),

              _imageOption(
                icon: Icons.photo_library_outlined,
                label: "Choose from Gallery",
                onTap: () {
                  Navigator.pop(context);
                  openGallery();
                },
              ),

              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  Widget _imageOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Icon(icon, size: 26, color: const Color(0xFF1F3C88)),
            const SizedBox(width: 16),
            Text(
              label,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> openCamera() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      if (kIsWeb) {
        webImage = await pickedFile.readAsBytes();
        setState(() {});
      } else {
        image = File(pickedFile.path);
        cropImage();
      }
    }
  }

  Future<void> openGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      if (kIsWeb) {
        webImage = await pickedFile.readAsBytes();
        setState(() {});
      } else {
        image = File(pickedFile.path);
        cropImage(); // only for mobile
      }
    }
  }

  Future<void> cropImage() async {
    if (kIsWeb) return; // skip cropping on web
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: image!.path,
      aspectRatio: CropAspectRatio(ratioX: 5, ratioY: 3),
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Please Crop Your Image',
          toolbarColor: Colors.deepPurple,
          toolbarWidgetColor: Colors.white,
        ),
        IOSUiSettings(title: 'Cropper'),
      ],
    );

    if (croppedFile != null) {
      image = File(croppedFile.path);
      setState(() {});
    }
  }

  void showSubmitDialog() {
    // Title validation
    if (titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter title"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Image validation: mobile uses image, web uses webImage
    if (!kIsWeb && image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select an image"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (kIsWeb && webImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select an image"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Hourly rate
    if (hourlyrateController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter hourly rate"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Description
    if (descriptionController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter description"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Confirm dialog
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Submit Service'),
          content: const Text('Are you sure you want to submit this service?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                submitService();
              },
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  void submitService() {
    String base64image = "";
    if (kIsWeb) {
      base64image = base64Encode(webImage!);
    } else {
      base64image = base64Encode(image!.readAsBytesSync());
    }
    String title = titleController.text.trim();
    String description = descriptionController.text.trim();
    String hourlyrate = hourlyrateController.text.trim();

    http
        .post(
          Uri.parse('${MyConfig.baseUrl}/myfuwu/api/insertservice.php'),
          body: {
            'userid': widget.user?.userId,
            'title': title,
            'service': selectedservice,
            'district': selecteddistrict,
            'hourlyrate': hourlyrate,
            'description': description,
            'image': base64image,
          },
        )
        .then((response) {
          print(response.body);
          if (response.statusCode == 200) {
            var jsonResponse = response.body;
            var resarray = jsonDecode(jsonResponse);
            if (resarray['status'] == 'success') {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Service submitted successfully"),
                  backgroundColor: Colors.green,
                ),
              );
              Navigator.pop(context);
            } else {
              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(resarray['message']),
                  backgroundColor: Colors.red,
                ),
              );
            }
          }
        });
  }
}

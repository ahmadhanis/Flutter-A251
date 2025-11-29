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
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    if (width > 600) {
      width = 600;
    } else {
      width = width;
    }
    return Scaffold(
      appBar: AppBar(title: Text('My Service Page')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            width: width,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      if (kIsWeb) {
                        openGallery();
                      } else {
                        pickimagedialog();
                      }
                    },
                    child: Container(
                      width: width,
                      height: height / 3,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.grey.shade200,
                        border: Border.all(color: Colors.grey.shade400),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                        image: (image != null && !kIsWeb)
                            ? DecorationImage(
                                image: FileImage(image!),
                                fit: BoxFit.cover,
                              )
                            : (webImage != null)
                            ? DecorationImage(
                                image: MemoryImage(webImage!),
                                fit: BoxFit.cover,
                              )
                            : null, // no image → show icon instead
                      ),

                      // If no image selected → show camera icon
                      child: (image == null && webImage == null)
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(
                                  Icons.camera_alt,
                                  size: 80,
                                  color: Colors.grey,
                                ),
                                SizedBox(height: 10),
                                Text(
                                  "Tap to add image",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            )
                          : null,
                    ),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: titleController,
                    decoration: InputDecoration(
                      labelText: 'Title',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Select Services',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    items: myservices.map((String selectserv) {
                      return DropdownMenuItem<String>(
                        value: selectserv,
                        child: Text(selectserv),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedservice = newValue!;
                        print(selectedservice);
                      });
                    },
                  ),

                  SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Select Location',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    items: kdhdistricts.map((String location) {
                      return DropdownMenuItem<String>(
                        value: location,
                        child: Text(location),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selecteddistrict = newValue!;
                      });
                    },
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: hourlyrateController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Hourly Rate',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: descriptionController,
                    decoration: InputDecoration(
                      labelText: 'Description',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueGrey,
                      minimumSize: Size(width, 50),

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      showSubmitDialog();
                    },
                    child: Text(
                      'Submit',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void pickimagedialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Pick Image'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text('Camera'),
                onTap: () {
                  Navigator.pop(context);
                  openCamera();
                },
              ),
              ListTile(
                leading: Icon(Icons.image),
                title: Text('Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  openGallery();
                },
              ),
            ],
          ),
        );
      },
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

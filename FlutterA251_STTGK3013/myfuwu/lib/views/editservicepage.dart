import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myfuwu/models/myservice.dart';
import 'package:myfuwu/myconfig.dart';

class EditServicePage extends StatefulWidget {
  final MyService myService;

  const EditServicePage({super.key, required this.myService});

  @override
  State<EditServicePage> createState() => _EditServicePageState();
}

class _EditServicePageState extends State<EditServicePage> {
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
  void initState() {
    // TODO: implement initState
    super.initState();
    titleController.text = widget.myService.serviceTitle!;
    descriptionController.text = widget.myService.serviceDesc!;
    hourlyrateController.text = widget.myService.serviceRate!;
    selectedservice = widget.myService.serviceType!;
    selecteddistrict = widget.myService.serviceDistrict!;
    print(selectedservice);
    print(selecteddistrict);
    setState(() {});
  }

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
      appBar: AppBar(title: Text('Edit My Service')),
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
                          ? Image.network(
                              '${MyConfig.baseUrl}/myfuwu/assets/services/service_${widget.myService.serviceId}.png',
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(
                                  Icons.broken_image,
                                  size: 60,
                                  color: Colors.grey,
                                );
                              },
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
                    initialValue: selectedservice,
                    decoration: const InputDecoration(
                      labelText: "Select Service",
                      border: OutlineInputBorder(),
                    ),
                    items: myservices.map((String value) {
                      return DropdownMenuItem(value: value, child: Text(value));
                    }).toList(),
                    onChanged: (val) => setState(() => selectedservice = val!),
                  ),

                  SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    initialValue: selecteddistrict,
                    decoration: const InputDecoration(
                      labelText: "Select Location",
                      border: OutlineInputBorder(),
                    ),
                    items: kdhdistricts.map((String value) {
                      return DropdownMenuItem(value: value, child: Text(value));
                    }).toList(),
                    onChanged: (val) => setState(() => selecteddistrict = val!),
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

    String title = titleController.text.trim();
    String description = descriptionController.text.trim();
    String hourlyrate = hourlyrateController.text.trim();
    if (kIsWeb) {
      if (webImage != null) {
        base64image = base64Encode(webImage!);
      } else {
        base64image = "NA";
      }
    } else {
      if (image == null) {
        base64image = "NA";
      } else {
        base64image = base64Encode(image!.readAsBytesSync());
      }
    }
    http
        .post(
          Uri.parse('${MyConfig.baseUrl}/myfuwu/api/updateservice.php'),
          body: {
            'userid': widget.myService.userId,
            'title': title,
            'serviceid': widget.myService.serviceId,
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

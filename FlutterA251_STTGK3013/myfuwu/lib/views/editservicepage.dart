import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:myfuwu/models/myservice.dart';

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
                        // openGallery();
                      } else {
                        // pickimagedialog();
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
                      // showSubmitDialog();
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
}

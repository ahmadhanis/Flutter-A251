import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myfuwu/models/user.dart';

class MyServicePage extends StatefulWidget {
  final User? user;

  const MyServicePage({super.key, required this.user});

  @override
  State<MyServicePage> createState() => _MyServicePageState();
}

class _MyServicePageState extends State<MyServicePage> {
  List<String> myservices = [
    'Cleaning',
    'Plumbing',
    'Electrical',
    'Painting',
    'Car Service',
    'Gardening',
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

  String selectedservice = 'Cleaning';
  String selecteddistrict = 'Kubang Pasu';
  File? image;
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
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    pickimagedialog();
                  },
                  child: Container(
                    height: height / 3,
                    alignment: Alignment.center,
                    width: width,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text('Upload Image'),
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  alignment: Alignment.center,
                  width: width,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: DropdownButton(
                    itemHeight: 50,
                    items: myservices.map((selectServ) {
                      return DropdownMenuItem(
                        value: selectServ,
                        child: Text(selectServ),
                      );
                    }).toList(),

                    onChanged: (value) {
                      setState(() {
                        selectedservice = value!;
                      });
                    },
                    value: selectedservice,
                  ),
                ),
                SizedBox(height: 5),
                Container(
                  alignment: Alignment.center,
                  width: width,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: DropdownButton(
                    items: kdhdistricts.map((selectLoc) {
                      return DropdownMenuItem(
                        value: selectLoc,
                        child: Text(selectLoc),
                      );
                    }).toList(),

                    onChanged: (value) {
                      setState(() {
                        selecteddistrict = value!;
                      });
                    },
                    value: selecteddistrict,
                  ),
                ),
                SizedBox(height: 5),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Hourly Rate',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(width, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {},
                  child: Text('Submit'),
                ),
              ],
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
    final pickedFile = await picker.pickImage(
      source: ImageSource.camera,
      maxHeight: 800,
      maxWidth: 800,
    );

    if (pickedFile != null) {
      setState(() => image = File(pickedFile.path));
    }
  }

  Future<void> openGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 800,
      maxWidth: 800,
    );

    if (pickedFile != null) {
      setState(() => image = File(pickedFile.path));
    }
  }
}

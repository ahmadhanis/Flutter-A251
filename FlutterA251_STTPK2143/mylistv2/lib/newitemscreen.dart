import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class NewItemScreen extends StatefulWidget {
  const NewItemScreen({super.key});

  @override
  State<NewItemScreen> createState() => _NewItemScreenStateState();
}

class _NewItemScreenStateState extends State<NewItemScreen> {
  late double screenHeight;
  late double screenWidth;
  File? image;
  Uint8List? webImageBytes;

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth > 600) {
      screenWidth = 600;
    } else {
      screenWidth = screenWidth;
    }

    return Scaffold(
      appBar: AppBar(title: Text("Add Item")),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: screenWidth,
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      selectCameraGalleryDialog();
                    },
                    child: Container(
                      // margin: const EdgeInsets.all(8),
                      height: screenHeight / 3,
                      decoration: BoxDecoration(
                        border: Border.all(width: 1),
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          alignment: Alignment.center,
                          scale:
                              0.5, // The lower the number, the LARGER the image will appear.
                          image: image == null
                              ? AssetImage("assets/camera128.png")
                              : FileImage(image!),
                          fit: BoxFit
                              .contain, // <--- Change this from .cover to .none
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Item Name',
                    ),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Item Description',
                    ),
                    maxLines: 4,
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      minimumSize: Size(screenWidth, 50),
                    ),
                    child: Text("Save"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void selectCameraGalleryDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Select Image"),
          content: const Text("Choose from Camera or Gallery"),
          actions: [
            TextButton(
              child: const Text("Camera"),
              onPressed: () {
                Navigator.of(context).pop();
                openCamera();
              },
            ),
            TextButton(
              child: const Text("Gallery"),
              onPressed: () {
                Navigator.of(context).pop();
                openGallery();
              },
            ),
          ],
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
      image = File(pickedFile.path);
      cropImage();
      // setState(() => image = File(pickedFile.path));
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
      image = File(pickedFile.path);
      cropImage();
      // setState(() => image = File(pickedFile.path));
    }
  }

  Future<void> cropImage() async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: image!.path,
      aspectRatio: const CropAspectRatio(ratioX: 5, ratioY: 3),
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Please Crop Your Image',
          toolbarColor: Colors.deepPurple,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
        ),
        IOSUiSettings(title: 'Cropper'),
      ],
    );
    if (croppedFile != null) {
      File imageFile = File(croppedFile.path);
      image = imageFile;
      setState(() {});
    }
  }
}

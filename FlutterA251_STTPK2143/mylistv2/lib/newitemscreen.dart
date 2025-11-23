import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mylistv2/databasehelper.dart';
import 'package:mylistv2/mylist.dart';
import 'package:path_provider/path_provider.dart';

class NewItemScreen extends StatefulWidget {
  const NewItemScreen({super.key});

  @override
  State<NewItemScreen> createState() => _NewItemScreenStateState();
}

class _NewItemScreenStateState extends State<NewItemScreen> {
  late double screenHeight;
  late double screenWidth;
  File? image;
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  DateFormat formatter = DateFormat('dd/MM/yyyy HH:mm:ss');

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
      appBar: AppBar(title: Text("Add To MyList")),
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
                    controller: titleController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'List Title',
                    ),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: descriptionController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'List Description',
                    ),
                    maxLines: 4,
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      showConfirmDialog();
                    },
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

  void showConfirmDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Save Item"),
          content: const Text("Are you sure you want to save this item?"),
          actions: [
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("Save"),
              onPressed: () {
                saveItem();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> saveItem() async {
    String title = titleController.text;
    String description = descriptionController.text;

    // Directory where images should be stored permanently
    Directory appDir = await getApplicationDocumentsDirectory();

    // Default image path stored in DB
    String storedImagePath = "NA";

    if (image != null) {
      // Generate unique name
      String imageName = "${DateTime.now().millisecondsSinceEpoch}.png";

      // Full file path inside app directory
      storedImagePath = "${appDir.path}/$imageName";

      // Copy the image from cache to the app directory
      await image!.copy(storedImagePath);
    }
    String date = DateFormat('dd/MM/yyyy HH:mm a').format(DateTime.now());
    // Save item to SQLite
    await DatabaseHelper().insertMyList(
      MyList(
        0,
        title,
        description,
        "Pending",
        date,
        storedImagePath, // <-- this is NOW correct!
      ),
    );

    // Show success snackbar
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Item saved successfully")));
    }

    // Go back to main screen
    if (mounted) {
      Navigator.pop(context);
    }
  }
}

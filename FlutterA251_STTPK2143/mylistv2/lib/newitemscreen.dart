// --------------------------------------------------------------
// NEW & IMPROVED UI FOR ADDING NEW ITEM (Modern + Responsive)
// --------------------------------------------------------------

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
  State<NewItemScreen> createState() => _NewItemScreenState();
}

class _NewItemScreenState extends State<NewItemScreen> {
  late double screenHeight;
  late double screenWidth;

  File? image;

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final DateFormat formatter = DateFormat('dd/MM/yyyy HH:mm a');

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth > 600) screenWidth = 600;

    return Scaffold(
      // 🌈 Purple gradient header background
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF8E3B8E), Color(0xFF6A1B9A)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Row(
                children: [
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                ],
              ),
              // -------------------------------
              // HEADER
              // -------------------------------
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Text(
                  "Add New Entry",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.0,
                  ),
                ),
              ),

              // -------------------------------
              // FORM SECTION (white rounded container)
              // -------------------------------
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(30),
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        // -----------------------------------
                        // IMAGE PICKER BOX
                        // -----------------------------------
                        GestureDetector(
                          onTap: selectCameraGalleryDialog,
                          child: Container(
                            height: screenHeight * 0.25,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: image == null
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.camera_alt,
                                        size: 70,
                                        color: Colors.grey.shade600,
                                      ),
                                      const SizedBox(height: 8),
                                      const Text(
                                        "Tap to add image",
                                        style: TextStyle(
                                          color: Colors.black54,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  )
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(18),
                                    child: Image.file(
                                      image!,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // -----------------------------------
                        // Title Input
                        // -----------------------------------
                        TextField(
                          controller: titleController,
                          decoration: InputDecoration(
                            labelText: "List Title",
                            prefixIcon: const Icon(Icons.title),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),

                        // -----------------------------------
                        // Description Input
                        // -----------------------------------
                        TextField(
                          controller: descriptionController,
                          maxLines: 4,
                          decoration: InputDecoration(
                            labelText: "Description",
                            prefixIcon: const Icon(Icons.description),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                        ),

                        const SizedBox(height: 15),

                        // -----------------------------------
                        // CURRENT DATE
                        // -----------------------------------
                        Row(
                          children: [
                            const Icon(
                              Icons.calendar_month,
                              color: Colors.deepPurple,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              "Date: ${formatter.format(DateTime.now())}",
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        // -----------------------------------
                        // SAVE BUTTON
                        // -----------------------------------
                        SizedBox(
                          width: double.infinity,
                          height: 55,
                          child: ElevatedButton(
                            onPressed: showConfirmDialog,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF8E3B8E),
                              foregroundColor: Colors.white,
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            child: const Text(
                              "Save Entry",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ----------------------------------------------------
  // IMAGE SELECTION DIALOG
  // ----------------------------------------------------
  void selectCameraGalleryDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Title
              const Text(
                "Choose Image Source",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 20),

              // Camera + Gallery options
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // CAMERA OPTION
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      openCamera();
                    },
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFF8E3B8E).withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Icon(
                            Icons.camera_alt_rounded,
                            color: Color(0xFF8E3B8E),
                            size: 40,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text("Camera"),
                      ],
                    ),
                  ),

                  // GALLERY OPTION
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      openGallery();
                    },
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFF6A1B9A).withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Icon(
                            Icons.photo_library_rounded,
                            color: Color(0xFF6A1B9A),
                            size: 40,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text("Gallery"),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 25),

              // CANCEL BUTTON
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  "Cancel",
                  style: TextStyle(color: Colors.black54, fontSize: 16),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // CAMERA
  Future<void> openCamera() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.camera,
      maxHeight: 900,
    );

    if (pickedFile != null) {
      image = File(pickedFile.path);
      cropImage();
    }
  }

  // GALLERY
  Future<void> openGallery() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      image = File(pickedFile.path);
      cropImage();
    }
  }

  // IMAGE CROPPER
  Future<void> cropImage() async {
    CroppedFile? cropped = await ImageCropper().cropImage(
      sourcePath: image!.path,
      aspectRatio: const CropAspectRatio(ratioX: 5, ratioY: 3),
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: "Crop Image",
          toolbarColor: Colors.deepPurple,
          toolbarWidgetColor: Colors.white,
        ),
        IOSUiSettings(title: "Crop Image"),
      ],
    );

    if (cropped != null) {
      image = File(cropped.path);
      setState(() {});
    }
  }

  // ----------------------------------------------------
  // SAVE CONFIRMATION
  // ----------------------------------------------------
  void showConfirmDialog() {
    if (titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please enter a title.")));
      return;
    }

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          child: Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header Icon
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF8E3B8E).withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.save_rounded,
                    size: 40,
                    color: Color(0xFF8E3B8E),
                  ),
                ),

                const SizedBox(height: 18),

                // Title
                const Text(
                  "Confirm Save",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 10),

                Text(
                  "Do you want to save this entry to your list?",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15, color: Colors.grey[700]),
                ),

                const SizedBox(height: 24),

                // ACTION BUTTONS (Cancel + Save)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Cancel button
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFF8E3B8E)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: () => Navigator.pop(context),
                        child: const Text(
                          "Cancel",
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF8E3B8E),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    // Save button
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF8E3B8E),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          saveItem();
                        },
                        child: const Text(
                          "Save",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
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

  // ----------------------------------------------------
  // SAVE ITEM TO SQLITE
  // ----------------------------------------------------
  Future<void> saveItem() async {
    Directory appDir = await getApplicationDocumentsDirectory();
    String storedImagePath = "NA";

    if (image != null) {
      String imageName = "${DateTime.now().millisecondsSinceEpoch}.png";
      storedImagePath = "${appDir.path}/$imageName";
      await image!.copy(storedImagePath);
    }

    await DatabaseHelper().insertMyList(
      MyList(
        0,
        titleController.text,
        descriptionController.text,
        "Pending",
        formatter.format(DateTime.now()),
        storedImagePath,
      ),
    );

    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Entry saved successfully")));
      Navigator.pop(context);
    }
  }
}

import 'package:flutter/material.dart';
import 'package:native_camera_view/camera_controller.dart';
import 'package:native_camera_view/camera_preview/native_camera_view.dart';

class ItemScreen extends StatefulWidget {
  const ItemScreen({super.key});

  @override
  State<ItemScreen> createState() => _ItemScreenState();
}

class _ItemScreenState extends State<ItemScreen> {
  late double deviceHeight;
  late double deviceWidth;
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  CameraController? _cameraController;

  @override
  Widget build(BuildContext context) {
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;
    if (deviceWidth > 600) {
      deviceWidth = 600;
    }
    return Scaffold(
      appBar: AppBar(title: Text('Item Screen')),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Container(
              margin: EdgeInsets.all(20),
              width: deviceWidth,
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      cameraCall();
                    },
                    child: Icon(
                      Icons.camera_alt,
                      size: 100,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(
                    height: 200,
                    width: double.infinity,
                    child: NativeCameraView(
                      onControllerCreated: _onCameraControllerCreated,
                      cameraPreviewFit: CameraPreviewFit.cover,
                      isFrontCamera: false,
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: titleController,
                    decoration: InputDecoration(
                      labelText: 'Title',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 5),
                  TextField(
                    maxLines: 3,
                    controller: descriptionController,
                    decoration: InputDecoration(
                      labelText: 'Description',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 5),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        // Save action
                      },
                      child: Text('Save'),
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

  void _onCameraControllerCreated(CameraController controller) {
    _cameraController = controller;
    print("CameraController created and received!");
  }

  void cameraCall() {
    _onCameraControllerCreated(_cameraController!);
    print("Camera called");
  }
}

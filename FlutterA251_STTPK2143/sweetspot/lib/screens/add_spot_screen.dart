// ignore_for_file: unnecessary_null_comparison

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../models/sweetspot.dart';
import '../providers/location_provider.dart';
import '../providers/spots_provider.dart';

class AddSpotScreen extends StatefulWidget {
  final SweetSpot? existingSpot;

  const AddSpotScreen({super.key, this.existingSpot});

  @override
  State<AddSpotScreen> createState() => _AddSpotScreenState();
}

class _AddSpotScreenState extends State<AddSpotScreen> {
  @override
  void initState() {
    super.initState();

    if (widget.existingSpot != null) {
      _titleController.text = widget.existingSpot!.title;
      _descriptionController.text = widget.existingSpot!.description;
      _imageFile = File(widget.existingSpot!.imagePath);

      final loc = context.read<LocationProvider>();
      loc.lat = widget.existingSpot!.lat;
      loc.lng = widget.existingSpot!.lng;
    }
  }

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  File? _imageFile;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final xfile = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 70,
    );
    if (xfile == null) return;
    setState(() => _imageFile = File(xfile.path));
  }

  Future<void> _saveSpot() async {
    final title = _titleController.text.trim();
    final loc = context.read<LocationProvider>();
    final description = _descriptionController.text.trim();

    if (title.isEmpty ||
        _imageFile == null ||
        description.isEmpty ||
        loc.lat == null ||
        loc.lng == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please complete all fields.")),
      );
      return;
    }

    final spot = SweetSpot(
      id: widget.existingSpot?.id,
      title: title,
      imagePath: _imageFile!.path,
      lat: loc.lat!,
      lng: loc.lng!,
      createdAt:
          widget.existingSpot?.createdAt ?? DateTime.now().toIso8601String(),
      description: description,
    );

    final provider = context.read<SpotsProvider>();

    // 🔹 ADD MODE (no confirmation)
    if (widget.existingSpot == null) {
      await provider.addSpot(spot);
      loc.clear();
      if (mounted) Navigator.pop(context);
      return;
    }

    // 🔹 EDIT MODE → confirmation required
    final confirm = await _confirmUpdate(context);
    if (!confirm) return;

    await provider.updateSpot(spot);
    loc.clear();
    if (mounted) Navigator.pop(context);
  }

  Future<bool> _confirmUpdate(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text("Confirm Update"),
            content: const Text(
              "Are you sure you want to update this SweetSpot location?",
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: const Text("Cancel"),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text("Update"),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    final loc = context.watch<LocationProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.existingSpot == null ? "Add SweetSpot" : "Edit SweetSpot",
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Container(
              height: 220,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: _imageFile == null
                  ? const Text("No photo yet")
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(
                        _imageFile!,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    ),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: _pickImage,
              icon: const Icon(Icons.camera_alt),
              label: const Text("Take Photo"),
            ),
            const SizedBox(height: 12),

            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: "Spot Title (e.g., Sunset Bridge)",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),

            TextField(
              controller: _descriptionController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: "Location Description",
                hintText: "Why is this a good place to take photos?",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),

            // Photo preview
            Row(
              children: [
                Flexible(
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text("Location"),
                    subtitle: loc.isLoading
                        ? const Text("Fetching location...")
                        : (loc.lat != null && loc.lng != null)
                        ? Text("Lat: ${loc.lat}\nLng: ${loc.lng}")
                        : (loc.error != null)
                        ? Text(loc.error!)
                        : const Text("No location captured yet."),
                  ),
                ),
                Flexible(
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      await context
                          .read<LocationProvider>()
                          .fetchCurrentLocation();
                      showMap(LatLng(loc.lat!, loc.lng!));
                    },

                    icon: const Icon(Icons.my_location),
                    label: const Text("Get Current Location"),
                  ),
                ),
              ],
            ),

            // Location section
            const SizedBox(height: 18),

            FilledButton.icon(
              onPressed: _saveSpot,
              icon: const Icon(Icons.save),
              label: Text(
                widget.existingSpot == null ? "Save Spot" : "Update Spot",
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showMap(LatLng loc) {
    //showmap google map dialog if location is avaiable
    if (loc.latitude != null && loc.longitude != null) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text("Location"),
          content: SizedBox(
            height: 500,
            width: 450,
            child: GoogleMap(
              initialCameraPosition: CameraPosition(target: loc, zoom: 16),
              markers: {
                Marker(markerId: const MarkerId("spot"), position: loc),
              },
              zoomControlsEnabled: true,
              mapToolbarEnabled: false,
              myLocationButtonEnabled: false,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text("Close"),
            ),
          ],
        ),
      );
    }
  }
}

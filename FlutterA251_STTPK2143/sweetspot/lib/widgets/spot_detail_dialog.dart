import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/sweetspot.dart';

class SpotDetailDialog extends StatelessWidget {
  final SweetSpot spot;

  const SpotDetailDialog({super.key, required this.spot});

  @override
  Widget build(BuildContext context) {
    final position = LatLng(spot.lat, spot.lng);

    return Dialog(
      insetPadding: const EdgeInsets.all(12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Image
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Image.file(
              File(spot.imagePath),
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  spot.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(spot.description),
                const SizedBox(height: 12),

                Text(
                  "Latitude: ${spot.lat}",
                  style: const TextStyle(fontSize: 12),
                ),
                Text(
                  "Longitude: ${spot.lng}",
                  style: const TextStyle(fontSize: 12),
                ),
                const SizedBox(height: 12),

                // Google Map
                SizedBox(
                  height: 300,
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: position,
                      zoom: 16,
                    ),
                    markers: {
                      Marker(
                        markerId: const MarkerId("spot"),
                        position: position,
                        infoWindow: InfoWindow(title: spot.title),
                      ),
                    },
                    zoomControlsEnabled: true,
                    mapToolbarEnabled: false,
                    myLocationButtonEnabled: false,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: 100,
                child: FilledButton.icon(
                  icon: const Icon(Icons.directions),
                  label: const Text("Go"),
                  onPressed: () => _openGoogleMaps(spot.lat, spot.lng),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Close"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _openGoogleMaps(double lat, double lng) async {
    final url = Uri.parse(
      'https://www.google.com/maps/dir/?api=1'
      '&destination=$lat,$lng'
      '&travelmode=driving',
    );

    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch Google Maps';
    }
  }
}

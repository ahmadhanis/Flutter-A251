import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class LocationProvider extends ChangeNotifier {
  double? lat;
  double? lng;
  bool isLoading = false;
  String? error;

  Future<void> fetchCurrentLocation() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        error = "Location service is disabled.";
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.deniedForever) {
        error = "Location permission denied forever. Enable in Settings.";
        return;
      }

      final pos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      lat = pos.latitude;
      lng = pos.longitude;
    } catch (e) {
      error = "Failed to get location: $e";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void clear() {
    lat = null;
    lng = null;
    error = null;
    notifyListeners();
  }
}

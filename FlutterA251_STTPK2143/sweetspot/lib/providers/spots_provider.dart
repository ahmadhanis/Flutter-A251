import 'package:flutter/material.dart';
import '../models/sweetspot.dart';
import '../services/db_service.dart';

class SpotsProvider extends ChangeNotifier {
  final DBService _db = DBService();

  List<SweetSpot> spots = [];
  bool isLoading = false;

  Future<void> loadSpots() async {
    isLoading = true;
    notifyListeners();

    spots = await _db.getAllSpots();

    isLoading = false;
    notifyListeners();
  }

  Future<void> addSpot(SweetSpot spot) async {
    await _db.insertSpot(spot);
    await loadSpots(); // refresh list after insert
  }

  Future<void> deleteSpot(int id) async {
    await _db.deleteSpot(id);
    await loadSpots();
  }

  Future<void> updateSpot(SweetSpot spot) async {
    await _db.updateSpot(spot);
    await loadSpots();
  }
}

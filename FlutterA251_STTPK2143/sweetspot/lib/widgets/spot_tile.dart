import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sweetspot/widgets/spot_detail_dialog.dart';
import '../models/sweetspot.dart';
import '../providers/spots_provider.dart';
import '../screens/add_spot_screen.dart';

class SpotTile extends StatelessWidget {
  final SweetSpot spot;
  const SpotTile({super.key, required this.spot});

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Delete SweetSpot"),
        content: const Text(
          "Are you sure you want to delete this location?\nThis action cannot be undone.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel"),
          ),
          FilledButton(
            onPressed: () {
              context.read<SpotsProvider>().deleteSpot(spot.id!);
              Navigator.pop(ctx);
            },
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.file(
            File(spot.imagePath),
            width: 56,
            height: 56,
            fit: BoxFit.cover,
          ),
        ),
        title: Text(spot.title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(spot.description),
            const SizedBox(height: 4),
            Text(
              "Lat: ${spot.lat.toStringAsFixed(5)}, "
              "Lng: ${spot.lng.toStringAsFixed(5)}",
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),

        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit_outlined),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AddSpotScreen(existingSpot: spot),
                  ),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () => _confirmDelete(context),
            ),
          ],
        ),
        onTap: () {
          showDialog(
            context: context,
            builder: (_) => SpotDetailDialog(spot: spot),
          );
        },
      ),
    );
  }
}

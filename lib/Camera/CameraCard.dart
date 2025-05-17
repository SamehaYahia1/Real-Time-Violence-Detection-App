import 'package:flutter/material.dart';

class CameraCard extends StatelessWidget {
  final String cameraName;
  final VoidCallback onTap;

  const CameraCard({
    required this.cameraName,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // Navigate to the camera display when the card is tapped
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 4,
        color: const Color.fromARGB(255, 22, 24, 47),
        child: ListTile(
          contentPadding: const EdgeInsets.all(16),
          leading: const Icon(
            Icons.camera_alt,
            color: Colors.blueAccent,
            size: 30,
          ),
          title: Text(
            cameraName,
            style: const TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          trailing: const Icon(Icons.arrow_forward, color: Colors.black),
        ),
      ),
    );
  }
}

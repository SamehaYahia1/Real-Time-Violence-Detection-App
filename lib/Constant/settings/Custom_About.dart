import 'package:flutter/material.dart';

class AboutDialogVdect extends StatelessWidget {
  const AboutDialogVdect({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFFE9F0FF),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(
        children: [
          Image.asset('Assets/images/cctv-camera.png', width: 40, height: 40),
          const SizedBox(width: 12),
          const Text('VDECT',
              style: TextStyle(
                  color: Color(0xFF355C7D), fontWeight: FontWeight.bold)),
        ],
      ),
      content: const SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Version 1.0.0', style: TextStyle(color: Colors.black54)),
            SizedBox(height: 16),
            Text(
              'VDECT is an advanced CCTV monitoring system that uses AI to detect violent behavior in real-time. Our solution helps security teams identify and respond to threats faster.\n\n'
              'Key Features:\n'
              '• Real-time violence detection\n'
              '• Suspect tracking and identification\n'
              '• Comprehensive incident logging\n'
              '• Instant alerts and notifications\n'
              '• Secure video evidence storage\n\n'
              '© 2025 VDECT Security Solutions. All rights reserved.',
              style:
                  TextStyle(fontSize: 14, color: Colors.black87, height: 1.5),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('OK', style: TextStyle(color: Color(0xFF355C7D))),
        ),
      ],
    );
  }
}

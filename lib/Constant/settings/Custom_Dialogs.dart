import 'package:flutter/material.dart';

class ContactSupportDialog extends StatelessWidget {
  const ContactSupportDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFFE9F0FF),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Row(
        children: [
          Icon(Icons.support_agent, color: Color(0xFF355C7D)),
          SizedBox(width: 10),
          Text('Contact Support',
              style: TextStyle(
                  color: Colors.black87, fontWeight: FontWeight.bold)),
        ],
      ),
      content: const Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Please email us at:', style: TextStyle(fontSize: 16)),
          SizedBox(height: 8),
          SelectableText('vdect2025@gmail.com',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF355C7D))),
          SizedBox(height: 16),
          Text('We typically respond within 24 hours.',
              style: TextStyle(fontSize: 14, color: Colors.black)),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('OK',
              style: TextStyle(
                  color: Color(0xFF355C7D),
                  fontSize: 16,
                  fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }
}

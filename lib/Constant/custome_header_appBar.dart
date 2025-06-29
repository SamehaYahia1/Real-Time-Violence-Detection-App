import 'package:flutter/material.dart';

class CustomHeaderAppBar extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool showBackButton;

  const CustomHeaderAppBar({
    super.key,
    required this.icon,
    required this.title,
    this.showBackButton = false,
  });

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(50),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(30),
        ),
        child: AppBar(
          backgroundColor: const Color(0xFFBFD7ED),
          elevation: 4,
          shadowColor: Colors.black26,
          automaticallyImplyLeading: false,
          leading: showBackButton
              ? IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black87),
                  onPressed: () => Navigator.pop(context),
                )
              : null,
          title: Row(
            children: [
              Icon(icon, color: Colors.black87),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

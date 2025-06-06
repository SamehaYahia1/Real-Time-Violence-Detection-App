import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter_application_1/Pages/AddScreen.dart';
import 'package:flutter_application_1/Pages/Home/List_Of_Cameras.dart';
import 'package:flutter_application_1/Pages/Notifactions/NotificationScreen.dart';
import 'package:flutter_application_1/Pages/Recoreds/RecordsScreen.dart';
import 'package:flutter_application_1/Pages/SettingsScreen.dart';

class Homeuserscreen extends StatefulWidget {
  final String userId;
  final String username;
  final int subscriptionPlan;
  const Homeuserscreen({
    super.key,
    required this.userId,
    required this.username,
    required this.subscriptionPlan,
  });

  @override
  State<Homeuserscreen> createState() => _HomeuserscreenState();
}

class _HomeuserscreenState extends State<Homeuserscreen> {
  int index = 2; // Initial index to show the first screen
  final items = const <Widget>[
    Icon(Icons.add, size: 30, color: Colors.black),
    Icon(Icons.videocam, size: 30, color: Colors.black),
    Icon(Icons.home, size: 30, color: Colors.black),
    Icon(Icons.notifications, size: 30, color: Colors.black),
    Icon(Icons.settings, size: 30, color: Colors.black),
  ];
  late final List<Widget> _screens;
  @override
  void initState() {
    super.initState();
    _screens = [
      AddScreen(),
      VideoScreen(),
      CameraListScreen(),
      NotificationsScreen(),
      SettingsScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE9F0FF),
      body: _screens[index], // Display the screen based on the selected index

      bottomNavigationBar: CurvedNavigationBar(
        animationDuration: const Duration(milliseconds: 400),
        height: 60,
        backgroundColor: Colors.transparent,
        buttonBackgroundColor: Colors.blueAccent,
        items: items,
        index: index,
        onTap: (index) {
          setState(() {
            this.index = index; // Update the current index
          });
        },
      ),
    );
  }
}

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
  final String initialTab; // <-- NEW optional param with default

  const Homeuserscreen({
    super.key,
    required this.userId,
    required this.username,
    required this.subscriptionPlan,
    this.initialTab = 'home', // <-- Default tab
  });

  @override
  State<Homeuserscreen> createState() => _HomeuserscreenState();
}

class _HomeuserscreenState extends State<Homeuserscreen> {
  late int index;
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

    // Choose index based on tab name
    switch (widget.initialTab) {
      case 'add':
        index = 0;
        break;
      case 'records':
        index = 1;
        break;
      case 'home':
        index = 2;
        break;
      case 'notifications':
        index = 3;
        break;
      case 'settings':
        index = 4;
        break;
      default:
        index = 2;
    }

    _screens = [
      AddScreen(), // 0
      VideoScreen(), // 1
      CameraListScreen(), // 2
      NotificationsScreen(
        onTapNotification: (newIndex) {
          setState(() {
            index = newIndex;
          });
        },
      ), // 3
      SettingsScreen(), // 4
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE9F0FF),
      body: _screens[index],
      bottomNavigationBar: CurvedNavigationBar(
        animationDuration: const Duration(milliseconds: 400),
        height: 60,
        backgroundColor: Colors.transparent,
        buttonBackgroundColor: Colors.blueAccent,
        items: items,
        index: index,
        onTap: (index) {
          setState(() {
            this.index = index;
          });
        },
      ),
    );
  }
}

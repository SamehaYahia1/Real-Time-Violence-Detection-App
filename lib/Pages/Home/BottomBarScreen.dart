import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter_application_1/Pages/AddScreen.dart';
import 'package:flutter_application_1/Pages/Home/List_Of_Cameras.dart';
import 'package:flutter_application_1/Pages/Notifactions/NotificationScreen.dart';
import 'package:flutter_application_1/Pages/Recoreds/RecordsScreen.dart';
import 'package:flutter_application_1/Pages/SettingsScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Homeuserscreen extends StatefulWidget {
  final String userId;
  final String username;
  final int subscriptionPlan;
  final String initialTab;

  const Homeuserscreen({
    super.key,
    required this.userId,
    required this.username,
    required this.subscriptionPlan,
    this.initialTab = 'home',
  });

  @override
  State<Homeuserscreen> createState() => _HomeuserscreenState();
}

class _HomeuserscreenState extends State<Homeuserscreen> {
  late int index;
  late List<Widget> _screens;
  String? _selectedCameraId;
  bool _isScreensReady = false;

  final items = const <Widget>[
    Icon(Icons.add, size: 30, color: Colors.black),
    Icon(Icons.videocam, size: 30, color: Colors.black),
    Icon(Icons.home, size: 30, color: Colors.black),
    Icon(Icons.notifications, size: 30, color: Colors.black),
    Icon(Icons.settings, size: 30, color: Colors.black),
  ];

  @override
  void initState() {
    super.initState();
    _setInitialTabIndex();
    _loadCameraIdAndInitScreens();
  }

  void _setInitialTabIndex() {
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
  }

  Future<void> _loadCameraIdAndInitScreens() async {
    final prefs = await SharedPreferences.getInstance();
    _selectedCameraId = prefs.getString('selectedCameraId') ?? '';

    _screens = [
      AddScreen(),
      VideoScreen(),
      CameraListScreen(),
      NotificationsScreen(
        onTapNotification: (newIndex) {
          setState(() {
            index = newIndex;
          });
        },
      ),
      SettingsScreen(cameraId: _selectedCameraId!), // Pass camera ID here
    ];

    setState(() {
      _isScreensReady = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isScreensReady) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

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
        onTap: (newIndex) {
          setState(() {
            index = newIndex;
          });
        },
      ),
    );
  }
}

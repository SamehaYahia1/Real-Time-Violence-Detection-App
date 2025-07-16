import 'package:flutter/material.dart';
import 'package:flutter_application_1/Constant/ShowErrorToSnackBar.dart';
import 'package:flutter_application_1/Constant/settings/Custom_About.dart';
import 'package:flutter_application_1/Constant/settings/Custom_Dialogs.dart';
import 'package:flutter_application_1/Constant/settings/Section_Card.dart';
import 'package:flutter_application_1/Constant/settings/settings_widgets.dart.dart';
import 'package:flutter_application_1/Constant/token_handler.dart';
import 'package:flutter_application_1/Pages/Notifactions/firebase_api.dart';
import 'package:flutter_application_1/Pages/Start/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:flutter_application_1/Constant/api_endpoint.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SettingsScreen extends StatefulWidget {
  final String cameraId;
  const SettingsScreen({super.key, required this.cameraId});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _aiProcessingEnabled = false;
  bool _darkModeEnabled = false;
  String _selectedRegion = 'United States';
  String fullname = '';
  String email = '';
  bool isLoading = true;
  String plan = '';
  int connectedCameras = 0;
  void _toggleAiProcessing(bool value) async {
    setState(() {
      _aiProcessingEnabled = value;
    });

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(
        'ai_processing_${widget.cameraId}', value); // Save state

    final token = prefs.getString('token');

    if (token == null) {
      showErrorTopSnackBar(context, 'Authentication token not found.');
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text('Authentication token not found.')),
      // );
      return;
    }

    final endpoint = _aiProcessingEnabled
        ? '/api/aiprocessing/${widget.cameraId}/start'
        : '/api/aiprocessing/${widget.cameraId}/stop';

    try {
      final response = await http.post(
        Uri.parse('${ApiEndpoints.baseUrl}$endpoint'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode != 200) {
        throw Exception('Server responded with ${response.statusCode}');
      }
      showErrorTopSnackBar(
          context,
          _aiProcessingEnabled
              ? 'AI processing started.'
              : 'AI processing stopped.');

      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text(_aiProcessingEnabled
      //         ? 'AI processing started.'
      //         : 'AI processing stopped.'),
      //   ),
      // );
    } catch (e) {
      print('AI processing toggle failed: $e');
      showErrorTopSnackBar(context, 'Failed to update AI processing state.');
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text('Failed to update AI processing state.')),
      // );
    }
  }

  // void _toggleAiProcessing(bool value) async {
  //   setState(() {
  //     _aiProcessingEnabled = value;
  //   });

  //   final tokenPrefs = await SharedPreferences.getInstance();
  //   final token = tokenPrefs.getString('token'); // or however you store it

  //   if (token == null) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Authentication token not found.')),
  //     );
  //     return;
  //   }

  //   final endpoint = _aiProcessingEnabled
  //       ? '/api/aiprocessing/${widget.cameraId}/start'
  //       : '/api/aiprocessing/${widget.cameraId}/stop';

  //   try {
  //     final response = await http.post(
  //       Uri.parse('${ApiEndpoints.baseUrl}$endpoint'),
  //       headers: {
  //         'Authorization': 'Bearer $token',
  //         'Content-Type': 'application/json',
  //       },
  //     );

  //     if (response.statusCode != 200) {
  //       throw Exception('Server responded with ${response.statusCode}');
  //     }

  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //           content: Text(_aiProcessingEnabled
  //               ? 'AI processing started.'
  //               : 'AI processing stopped.')),
  //     );
  //   } catch (e) {
  //     print('AI processing toggle failed: $e');
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Failed to update AI processing state.')),
  //     );
  //   }
  // }

  final List<String> regions = [
    'United States',
    'United Kingdom',
    'Canada',
    'Australia',
    'Egypt',
    'India',
    'Europe'
  ];

  @override
  void initState() {
    super.initState();
    fetchUserData();
    loadAiProcessingSetting();
    fetchCamerasCount();
    // loadNotificationSetting();
  }

//   Future<void> loadNotificationSetting() async {
//   final prefs = await SharedPreferences.getInstance();
//   final enabled = prefs.getBool('notifications_enabled') ?? true;
//   setState(() {
//     _notificationsEnabled = enabled;
//   });
// }
  Future<void> loadAiProcessingSetting() async {
    final prefs = await SharedPreferences.getInstance();
    final savedValue =
        prefs.getBool('ai_processing_${widget.cameraId}') ?? false;
    setState(() {
      _aiProcessingEnabled = savedValue;
    });
  }

  Future<void> fetchUserData() async {
    try {
      final token = await TokenHandler().getToken();

      if (token == null) {
        throw Exception('Token not found');
      }
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);

      setState(() {
        fullname = decodedToken['name']?[1] ?? 'Unknown';
        email = decodedToken['email'] ?? 'unknown@example.com';
        plan = decodedToken['SubscriptionPlanId'] ?? 'Unknown';
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error decoding token: $e')),
      );
    }
  }

  Future<void> fetchCamerasCount() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');
    final token = await TokenHandler().getToken();

    if (token == null || userId == null || mounted == false) {
      return;
    }

    final response = await http.get(
      Uri.parse(
          '${ApiEndpoints.baseUrl}/api/Camera/UserCameras?userId=$userId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json'
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        connectedCameras = data.length;
      });
    } else {
      setState(() {
        connectedCameras = 0;
      });
    }
  }

  Future<void> _logout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFFBFD7ED),
        title: const Text('Logout',
            style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
                fontSize: 24)),
        content: const Text('Are you sure you want to logout?',
            style: TextStyle(fontSize: 18)),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child:
                  const Text('Cancel', style: TextStyle(color: Colors.black))),
          TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Logout', style: TextStyle(color: Colors.red))),
        ],
      ),
    );

    if (confirmed ?? false) {
      notificationList.clear();
      notificationCounter.value = 0;
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('jwt_token');

      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE9F0FF),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("Assets/images/camera_bg.png"),
            fit: BoxFit.scaleDown,
            alignment: Alignment(0, 0.15),
            colorFilter: ColorFilter.mode(Color(0xFFE9F0FF), BlendMode.dstATop),
          ),
        ),
        child: Column(
          children: [
            PreferredSize(
              preferredSize: const Size.fromHeight(50),
              child: ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(bottom: Radius.circular(30)),
                child: AppBar(
                  backgroundColor: const Color(0xFFBFD7ED),
                  elevation: 4,
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.logout, color: Colors.black87),
                      tooltip: 'Logout',
                      onPressed: _logout,
                    )
                  ],
                  automaticallyImplyLeading: false,
                  title: const Row(
                    children: [
                      Icon(Icons.settings, color: Colors.black87),
                      SizedBox(width: 10),
                      Text("Settings",
                          style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87)),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          SectionCard(
                            title: 'Account Information',
                            children: [
                              InfoRow(
                                label: 'Name',
                                value: fullname,
                              ),
                              InfoRow(
                                label: 'Email',
                                value: email,
                              ),
                              InfoRow(
                                label: 'Cameras',
                                value: '$connectedCameras connected',
                              ),
                              InfoRow(
                                label: 'Plan',
                                value: plan,
                              ),
                            ],
                          ),
                          SectionCard(
                            title: 'Preferences',
                            children: [
                              SwitchRow(
                                icon: Icons.notifications,
                                label: 'Notifications',
                                value: _notificationsEnabled,
                                onChanged: (value) => setState(
                                    () => _notificationsEnabled = value),

//                                 onChanged: (value) async {
//   setState(() => _notificationsEnabled = value);

//   final prefs = await SharedPreferences.getInstance();
//   await prefs.setBool('notifications_enabled', value);

//   if (!value) {
//     // Notifications are now disabled
//     showErrorTopSnackBar(context, 'Notifications are disabled. You will only see them in the app.');
//   }
// },
                              ),
                              SwitchRow(
                                icon: Icons.smart_toy_outlined,
                                label: 'AI Processing',
                                value: _aiProcessingEnabled,
                                onChanged: _toggleAiProcessing,
                              ),
                              SwitchRow(
                                icon: Icons.dark_mode,
                                label: 'Dark Mode',
                                value: _darkModeEnabled,
                                onChanged: (value) =>
                                    setState(() => _darkModeEnabled = value),
                              ),
                              DropdownRow(
                                icon: Icons.language,
                                label: 'Region',
                                value: _selectedRegion,
                                items: regions,
                                onChanged: (value) =>
                                    setState(() => _selectedRegion = value!),
                              ),
                            ],
                          ),
                          SectionCard(
                            title: 'Support',
                            children: [
                              ActionRow(
                                icon: Icons.headset_mic,
                                label: 'Contact Support',
                                onTap: () => showDialog(
                                    context: context,
                                    builder: (_) =>
                                        const ContactSupportDialog()),
                              ),
                              ActionRow(
                                icon: Icons.info_outline,
                                label: 'About',
                                onTap: () => showDialog(
                                    context: context,
                                    builder: (_) => const AboutDialogVdect()),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
            )
          ],
        ),
      ),
    );
  }
}

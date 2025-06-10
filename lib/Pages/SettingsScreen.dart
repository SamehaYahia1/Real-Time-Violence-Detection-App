import 'package:flutter/material.dart';
import 'package:flutter_application_1/Constant/settings/Custom_Dialogs.dart';
import 'package:flutter_application_1/Constant/settings/Custom_About.dart';
import 'package:flutter_application_1/Constant/settings/Section_Card.dart';
import 'package:flutter_application_1/Constant/settings/settings_widgets.dart.dart';
import 'package:flutter_application_1/Constant/token_handler.dart';
import 'package:flutter_application_1/Pages/Start/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;
  String _selectedRegion = 'United States';
  String fullname = '';
  String email = '';
  bool isLoading = true;
  String plan = '';

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
  }

  Future<void> fetchUserData() async {
    try {
      final token = await TokenHandler().getToken();
      // print("Token: $token");

      if (token == null) {
        throw Exception('Token not found');
      }

      // ✅ Decode the token directly to extract user data
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);

      // print("Decoded Token: $decodedToken");

      setState(() {
        // Your 'name' is an array: ["username", "fullname"]
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
      print('Error decoding token: $e');
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
                    ),
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
                              InfoRow(label: 'Email', value: email),
                              InfoRow(label: 'Cameras', value: '4 connected'),
                              InfoRow(label: 'Plan', value: plan),
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
            ),
          ],
        ),
      ),
    );
  }
}

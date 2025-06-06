import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Constant/api_endpoint.dart';
import 'package:flutter_application_1/Constant/token_handler.dart';
import 'package:flutter_application_1/Pages/Start/login_screen.dart';
import 'package:http/http.dart' as http;
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
                          _buildSectionCard(
                            title: 'Account Information',
                            children: [
                              _buildInfoRow('Name', fullname),
                              _buildInfoRow('Email', email),
                              _buildInfoRow('Cameras', '4 connected'),
                              _buildInfoRow('Plan', plan),
                            ],
                          ),
                          _buildSectionCard(
                            title: 'Preferences',
                            children: [
                              _buildSwitchRow(
                                icon: Icons.notifications,
                                label: 'Notifications',
                                value: _notificationsEnabled,
                                onChanged: (value) => setState(
                                    () => _notificationsEnabled = value),
                              ),
                              _buildSwitchRow(
                                icon: Icons.dark_mode,
                                label: 'Dark Mode',
                                value: _darkModeEnabled,
                                onChanged: (value) =>
                                    setState(() => _darkModeEnabled = value),
                              ),
                              _buildDropdownRow(
                                icon: Icons.language,
                                label: 'Region',
                                value: _selectedRegion,
                                items: regions,
                                onChanged: (value) =>
                                    setState(() => _selectedRegion = value!),
                              ),
                            ],
                          ),
                          _buildSectionCard(
                            title: 'Support',
                            children: [
                              _buildActionRow(
                                icon: Icons.headset_mic,
                                label: 'Contact Support',
                                onTap: () => showDialog(
                                    context: context,
                                    builder: (_) =>
                                        _buildContactSupportDialog()),
                              ),
                              _buildActionRow(
                                icon: Icons.info_outline,
                                label: 'About',
                                onTap: () => showDialog(
                                    context: context,
                                    builder: (_) => _buildAboutDialog()),
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

  // --- Helper Widgets ---
  Widget _buildSectionCard(
      {required String title, required List<Widget> children}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: const Color.fromARGB(255, 154, 199, 240).withOpacity(0.7),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87)),
            const SizedBox(height: 8),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
              child: Text(label,
                  style: const TextStyle(fontSize: 16, color: Colors.black87))),
          Text(value,
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black)),
        ],
      ),
    );
  }

  Widget _buildSwitchRow({
    required IconData icon,
    required String label,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 24, color: Colors.black87),
          const SizedBox(width: 12),
          Expanded(
              child: Text(label,
                  style: const TextStyle(fontSize: 16, color: Colors.black87))),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: const Color.fromARGB(255, 23, 63, 98),
            activeTrackColor: const Color.fromARGB(255, 71, 92, 255),
            inactiveThumbColor: Colors.grey,
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownRow({
    required IconData icon,
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 24, color: Colors.black87),
          const SizedBox(width: 12),
          Expanded(
              child: Text(label,
                  style: const TextStyle(fontSize: 16, color: Colors.black87))),
          Container(
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 23, 63, 98),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.black12, width: 1),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: DropdownButton<String>(
              value: value,
              underline: Container(),
              icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
              dropdownColor: const Color.fromARGB(255, 23, 63, 98),
              borderRadius: BorderRadius.circular(12),
              style: const TextStyle(fontSize: 16, color: Colors.white),
              items: items.map((String val) {
                return DropdownMenuItem<String>(
                  value: val,
                  child: Text(val, style: const TextStyle(fontSize: 14)),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionRow(
      {required IconData icon,
      required String label,
      required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Icon(icon, size: 24, color: Colors.black87),
            const SizedBox(width: 12),
            Expanded(
                child: Text(label,
                    style:
                        const TextStyle(fontSize: 16, color: Colors.black87))),
            const Icon(Icons.chevron_right, color: Colors.black87),
          ],
        ),
      ),
    );
  }

  Widget _buildContactSupportDialog() => AlertDialog(
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

  Widget _buildAboutDialog() => AlertDialog(
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

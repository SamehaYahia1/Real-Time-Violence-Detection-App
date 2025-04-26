// UserCamerasPage.dart
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Pages/camera_stream_page.dart';
import 'package:flutter_application_1/Constant/colors.dart';
import 'package:flutter_application_1/Constant/token_handler.dart';
import 'package:flutter_application_1/Constant/api_endpoint.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserCamerasPage extends StatefulWidget {
  const UserCamerasPage({super.key});

  @override
  State<UserCamerasPage> createState() => _UserCamerasPageState();
}

class _UserCamerasPageState extends State<UserCamerasPage> {
  List<dynamic> cameras = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCameraStreams();
  }

  Future<void> fetchCameraStreams() async {
    final token = await TokenHandler().getToken(); // <--- load saved JWT token
    if (token == null) {
      setState(() {
        isLoading = false;
      });
      throw Exception('No token found');
    }

    final response = await http.get(
      Uri.parse(ApiEndpoints.cameras),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // <<--- Send JWT token
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        cameras = data;
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      throw Exception('Failed to load cameras: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Available Cameras'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: cameras.length,
              itemBuilder: (context, index) {
                final cam = cameras[index];
                final bool isOnline = cam['isOnline'];

                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: ListTile(
                    title: Text(cam['cameraName']),
                    subtitle: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: isOnline ? Colors.green : Colors.red,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            isOnline ? 'Online' : 'Offline',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      final streamUrl = cam['streamURL'] as String? ?? '';
                      final cameraName = cam['cameraName'] as String? ?? '';

                      if (streamUrl.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text(
                                  'Stream not available for this camera.')),
                        );
                        return;
                      }

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CameraStreamPage(
                            streamUrl: streamUrl,
                            cameraName: cameraName,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_application_1/Models/camera_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_application_1/Camera/CameraCard.dart';
import 'package:flutter_application_1/Camera/CameraDisplayScreen.dart';
import 'package:flutter_application_1/Constant/api_endpoint.dart';
import 'package:flutter_application_1/Constant/token_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class CameraListScreen extends StatefulWidget {
  const CameraListScreen({Key? key}) : super(key: key);

  @override
  State<CameraListScreen> createState() => _CameraListScreenState();
}

class _CameraListScreenState extends State<CameraListScreen> {
  List<CameraModel> _cameras = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUserCameras();
  }

  Future<void> fetchUserCameras() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');
    final token = await TokenHandler().getToken();
    print("Token: $token");
    print('User ID: $userId');
    if (token == null || userId == null) {
      print('Missing token.');
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
      final List<CameraModel> loadedCameras =
          data.map((json) => CameraModel.fromJson(json)).toList();
      if (!mounted) return;

      setState(() {
        _cameras = loadedCameras;
        _isLoading = false;
      });
    } else {
      print('Failed to load cameras: ${response.body}');
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE9F0FF),
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        elevation: 0,
        title:
            const Text("Your Cameras", style: TextStyle(color: Colors.white)),
      ),
      body: _isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  LoadingAnimationWidget.staggeredDotsWave(
                    color: Color.fromARGB(255, 60, 90, 118),
                    size: 80,
                  ),
                  const SizedBox(height: 24),
                  // const Padding(
                  //   padding: EdgeInsets.symmetric(horizontal: 24.0),
                  //   child: Text(
                  //     "Fetching your cameras, please wait...",
                  //     textAlign: TextAlign.center,
                  //     style: TextStyle(
                  //       fontSize: 20,
                  //       fontWeight: FontWeight.bold,
                  //       color: Colors.black87,
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            )
          : _cameras.isEmpty
              ? const Center(child: Text("No cameras found."))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _cameras.length,
                  itemBuilder: (context, index) {
                    final camera = _cameras[index];
                    return CameraCard(
                      cameraName: camera.cameraName,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CameraDisplayScreen(
                              cameraName: camera.cameraName,
                              streamUrl: camera.streamUrl,
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
    );
  }
}

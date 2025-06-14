import 'package:flutter/material.dart';
import 'package:flutter_application_1/Models/camera_model.dart';
import 'package:flutter_application_1/Camera/CameraCard.dart';
import 'package:flutter_application_1/Camera/CameraDisplayScreen.dart';
import 'package:flutter_application_1/Constant/api_endpoint.dart';
import 'package:flutter_application_1/Constant/token_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CameraListScreen extends StatefulWidget {
  const CameraListScreen({Key? key}) : super(key: key);

  @override
  State<CameraListScreen> createState() => _CameraListScreenState();
}

class _CameraListScreenState extends State<CameraListScreen> {
  List<CameraModel> _cameras = [];
  bool _isLoading = true;
  bool _hasError = false;

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
      setState(() {
        _isLoading = false;
        _hasError = true; // Show error if no token/userId
      });
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
      final List<CameraModel> loadedCameras = [];
      for (var jsonCamera in data) {
        final camera = CameraModel.fromJson(jsonCamera);
        final location =
            prefs.getString('location_${camera.cameraName}') ?? 'Unknown';
        camera.location = location;
        loadedCameras.add(camera);
      }

      // final List<CameraModel> loadedCameras =
      //     data.map((json) => CameraModel.fromJson(json)).toList();
      // if (!mounted) return;

      setState(() {
        _cameras = loadedCameras;
        _isLoading = false;
        _hasError = false;
      });
    } else {
      print(
          'Failed to load cameras: ${response.statusCode} - ${response.body}');
      setState(() {
        _isLoading = false;
        _hasError = response.statusCode == 500; // Specific to your backend
      });
    }

    // } else {
    //   print('Failed to load cameras: ${response.body}');
    //   setState(() => _isLoading = false);
    // }
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
            colorFilter: ColorFilter.mode(
              Color(0xFFE9F0FF),
              BlendMode.dstATop,
            ),
          ),
        ),
        child: Column(
          children: [
            PreferredSize(
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
                  title: const Row(
                    children: [
                      Icon(Icons.camera_alt, color: Colors.black87),
                      SizedBox(width: 10),
                      Text(
                        "Cameras",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: _isLoading
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          LoadingAnimationWidget.staggeredDotsWave(
                            color: Color.fromARGB(255, 60, 90, 118),
                            size: 80,
                          ),
                          const SizedBox(height: 24),
                        ],
                      ),
                    )
                  : _hasError || _cameras.isEmpty
                      ? const Center(
                          child: Text("No cameras found.",
                              style:
                                  TextStyle(fontSize: 18, color: Colors.black)))
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: _cameras.length,
                          itemBuilder: (context, index) {
                            final camera = _cameras[index];
                            return CameraCard(
                              cameraName: camera.cameraName,
                              //must update them
                              location: camera.location,
                              isOnline: true,
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
            ),
          ],
        ),
      ),
    );
  }
}

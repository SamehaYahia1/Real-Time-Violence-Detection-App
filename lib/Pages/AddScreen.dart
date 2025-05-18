import 'package:flutter/material.dart';
import 'package:flutter_application_1/Cameras/camera_discovery_service.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class AddScreen extends StatefulWidget {
  const AddScreen({super.key});

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  bool isLoading = false;
  //String loadingMessage = "Discovering your camera, please wait...";

  void handleDiscoverCamera() async {
    setState(() => isLoading = true);

    final result =
        await CameraDiscoveryService.discoverAndSaveCamera("Camera 1");

    setState(() => isLoading = false);

    if (result != null && result.containsKey('error')) {
      // Show backend error (e.g., status 500: already added)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['error']!)),
      );
    } else if (result != null && result.containsKey('cameraName')) {
      // Success: show success dialog
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Success"),
          content: Text("Camera ${result['cameraName']} added successfully!"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            )
          ],
        ),
      );
    } else {
      // Unknown or unexpected failure
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Camera discovery or saving failed.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE9F0FF),
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        elevation: 0,
        title: const Text(
          "Please Add Your Camera",
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
      body: Center(
        child: isLoading
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  LoadingAnimationWidget.staggeredDotsWave(
                    color: Color.fromARGB(255, 60, 90, 118),
                    size: 80,
                  ),
                  const SizedBox(height: 24),
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  //   child: Text(
                  //     loadingMessage,
                  //     textAlign: TextAlign.center,
                  //     style: const TextStyle(
                  //       fontSize: 20,
                  //       fontWeight: FontWeight.bold,
                  //       color: Colors.black87,
                  //     ),
                  //   ),
                  // ),
                ],
              )
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: InkWell(
                    onTap: handleDiscoverCamera,
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      width: double.infinity,
                      child: const Text(
                        "Discover Your Camera",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}



























































































































































// import 'package:flutter/material.dart';
// import 'package:flutter_application_1/Camera/CameraDIsplayScreen.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:flutter/services.dart';
// import 'dart:convert';
// import 'package:http/http.dart' as http;

// import '../Constant/api_endpoint.dart';
// import '../Constant/token_handler.dart';

// class AddScreen extends StatefulWidget {
//   final String username;
//   final String userId;

//   const AddScreen({super.key, required this.username, required this.userId});

//   @override
//   State<AddScreen> createState() => _AddScreenState();
// }

// class _AddScreenState extends State<AddScreen> {
//   bool discoveryDone = false;
//   bool isDiscovering = false;

//   @override
//   void initState() {
//     super.initState();
//     checkDiscoveryStatus();
//   }

//   Future<void> checkDiscoveryStatus() async {
//     final prefs = await SharedPreferences.getInstance();
//     final done = prefs.getBool('discovery_done') ?? false;
//     setState(() {
//       discoveryDone = done;
//     });
//   }

//   Future<void> discoverCameras() async {
//     setState(() {
//       isDiscovering = true;
//     });

//     try {
//       const platform = MethodChannel('onvif_discovery');
//       final List<dynamic> cameras =
//           await platform.invokeMethod('discoverOnvifCameras');

//       if (cameras.isNotEmpty) {
//         final ip = cameras[0]['ip'];
//         final prefs = await SharedPreferences.getInstance();

//         await prefs.setString('camera_ip', ip);
//         await prefs.setBool('discovery_done', true);

//         final rtspUrl = "rtsp://admin:admin123456@192.168.1.57:8554/profile0";

//         // Optionally, send to backend
//         await sendCameraToBackend("Camera 1", rtspUrl);

//         // Navigate to display screen
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => CameraDisplayScreen(
//               cameraName: "Camera 1",
//               streamUrl: rtspUrl,
//             ),
//           ),
//         );
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("No cameras found.")),
//         );
//       }
//     } catch (e) {
//       print("Discovery error: $e");
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Discovery failed: $e")),
//       );
//     } finally {
//       setState(() {
//         isDiscovering = false;
//       });
//     }
//   }

//   Future<void> sendCameraToBackend(String cameraName, String rtspUrl) async {
//     final token = await TokenHandler().getToken();
//     if (token == null) {
//       print("No token found.");
//       return;
//     }

//     final url = Uri.parse('${ApiEndpoints.baseUrl}/api/Camera/add');

//     final response = await http.post(
//       url,
//       headers: {
//         'Content-Type': 'application/json',
//         'Authorization': 'Bearer $token'
//       },
//       body: jsonEncode({
//         'cameraName': cameraName,
//         'streamUrl': rtspUrl,
//       }),
//     );

//     if (response.statusCode == 200 || response.statusCode == 201) {
//       print('Camera added');
//     } else {
//       print('Failed to add camera: ${response.body}');
//     }
//   }

//   void addCameraManually() {
//     // You can navigate to a manual add camera screen
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text("Manual add not implemented yet.")),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFE9F0FF),
//       appBar: AppBar(
//         backgroundColor: Colors.blueAccent,
//         elevation: 0,
//         title: const Text(
//           "Please Add Your Camera",
//           style: TextStyle(fontSize: 20, color: Colors.white),
//         ),
//       ),
//       body: isDiscovering
//           ? const Center(child: CircularProgressIndicator())
//           : Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 children: [
//                   if (!discoveryDone)
//                     Column(
//                       children: [
//                         buildCard(
//                           title: "Discover Your Cameras",
//                           icon: Icons.search,
//                           onTap: discoverCameras,
//                         ),
//                         const SizedBox(height: 16),
//                         buildCard(
//                           title: "Add Camera Manually",
//                           icon: Icons.add_box,
//                           onTap: addCameraManually,
//                         ),
//                       ],
//                     )
//                   else
//                     Column(
//                       children: [
//                         Text(
//                           "You’ve already added a camera. You can add more if you want:",
//                           style: const TextStyle(fontSize: 16),
//                           textAlign: TextAlign.center,
//                         ),
//                         const SizedBox(height: 20),
//                         buildCard(
//                           title: "Discover More Cameras",
//                           icon: Icons.add_to_photos,
//                           onTap: discoverCameras,
//                         ),
//                         const SizedBox(height: 16),
//                         buildCard(
//                           title: "Add Camera Manually",
//                           icon: Icons.add_box,
//                           onTap: addCameraManually,
//                         ),
//                       ],
//                     )
//                 ],
//               ),
//             ),
//     );
//   }

//   Widget buildCard(
//       {required String title,
//       required IconData icon,
//       required VoidCallback onTap}) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Card(
//         elevation: 3,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         child: Container(
//           padding: const EdgeInsets.all(20),
//           width: double.infinity,
//           child: Row(
//             children: [
//               Icon(icon, size: 28, color: Colors.blue),
//               const SizedBox(width: 16),
//               Text(title, style: const TextStyle(fontSize: 18)),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

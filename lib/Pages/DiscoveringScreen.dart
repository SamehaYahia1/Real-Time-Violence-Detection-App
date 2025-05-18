// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_application_1/Constant/api_endpoint.dart';
// import 'package:flutter_application_1/Constant/token_handler.dart';
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:flutter_application_1/Camera/CameraDIsplayScreen.dart';
// import 'package:flutter_application_1/Camera/CameraCard.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class DiscoveringScreen extends StatefulWidget {
//   final String username;
//   final String userId;

//   const DiscoveringScreen({
//     Key? key,
//     required this.username,
//     required this.userId,
//   }) : super(key: key);

//   @override
//   State<DiscoveringScreen> createState() => _DiscoveringScreenState();
// }

// class _DiscoveringScreenState extends State<DiscoveringScreen> {
//   String? cameraIp;
//   bool isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     loadCameraInfo();
//   }
// //must get from the backend not shared preferences
//   Future<void> loadCameraInfo() async {
//     final prefs = await SharedPreferences.getInstance();
//     final savedIp = prefs.getString('camera_ip');

//     if (savedIp != null) {
//       setState(() {
//         cameraIp = savedIp;
//         isLoading = false;
//       });
//     } else {
//       await discoverAndSaveCamera();
//     }
//   }

// // change it to the backend
//   Future<void> discoverAndSaveCamera() async {
//     const platform = MethodChannel('onvif_discovery');
//     try {
//       final List<dynamic> cameras =
//           await platform.invokeMethod('discoverOnvifCameras');
//       if (!mounted) return;
//       if (cameras.isNotEmpty) {
//         final ip = cameras[0]['ip'];
//         final prefs = await SharedPreferences.getInstance();
//         await prefs.setString('camera_ip', ip);

//         setState(() {
//           cameraIp = ip;
//           isLoading = false;
//         });
//       } else {
//         setState(() => isLoading = false);
//       }
//     } catch (e) {
//       print("Camera discovery failed: $e");
//       setState(() => isLoading = false);
//     }
//   }

//   void navigateToCameraScreen(BuildContext context, String CameraName) async {
//     if (cameraIp != null) {
//       final RTCPUrl = "rtsp://admin:admin123456@$cameraIp:8554/profile0";
//       //send to the backend
//       await sendCameraToBackend(CameraName, RTCPUrl);
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => CameraDisplayScreen(
//             cameraName: CameraName,
//             streamUrl: RTCPUrl,
//           ),
//         ),
//       );
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("No camera discovered yet.")),
//       );
//     }
//   }

//   Future<void> sendCameraToBackend(String cameraName, String RTCPUrl) async {
//     final token = await TokenHandler().getToken();
//     if (token == null) {
//       print('Token not found. Please log in again.');
//       return;
//     }
//     final url = Uri.parse(
//         '${ApiEndpoints.baseUrl}/api/Camera/add'); // or your actual IP/domain

//     final response = await http.post(
//       url,
//       headers: {
//         'Content-Type': 'application/json',
//         'Authorization': 'Bearer $token'
//       },
//       body: jsonEncode({
//         'cameraName': cameraName,
//         'streamUrl': RTCPUrl,
//       }),
//     );

//     if (response.statusCode == 200 || response.statusCode == 201) {
//       print('Camera info sent successfully');
//     } else {
//       print('Failed to send camera info: ${response.body}');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (isLoading) {
//       return const Scaffold(
//         body: Center(child: CircularProgressIndicator()),
//       );
//     }

//     return Scaffold(
//       backgroundColor: const Color(0xFFE9F0FF),
//       body: Stack(
//         children: [
//           Column(
//             children: [
//               AppBar(
//                 backgroundColor: Colors.blueAccent,
//                 elevation: 0,
//                 title: const Text(
//                   "Your Cameras",
//                   style: TextStyle(
//                     fontSize: 20,
//                     fontStyle: FontStyle.italic,
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//               Expanded(
//                 child: cameraIp != null
//                     ? ListView(
//                         padding: const EdgeInsets.all(16),
//                         children: [
//                           CameraCard(
//                             cameraName: "Camera 1", //living room camera
//                             onTap: () =>
//                                 navigateToCameraScreen(context, "Camera 1"),
//                           ),
//                         ],
//                       )
//                     : const Center(
//                         child: Text(
//                           "No cameras discovered.",
//                           style: TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.w500,
//                             color: Colors.grey,
//                           ),
//                         ),
//                       ),
//               ),
//             ],
//           ),
//           Positioned(
//             top: 0,
//             right: -90,
//             child: Image.asset(
//               'Assets/images/background.png',
//               width: 300,
//               height: 300,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

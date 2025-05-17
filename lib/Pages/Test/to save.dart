// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_application_1/Constant/api_endpoint.dart';
// import 'package:flutter_application_1/Constant/token_handler.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:flutter_application_1/Camera/CameraCard.dart';
// import 'package:flutter_application_1/Camera/CameraDIsplayScreen.dart';

// class DiscoveringScreen extends StatefulWidget {
//   final String username;
//   final String userId;

//   const DiscoveringScreen(
//       {super.key, required this.username, required this.userId});

//   @override
//   State<DiscoveringScreen> createState() => _DiscoveringScreenState();
// }

// class _DiscoveringScreenState extends State<DiscoveringScreen> {
//   String? cameraIp;
//   bool isLoading = true;
//   @override
//   void initState() {
//     super.initState();
//     discoverCamera();
//   }

//   Future<void> sendRtspUrlToBackend(String RTCPUrl, String cameraIp) async {
//     final token = await TokenHandler().getToken();
//     if (token == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//             content: Text("No token found. User might not be logged in.")),
//       );
//       return;
//     }

//     final url =
//         Uri.parse('${ApiEndpoints.baseUrl}/api/Auth/login'); // change it

//     final response = await http.post(
//       url,
//       headers: {
//         'Content-Type': 'application/json',
//         'Authorization': 'Bearer $token',
//       },
//       body: jsonEncode({'rtspUrl': RTCPUrl, 'cameraIp': cameraIp}),
//     );

//     if (response.statusCode == 200) {
//       print("Stream sent successfully");
//     } else {
//       print("Failed to send stream: ${response.statusCode} - ${response.body}");
//     }
//   }

//   Future<void> discoverCamera() async {
//     const platform = MethodChannel('onvif_discovery');
//     try {
//       final List<dynamic> cameras =
//           await platform.invokeMethod('discoverOnvifCameras');
//       if (!mounted) return;
//       if (cameras.isNotEmpty) {
//         setState(() {
//           cameraIp = cameras[0]['ip'];
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

//   void navigateToCameraScreen(BuildContext context, String location) async {
//     if (cameraIp != null) {
//       final RTCPUrl = "rtsp://admin:admin123456@$cameraIp:8554/profile0";
//       await sendRtspUrlToBackend(
//         RTCPUrl,
//         cameraIp!,
//       );

//       // Navigator.push(
//       //   context,
//       //   MaterialPageRoute(
//       //     builder: (context) => CameraDisplayScreen(
//       //       cameraLocation: location,
//       //       streamUrl: RTCPUrl,
//       //     ),
//       //   ),
//       // );
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("No camera discovered yet.")),
//       );
//     }
//   }

//   @override
//   @override
//   Widget build(BuildContext context) {
//     if (isLoading) {
//       return const Center(child: CircularProgressIndicator());
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
//                   //"Welcome, ${widget.username}!\nYour Cameras",
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
//                             cameraName: "Camera 1",
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




// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_application_1/Constant/api_endpoint.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:flutter_application_1/Camera/CameraCard.dart';
// import 'package:flutter_application_1/Camera/CameraDIsplayScreen.dart';

// class DiscoveringScreen extends StatefulWidget {
//   final String username;
//   final String userId;

//   const DiscoveringScreen(
//       {super.key, required this.username, required this.userId});

//   @override
//   State<DiscoveringScreen> createState() => _DiscoveringScreenState();
// }

// class _DiscoveringScreenState extends State<DiscoveringScreen> {
//   String? cameraIp;
//   bool isLoading = true;
//   @override
//   void initState() {
//     super.initState();
//     discoverCamera();
//   }

//   // Future<void> sendRtspUrlToBackend(String RTCPUrl, String userId) async {
//   //   final url =
//   //       Uri.parse('${ApiEndpoints.baseUrl}/api/Auth/login'); // change it

//   //   final response = await http.post(
//   //     url,
//   //     headers: {
//   //       'Content-Type': 'application/json',
//   //     },
//   //     body: jsonEncode({
//   //       'userId': userId,
//   //       'rtspUrl': RTCPUrl,
//   //     }),
//   //   );

//   //   if (response.statusCode == 200) {
//   //     print("Stream sent successfully");
//   //   } else {
//   //     print("Failed to send stream: ${response.statusCode} - ${response.body}");
//   //   }
//   // }

//   Future<void> discoverCamera() async {
//     const platform = MethodChannel('onvif_discovery');
//     try {
//       final List<dynamic> cameras =
//           await platform.invokeMethod('discoverOnvifCameras');
//       if (!mounted) return;
//       if (cameras.isNotEmpty) {
//         setState(() {
//           cameraIp = cameras[0]['ip'];
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

//   void navigateToCameraScreen(BuildContext context, String location) async {
//     if (cameraIp != null) {
//       final RTCPUrl = "rtsp://admin:admin123456@$cameraIp:8554/profile0";
//       //await sendRtspUrlToBackend(RTCPUrl, widget.userId);

//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => CameraDisplayScreen(
//             cameraLocation: location,
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

//   @override
//   @override
//   Widget build(BuildContext context) {
//     if (isLoading) {
//       return const Center(child: CircularProgressIndicator());
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
//                 title: Text(
//                   //"Welcome, ${widget.username}!\nYour Cameras",
//                   "Your Cameras",
//                   style: const TextStyle(
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
//                             cameraLocation: "Camera 1",
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

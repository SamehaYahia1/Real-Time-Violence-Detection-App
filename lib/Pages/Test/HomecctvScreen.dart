// import 'package:curved_navigation_bar/curved_navigation_bar.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_application_1/Camera/CameraCard.dart';
// import 'package:flutter_application_1/Camera/CameraDIsplayScreen.dart';
// import 'package:flutter_application_1/Pages/AddScreen.dart';
// import 'package:flutter_application_1/Pages/DiscoveringScreen.dart';
// import 'package:flutter_application_1/Pages/NotificationScreen.dart';
// import 'package:flutter_application_1/Pages/RecordsScreen.dart';
// import 'package:flutter_application_1/Pages/SettingsScreen.dart';

// class HomeCCTVScreen extends StatefulWidget {
//   final String userId;
//   final String username;
//   final int subscriptionPlan;

//   const HomeCCTVScreen(
//       {super.key,
//       required this.userId,
//       required this.username,
//       required this.subscriptionPlan});

//   @override
//   State<HomeCCTVScreen> createState() => _HomeCCTVScreenState();
// }

// class _HomeCCTVScreenState extends State<HomeCCTVScreen> {
//   int index = 2; // Initial index to show the first screen
//   final items = const <Widget>[
//     Icon(Icons.home, size: 30, color: Colors.black),
//     Icon(Icons.videocam, size: 30, color: Colors.black),
//     Icon(Icons.add, size: 30, color: Colors.black),
//     Icon(Icons.notifications, size: 30, color: Colors.black),
//     Icon(Icons.settings, size: 30, color: Colors.black),
//   ];

//   late final List<Widget> _screens;

//   // List of screens to navigate to

//   void initState() {
//     super.initState();
//     _screens = [
//       HomeScreen(),
//       VideoScreen(),
//       AddScreen(),
//       NotificationsScreen(),
//       SettingsScreen(),
//     ];
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFE9F0FF),
//       body: _screens[index], // Display the screen based on the selected index

//       bottomNavigationBar: CurvedNavigationBar(
//         animationDuration: const Duration(milliseconds: 400),
//         height: 60,
//         backgroundColor: Colors.transparent,
//         buttonBackgroundColor: Colors.blueAccent,
//         items: items,
//         index: index,
//         onTap: (index) {
//           setState(() {
//             this.index = index; // Update the current index
//           });
//         },
//       ),
//     );
//   }
// }

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   String? cameraIp;
//   bool isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     discoverCamera();
//   }

//   Future<void> discoverCamera() async {
//     const platform = MethodChannel('onvif_discovery');
//     try {
//       final List<dynamic> cameras =
//           await platform.invokeMethod('discoverOnvifCameras');
//       print("Discovered Cameras: $cameras");
//       if (cameras.isNotEmpty) {
//         final ip = cameras[0]['ip'];
//         setState(() {
//           cameraIp = ip;
//           isLoading = false;
//         });
//       } else {
//         setState(() {
//           isLoading = false;
//         });
//         // You may want to show a message that no cameras were found
//       }
//     } catch (e) {
//       print("Camera discovery failed: $e");
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }

//   void navigateToCameraScreen(BuildContext context, String location) {
//     if (cameraIp != null) {
//       final RTCpUrl = "rtsp://admin:admin123456@$cameraIp:8554/profile0";
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => CameraDisplayScreen(
//             cameraLocation: location,
//             streamUrl: RTCpUrl,
//           ),
//         ),
//       );
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("No camera discovered yet.")),
//       );
//     }
//   }

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
//                   "Welcome, User!\nYour Cameras",
//                   style: TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white),
//                 ),
//               ),
//               Expanded(
//                 child: ListView(
//                   padding: const EdgeInsets.all(16),
//                   children: [
//                     CameraCard(
//                       cameraLocation: "Living Room",
//                       onTap: () =>
//                           navigateToCameraScreen(context, "Living Room"),
//                     ),
//                     // CameraCard(
//                     //   cameraLocation: "Kitchen",
//                     //   onTap: () => navigateToCameraScreen(context, "Kitchen"),
//                     // ),
//                     // CameraCard(
//                     //   cameraLocation: "Bedroom",
//                     //   onTap: () => navigateToCameraScreen(context, "Bedroom"),
//                     // ),
//                   ],
//                 ),
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

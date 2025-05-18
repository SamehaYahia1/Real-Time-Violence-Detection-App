// import 'package:flutter/material.dart';
// import 'package:flutter_application_1/Pages/login_screen.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class UserPage extends StatefulWidget {
//   final String userName;
//   const UserPage({super.key, required this.userName});

//   @override
//   State<UserPage> createState() => _UserPageState();
// }

// class _UserPageState extends State<UserPage> {
//   Future<void> _logout() async {
//     final confirmed = await showDialog<bool>(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Logout'),
//         content: const Text('Are you sure you want to log out?'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context, false),
//             child: const Text('Cancel'),
//           ),
//           TextButton(
//             onPressed: () => Navigator.pop(context, true),
//             child: const Text('Logout'),
//           ),
//         ],
//       ),
//     );

//     if (confirmed ?? false) {
//       final prefs = await SharedPreferences.getInstance();
//       await prefs.remove('jwt_token');

//       if (!mounted) return;
//       Navigator.pushAndRemoveUntil(
//         context,
//         MaterialPageRoute(builder: (_) => const LoginScreen()),
//         (route) => false,
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('User Page'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.logout),
//             tooltip: 'Logout',
//             onPressed: _logout,
//           ),
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             Text(
//               'Welcome, ${widget.userName}!',
//               textAlign: TextAlign.center,
//               style: const TextStyle(fontSize: 20),
//             ),
//             const SizedBox(height: 24),
//             ElevatedButton.icon(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                       builder: (_) => const UserPage(
//                             userName: 'User',
//                           )),
//                 );
//               },
//               icon: const Icon(Icons.videocam),
//               label: const Text('View My Cameras'),
//               style: ElevatedButton.styleFrom(
//                 padding: const EdgeInsets.symmetric(vertical: 16),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

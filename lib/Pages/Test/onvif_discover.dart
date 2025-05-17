// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_application_1/Pages/stream_url.dart';

// class OnvifDiscoveryScreen extends StatefulWidget {
//   const OnvifDiscoveryScreen({super.key});

//   @override
//   State<OnvifDiscoveryScreen> createState() => _OnvifDiscoveryScreenState();
// }

// class _OnvifDiscoveryScreenState extends State<OnvifDiscoveryScreen> {
//   static const platform = MethodChannel('onvif_discovery');

//   List<Map<String, String>> _cameras = [];
//   bool _loading = false;
//   String? _error;

//   Future<void> _discoverCameras() async {
//     setState(() {
//       _loading = true;
//       _error = null;
//     });

//     try {
//       final List cameras = await platform.invokeMethod('discoverOnvifCameras');

//       setState(() {
//         _cameras = cameras.map<Map<String, String>>((camera) {
//           return {
//             'ip': camera['ip'] ?? '',
//             'xaddrs': camera['xaddrs'] ?? '',
//           };
//         }).toList();
//         _loading = false;
//       });
//     } on PlatformException catch (e) {
//       setState(() {
//         _error = "Discovery failed: ${e.message}";
//         _loading = false;
//       });
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     _discoverCameras();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('ONVIF Camera Discovery')),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: _loading
//             ? const Center(child: CircularProgressIndicator())
//             : _error != null
//                 ? Center(child: Text(_error!))
//                 : _cameras.isEmpty
//                     ? const Center(child: Text('No cameras found.'))
//                     : ListView.builder(
//                         itemCount: _cameras.length,
//                         itemBuilder: (context, index) {
//                           final camera = _cameras[index];
//                           return ListTile(
//                             title: Text(camera['ip'] ?? ''),
//                             subtitle: Text(camera['xaddrs'] ?? ''),
//                             onTap: () async {
//                               try {
//                                 final String streamUrl =
//                                     await platform.invokeMethod(
//                                   'getStreamUri',
//                                   {
//                                     'xaddr': camera['xaddrs'],
//                                     'username':
//                                         'admin', // replace with real username
//                                     'password':
//                                         'admin123456', // replace with real password
//                                   },
//                                 );

//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (context) =>
//                                         CameraStreamScreen(rtspUrl: streamUrl),
//                                   ),
//                                 );
//                               } on PlatformException catch (e) {
//                                 ScaffoldMessenger.of(context).showSnackBar(
//                                   SnackBar(
//                                       content: Text(
//                                           'Failed to get stream URL: ${e.message}')),
//                                 );
//                               }
//                             },
//                           );
//                         },
//                       ),
//       ),
//     );
//   }
// }

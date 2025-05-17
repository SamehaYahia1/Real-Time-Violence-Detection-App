// import 'package:flutter/material.dart';
// import 'package:flutter_vlc_player/flutter_vlc_player.dart';

// class CameraStreamScreen extends StatefulWidget {
//   final String rtspUrl;

//   const CameraStreamScreen({Key? key, required this.rtspUrl}) : super(key: key);

//   @override
//   _CameraStreamScreenState createState() => _CameraStreamScreenState();
// }

// class _CameraStreamScreenState extends State<CameraStreamScreen> {
//   late VlcPlayerController _vlcViewController;

//   @override
//   void initState() {
//     super.initState();
//     _vlcViewController = VlcPlayerController.network(
//       widget.rtspUrl,
//       hwAcc: HwAcc.full,
//       autoPlay: true,
//     );
//   }

//   @override
//   void dispose() {
//     _vlcViewController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Camera Stream")),
//       body: Center(
//         child: VlcPlayer(
//           controller: _vlcViewController,
//           aspectRatio: 16 / 9,
//           placeholder: const Center(child: CircularProgressIndicator()),
//         ),
//       ),
//     );
//   }
// }

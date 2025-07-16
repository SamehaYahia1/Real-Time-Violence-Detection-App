// import 'package:flutter/material.dart';
// import 'package:flutter_vlc_player/flutter_vlc_player.dart';

// //vlc
// class CameraDisplayScreen extends StatefulWidget {
//   final String cameraName;
//   final String streamUrl;

//   const CameraDisplayScreen({
//     Key? key,
//     required this.cameraName,
//     required this.streamUrl,
//   }) : super(key: key);

//   @override
//   State<CameraDisplayScreen> createState() => _CameraDisplayScreenState();
// }

// class _CameraDisplayScreenState extends State<CameraDisplayScreen> {
//   late VlcPlayerController _vlcViewController;

//   @override
//   void initState() {
//     super.initState();

//     print("Initializing VLC player with stream URL: ${widget.streamUrl}");

//     _vlcViewController = VlcPlayerController.network(
//       widget.streamUrl,
//       hwAcc: HwAcc.auto,
//       autoPlay: true,
//       options: VlcPlayerOptions(

//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _vlcViewController.stop();
//     _vlcViewController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFE9F0FF),
//       body: Container(
//         decoration: const BoxDecoration(
//           image: DecorationImage(
//             image: AssetImage("Assets/images/camera_bg.png"),
//             fit: BoxFit.scaleDown,
//             alignment: Alignment(0, 0.15),
//             colorFilter: ColorFilter.mode(Color(0xFFE9F0FF), BlendMode.dstATop),
//           ),
//         ),
//         child: Column(
//           children: [
//             PreferredSize(
//               preferredSize: const Size.fromHeight(50),
//               child: ClipRRect(
//                 borderRadius:
//                     const BorderRadius.vertical(bottom: Radius.circular(30)),
//                 child: AppBar(
//                   backgroundColor: const Color(0xFFBFD7ED),
//                   leadingWidth: 30,
//                   titleSpacing: 8,
//                   // elevation: 4,
//                   // automaticallyImplyLeading: false,
//                   title: Row(
//                     children: [
//                       Icon(Icons.camera_alt, color: Colors.black87),
//                       SizedBox(width: 10),
//                       Text("${widget.cameraName} Live Feed",
//                           style: const TextStyle(
//                               fontSize: 22,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.black87)),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//             Expanded(
//               child: Center(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     // Text(
//                     //   "Displaying the live feed from ${widget.cameraName}",
//                     //   style: const TextStyle(fontSize: 18, color: Colors.black),
//                     // ),
//                     const SizedBox(height: 20),
//                     SizedBox(
//                       width: 400,
//                       height: 300,
//                       child: VlcPlayer(
//                         controller: _vlcViewController,
//                         aspectRatio: 16 / 9,
//                         placeholder:
//                             const Center(child: CircularProgressIndicator()),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:better_player/better_player.dart';

// class CameraDisplayScreen extends StatefulWidget {
//   final String cameraName;
//   final String streamUrl; // The .m3u8 stream from your backend

//   const CameraDisplayScreen({
//     Key? key,
//     required this.cameraName,
//     required this.streamUrl,
//   }) : super(key: key);

//   @override
//   State<CameraDisplayScreen> createState() => _CameraDisplayScreenState();
// }

// class _CameraDisplayScreenState extends State<CameraDisplayScreen> {
//   late BetterPlayerController _betterPlayerController;

//   @override
//   void initState() {
//     super.initState();

//     final source = BetterPlayerDataSource(
//       BetterPlayerDataSourceType.network,
//       widget.streamUrl
//           .replaceAll("localhost", "10.0.2.2"), // ✅ Important for emulator
//       liveStream: true,
//     );

//     _betterPlayerController = BetterPlayerController(
//       BetterPlayerConfiguration(
//         aspectRatio: 16 / 9,
//         autoPlay: true,
//         controlsConfiguration: BetterPlayerControlsConfiguration(
//           enableFullscreen: true,
//         ),
//         errorBuilder: (context, error) => Center(
//           child: Text(
//             "Failed to load stream",
//             style: TextStyle(color: Colors.red),
//           ),
//         ),
//       ),
//       betterPlayerDataSource: source,
//     );
//   }

//   @override
//   void dispose() {
//     _betterPlayerController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFE9F0FF),
//       appBar: AppBar(
//         title: Text("${widget.cameraName} Live Feed"),
//         backgroundColor: const Color(0xFFBFD7ED),
//       ),
//       body: Center(
//         child: AspectRatio(
//           aspectRatio: 16 / 9,
//           child: BetterPlayer(controller: _betterPlayerController),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';

//vlc
class CameraDisplayScreen extends StatefulWidget {
  final String cameraName;
  final String streamUrl;

  const CameraDisplayScreen({
    Key? key,
    required this.cameraName,
    required this.streamUrl,
  }) : super(key: key);

  @override
  State<CameraDisplayScreen> createState() => _CameraDisplayScreenState();
}

class _CameraDisplayScreenState extends State<CameraDisplayScreen> {
  late VlcPlayerController _vlcViewController;

  @override
  void initState() {
    super.initState();

    print("Initializing VLC player with stream URL: ${widget.streamUrl}");

    _vlcViewController = VlcPlayerController.network(
      widget.streamUrl,
      hwAcc: HwAcc.auto,
      autoPlay: true,
      // options: VlcPlayerOptions(
      //   advanced: VlcAdvancedOptions([
      //     VlcAdvancedOptions.networkCaching(200),
      //   ]),
      //   http: VlcHttpOptions([
      //     VlcHttpOptions.httpReconnect(true),
      //   ]),
      //   live: VlcLiveOptions([
      //     VlcLiveOptions.liveCaching(200),
      //   ]),
      // ),
      options: VlcPlayerOptions(
        advanced: VlcAdvancedOptions([
          VlcAdvancedOptions.networkCaching(200),
          VlcAdvancedOptions.liveCaching(200),
        ]),
        http: VlcHttpOptions([
          VlcHttpOptions.httpReconnect(true),
        ]),
      ),
    );
  }

  @override
  void dispose() {
    _vlcViewController.stop();
    _vlcViewController.dispose();
    super.dispose();
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
            colorFilter: ColorFilter.mode(Color(0xFFE9F0FF), BlendMode.dstATop),
          ),
        ),
        child: Column(
          children: [
            PreferredSize(
              preferredSize: const Size.fromHeight(50),
              child: ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(bottom: Radius.circular(30)),
                child: AppBar(
                  backgroundColor: const Color(0xFFBFD7ED),
                  leadingWidth: 30,
                  titleSpacing: 8,
                  // elevation: 4,
                  // automaticallyImplyLeading: false,
                  title: Row(
                    children: [
                      Icon(Icons.camera_alt, color: Colors.black87),
                      SizedBox(width: 10),
                      Text("${widget.cameraName} Live Feed",
                          style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87)),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Text(
                    //   "Displaying the live feed from ${widget.cameraName}",
                    //   style: const TextStyle(fontSize: 18, color: Colors.black),
                    // ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: 400,
                      height: 300,
                      child: VlcPlayer(
                        controller: _vlcViewController,
                        aspectRatio: 16 / 9,
                        placeholder:
                            const Center(child: CircularProgressIndicator()),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

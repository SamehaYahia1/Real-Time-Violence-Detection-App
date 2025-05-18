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
      options: VlcPlayerOptions(),
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
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(widget.cameraName,
            style: const TextStyle(color: Colors.white)),
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Displaying the live feed from ${widget.cameraName}",
              style: const TextStyle(fontSize: 18, color: Colors.black),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 400,
              height: 300,
              child: VlcPlayer(
                controller: _vlcViewController,
                aspectRatio: 16 / 9,
                placeholder: const Center(child: CircularProgressIndicator()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

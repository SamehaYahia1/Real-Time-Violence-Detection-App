import 'package:flutter/material.dart';
import 'package:mjpeg_stream/mjpeg_stream.dart';

class CameraStreamPage extends StatelessWidget {
  final String streamUrl;
  final String cameraName;

  const CameraStreamPage({
    super.key,
    required this.streamUrl,
    required this.cameraName,
  });

  @override
  Widget build(BuildContext context) {
    final adjustedUrl = streamUrl.replaceFirst('localhost', '10.0.2.2');

    return Scaffold(
      appBar: AppBar(
        title: Text(cameraName),
      ),
      body: Center(
        child: MJPEGStreamScreen(
          streamUrl: adjustedUrl,
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.contain,
          showLiveIcon: false, // <<< 🌟 this line was missing!
        ),
      ),
    );
  }
}

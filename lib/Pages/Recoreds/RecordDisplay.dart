import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:video_player/video_player.dart';

class RecordDisplay extends StatefulWidget {
  final String videoUrl; //video link from firebase

  const RecordDisplay({super.key, required this.videoUrl});

  @override
  State<RecordDisplay> createState() => _RecordDisplayState();
}

class _RecordDisplayState extends State<RecordDisplay> {
  late VideoPlayerController
      _videoPlayerController; //controls the video {pause , play}
  bool _isInitialized =
      false; //checks if the video is initialized{ready to show or not}

  @override
  void initState() {
    super.initState();
    _videoPlayerController =
        VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
          ..initialize().then((_) {
            setState(() {
              _isInitialized = true;
            }); // Update the UI when the video is ready
          })
          ..setLooping(true) // reads the video after it ends
          ..play(); // Auto-play
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }
  //Releases the video controller when the screen is closed

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
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black87),
                    onPressed: () => Navigator.pop(context),
                  ),
                  title: const Text('Record Display',
                      style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                      )),
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: _isInitialized
                    ? AspectRatio(
                        aspectRatio: _videoPlayerController.value.aspectRatio,
                        child: Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            VideoPlayer(_videoPlayerController),
                            VideoProgressIndicator(_videoPlayerController,
                                allowScrubbing: true),
                            Positioned(
                              bottom: 10,
                              right: 10,
                              child: FloatingActionButton(
                                backgroundColor: Colors.black54,
                                mini: true,
                                onPressed: () {
                                  setState(() {
                                    _videoPlayerController.value.isPlaying
                                        ? _videoPlayerController.pause()
                                        : _videoPlayerController.play();
                                  });
                                },
                                child: Icon(
                                  _videoPlayerController.value.isPlaying
                                      ? Icons.pause
                                      : Icons.play_arrow,
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    : LoadingAnimationWidget.staggeredDotsWave(
                        color: const Color.fromARGB(255, 60, 90, 118),
                        size: 80,
                      ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

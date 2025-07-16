import 'package:flutter/material.dart';
import 'package:flutter_application_1/Pages/Notifactions/url_convert.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:video_player/video_player.dart';
import 'package:appinio_video_player/appinio_video_player.dart';

class RecordDisplay extends StatefulWidget {
  final String videoUrl; //video link from firebase

  const RecordDisplay({super.key, required this.videoUrl});

  @override
  State<RecordDisplay> createState() => _RecordDisplayState();
}

class _RecordDisplayState extends State<RecordDisplay> {
  // late VideoPlayerController
  //     _videoPlayerController;
  // bool _isInitialized = false;
  late CustomVideoPlayerController _customVideoPlayerController;
  bool _isInitialized = false;
  bool _isMuted = false;

  @override
  void initState() {
    super.initState();
    // _videoPlayerController = VideoPlayerController.networkUrl(
    //     Uri.parse(fixMinioUrl(widget.videoUrl)))
    //   ..initialize().then((_) {
    //     setState(() {
    //       _isInitialized = true;
    //     }); // Update the UI when the video is ready
    //   })
    //   ..setLooping(true) // reads the video after it ends
    //   ..play(); // Auto-play

    initializeVideoPlayer();
  }

  @override
  void dispose() {
    //_videoPlayerController.dispose();
    _customVideoPlayerController.videoPlayerController.dispose();
    super.dispose();
  }

  //Releases the video controller when the screen is closed
  Future<void> initializeVideoPlayer() async {
    final controller = VideoPlayerController.networkUrl(
      Uri.parse(fixMinioUrl(widget.videoUrl)),
    );

    await controller.initialize();
    controller.setLooping(true);
    controller.setVolume(_isMuted ? 0.0 : 1.0);
    controller.play();

    _customVideoPlayerController = CustomVideoPlayerController(
      context: context,
      videoPlayerController: controller,
    );

    setState(() {
      _isInitialized = true;
    });
  }

  void _toggleMute() {
    final controller = _customVideoPlayerController.videoPlayerController;
    setState(() {
      _isMuted = !_isMuted;
      controller.setVolume(_isMuted ? 0.0 : 1.0);
    });
  }

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
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(30),
                ),
                child: AppBar(
                  backgroundColor: const Color(0xFFBFD7ED),
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black87),
                    onPressed: () => Navigator.pop(context),
                  ),
                  title: const Text(
                    'Recorded Video',
                    style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: _isInitialized
                    ? Stack(
                        alignment: Alignment.topRight,
                        children: [
                          CustomVideoPlayer(
                            customVideoPlayerController:
                                _customVideoPlayerController,
                          ),
                          Positioned(
                            top: 10,
                            right: 10,
                            child: IconButton(
                              icon: Icon(
                                _isMuted ? Icons.volume_off : Icons.volume_up,
                              ),
                              iconSize: 24,
                              color: Colors.white,
                              onPressed: _toggleMute,
                            ),
                          ),
                        ],
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

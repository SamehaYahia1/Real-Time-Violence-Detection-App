import 'package:flutter/material.dart';

class RecordDisplay extends StatefulWidget {
  final String videoUrl;

  const RecordDisplay({super.key, required this.videoUrl});

  @override
  State<RecordDisplay> createState() => _RecordDisplayState();
}

class _RecordDisplayState extends State<RecordDisplay> {
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
                  leading: IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.black87),
                    onPressed: () => Navigator.pop(context),
                  ),
                  title: Text('Record Display',
                      style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                      )),
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Text(
                  'Video URL:\n${widget.videoUrl}',
                  style: TextStyle(fontSize: 18, color: Colors.black87),
                  textAlign: TextAlign.center,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

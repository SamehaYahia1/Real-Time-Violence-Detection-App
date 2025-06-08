import 'package:flutter/material.dart';
import 'package:flutter_application_1/Pages/Recoreds/RecordsCard.dart';

class VideoScreen extends StatefulWidget {
  const VideoScreen({super.key});

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
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
            colorFilter: ColorFilter.mode(
              Color(0xFFE9F0FF),
              BlendMode.dstATop,
            ),
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
                  elevation: 4,
                  shadowColor: Colors.black26,
                  automaticallyImplyLeading: false,
                  title: const Row(
                    children: [
                      Icon(Icons.video_library, color: Colors.black87),
                      SizedBox(width: 10),
                      Text(
                        "Records",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: const [
                  // _buildSectionTitle("Today"),
                  SizedBox(height: 10),
                  RecordCard(
                      title: "2020611_Living Room",
                      time: "12:30 PM",
                      size: "36.9 MB"),
                  RecordCard(
                      title: "2020610_Kitchen",
                      time: "10:30 AM",
                      size: "36.9 MB"),
                  RecordCard(
                      title: "2020609_Bed Room",
                      time: "08:30 AM",
                      size: "36.9 MB"),
                  // const SizedBox(height: 10),
                  // _buildSectionTitle("Yesterday"),
                  // const SizedBox(height: 10),
                  RecordCard(
                      title: "2020608_Family Room",
                      time: "21:30 PM",
                      size: "36.9 MB"),
                  RecordCard(
                      title: "2020607_Kitchen",
                      time: "20:30 PM",
                      size: "36.9 MB"),
                  RecordCard(
                      title: "2020606_Terrace",
                      time: "17:25 PM",
                      size: "36.9 MB",
                      isOutdoor: true),

                  RecordCard(
                      title: "2020607_Kitchen",
                      time: "20:30 PM",
                      size: "36.9 MB"),
                  RecordCard(
                      title: "2020606_Terrace",
                      time: "17:25 PM",
                      size: "36.9 MB",
                      isOutdoor: true),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

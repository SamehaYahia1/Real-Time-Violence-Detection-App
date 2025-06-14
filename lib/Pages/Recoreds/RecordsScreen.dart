import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Pages/Recoreds/RecordDisplay.dart';
import 'package:flutter_application_1/Pages/Recoreds/RecordsCard.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VideoScreen extends StatefulWidget {
  const VideoScreen({Key? key}) : super(key: key);

  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  Future<String?> _getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userId'); // make sure you previously saved it
  }

  Stream<QuerySnapshot<Map<String, dynamic>>>? _notificationStream;

  @override
  void initState() {
    super.initState();
    _getUserId().then((userId) {
      if (userId != null) {
        setState(() {
          _notificationStream = FirebaseFirestore.instance
              .collection('notifications')
              .doc(userId)
              .collection('items')
              .orderBy('timestamp', descending: true)
              .snapshots();
        });
      }
    });
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
                      )
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
                child: _notificationStream == null
                    ? Center(child: CircularProgressIndicator())
                    : StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                        stream: _notificationStream,
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return Center(
                              child: Text('Error: ${snapshot.error}'),
                            );
                          }
                          if (!snapshot.hasData ||
                              snapshot.data!.docs.isEmpty) {
                            return Center(child: Text('No recordings.'));
                          }
                          final documents = snapshot.data!.docs;

                          return ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: documents.length,
                            itemBuilder: (context, index) {
                              final data = documents[index].data();

                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => RecordDisplay(
                                                videoUrl: data['data']?[
                                                        'incident_video_url'] ??
                                                    '',
                                              )));
                                },
                                child: RecordCard(
                                  title: data['title'] ?? 'Unknown',
                                  time: (data['timestamp'] as Timestamp?)
                                          ?.toDate()
                                          .toString() ??
                                      '',
                                  size: '',
                                  isOutdoor: true,
                                  thumbnailUrl:
                                      data['data']?['thumbnail_url'] ?? '',
                                ),
                              );
                            },
                          );
                        },
                      ))
          ],
        ),
      ),
    );
  }
}

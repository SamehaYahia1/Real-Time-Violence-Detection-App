import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Constant/Background_container.dart';
import 'package:flutter_application_1/Constant/custome_header_appBar.dart';
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
    return prefs.getString('userId');
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
      body: BackgroundContainer(
        child: Column(
          children: [
            const CustomHeaderAppBar(
              icon: Icons.video_library,
              title: "Records",
            ),
            Expanded(
              child: _notificationStream == null
                  ? const Center(child: CircularProgressIndicator())
                  : StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                      stream: _notificationStream,
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Center(
                            child: Text('Error: ${snapshot.error}'),
                          );
                        }
                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return const Center(child: Text('No recordings.'));
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
                                      videoUrl: data['data']
                                              ?['incident_video_url'] ??
                                          '',
                                    ),
                                  ),
                                );
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
                    ),
            )
          ],
        ),
      ),
    );
  }
}

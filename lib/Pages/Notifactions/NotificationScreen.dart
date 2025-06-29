import 'package:flutter/material.dart';
import 'package:flutter_application_1/Constant/Background_container.dart';
import 'package:flutter_application_1/Constant/custome_header_appBar.dart';
import 'package:flutter_application_1/Pages/Notifactions/firebase_api.dart';
import 'package:flutter_application_1/main.dart';

class NotificationsScreen extends StatefulWidget {
  final Function(int)? onTapNotification;

  const NotificationsScreen({super.key, this.onTapNotification});

  static const route = '/notifications-screen';

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  late VoidCallback _notificationListener;

  @override
  void initState() {
    super.initState();

    _notificationListener = () {
      if (!mounted) return;
      setState(() {});
    };

    notificationCounter.addListener(_notificationListener);
    loadNotificationsFromFirestore().then((_) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    notificationCounter.removeListener(_notificationListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sortedNotifications = List.from(notificationList)
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));

    return Scaffold(
      backgroundColor: const Color(0xFFE9F0FF),
      body: BackgroundContainer(
        child: Column(
          children: [
            const CustomHeaderAppBar(
              icon: Icons.notifications,
              title: "Notifications",
            ),
            Expanded(
              child: sortedNotifications.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.notifications_off,
                            size: 60,
                            color: Colors.grey[400],
                          ),
                          SizedBox(height: 20),
                          Text(
                            "No notifications yet",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            "We'll notify you when something new arrives",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: EdgeInsets.only(top: 10, bottom: 20),
                      itemCount: sortedNotifications.length,
                      itemBuilder: (context, index) {
                        final message = sortedNotifications[index];
                        final bool isNew =
                            index == 0; // Mark most recent as new

                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 6),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 6,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Card(
                              margin: EdgeInsets.zero,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              color: isNew
                                  ? Color.fromARGB(255, 240, 248, 255)
                                  : const Color.fromARGB(255, 154, 199, 240)
                                      .withOpacity(0.7),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(16),
                                onTap: () {
                                  if (widget.onTapNotification != null) {
                                    widget.onTapNotification!(1);
                                    // 1 is the index of Records in your bottom nav
                                  }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Notification icon with status indicator
                                      Stack(
                                        children: [
                                          Container(
                                            padding: EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              color: isNew
                                                  ? Color(0xFF4A90E2)
                                                  : Color(0xFF4A90E2)
                                                      .withOpacity(0.7),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: Icon(
                                              isNew
                                                  ? Icons.notifications_active
                                                  : Icons.notifications,
                                              size: 24,
                                              color: Colors.white,
                                            ),
                                          ),
                                          if (isNew)
                                            Positioned(
                                              right: 0,
                                              top: 0,
                                              child: Container(
                                                padding: EdgeInsets.all(4),
                                                decoration: BoxDecoration(
                                                  color: Colors.redAccent,
                                                  shape: BoxShape.circle,
                                                  border: Border.all(
                                                    color: Colors.white,
                                                    width: 2,
                                                  ),
                                                ),
                                                width: 12,
                                                height: 12,
                                              ),
                                            ),
                                        ],
                                      ),
                                      SizedBox(width: 16),
                                      // Notification content
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Flexible(
                                                  child: Text(
                                                    message.title ?? "No Title",
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Colors.black,
                                                    ),
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                                Text(
                                                  formatTimestamp(
                                                      message.timestamp),
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.grey[700],
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 6),
                                            Text(
                                              message.body ?? "No Body",
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.grey[900],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

String formatTimestamp(DateTime? timestamp) {
  if (timestamp == null) return "Just now";

  final now = DateTime.now();
  final difference = now.difference(timestamp);

  if (difference.inSeconds < 60) {
    return "Just now";
  } else if (difference.inMinutes < 60) {
    return "${difference.inMinutes}m ago";
  } else if (difference.inHours < 24) {
    return "${difference.inHours}h ago";
  } else if (difference.inDays < 7) {
    return "${difference.inDays}d ago";
  } else {
    return "${timestamp.day.toString().padLeft(2, '0')}/"
        "${timestamp.month.toString().padLeft(2, '0')}/"
        "${timestamp.year.toString().substring(2)}";
  }
}

// Global callback class
class FirebaseNotificationHandler {
  static Function(String title, String body, String time)?
      onNotificationReceived;
}

import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_application_1/Pages/Notifactions/firebase_api.dart';
// import 'package:flutter_application_1/FirebaseApi.dart'; // import the global list

class NotificationsScreen extends StatefulWidget {
  NotificationsScreen({super.key});
  List<RemoteMessage> notificationList = [];
  ValueNotifier<int> notificationCounter = ValueNotifier<int>(0);

  static const route = '/notifications-screen';

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  void initState() {
    super.initState();
    notificationCounter.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        backgroundColor: const Color(0xFFBFD7ED),
        elevation: 4,
        shadowColor: Colors.black26,
        automaticallyImplyLeading: false,
        title: const Row(
          children: [
            Icon(Icons.notifications, color: Colors.black87),
            SizedBox(width: 10),
            Text(
              "Notifications",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
      body: ListView.builder(
        itemCount: notificationList.length,
        itemBuilder: (context, index) {
          final message = notificationList[notificationList.length - 1 - index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              leading: const Icon(Icons.notification_important),
              title: Text(message.notification?.title ?? "No Title"),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(message.notification?.body ?? "No Body"),
                  Text(message.sentTime?.toString() ?? "No Time",
                      style: const TextStyle(fontSize: 12)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// Global callback class
class FirebaseNotificationHandler {
  static Function(String title, String body, String time)?
      onNotificationReceived;
}





// import 'package:flutter/material.dart';
// import 'package:flutter_application_1/Pages/Notifactions/NotifiSettings.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// class NotificationsScreen extends StatefulWidget {
//   const NotificationsScreen({super.key});
//   static const route = '/notifications-screen';

//   @override
//   State<NotificationsScreen> createState() => _NotificationsScreenState();
// }

// class _NotificationsScreenState extends State<NotificationsScreen> {
//   @override
//   Widget build(BuildContext context) {
//     final message = ModalRoute.of(context)!.settings.arguments;
//     // Replace 'RemoteMessage' with the actual type if different
//     final remoteMessage = message as dynamic;
//     return Scaffold(
//       backgroundColor: Colors.blue[50],
//       appBar: AppBar(
//         backgroundColor: const Color(0xFFBFD7ED),
//         elevation: 4,
//         shadowColor: Colors.black26,
//         automaticallyImplyLeading: false,
//         title: const Row(
//           children: [
//             Icon(Icons.notifications, color: Colors.black87),
//             SizedBox(width: 10),
//             Text(
//               "Notifications",
//               style: TextStyle(
//                 fontSize: 22,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.black87,
//               ),
//             ),
//           ],
//         ),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text('${remoteMessage.notification?.title ?? ""}'),
//             Text('${remoteMessage.notification?.body ?? ""}'),
//             Text('${remoteMessage.data ?? ""}'),
//             Text('${remoteMessage.sentTime ?? ""}'),
//           ],
//         ),
//       ),
//     );
//   }
// }




//   // Function to add a new notification
//   void _addNotification(String title, String body) {
//     setState(() {
//       _notifications.insert(0, {
//         'icon': Icons.notifications,
//         'title': title,
//         'body': body,
//         'time': _formatTime(DateTime.now()),
//         'id': DateTime.now()
//             .millisecondsSinceEpoch
//             .toString(), // Unique ID for each notification
//       });
//     });
//   }

//   // Function to remove a notification
//   void _removeNotification(String id) {
//     setState(() {
//       _notifications.removeWhere((notification) => notification['id'] == id);
//     });
//   }

//   // Helper function to format time
//   String _formatTime(DateTime time) {
//     final now = DateTime.now();
//     final today = DateTime(now.year, now.month, now.day);
//     final yesterday = DateTime(now.year, now.month, now.day - 1);

//     if (time.isAfter(today)) {
//       return '${time.hour}:${time.minute.toString().padLeft(2, '0')}';
//     } else if (time.isAfter(yesterday)) {
//       return 'Yesterday';
//     } else {
//       return '${time.day}/${time.month}/${time.year}';
//     }
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
//             colorFilter: ColorFilter.mode(
//               Color(0xFFE9F0FF),
//               BlendMode.dstATop,
//             ),
//           ),
//         ),
//         child: Column(
//           children: [
//             PreferredSize(
//               preferredSize: const Size.fromHeight(50),
//               child: ClipRRect(
//                 borderRadius: const BorderRadius.vertical(
//                   bottom: Radius.circular(30),
//                 ),
//                 child: AppBar(
//                   backgroundColor: const Color(0xFFBFD7ED),
//                   elevation: 4,
//                   shadowColor: Colors.black26,
//                   automaticallyImplyLeading: false,
//                   title: const Row(
//                     children: [
//                       Icon(Icons.notifications, color: Colors.black87),
//                       SizedBox(width: 10),
//                       Text(
//                         "Notifications",
//                         style: TextStyle(
//                           fontSize: 22,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.black87,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//             Expanded(
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   children: [
//                     // Button to send test notification
//                     ElevatedButton(
//                       onPressed: () {
//                         const title = "Test Notification";
//                         const body =
//                             "This is a test notification from the app.";

//                         // Send notification
//                         // NotifiSettings().showNotification(
//                         //   title: title,
//                         //   body: body,
//                         // );

//                         // Save notification locally
//                         _addNotification(title, body);
//                       },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: const Color(0xFFBFD7ED),
//                         foregroundColor: Colors.black87,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         elevation: 2,
//                       ),
//                       child: const Padding(
//                         padding: EdgeInsets.symmetric(vertical: 12.0),
//                         child: Text(
//                           "Send Test Notification",
//                           style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 20),
//                     // Notification list
//                     Expanded(
//                       child: _notifications.isEmpty
//                           ? const Center(
//                               child: Text(
//                                 "No notifications yet",
//                                 style: TextStyle(
//                                   fontSize: 16,
//                                   color: Colors.grey,
//                                 ),
//                               ),
//                             )
//                           : ListView.builder(
//                               itemCount: _notifications.length,
//                               itemBuilder: (context, index) {
//                                 final notification = _notifications[index];
//                                 return _buildDismissibleNotificationCard(
//                                   context,
//                                   notification,
//                                   index,
//                                 );
//                               },
//                             ),
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

//   Widget _buildDismissibleNotificationCard(
//       BuildContext context, Map<String, dynamic> notification, int index) {
//     return Dismissible(
//       key: Key(notification['id']),
//       direction: DismissDirection.endToStart, // Swipe left to delete
//       background: Container(
//         margin: const EdgeInsets.only(bottom: 12),
//         decoration: BoxDecoration(
//           color: Colors.red[400],
//           borderRadius: BorderRadius.circular(12),
//         ),
//         alignment: Alignment.centerRight,
//         padding: const EdgeInsets.only(right: 20),
//         child: const Icon(
//           Icons.delete,
//           color: Colors.white,
//           size: 30,
//         ),
//       ),
//       onDismissed: (direction) {
//         _removeNotification(notification['id']);

//         // Show a snackbar to undo the deletion
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Notification "${notification['title']}" deleted'),
//             action: SnackBarAction(
//               label: 'UNDO',
//               textColor: Colors.white,
//               onPressed: () {
//                 // Reinsert the item at the original position
//                 setState(() {
//                   _notifications.insert(index, notification);
//                 });
//               },
//             ),
//           ),
//         );
//       },
//       child: NotificationCard(
//         icon: notification['icon'],
//         title: notification['title'],
//         body: notification['body'],
//         time: notification['time'],
//       ),
//     );
//   }
// }

// class NotificationCard extends StatelessWidget {
//   final IconData icon;
//   final String title;
//   final String body;
//   final String time;

//   const NotificationCard({
//     super.key,
//     required this.icon,
//     required this.title,
//     required this.body,
//     required this.time,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: const EdgeInsets.only(bottom: 12),
//       elevation: 2,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(12.0),
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Icon
//             Container(
//               padding: const EdgeInsets.all(10),
//               decoration: BoxDecoration(
//                 color: const Color(0xFFBFD7ED).withOpacity(0.7),
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: Icon(icon, size: 24, color: Colors.black87),
//             ),
//             const SizedBox(width: 12),
//             // Notification content
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         title,
//                         style: const TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.black87,
//                         ),
//                       ),
//                       Text(
//                         time,
//                         style: TextStyle(
//                           fontSize: 12,
//                           color: Colors.grey[600],
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     body,
//                     style: TextStyle(
//                       fontSize: 14,
//                       color: Colors.grey[800],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

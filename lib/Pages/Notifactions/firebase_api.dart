// import 'dart:convert';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_application_1/Pages/Notifactions/NotificationScreen.dart';
// import 'package:flutter_application_1/main.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// @pragma('vm:entry-point')
// Future<void> handleBackgroundMessage(RemoteMessage message) async {
//   print('Title: ${message.notification?.title}');
//   print('Body: ${message.notification?.body}');
//   print('Payload: ${message.data}');
// }

// void handleMessage(RemoteMessage? message) {
//   if (message == null) return;

//   navigatorKey.currentState?.pushNamed(
//     NotificationsScreen.route,
//     arguments: message,
//   );
// }

// class FirebaseApi {
//   final _firebaseMessaging = FirebaseMessaging.instance;
//   final _androidChannel = const AndroidNotificationChannel(
//     'high_importance_channel', // id
//     'High Importance Notifications', // title
//     description: 'This channel is used for important notifications.',
//     importance: Importance.high,
//   );

//   final _localNotifications = FlutterLocalNotificationsPlugin();

//   Future<void> initNotification() async {
//     // Request permission
//     await _firebaseMessaging.requestPermission();
//     final fCMToken = await _firebaseMessaging.getToken();
//     print("Firebase Messaging Token: $fCMToken");

//     await _initLocalNotifications();
//     await _initPushNotifications();
//   }

//   Future<void> _initLocalNotifications() async {
//     final iOS = DarwinInitializationSettings();
//     const android = AndroidInitializationSettings('@mipmap/launcher_icon');
//     final settings = InitializationSettings(android: android, iOS: iOS);

//     await _localNotifications.initialize(
//       settings,
//       onDidReceiveNotificationResponse: (NotificationResponse response) {
//         final payload = response.payload;
//         if (payload != null) {
//           final data = jsonDecode(payload);
//           final message = RemoteMessage.fromMap(data);
//           handleMessage(message);
//         }
//       },
//     );

//     final platform = _localNotifications.resolvePlatformSpecificImplementation<
//         AndroidFlutterLocalNotificationsPlugin>();
//     await platform?.createNotificationChannel(_androidChannel);
//   }

//   Future<void> _initPushNotifications() async {
//     await _firebaseMessaging.setForegroundNotificationPresentationOptions(
//       alert: true,
//       badge: true,
//       sound: true,
//     );

//     FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
//     FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
//     FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);

//     FirebaseMessaging.onMessage.listen((message) {
//       final notification = message.notification;
//       if (notification == null) return;

//       _localNotifications.show(
//         notification.hashCode,
//         notification.title,
//         notification.body,
//         NotificationDetails(
//           android: AndroidNotificationDetails(
//             _androidChannel.id,
//             _androidChannel.name,
//             channelDescription: _androidChannel.description,
//             icon: '@mipmap/launcher_icon',
//             importance: Importance.high, // Important!
//             priority: Priority.high,
//           ),
//         ),
//         payload: jsonEncode(message.toMap()),
//       );
//     });
//   }
// }

import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Pages/Notifactions/NotificationScreen.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

List<RemoteMessage> notificationList = [];
ValueNotifier<int> notificationCounter = ValueNotifier<int>(0);

@pragma('vm:entry-point')
Future<void> handleBackgroundMessage(RemoteMessage message) async {
  notificationList.add(message);
  notificationCounter.value++;
}

void handleMessage(RemoteMessage? message) {
  if (message == null) return;

  notificationList.add(message);
  notificationCounter.value++;
  navigatorKey.currentState?.pushNamed(
    NotificationsScreen.route,
    arguments: message,
  );
}

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;
  final _androidChannel = const AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'This channel is used for important notifications.',
    importance: Importance.high,
  );

  final _localNotifications = FlutterLocalNotificationsPlugin();

  Future<void> initNotification() async {
    await _firebaseMessaging.requestPermission();
    final fCMToken = await _firebaseMessaging.getToken();
    print("Firebase Messaging Token: $fCMToken");

    await _initLocalNotifications();
    await _initPushNotifications();
  }

  Future<void> _initLocalNotifications() async {
    const android = AndroidInitializationSettings('@mipmap/launcher_icon');
    final iOS = DarwinInitializationSettings();
    final settings = InitializationSettings(android: android, iOS: iOS);

    await _localNotifications.initialize(
      settings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        final payload = response.payload;
        if (payload != null) {
          final data = jsonDecode(payload);
          final message = RemoteMessage.fromMap(data);
          handleMessage(message);
        }
      },
    );

    final platform = _localNotifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await platform?.createNotificationChannel(_androidChannel);
  }

  Future<void> _initPushNotifications() async {
    await _firebaseMessaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
    FirebaseMessaging.onMessage.listen((message) {
      notificationList.add(message);
      notificationCounter.value++;

      final notification = message.notification;
      if (notification == null) return;

      _localNotifications.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            _androidChannel.id,
            _androidChannel.name,
            channelDescription: _androidChannel.description,
            importance: Importance.high,
            priority: Priority.high,
            icon: '@mipmap/launcher_icon',
          ),
        ),
        payload: jsonEncode(message.toMap()),
      );
    });

    _firebaseMessaging.getInitialMessage().then(handleMessage);
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
  }
}

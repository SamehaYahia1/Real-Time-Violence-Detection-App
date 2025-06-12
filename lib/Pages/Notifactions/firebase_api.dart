import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_application_1/Pages/Notifactions/NotificationScreen.dart';
import 'package:flutter_application_1/main.dart';

//create a custom class to hold notification details
class AppNotification {
  final String title;
  final String body;
  final DateTime? timestamp;

  AppNotification({
    required this.title,
    required this.body,
    this.timestamp,
  });
}

// Global state
List<AppNotification> notificationList = []; // all notifications stored here
ValueNotifier<int> notificationCounter =
    ValueNotifier<int>(0); // Tracks how many notifications you have

//when the app is closed and you receive a notification
@pragma('vm:entry-point')
Future<void> handleBackgroundMessage(RemoteMessage message) async {
  await saveNotificationToFirestore(message);
}

void handleMessage(RemoteMessage? message) async {
  if (message == null) return;
  navigatorKey.currentState?.pushNamed(
    '/home',
    arguments: 'notifications',
  );
}

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;
  final _androidChannel = const AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'This channel is used for important notifications.',
    importance: Importance.high,
    playSound: true,
  );
  final _localNotifications = FlutterLocalNotificationsPlugin();

  Future<void> initNotification() async {
    await _firebaseMessaging.requestPermission();
    final fCMToken = await _firebaseMessaging.getToken();
    print("Firebase Messaging Token: $fCMToken");

    await loadNotificationsFromFirestore();
    await _initLocalNotifications();
    await _initPushNotifications();
  }

  Future<void> _initLocalNotifications() async {
    const android = AndroidInitializationSettings('@mipmap/launcher_icon');
    final iOS = DarwinInitializationSettings();
    final settings = InitializationSettings(android: android, iOS: iOS);

    await _localNotifications.initialize(
      settings,
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
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

    FirebaseMessaging.onMessage.listen((message) async {
      await saveNotificationToFirestore(message);

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

Future<void> saveNotificationToFirestore(RemoteMessage message) async {
  final prefs = await SharedPreferences.getInstance();
  final userId = prefs.getString('userId');
  if (userId == null) return;

  final docId = DateTime.now().millisecondsSinceEpoch.toString();

  await FirebaseFirestore.instance
      .collection('notifications')
      .doc(userId)
      .collection('items')
      .doc(docId)
      .set({
    'title': message.notification?.title ?? 'No Title',
    'body': message.notification?.body ?? 'No Body',
    'timestamp': FieldValue.serverTimestamp(),
  });

  // Add to local list immediately
  notificationList.insert(
    0,
    AppNotification(
      title: message.notification?.title ?? 'No Title',
      body: message.notification?.body ?? 'No Body',
      timestamp: DateTime.now(),
    ),
  );
  notificationCounter.value++;
}

Future<void> loadNotificationsFromFirestore() async {
  final prefs = await SharedPreferences.getInstance();
  final userId = prefs.getString('userId');
  if (userId == null) return;

  final snapshot = await FirebaseFirestore.instance
      .collection('notifications')
      .doc(userId)
      .collection('items')
      .orderBy('timestamp')
      .get();

  notificationList = snapshot.docs.map((doc) {
    final data = doc.data();
    final timestamp = data['timestamp'] as Timestamp?;
    return AppNotification(
      title: data['title'] ?? 'No Title',
      body: data['body'] ?? 'No Body',
      timestamp: timestamp?.toDate(),
    );
  }).toList();

  notificationCounter.value = notificationList.length;
}

// import 'package:flutter/material.dart'; // Correct your actual project name
// import 'package:flutter_application_1/Constant/firebase_api.dart';
// import 'package:flutter_application_1/Constant/local_notification_services.dart';
// import 'package:flutter_application_1/Pages/Home/BottomBarScreen.dart';
// import 'package:flutter_application_1/Pages/Notifactions/NotifiSettings.dart';
// import 'package:flutter_application_1/Pages/Start/choose_screen.dart';
// import 'package:flutter_application_1/Pages/Start/login_screen.dart';
// import 'package:flutter_application_1/Pages/Start/signup_screen.dart';
// import 'package:flutter_application_1/Pages/Start/splash_screen.dart';
// import 'package:flutter_application_1/Pages/Plans/choose_your_plan.dart';
// import 'package:flutter_application_1/firebase_options.dart';
// import 'package:firebase_core/firebase_core.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   await FirebaseApi().initNotification();
//   NotifiSettings().initNotification();
//   runApp(const MyApp());
// }
// //yarab

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//   // Future<bool> _isLoggedIn() async {
//   //   final prefs = await SharedPreferences.getInstance();
//   //   final token = prefs.getString('jwt_token');
//   //   return token != null && token.isNotEmpty;
//   // }

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Flutter Demo',
//       initialRoute: '/',
//       routes: {
//         '/': (context) => const SplashScreen(),
//         '/choose': (context) => const ChooseScreen(),
//         '/login': (context) => const LoginScreen(),
//         '/signup': (context) => const SignupScreen(),
//         '/plans': (context) => const ChoosePlanScreen(
//               userName: 'User',
//               userId: '1',
//               SubscriptionId: '1',
//             ),
//         '/home': (context) => const Homeuserscreen(
//               username: 'User',
//               userId: '1',
//               subscriptionPlan: 1,
//             ),
//         // '/userHome': (context) => const UserPage(userName: 'User'),
//         // '/adminHome': (context) => const UserPage(userName: 'Admin'),
//       },
//     );
//   }
// }

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Pages/Notifactions/firebase_api.dart';
import 'package:flutter_application_1/Pages/Home/BottomBarScreen.dart';
// import 'package:flutter_application_1/Constant/local_notification_services.dart';
// import 'package:flutter_application_1/Pages/AddScreen.dart';
import 'package:flutter_application_1/Pages/Home/BottomBarScreen.dart';
import 'package:flutter_application_1/Pages/Notifactions/NotificationScreen.dart';
// import 'package:flutter_application_1/Pages/Recoreds/RecordsScreen.dart';
// import 'package:flutter_application_1/Pages/SettingsScreen.dart';
// import 'package:flutter_application_1/Pages/Notifactions/NotifiSettings.dart';
import 'package:flutter_application_1/firebase_options.dart';

final navigatorKey = GlobalKey<NavigatorState>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseApi().initNotification();
  // await Future.wait(
  //     [FirebaseApi().initNotification(), LocalNotificationService.init()]);

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          textTheme: const TextTheme(
            bodyLarge: TextStyle(fontSize: 40, color: Colors.black),
          ),
        ),
        navigatorKey: navigatorKey,
        home: const Homeuserscreen(
          username: 'User',
          userId: '1',
          subscriptionPlan: 1,
        ),
        routes: {
          NotificationsScreen.route: (context) => const Homeuserscreen(
                username: 'User',
                userId: '1',
                subscriptionPlan: 1,
              ),
          // Add other routes here if needed
        });
  }
}

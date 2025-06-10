import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Pages/Home/BottomBarScreen.dart';
import 'package:flutter_application_1/Pages/Notifactions/firebase_api.dart';
import 'package:flutter_application_1/Pages/Notifactions/NotificationScreen.dart';
import 'package:flutter_application_1/Pages/Plans/choose_your_plan.dart';
import 'package:flutter_application_1/Pages/Start/choose_screen.dart';
import 'package:flutter_application_1/Pages/Start/login_screen.dart';
import 'package:flutter_application_1/Pages/Start/signup_screen.dart';
import 'package:flutter_application_1/Pages/Start/splash_screen.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseApi().initNotification();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      navigatorKey: navigatorKey,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontSize: 16, color: Colors.black),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/choose': (context) => const ChooseScreen(),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
        '/plans': (context) => const ChoosePlanScreen(
              userName: 'User',
              userId: '1',
              SubscriptionId: '1',
            ),
        '/home': (context) => const Homeuserscreen(
              username: 'User',
              userId: '1',
              subscriptionPlan: 1,
            ),
        NotificationsScreen.route: (context) => NotificationsScreen(),
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_application_1/Pages/Home/BottomBarScreen.dart';
import 'package:flutter_application_1/Pages/Start/choose_screen.dart';
import 'package:flutter_application_1/Pages/Start/login_screen.dart';
import 'package:flutter_application_1/Pages/Start/signup_screen.dart';
import 'package:flutter_application_1/Pages/Start/splash_screen.dart';
import 'package:flutter_application_1/Pages/Plans/choose_your_plan.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}
//yarab

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // Future<bool> _isLoggedIn() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final token = prefs.getString('jwt_token');
  //   return token != null && token.isNotEmpty;
  // }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
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
          // '/userHome': (context) => const UserPage(userName: 'User'),
          // '/adminHome': (context) => const UserPage(userName: 'Admin'),
        });
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter_application_1/Pages/onvif_discover.dart';

// void main() {
//   WidgetsFlutterBinding.ensureInitialized();
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Flutter Demo',
//       home: OnvifDiscoveryScreen(),
//     );
//   }
// }

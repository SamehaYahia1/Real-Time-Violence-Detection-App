import 'package:flutter/material.dart';
import 'package:flutter_application_1/Pages/choose_screen.dart';
import 'package:flutter_application_1/Pages/login_screen.dart';
import 'package:flutter_application_1/Pages/signup_screen.dart';
import 'package:flutter_application_1/Pages/splash_screen.dart';
import 'package:flutter_application_1/UserOrAdminPage/user_or_admin.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_application_1/Pages/choose_your_plan.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}
//yarab

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  Future<bool> _isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');
    return token != null && token.isNotEmpty;
  }

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
          '/userHome': (context) => const UserPage(userName: 'User'),
          '/adminHome': (context) => const UserPage(userName: 'Admin'),
        });
  }
}

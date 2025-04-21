import 'package:flutter/material.dart';
import 'package:flutter_application_1/Constant/colors.dart';
import 'package:flutter_application_1/Pages/choose_screen.dart';
import 'package:flutter_application_1/UserOrAdminPage/user_or_admin.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  bool _visible = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    // Start the animation
    Future.delayed(const Duration(milliseconds: 200), () {
      setState(() {
        _visible = true;
      });
      _controller.forward();
    });

    // Navigate after 5 seconds to allow animation to complete
    Future.delayed(const Duration(seconds: 5), () {
      _navigateBasedOnLoginStatus();
    });
  }

  Future<void> _navigateBasedOnLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');
    final userName = prefs.getString('user_name');

    if (!mounted) return;

    if (token != null && token.isNotEmpty) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => UserPage(userName: userName ?? "User"),
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const ChooseScreen(),
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [colors.backgroundColor, colors.secondaryBackgroundColor],
          ),
        ),
        child: Stack(
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeOut,
              top: 0,
              left: _visible ? -1 : -200,
              child: Image.asset(
                'Assets/images/appTop.PNG',
                width: 150,
              ),
            ),
            AnimatedPositioned(
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeOut,
              bottom: 0,
              right: _visible ? 0 : -200,
              child: Image.asset(
                'Assets/images/appBottom.PNG',
                width: 150,
              ),
            ),
            Center(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: const Text(
                  'VDECT.',
                  style: TextStyle(
                    color: colors.secondaryColor,
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

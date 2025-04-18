import 'package:flutter/material.dart';
import 'package:flutter_application_1/Pages/choose_screen.dart';

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

    Future.delayed(const Duration(milliseconds: 200), () {
      setState(() {
        _visible = true;
      });
      _controller.forward();
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(seconds: 5), () {
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const ChooseScreen()),
          );
        }
      });
    });
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
            colors: [
              Color(0xFF1B7CA6),
              Color(0xff100e48),
            ],
          ),
        ),
        child: Stack(
          children: [
            // Top Shape
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

            // Bottom Shape
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

            // Center Logo
            Center(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: const Text(
                  'VDECT.',
                  style: TextStyle(
                    color: Colors.white,
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

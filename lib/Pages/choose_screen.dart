import 'package:flutter/material.dart';
import 'package:flutter_application_1/Pages/login_screen.dart';
import 'package:flutter_application_1/Pages/signup_screen.dart';

class ChooseScreen extends StatelessWidget {
  const ChooseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [
                Color(0xFF1B7CA6),
                Color(0xff100e48),
              ]),
            ),
          ),

          // Main content
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 30),

                  Stack(
                    children: [
                      SizedBox(
                        height: 240,
                        width: double.infinity,
                        child: Stack(
                          children: [
                            Positioned(
                              top: 130,
                              left: 150,
                              child: Image.asset(
                                'Assets/images/Logo.png',
                                width: 130,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Center(
                    child: Text(
                      '  VDECT.',
                      style: TextStyle(
                        color: Color(0xFF100F23),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                  ),

                  // Rounded container for the form
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 60),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 230),
                        // Login button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginScreen()),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 18),
                              backgroundColor: const Color(0xFF051136),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'Sign In',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SignupScreen()),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 18),
                              backgroundColor: const Color(0xFF2557EF),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'Sign Up',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Constant/api_endpoint.dart';
import 'package:flutter_application_1/Pages/login_screen.dart';
import 'package:flutter_application_1/UserOrAdminPage/user_or_admin.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:flutter_application_1/Constant/api_endpoint.dart';

class VerificationScreen extends StatefulWidget {
  final String email;
  const VerificationScreen({super.key, required this.email});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  String enteredPin = '';
  bool isPinVisible = false;
  bool isVerifying = false;
  String Username = '';

  Future<void> verifyCode() async {
    setState(() {
      isVerifying = true;
    });

    final verificationData = {
      'email': widget.email,
      'verificationCode': enteredPin,
    };

    try {
      final response = await http.post(
        Uri.parse('${ApiEndpoints.baseUrl}/api/Auth/verify'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(verificationData),
      );

      if (response.statusCode == 200) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Verification Success'),
            content: const Text(
              'Your email has been verified successfully!',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoginScreen()),
                  );
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      } else {
        String errorMessage = 'Verification failed. Please try again.';
        try {
          final responseBody = json.decode(response.body);
          errorMessage = responseBody['message'] ?? errorMessage;
        } catch (e) {
          print('Error decoding response: $e');
        }

        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Error'),
            content: Text(errorMessage),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      print('API error: $e');
    } finally {
      setState(() {
        isVerifying = false;
      });
    }
  }

  Widget buildGridButton(String value, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap ??
          () {
            setState(() {
              if (enteredPin.length < 6) {
                enteredPin += value;
              }
              if (enteredPin.length == 6) {
                verifyCode();
              }
            });
          },
      child: Container(
        height: 70,
        alignment: Alignment.center,
        child: value == 'backspace'
            ? const Icon(Icons.backspace, color: Colors.white)
            : Text(
                value,
                style: const TextStyle(fontSize: 24, color: Colors.white),
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1B7CA6), Color.fromARGB(255, 9, 7, 69)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 3),
            physics: const BouncingScrollPhysics(),
            children: [
              const SizedBox(height: 40),
              Stack(
                children: [
                  SizedBox(
                    height: 180,
                    width: double.infinity,
                    child: Stack(
                      children: [
                        Positioned(
                          top: 0,
                          left: 0,
                          child: Image.asset(
                            'Assets/images/leftApp.PNG',
                            width: 110,
                          ),
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: Image.asset(
                            'Assets/images/rightApp.PNG',
                            width: 110,
                          ),
                        ),
                        const Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: EdgeInsets.only(top: 50),
                            child: Text(
                              'PIN\nVERIFICATION',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 26,
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              //const SizedBox(height: 15),
              Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(103, 27, 89, 235),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                  ),
                ),
                padding: const EdgeInsets.fromLTRB(16, 30, 16, 70),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Center(
                      child: Text(
                        'Enter Your Pin',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    /// PIN circles
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(6, (index) {
                        return Container(
                          margin: const EdgeInsets.all(4.0),
                          width: 45,
                          height: 45,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(7.0),
                            color: index < enteredPin.length
                                ? const Color.fromARGB(255, 9, 7, 69)
                                : const Color.fromRGBO(33, 150, 243, 1),
                          ),
                          child: index < enteredPin.length
                              ? Center(
                                  child: isPinVisible
                                      ? Text(
                                          enteredPin[index],
                                          style: const TextStyle(
                                            fontSize: 17,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        )
                                      : const Icon(
                                          Icons.circle,
                                          size: 10,
                                          color: Colors.white,
                                        ),
                                )
                              : null,
                        );
                      }),
                    ),

                    /// Show/Hide PIN
                    IconButton(
                      onPressed: () {
                        setState(() {
                          isPinVisible = !isPinVisible;
                        });
                      },
                      icon: Icon(
                        isPinVisible ? Icons.visibility_off : Icons.visibility,
                        color: Colors.white,
                      ),
                    ),

                    if (isVerifying)
                      const Center(child: CircularProgressIndicator())
                    else
                      const SizedBox(height: 16),

                    /// RED BORDER TABLE KEYPAD
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Table(
                        border: const TableBorder.symmetric(
                          inside: BorderSide(
                            color: const Color.fromARGB(102, 255, 255, 255),
                            width: 2,
                          ),
                        ),
                        children: [
                          TableRow(
                            children: [
                              buildGridButton('1'),
                              buildGridButton('2'),
                              buildGridButton('3'),
                            ],
                          ),
                          TableRow(
                            children: [
                              buildGridButton('4'),
                              buildGridButton('5'),
                              buildGridButton('6'),
                            ],
                          ),
                          TableRow(
                            children: [
                              buildGridButton('7'),
                              buildGridButton('8'),
                              buildGridButton('9'),
                            ],
                          ),
                          TableRow(
                            children: [
                              buildGridButton(
                                'Reset',
                                onTap: () {
                                  setState(() {
                                    enteredPin = '';
                                  });
                                },
                              ),
                              buildGridButton('0'),
                              buildGridButton(
                                'backspace',
                                onTap: () {
                                  setState(() {
                                    if (enteredPin.isNotEmpty) {
                                      enteredPin = enteredPin.substring(
                                        0,
                                        enteredPin.length - 1,
                                      );
                                    }
                                  });
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

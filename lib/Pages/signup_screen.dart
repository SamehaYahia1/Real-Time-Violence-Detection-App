import 'package:flutter/material.dart';
import 'package:flutter_application_1/Constant/api_endpoint.dart';
import 'package:flutter_application_1/Constant/colors.dart';
import 'package:flutter_application_1/Constant/custom_padding_field.dart';
import 'package:flutter_application_1/Constant/custom_password_field.dart';
import 'package:flutter_application_1/Constant/custom_text_field.dart';
import 'package:flutter_application_1/Pages/verification_screen.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SignupScreen extends StatefulWidget {
  const SignupScreen({
    super.key,
  });

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _fullnameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _roleController =
      TextEditingController(text: "User");
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String? _errorText;
  String? _errorTextEmail;
  String? _errorTextPass;

  String _extractErrorMessage(String responseBody) {
    try {
      final decoded = json.decode(responseBody);

      if (decoded is Map<String, dynamic>) {
        String message =
            decoded['detail'] ?? decoded['message'] ?? "Something went wrong.";

        // ✨ Format long error message to add line breaks after commas
        if (message.contains(',')) {
          message = message.replaceAll(', ', ',\n');
        }

        return message;
      } else {
        return decoded.toString();
      }
    } catch (e) {
      return responseBody;
    }
  }

  Future<void> register() async {
    if (!_formKey.currentState!.validate()) return;

    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Passwords do not match"),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _errorText = null;
      _errorTextEmail = null;
      _errorTextPass = null;
    });

    final registrationData = {
      'fullname': _fullnameController.text,
      'username': _usernameController.text,
      'password': _passwordController.text,
      'email': _emailController.text,
      'role': _roleController.text,
    };

    final response = await http.post(
      Uri.parse('${ApiEndpoints.baseUrl}/api/Auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(registrationData),
    );

    setState(() {
      _isLoading = false;
    });

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      final message = responseBody['message'];

      showDialog(
        context: context,
        barrierDismissible: false, // 🚫 Prevent tap outside to close
        builder: (context) => WillPopScope(
          // 🚫 Prevent back button
          onWillPop: () async => false,
          child: AlertDialog(
            title: const Text('Registration Success'),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close dialog
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          VerificationScreen(email: _emailController.text),
                    ),
                  );
                },
                child: const Text('Go to Verification'),
              ),
            ],
          ),
        ),
      );
    } else {
      String errorMessage = _extractErrorMessage(response.body);

      setState(() {
        if (errorMessage.toLowerCase().contains("email")) {
          _errorTextEmail = errorMessage;
          _errorText = null;
          _errorTextPass = null;
        } else if (errorMessage.toLowerCase().contains("password")) {
          _errorTextPass = errorMessage;
          _errorText = null;
          _errorTextEmail = null;
        } else if (errorMessage.toLowerCase().contains("username")) {
          _errorText = errorMessage;
          _errorTextEmail = null;
          _errorTextPass = null;
        } else {
          _errorText = errorMessage;
          _errorTextEmail = null;
          _errorTextPass = null;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  colors.backgroundColor,
                  colors.secondaryBackgroundColor
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 30),
                    SizedBox(
                      height: 220,
                      child: Stack(
                        children: [
                          Positioned(
                            top: 0,
                            left: 0,
                            child: Image.asset('Assets/images/leftApp.PNG',
                                width: 120),
                          ),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: Image.asset('Assets/images/rightApp.PNG',
                                width: 120),
                          ),
                          const Align(
                            alignment: Alignment.center,
                            child: Padding(
                              padding: EdgeInsets.only(top: 50),
                              child: Text(
                                'NEW ACCOUNT',
                                style: TextStyle(
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold,
                                    color: colors.secondaryColor),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: colors.contColor,
                        borderRadius: BorderRadius.all(Radius.circular(40)),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 40),
                      child: Column(
                        children: [
                          const Text(
                            'Enter your signup information',
                            style: TextStyle(
                                color: colors.secondaryColor, fontSize: 18),
                          ),
                          const SizedBox(height: 15),

                          // Fullname
                          CustomTextField(
                              controller: _fullnameController,
                              label: 'Fullname',
                              icon: Icons.person),

                          // Username
                          CustomPaddingField(
                            controller: _usernameController,
                            labelText: 'Username',
                            obscureText: false,
                            prefixIcon: const Icon(
                              Icons.person,
                              color: colors.secondaryColor,
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Username is required';
                              }
                              if (_errorText != null) {
                                return _errorText;
                              }
                              return null;
                            },
                            onChanged: (_) {
                              // // btshel el error lam el user ybda2 yktb w terg3 t check tany
                              if (_errorText != null) {
                                setState(() {
                                  _errorText = null;
                                });
                              }
                            },
                          ),
                          //email
                          CustomPaddingField(
                            controller: _emailController,
                            labelText: 'Email',
                            obscureText: false,
                            prefixIcon: const Icon(
                              Icons.email,
                              color: colors.secondaryColor,
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Email is required';
                              }
                              if (_errorTextEmail != null) {
                                return _errorTextEmail;
                              }
                              return null;
                            },
                            onChanged: (_) {
                              if (_errorTextEmail != null) {
                                setState(() {
                                  _errorTextEmail = null;
                                });
                              }
                            },
                          ),
                          // Password
                          CustomPasswordField(
                              controller: _passwordController,
                              label: 'Enter Your Password',
                              errorText: _errorTextPass,
                              validator: (value) {
                                if (value!.trim().isEmpty) {
                                  return 'Password is required';
                                }
                                if (value.length < 5) {
                                  return 'Password must be at least 5 characters';
                                }
                                // if (_errorTextPass != null) {
                                //  return _errorTextPass;
                                // //}
                                return null;
                              },
                              onChanged: (_) {
                                if (_errorTextPass != null) {
                                  setState(() {
                                    _errorTextPass = null;
                                  });
                                }
                              }),
                          // Confirm Password
                          CustomPasswordField(
                            controller: _confirmPasswordController,
                            label: 'Confirm Password',
                            validator: (value) {
                              if (value!.trim().isEmpty) {
                                return 'Password is required';
                              }
                            },
                          ),
                          const SizedBox(height: 20),
                          // Sign Up button or Spinner
                          SizedBox(
                            width: double.infinity,
                            child: _isLoading
                                ? const SpinKitCircle(
                                    color: colors.secondaryColor, size: 50.0)
                                : ElevatedButton(
                                    onPressed: register,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: colors.secondaryColor2,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 14),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: const Text(
                                      'SIGN UP',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: colors.primaryColor),
                                    ),
                                  ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("Already have an account?",
                                  style: TextStyle(color: colors.textColor)),
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Sign In',
                                    style: TextStyle(
                                        color: colors.secondaryColor2)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

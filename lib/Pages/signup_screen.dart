import 'package:flutter/material.dart';
import 'package:flutter_application_1/Constant/api_endpoint.dart';
import 'package:flutter_application_1/Constant/custom_password_field.dart';
import 'package:flutter_application_1/Constant/custom_text_field.dart';
import 'package:flutter_application_1/Pages/verification_screen.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

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

  bool _obscureText = true;
  bool _isLoading = false;
  String? _errorText;
  String? _errorTextEmail;
  String? _errorTextPass;

  void _toggleVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
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
        builder: (_) => AlertDialog(
          title: const Text('Registration Success'),
          content: Text(message), //fist message
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // close dialog
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
      );
    } else if (response.statusCode == 400) {
      setState(() {
        _errorTextEmail =
            "You cannot have more than two accounts with the same email";
        _errorText = null;
      });
    } else if (response.statusCode == 402) {
      setState(() {
        _errorText = "Username is already taken !";
        _errorTextEmail = null;
      });
    } else if (response.statusCode == 401) {
      setState(() {
        _errorTextPass = "Please use strong password";
        _errorText = null;
        _errorTextEmail = null;
      });
    } else {
      setState(() {
        _errorText = "Something went wrong. Please try again later.";
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
                colors: [Color(0xFF1B7CA6), Color(0xff100e48)],
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
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: Color(0xFF100F23),
                        borderRadius: BorderRadius.all(Radius.circular(40)),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 40),
                      child: Column(
                        children: [
                          const Text(
                            'Enter your signup information',
                            style:
                                TextStyle(color: Colors.white70, fontSize: 18),
                          ),
                          const SizedBox(height: 15),

                          // Fullname
                          CustomTextField(
                              controller: _fullnameController,
                              label: 'Fullname',
                              icon: Icons.person),

                          // Username
                          Padding(
                            padding: const EdgeInsets.all(13.0),
                            child: TextFormField(
                              controller: _usernameController,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              style: const TextStyle(color: Colors.white),
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
                                // btshel el error lam el user ybda2 yktb w terg3 t check tany
                                if (_errorText != null) {
                                  setState(() {
                                    _errorText = null;
                                  });
                                }
                              },
                              decoration: InputDecoration(
                                prefixIcon:
                                    Icon(Icons.person, color: Colors.white),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                labelText: 'Username',
                                labelStyle: TextStyle(color: Colors.white70),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(13.0),
                            child: TextFormField(
                              controller: _emailController,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              style: const TextStyle(color: Colors.white),
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
                              decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.person,
                                    color: Colors.white),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                labelText: 'Email',
                                labelStyle:
                                    const TextStyle(color: Colors.white70),
                              ),
                            ),
                          ),
                          // Password
                          Padding(
                            padding: const EdgeInsets.all(13.0),
                            child: TextFormField(
                              controller: _passwordController,
                              obscureText: true,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              style: const TextStyle(color: Colors.white),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Password is required';
                                } else if (value.length < 5) {
                                  return 'Password must be more than 5 characters';
                                }
                                if (_errorTextPass != null) {
                                  return _errorTextPass;
                                }
                                return null;
                              },
                              onChanged: (_) {
                                if (_errorTextPass != null) {
                                  setState(() {
                                    _errorTextPass = null;
                                  });
                                }
                              },
                              decoration: InputDecoration(
                                prefixIcon:
                                    const Icon(Icons.lock, color: Colors.white),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscureText
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: Colors.white,
                                  ),
                                  onPressed: _toggleVisibility,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                labelText: 'Password',
                                labelStyle:
                                    const TextStyle(color: Colors.white70),
                              ),
                            ),
                          ),
                          // Confirm Password
                          CustomPasswordField(
                              controller: _confirmPasswordController,
                              label: 'Confirm Password'),
                          const SizedBox(height: 20),
                          // Sign Up button or Spinner
                          SizedBox(
                            width: double.infinity,
                            child: _isLoading
                                ? const SpinKitCircle(
                                    color: Colors.white, size: 50.0)
                                : ElevatedButton(
                                    onPressed: register,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF3867F4),
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
                                          color: Colors.black),
                                    ),
                                  ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("Already have an account?",
                                  style: TextStyle(color: Colors.white70)),
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Sign In',
                                    style: TextStyle(color: Color(0xFF3867F4))),
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

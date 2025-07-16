import 'package:flutter/material.dart';
import 'package:flutter_application_1/Constant/api_endpoint.dart';
import 'package:flutter_application_1/Constant/colors.dart';
import 'package:flutter_application_1/Constant/custom_padding_field.dart';
import 'package:flutter_application_1/Constant/custom_password_field.dart';
import 'dart:convert';
import 'package:flutter_application_1/Constant/token_handler.dart';
import 'package:flutter_application_1/Pages/Home/BottomBarScreen.dart';
import 'package:flutter_application_1/Pages/Notifactions/firebase_api.dart';
import 'package:flutter_application_1/Pages/Start/signup_screen.dart';
import 'package:flutter_application_1/Pages/Start/unknown_role.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Plans/choose_your_plan.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String? _loginError;
  String? _errorTextPass;

  @override
  void dispose() {
    _userNameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _SendFCMTokenToBackend(String userId, String token) async {
    final fcmToken = FirebaseApi.fCMToken;
    print("🔑 Current FCM Token: $fcmToken");
    if (fcmToken == null) {
      print("❌ FCM token is null. Skipping registration.");
      return;
    }
    final url = Uri.parse('${ApiEndpoints.baseUrl}/api/Devices/register');
    print("🚀 Sending FCM token: $fcmToken to backend...");
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          "fcmToken": fcmToken,
          "userId": userId,
        }),
      );

      print("🔔 Backend Response: ${response.statusCode} - ${response.body}");

      if (response.statusCode == 200) {
        print("✅ FCM token registered successfully");
      } else {
        print("❌ Failed to register FCM token: ${response.body}");
      }
    } catch (e) {
      print("🔥 Error sending FCM token: $e");
    }
  }

  String _extractLoginErrorMessage(String responseBody) {
    try {
      final decoded = json.decode(responseBody);
      if (decoded is Map<String, dynamic> && decoded.containsKey('title')) {
        return decoded['title'];
      }
      return responseBody;
    } catch (e) {
      return responseBody;
    }
  }

  Future<void> login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      final url = Uri.parse('${ApiEndpoints.baseUrl}/api/Auth/login');
      final loginData = jsonEncode({
        'userName': _userNameController.text.trim(),
        'password': _passwordController.text.trim(),
      });

      try {
        final response = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: loginData,
        );

        if (response.statusCode == 200) {
          final responseData = json.decode(response.body);
          final token = responseData['token'];

          if (token == null) {
            throw Exception("Token not found in response.");
          }
          final decodedToken = JwtDecoder.decode(token);
          final role = decodedToken[
                  "http://schemas.microsoft.com/ws/2008/06/identity/claims/role"] ??
              '';
          final nameClaim = decodedToken["name"];
          final userId = decodedToken[
              "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/nameidentifier"];
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', token);
          await prefs.setString('userId', userId);
          await _SendFCMTokenToBackend(userId, token);
          await loadNotificationsFromFirestore();
          notificationCounter.value = notificationList.length;
          final SubscriptionId = decodedToken["SubscriptionPlanId"];
          final userName = nameClaim is List ? nameClaim[0] : nameClaim;
          final subscriptionPlanIdInt = int.tryParse(SubscriptionId);
          if (subscriptionPlanIdInt == null) {
            throw Exception("Invalid SubscriptionPlanId");
          }
          await TokenHandler().saveToken(token);
          await TokenHandler().saveUserName(userName);
          if (!mounted) return;
          setState(() {
            _isLoading = false;
          });
          if (role.contains("User")) {
            // Navigate based on SubscriptionPlanId
            if (subscriptionPlanIdInt > 0) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (_) => Homeuserscreen(
                          username: userName,
                          userId: userId,
                          subscriptionPlan: int.parse(SubscriptionId),
                        )),
              );
            } else {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => ChoosePlanScreen(
                      userName: userName,
                      userId: userId,
                      SubscriptionId: SubscriptionId),
                ),
              );
            }
          } else {
            if (!mounted) return;
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => const UnknownRole(),
              ),
            );
          }
        } else if (response.statusCode == 400) {
          setState(() {
            _loginError = _extractLoginErrorMessage(response.body);
            _errorTextPass = null;
          });
          _formKey.currentState!.validate();
        } else if (response.statusCode == 401) {
          setState(() {
            _errorTextPass = _extractLoginErrorMessage(response.body);
            _loginError = null;
          });
        } else {
          setState(() {
            _isLoading = false;
          });
          print("Unexpected error: ${response.statusCode}");
        }
      } catch (e) {
        print("Login error: $e");
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [
                colors.backgroundColor,
                colors.secondaryBackgroundColor
              ]),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 30),
                  Stack(
                    children: [
                      SizedBox(
                        height: 220,
                        width: double.infinity,
                        child: Stack(
                          children: [
                            Positioned(
                              top: 0,
                              left: 0,
                              child: Image.asset(
                                'Assets/images/leftApp.PNG',
                                width: 120,
                              ),
                            ),
                            Positioned(
                              top: 0,
                              right: 0,
                              child: Image.asset(
                                'Assets/images/rightApp.PNG',
                                width: 120,
                              ),
                            ),
                            const Align(
                              alignment: Alignment.center,
                              child: Padding(
                                padding: EdgeInsets.only(top: 50),
                                child: Text(
                                  'LOGIN TO\nYOUR ACCOUNT',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 22,
                                    // fontWeight: FontWeight.bold,
                                    // fontStyle: FontStyle.italic,
                                    color: colors.secondaryColor,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: colors.contColor,
                      borderRadius: BorderRadius.all(Radius.circular(40)),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 70),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            'Enter your login information',
                            style: TextStyle(
                              color: colors.textColor,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 30),
                          //username
                          CustomPaddingField(
                            controller: _userNameController,
                            labelText: 'Username',
                            prefixIcon:
                                const Icon(Icons.person, color: Colors.white),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Username is required';
                              }
                              if (_loginError != null) {
                                return _loginError;
                              }
                              return null;
                            },
                            onChanged: (_) {
                              if (_loginError != null) {
                                setState(() {
                                  _loginError = null;
                                });
                              }
                            },
                          ),
                          const SizedBox(height: 8),
                          CustomPasswordField(
                            controller: _passwordController,
                            label: 'Password',
                            validator: (value) {
                              if (value!.trim().isEmpty) {
                                return 'Password is required';
                              }
                              if (value.length < 5) {
                                return 'Password must be at least 5 characters';
                              }

                              if (_errorTextPass != null) {
                                return _errorTextPass;
                              }
                              return null;
                            },
                            onChanged: (_) {
                              if (_errorTextPass != null) {
                                // _errorTextPass=401
                                setState(() {
                                  _errorTextPass = null;
                                });
                              }
                            },
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                                onPressed: _isLoading ? null : login,
                                style: ElevatedButton.styleFrom(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  backgroundColor: colors.secondaryColor2,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: _isLoading // lw el loading false
                                    ? const SizedBox(
                                        height: 30,
                                        width: 30,
                                        child: SpinKitFadingCircle(
                                          color: colors.primaryColor,
                                          size: 30.0,
                                        ),
                                      )
                                    : const Text(
                                        //lw true
                                        'LOGIN',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: colors.primaryColor),
                                      )),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Don't have an account?",
                                style: TextStyle(color: colors.textColor),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const SignupScreen()),
                                  );
                                },
                                child: const Text(
                                  'Sign Up',
                                  style:
                                      TextStyle(color: colors.secondaryColor2),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
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

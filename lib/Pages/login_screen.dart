import 'package:flutter/material.dart';
import 'package:flutter_application_1/Constant/api_endpoint.dart';
import 'package:flutter_application_1/Constant/colors.dart';
import 'package:flutter_application_1/Constant/custom_padding_field.dart';
import 'package:flutter_application_1/Constant/custom_password_field.dart';
import 'dart:convert';
import 'package:flutter_application_1/Constant/token_handler.dart';
import 'package:flutter_application_1/Pages/signup_screen.dart';
import 'package:flutter_application_1/Pages/unknown_role.dart';
import 'package:flutter_application_1/UserOrAdminPage/user_or_admin.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';

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
          final userName = nameClaim is List ? nameClaim[0] : nameClaim;
          await TokenHandler().saveToken(token);
          await TokenHandler().saveUserName(userName);
          if (!mounted) return;
          setState(() {
            _isLoading = false;
          });
          if (role.contains("User")) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => UserPage(userName: userName),
              ),
            );
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
                colors.secondaryColor2,
                colors.secondaryBackgroundColor,
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
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold,
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
                      color: Color(0xFF100F23),
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Checkbox(
                                    value: false,
                                    onChanged: (value) {},
                                    side:
                                        const BorderSide(color: colors.white2),
                                    checkColor: Colors.black,
                                  ),
                                  const Text(
                                    'Remember me',
                                    style: TextStyle(color: colors.textColor),
                                  ),
                                ],
                              ),
                              TextButton(
                                onPressed: () {},
                                child: const Text(
                                  'Forgot password',
                                  style: TextStyle(color: colors.textColor),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
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
                          const Row(
                            children: [
                              Expanded(
                                  child: Divider(color: colors.accentColor)),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                child: Text('Or',
                                    style: TextStyle(color: colors.white)),
                              ),
                              Expanded(
                                  child: Divider(color: colors.accentColor)),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: () {},
                                  icon: const Icon(Icons.g_mobiledata,
                                      size: 28, color: colors.secondaryColor),
                                  label: const Text('GOOGLE',
                                      style: TextStyle(
                                          color: colors.secondaryColor)),
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(
                                        color: colors.accentColor),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                            ],
                          ),
                          const SizedBox(height: 30),
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

import 'package:flutter/material.dart';
import 'package:flutter_application_1/Constant/ShowErrorToSnackBar.dart';
import 'package:flutter_application_1/Constant/api_endpoint.dart';
import 'package:flutter_application_1/Constant/custom_textfieldAdd.dart';
import 'package:flutter_application_1/Constant/token_handler.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddScreen extends StatefulWidget {
  const AddScreen({super.key});

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  // Controller for text fields
  final _formKey = GlobalKey<FormState>(); //used for validation
  final TextEditingController _cameraNameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _ipController = TextEditingController();
  final TextEditingController _portController = TextEditingController();
  bool _isSubmitting = false; //Tracks whether the camera is being submitted.
  String _selectedStream = 'stream1';
  final List<String> _streamOptions = ['stream1', 'profile1', 'profile0'];
//A7A
  Future<void> _submitCameraData() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSubmitting = true;
    });

    String username = _usernameController.text.trim();
    String password = _passwordController.text.trim();
    String ip = _ipController.text.trim();
    String port = _portController.text.trim();
    String cameraName = _cameraNameController.text.trim();
    final path = _selectedStream.trim().replaceAll(RegExp(r'^/+'), '');

    String rtspUrl = 'rtsp://$username:$password@$ip:$port/$path';
    final token = await TokenHandler().getToken();
    if (token == null) {
      showErrorTopSnackBar(context, "Token is missing. Please login.");
      setState(() => _isSubmitting = false);
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('${ApiEndpoints.baseUrl}/api/Camera/add'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'cameraName': cameraName,
          'streamUrl': rtspUrl,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        showErrorTopSnackBar(
            context, " $cameraName✅Camera added successfully.");
      } else if (response.statusCode == 500) {
        showErrorTopSnackBar(context, "⚠️ Camera already exists.");
      } else {
        showErrorTopSnackBar(
            context, "❌ Failed to add camera: ${response.body}");
      }
    } catch (e) {
      showErrorTopSnackBar(context, "❌ Error: $e");
    }

    setState(() => _isSubmitting = false);
  }

  @override
  void dispose() {
    _cameraNameController.dispose();
    _locationController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _ipController.dispose();
    _portController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE9F0FF),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("Assets/images/camera_bg.png"),
            fit: BoxFit.scaleDown,
            alignment: Alignment(0, 0.15),
            colorFilter: ColorFilter.mode(
              Color(0xFFE9F0FF),
              BlendMode.dstATop,
            ),
          ),
        ),
        child: Column(
          children: [
            PreferredSize(
              preferredSize: const Size.fromHeight(50),
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(30),
                ),
                child: AppBar(
                  backgroundColor: const Color(0xFFBFD7ED),
                  elevation: 4,
                  shadowColor: Colors.black26,
                  automaticallyImplyLeading: false,
                  title: const Row(
                    children: [
                      Icon(Icons.add, color: Colors.black87),
                      SizedBox(width: 10),
                      Text(
                        "Add Your New Camera",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.only(bottom: 0),
              child: Image.asset(
                'Assets/images/camer_logo.png',
                height: 150,
              ),
            ),
            // const SizedBox(height: 0),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Camera Name
                      CustomTextFieldAdd(
                        controller: _cameraNameController,
                        label: 'Username',
                        icon: Icons.person,
                      ),
                      const SizedBox(height: 15),

                      // Camera Location
                      CustomTextFieldAdd(
                        controller: _locationController,
                        label: 'Camera Location',
                        icon: Icons.location_on,
                      ),

                      const SizedBox(height: 20),

                      // Camera Information Section
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE0EDFF),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: const Color.fromARGB(7, 68, 137, 255)
                                  .withOpacity(0.5),
                              blurRadius: 10,
                              offset: const Offset(2, 4),
                            ),
                          ],
                        ),
                        child: const Text(
                          'Camera Connection Information',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 1, 4, 146),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      // // Username
                      CustomTextFieldAdd(
                        controller: _usernameController,
                        label: 'Username',
                        icon: Icons.person,
                        isPassword: false,
                      ),
                      const SizedBox(height: 15),
                      // Password
                      CustomTextFieldAdd(
                        controller: _passwordController,
                        label: 'Password',
                        icon: Icons.lock,
                        isPassword: true,
                      ),
                      const SizedBox(height: 15),
                      // IP Address
                      CustomTextFieldAdd(
                        controller: _ipController,
                        label: 'IP Address',
                        icon: Icons.language,
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 15),
                      // Port
                      CustomTextFieldAdd(
                        controller: _portController,
                        label: 'Port',
                        icon: Icons.settings_ethernet,
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 15),
                      DropdownButtonFormField<String>(
                        value: _selectedStream,
                        decoration: InputDecoration(
                          isDense: true,
                          labelText: 'Choose Your Stream Type',
                          prefixIcon: const Icon(
                            Icons.video_settings,
                            color: Color.fromARGB(255, 70, 133, 193),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Color.fromARGB(255, 70, 133, 193),
                              width: 2,
                            ),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        dropdownColor: Colors.white,
                        icon: const Icon(Icons.arrow_drop_down,
                            color: Color.fromARGB(255, 70, 133, 193)),
                        style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 16,
                        ),
                        items: _streamOptions.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: const TextStyle(
                                color: Color.fromARGB(255, 33, 63, 104),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedStream = newValue!;
                          });
                        },
                        validator: (value) {
                          if (value == null || value == value.isEmpty) {
                            return 'Please select a valid stream type';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 15),
                      // Add Camera Button
                      if (_isSubmitting)
                        LoadingAnimationWidget.staggeredDotsWave(
                          color: const Color.fromARGB(255, 60, 90, 118),
                          size: 60,
                        )
                      else
                        GestureDetector(
                          onTap: _submitCameraData,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE0EDFF),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color.fromARGB(7, 68, 137, 255)
                                      .withOpacity(0.5),
                                  blurRadius: 10,
                                  offset: const Offset(2, 4),
                                ),
                              ],
                            ),
                            child: const Text(
                              'Add Camera',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 1, 4, 146),
                              ),
                            ),
                          ),
                        ),
                    ],
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

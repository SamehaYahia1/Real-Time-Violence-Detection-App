import 'package:flutter/material.dart';
import 'package:flutter_application_1/Pages/Test/Cameras/camera_discovery_service.dart';
import 'package:flutter_application_1/Constant/colors.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'dart:math' as math;

class AddScreen extends StatefulWidget {
  const AddScreen({super.key});

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();

  // Controller for text fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _ipController = TextEditingController();
  final TextEditingController _portController = TextEditingController();

  String _selectedStream = 'stream1';
  final List<String> _streamOptions = ['stream1', 'profile1', 'profile0'];

  @override
  void dispose() {
    // Clean up the controllers when the widget is disposed
    _nameController.dispose();
    _locationController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _ipController.dispose();
    _portController.dispose();
    super.dispose();
  }

  Future<void> handleAddCamera() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => isLoading = true);

    // Create camera data map
    final cameraData = {
      'name': _nameController.text,
      'location': _locationController.text,
      'username': _usernameController.text,
      'password': _passwordController.text,
      'ip': _ipController.text,
      'port': _portController.text,
      'streamProfile': _selectedStream,
    };

    // Here you would typically send this data to your backend
    // For now, we'll simulate a successful response
    await Future.delayed(const Duration(seconds: 2));

    setState(() => isLoading = false);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Success"),
        content: Text("Camera ${_nameController.text} added successfully!"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          )
        ],
      ),
    );
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
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: 'Camera Name',
                          focusColor: Colors.black,
                          prefixIcon: Icon(
                            Icons.camera_alt,
                            color: const Color.fromARGB(255, 70, 133, 193),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Color.fromARGB(
                                  255, 70, 133, 193), // Your custom color
                              width: 2,
                            ),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a camera name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15),

                      // Camera Location
                      TextFormField(
                        controller: _locationController,
                        decoration: InputDecoration(
                          labelText: 'Camera Location',
                          prefixIcon: Icon(
                            Icons.location_on,
                            color: const Color.fromARGB(255, 70, 133, 193),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Color.fromARGB(
                                  255, 70, 133, 193), // Your custom color
                              width: 2,
                            ),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a location';
                          }
                          return null;
                        },
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

                      // Username
                      TextFormField(
                        controller: _usernameController,
                        decoration: InputDecoration(
                          labelText: 'Username',
                          prefixIcon: Icon(
                            Icons.person,
                            color: const Color.fromARGB(255, 70, 133, 193),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Color.fromARGB(
                                  255, 70, 133, 193), // Your custom color
                              width: 2,
                            ),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a username';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 15),

                      // Password
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          prefixIcon: Icon(
                            Icons.lock,
                            color: Color.fromARGB(255, 70, 133, 193),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: Color.fromARGB(255, 70, 133, 193),
                              width: 2,
                            ),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a password';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 15),

                      // IP Address
                      TextFormField(
                        controller: _ipController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'IP Address',
                          prefixIcon: Icon(
                            Icons.language,
                            color: const Color.fromARGB(255, 70, 133, 193),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: Color.fromARGB(
                                  255, 70, 133, 193), // Your custom color
                              width: 2,
                            ),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter an IP address';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15),

                      // Port
                      TextFormField(
                        controller: _portController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Port',
                          prefixIcon: Icon(
                            Icons.settings_ethernet,
                            color: const Color.fromARGB(255, 70, 133, 193),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Color.fromARGB(
                                  255, 70, 133, 193), // Your custom color
                              width: 2,
                            ),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a port number';
                          }
                          return null;
                        },
                      ),
                      // const SizedBox(height: 30),
                      const SizedBox(height: 15),

                      DropdownButtonFormField<String>(
                        value: _selectedStream,
                        decoration: InputDecoration(
                          labelText: 'Choose Your Stream Type',
                          prefixIcon: Icon(
                            Icons.video_settings,
                            color: const Color.fromARGB(255, 70, 133, 193),
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
                      if (isLoading)
                        LoadingAnimationWidget.staggeredDotsWave(
                          color: const Color.fromARGB(255, 60, 90, 118),
                          size: 60,
                        )
                      else
                        GestureDetector(
                          onTap: handleAddCamera,
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

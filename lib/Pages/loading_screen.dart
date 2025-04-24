import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Constant/colors.dart';
import 'package:flutter_application_1/UserOrAdminPage/user_or_admin.dart';
import 'package:http/http.dart' as http;
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LoadingScreen extends StatefulWidget {
  final String message;
  // final String userId;

  const LoadingScreen({
    super.key,
    required this.message,
    // required this.userId,
  });

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  // late Timer _timer;

  // @override
  // void initState() {
  //   super.initState();
  //   _startPolling();
  // }

  // void _startPolling() {
  //   _timer = Timer.periodic(const Duration(seconds: 3), (_) => _checkApprovalStatus());
  // }

  // Future<void> _checkApprovalStatus() async {
  //   try {
  //     final response = await http.get(
  //       Uri.parse('http://10.0.2.2:5000/api/SubscriptionPlans/status?userId=${widget.userId}'),
  //     );

  //     if (response.statusCode == 200) {
  //       final data = jsonDecode(response.body);
  //       if (data['isApproved'] == true) {
  //         _timer.cancel();
  //         if (!mounted) return;
  //         Navigator.pushReplacement(
  //           context,
  //           MaterialPageRoute(
  //             builder: (context) => const UserPage(userName: 'User'),
  //           ),
  //         );
  //       }
  //     }
  //   } catch (e) {
  //     print('Error checking status: $e');
  //   }
  // }

  @override
  void dispose() {
    //_timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: LoadingAnimationWidget.flickr(
              leftDotColor: const Color.fromARGB(255, 56, 142, 217),
              rightDotColor: const Color.fromARGB(255, 46, 63, 112),
              size: 100,
            ),
          ),
          const SizedBox(height: 24),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Text(
              widget.message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: colors.contColor,
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Optional fallback text
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Text(
              'Waiting for admin approval...',
              style: TextStyle(
                fontSize: 16,
                color: colors.contColor.withOpacity(0.7),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

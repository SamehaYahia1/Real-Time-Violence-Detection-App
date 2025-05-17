import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Constant/api_endpoint.dart';
import 'package:flutter_application_1/Constant/colors.dart';
import 'package:flutter_application_1/Pages/Home/BottomBarScreen.dart';
import 'package:flutter_application_1/Pages/Test/HomecctvScreen.dart';
import 'package:flutter_application_1/Pages/Plans/choose_your_plan.dart';
import 'package:flutter_application_1/Pages/Test/UserOrAdminPage/user_or_admin.dart';
import 'package:http/http.dart' as http;
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LoadingScreen extends StatefulWidget {
  final String message;
  final String SubscriptionId;
  final String userName;
  final String userId;

  const LoadingScreen(
      {super.key,
      required this.message,
      required this.userId,
      required this.userName,
      required this.SubscriptionId});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _startPolling();
  }

  void _startPolling() {
    _timer = Timer.periodic(
      const Duration(seconds: 15),
      (_) => _checkApprovalStatus(),
    );
  }

  Future<void> _checkApprovalStatus() async {
    try {
      final response = await http.get(
        Uri.parse(
            '${ApiEndpoints.baseUrl}/api/SubscriptionPlans/${widget.userId}/status'),
      );

      print('Status Code: ${response.statusCode}');
      print('Raw Body: ${response.body}');

      if (response.statusCode == 200) {
        final message = response.body.trim(); // Clean whitespace/newlines
        print('Message: $message');

        if (message == 'Approved') {
          _timer.cancel();
          if (!mounted) return;
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => Homeuserscreen(
                userId: widget.userId,
                username: widget.userName,
                subscriptionPlan: int.parse(widget.SubscriptionId),
              ),
            ),
          );
        } else if (message == 'Rejected') {
          _timer.cancel();
          if (!mounted) return;
          await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Request Rejected'),
              content: const Text(
                  'We are sorry, your request was rejected. Please try again.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close dialog
                  },
                  child: const Text('OK'),
                ),
              ],
            ),
          );
          if (!mounted) return;
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => ChoosePlanScreen(
                userId: widget.userId,
                SubscriptionId: widget.SubscriptionId,
                userName: widget.userName,
              ), // Navigate to ChoosePlanScreen
            ),
          );
        } else if (message == 'No request found for this userId') {
          _timer.cancel();
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No request found for this user.')),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => ChoosePlanScreen(
                userId: widget.userId,
                SubscriptionId: widget.SubscriptionId,
                userName: widget.userName,
              ), // Navigate to ChoosePlanScreen
            ),
          );
        }
      }
    } catch (e) {
      print('Error checking status: $e');
    }
  }

  @override
  void dispose() {
    _timer.cancel();
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

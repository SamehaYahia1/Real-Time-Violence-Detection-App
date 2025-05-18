import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Constant/api_endpoint.dart';
import 'package:flutter_application_1/Pages/Plans/loading_screen.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_application_1/Models/plan_model.dart';
import 'package:flutter_application_1/Models/plan_card.dart';

class ChoosePlanScreen extends StatefulWidget {
  final String userName;
  final String userId;
  final String SubscriptionId;

  const ChoosePlanScreen({
    super.key,
    required this.userName,
    required this.userId,
    required this.SubscriptionId,
  });

  @override
  State<ChoosePlanScreen> createState() => _ChoosePlanScreenState();
}

class _ChoosePlanScreenState extends State<ChoosePlanScreen>
    with SingleTickerProviderStateMixin {
  int? selectedIndex;
  bool _visible = false;
  late AnimationController _controller;

  List<PlanModel> plans = [];
  bool isLoadingPlans = true;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(duration: const Duration(seconds: 2), vsync: this);
    fetchPlans();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _visible = true;
      });
    });
  }

  Future<void> fetchPlans() async {
    final url =
        Uri.parse('${ApiEndpoints.baseUrl}/api/SubscriptionPlans/plans');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        final filteredPlans = data
            .where((plan) => plan['id'] == 2 || plan['id'] == 3)
            .map((plan) {
          return PlanModel(
            id: plan['id'],
            name: plan['name'],
            enableStreaming: plan['enableStreaming'],
            enableFullStreamStorage: plan['enableFullStreamStorage'],
            enableAIDetection: plan['enableAIDetection'],
            enableAIChunkStorage: plan['enableAIChunkStorage'],
            fullStreamRetentionHours: plan['fullStreamRetentionHours'],
            aiChunkRetentionHours: plan['aiChunkRetentionHours'],
            maxTotalStorageMB: plan['maxTotalStorageMB'],
          );
        }).toList();

        setState(() {
          plans = filteredPlans;
          isLoadingPlans = false;
        });
      } else {
        throw Exception('Failed to load plans');
      }
    } catch (e) {
      print('Error fetching plans: $e');
      setState(() {
        isLoadingPlans = false;
      });
    }
  }

  Future<void> requestPlan(String userId, int requestedPlanId) async {
    final url = Uri.parse('${ApiEndpoints.baseUrl}/api/SubscriptionPlans');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'userId': userId,
          'requestedPlanId': requestedPlanId,
        }),
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        final message = decoded['message'] ?? 'Plan updated!';
        if (!context.mounted) return;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => LoadingScreen(
                userId: widget.userId,
                userName: widget.userName,
                message: message,
                SubscriptionId: widget.SubscriptionId),
          ),
        );
      } else {
        print('Error: ${response.body}');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => LoadingScreen(
                userName: widget.userName,
                SubscriptionId: widget.SubscriptionId,
                userId: '',
                message: "Something went wrong. Please try again."),
          ),
        );
      }
    } catch (e) {
      print('Exception: $e');
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => LoadingScreen(
              SubscriptionId: widget.SubscriptionId,
              userName: widget.userName,
              userId: '',
              message: "Something went wrong. Please try again."),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFFE9F0FF),
      body: SafeArea(
        child: Stack(
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 1500),
              curve: Curves.easeOut,
              top: 0,
              right: _visible ? -19 : -200,
              child: Image.asset('Assets/images/background.png',
                  width: 200, height: 350),
            ),
            AnimatedPositioned(
              duration: const Duration(milliseconds: 1500),
              curve: Curves.easeOut,
              bottom: 0,
              left: _visible ? -19 : -200,
              child: Image.asset('Assets/images/background2.png',
                  width: 200, height: 350),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(LucideIcons.arrowLeft,
                      size: 24, color: Colors.blueAccent),
                  const SizedBox(height: 50),
                  Text(
                    "Welcome, ${widget.userName}!",
                    style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF043B8E)),
                  ),
                  const SizedBox(height: 15),
                  const Text("Select a suitable plan",
                      style: TextStyle(fontSize: 18, color: Colors.blueAccent)),
                  const SizedBox(height: 40),
                  isLoadingPlans
                      ? const Center(child: CircularProgressIndicator())
                      : Expanded(
                          child: Stack(
                            children: List.generate(plans.length, (index) {
                              final isSelected = selectedIndex == index;
                              final isHidden = selectedIndex != null &&
                                  selectedIndex != index;

                              return AnimatedPositioned(
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.easeInOut,
                                top: isSelected ? 0 : index * 150.0,
                                left: isHidden ? -size.width : 0,
                                right: isHidden ? size.width : 0,
                                bottom: isSelected ? 0 : null,
                                child: AnimatedOpacity(
                                  duration: const Duration(milliseconds: 300),
                                  opacity: isHidden ? 0 : 1,
                                  child: PlanCard(
                                    plan: plans[index],
                                    isSelected: isSelected,
                                    onTap: () {
                                      setState(() {
                                        selectedIndex =
                                            isSelected ? null : index;
                                      });
                                    },
                                    onBackTap: () {
                                      setState(() {
                                        selectedIndex = null;
                                      });
                                    },
                                    onRequestTap: () {
                                      final selectedPlanId = plans[index].id;
                                      requestPlan(
                                          widget.userId, selectedPlanId);
                                    },
                                  ),
                                ),
                              );
                            }),
                          ),
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

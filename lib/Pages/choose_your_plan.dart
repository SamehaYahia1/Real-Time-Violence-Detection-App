import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../Constant/plan_constants.dart';
import '../../../Models/plan_model.dart';
import '../../Models/plan_card.dart';
import 'package:flutter_application_1/UserOrAdminPage/user_or_admin.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChoosePlanScreen extends StatefulWidget {
  final String userName;
  const ChoosePlanScreen({super.key, required this.userName});

  @override
  State<ChoosePlanScreen> createState() => _ChoosePlanScreenState();
}

class _ChoosePlanScreenState extends State<ChoosePlanScreen>
    with SingleTickerProviderStateMixin {
  int? selectedIndex;
  bool _visible = false;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(duration: const Duration(seconds: 2), vsync: this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _visible = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final List<PlanModel> plans = AppConstants.plans;

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
                  Icon(LucideIcons.arrowLeft,
                      size: 24, color: Colors.blueAccent),
                  const SizedBox(height: 50),
                  Text("Welcome, ${widget.userName}!\nChoose Your Plan",
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF043B8E))),
                  const SizedBox(height: 15),
                  Text("Select a suitable plan",
                      style: TextStyle(fontSize: 18, color: Colors.blueAccent)),
                  const SizedBox(height: 40),
                  Expanded(
                    child: Stack(
                      children: List.generate(plans.length, (index) {
                        final isSelected = selectedIndex == index;
                        final isHidden =
                            selectedIndex != null && selectedIndex != index;

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
                                  selectedIndex = isSelected ? null : index;
                                });
                              },
                              onBackTap: () {
                                setState(() {
                                  selectedIndex =
                                      null; // This is the only place "Back" is handled
                                });
                              },
                              onRequestTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          UserPage(userName: widget.userName)),
                                );
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

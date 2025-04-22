import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../Models/plan_model.dart';
import 'package:flutter_application_1/UserOrAdminPage/user_or_admin.dart';

class PlanCard extends StatelessWidget {
  final PlanModel plan;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback? onBackTap;
  final VoidCallback? onRequestTap;

  const PlanCard({
    super.key,
    required this.plan,
    required this.isSelected,
    required this.onTap,
    this.onBackTap,
    this.onRequestTap,
  });

  @override
  Widget build(BuildContext context) {
    final titleColor = isSelected ? const Color(0xFF043B8E) : Colors.blue[800];
    final subTextColor = isSelected ? Colors.white : Colors.blue[300];
    final cardColor = isSelected ? const Color(0xFF4196FD) : Colors.white;
    final iconColor = isSelected ? Colors.blue[900] : Colors.blue;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 15,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: isSelected
            ? SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(plan.title,
                        style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: titleColor)),
                    const SizedBox(height: 6),
                    Text(plan.price, style: TextStyle(color: subTextColor)),
                    Text(plan.users, style: TextStyle(color: subTextColor)),
                    const SizedBox(height: 12),
                    ...plan.features.map(
                      (feature) => Row(
                        children: [
                          Icon(LucideIcons.check, color: iconColor, size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              feature,
                              style: TextStyle(fontSize: 14, color: titleColor),
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: onBackTap,
                              icon: Icon(
                                LucideIcons.arrowLeft,
                                color: Colors.blueAccent,
                              ),
                              label: const Text("Back"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors
                                    .white, // This sets the button's background to white
                                foregroundColor: Colors
                                    .blueAccent, // Color of the text and icon
                                elevation: 0, // Remove elevation
                                shadowColor:
                                    Colors.transparent, // Remove shadow
                                shape:
                                    const StadiumBorder(), // Keeps the shape as stadium border
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: onRequestTap ??
                                  () {
                                    // This is where the navigation happens when the button is pressed
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => const UserPage(
                                              userName:
                                                  'User')), // Navigate to UserPage
                                    );
                                  },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Colors.white, // White background
                                foregroundColor:
                                    Colors.blueAccent, // Color of text and icon
                                elevation: 0, // No elevation
                                shadowColor:
                                    Colors.transparent, // Remove shadow
                                shape:
                                    const StadiumBorder(), // Keeps the shape as stadium border
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Text("Request"),
                                  SizedBox(width: 8),
                                  Icon(LucideIcons.arrowRight,
                                      color: Colors.blueAccent),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(plan.title,
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: titleColor)),
                  const SizedBox(height: 10),
                  Text(plan.price,
                      style: TextStyle(fontSize: 20, color: subTextColor)),
                ],
              ),
      ),
    );
  }
}

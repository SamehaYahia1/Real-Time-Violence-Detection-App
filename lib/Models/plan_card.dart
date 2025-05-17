import 'package:flutter/material.dart';
import 'package:flutter_application_1/Pages/Home/BottomBarScreen.dart';
import 'package:flutter_application_1/Pages/Test/HomecctvScreen.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../Models/plan_model.dart';
import 'package:flutter_application_1/Pages/Test/UserOrAdminPage/user_or_admin.dart';

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
    final String userId = "";
    final String userName = "";
    final String SubscriptionId = "";

    // Features to display
    final List<String> features = [
      plan.enableStreaming ? 'Live Streaming Enabled' : 'No Live Streaming',
      plan.enableFullStreamStorage
          ? 'Full Stream Storage Enabled'
          : 'No Full Stream Storage',
      plan.enableAIDetection ? 'AI Detection Enabled' : 'No AI Detection',
      plan.enableAIChunkStorage
          ? 'AI Chunk Storage Enabled'
          : 'No AI Chunk Storage',
      'Full Stream Retention: ${plan.fullStreamRetentionHours} hours',
      'AI Chunk Retention: ${plan.aiChunkRetentionHours} hours',
      'Max Storage: ${plan.maxTotalStorageMB} MB',
    ];

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(24),
          boxShadow: const [
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
                    Text(plan.name,
                        style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: titleColor)),
                    const SizedBox(height: 12),
                    ...features.map(
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
                              icon: const Icon(
                                LucideIcons.arrowLeft,
                                color: Colors.blueAccent,
                              ),
                              label: const Text("Back"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.blueAccent,
                                elevation: 0,
                                shadowColor: Colors.transparent,
                                shape: const StadiumBorder(),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: onRequestTap ??
                                  () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Homeuserscreen(
                                              userId: userId,
                                              username: userName,
                                              subscriptionPlan:
                                                  int.parse(SubscriptionId))),
                                    );
                                  },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.blueAccent,
                                elevation: 0,
                                shadowColor: Colors.transparent,
                                shape: const StadiumBorder(),
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
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
                  Text(plan.name,
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: titleColor)),
                  const SizedBox(height: 10),
                  Text('Max Storage: ${plan.maxTotalStorageMB} MB',
                      style: TextStyle(fontSize: 20, color: subTextColor)),
                ],
              ),
      ),
    );
  }
}

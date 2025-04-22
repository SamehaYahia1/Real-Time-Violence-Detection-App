// import 'package:flutter/material.dart';

// class SubscriptionScreen extends StatefulWidget {
//   @override
//   _SubscriptionScreenState createState() => _SubscriptionScreenState();
// }

// class _SubscriptionScreenState extends State<SubscriptionScreen> {
//   int selectedPlanIndex = 0;

//   final List<Map<String, dynamic>> plans = [
//     {
//       'title': 'Common',
//       'price': '\$5.99 / month',
//       'features': ['Basic music streaming', 'Ad-supported'],
//     },
//     {
//       'title': 'Plus',
//       'price': '\$9.99 / month',
//       'features': ['Ad-free listening', 'Offline mode', 'High quality audio'],
//     },
//     {
//       'title': 'Premium',
//       'price': '\$14.99 / month',
//       'features': [
//         'All Plus features',
//         'Multi-device access',
//         'Exclusive content'
//       ],
//     },
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xFFD9EAFE),
//       appBar: AppBar(
//         backgroundColor: Color(0xFFD9EAFE),
//         elevation: 0,
//         title: Text(
//           'Choose Your Plan',
//           style: TextStyle(
//             fontFamily: 'Inter',
//             fontSize: 24,
//             fontWeight: FontWeight.bold,
//             color: Color(0xFF95C4FC),
//           ),
//         ),
//         centerTitle: true,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             Text(
//               'Select a suitable plan',
//               style: TextStyle(
//                 fontFamily: 'Inter',
//                 fontSize: 14,
//                 color: Colors.black,
//               ),
//             ),
//             const SizedBox(height: 16),
//             Expanded(
//               child: ListView.builder(
//                 itemCount: plans.length,
//                 itemBuilder: (context, index) {
//                   final isSelected = index == selectedPlanIndex;
//                   return GestureDetector(
//                     onTap: () {
//                       setState(() {
//                         selectedPlanIndex = index;
//                       });
//                     },
//                     child: AnimatedContainer(
//                       duration: Duration(milliseconds: 300),
//                       margin: EdgeInsets.symmetric(vertical: 8),
//                       padding: EdgeInsets.all(16),
//                       decoration: BoxDecoration(
//                         color: isSelected ? Color(0xFF95C4FC) : Colors.white,
//                         borderRadius: BorderRadius.circular(20),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.black12,
//                             blurRadius: 8,
//                             offset: Offset(0, 4),
//                           ),
//                         ],
//                       ),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             plans[index]['title'],
//                             style: TextStyle(
//                               fontFamily: 'Inter',
//                               fontWeight: FontWeight.bold,
//                               fontSize: 18,
//                               color:
//                                   isSelected ? Colors.white : Color(0xFF95C4FC),
//                             ),
//                           ),
//                           SizedBox(height: 4),
//                           Text(
//                             plans[index]['price'],
//                             style: TextStyle(
//                               fontFamily: 'Inter',
//                               fontSize: 14,
//                               color:
//                                   isSelected ? Colors.white : Color(0xFF95C4FC),
//                             ),
//                           ),
//                           SizedBox(height: 8),
//                           ...plans[index]['features'].map<Widget>((feature) {
//                             return Row(
//                               children: [
//                                 Icon(Icons.check,
//                                     size: 16,
//                                     color: isSelected
//                                         ? Colors.white
//                                         : Color(0xFF95C4FC)),
//                                 SizedBox(width: 6),
//                                 Text(
//                                   feature,
//                                   style: TextStyle(
//                                     fontFamily: 'Inter',
//                                     fontSize: 13,
//                                     color: isSelected
//                                         ? Colors.white
//                                         : Color(0xFF95C4FC),
//                                   ),
//                                 )
//                               ],
//                             );
//                           }).toList(),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

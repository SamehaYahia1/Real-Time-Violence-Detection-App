// import 'package:flutter/material.dart';

// class SubscriptionPlansScreen extends StatefulWidget {
//   @override
//   _SubscriptionPlansScreenState createState() =>
//       _SubscriptionPlansScreenState();
// }

// class _SubscriptionPlansScreenState extends State<SubscriptionPlansScreen> {
//   int selectedIndex =
//       1; // 0 = Common, 1 = Plus, 2 = Premium (Plus is initially centered)

//   final List<Map<String, String>> plans = [
//     {
//       'title': 'Common Plan',
//       'price': '\$4,200 / month',
//       'seats': '2 free seats',
//       'storage': '250MB storage',
//     },
//     {
//       'title': 'Plus Plan',
//       'price': '\$10,500 / month',
//       'seats': '4 free seats',
//       'storage': '1GB storage',
//     },
//     {
//       'title': 'Premium Plan',
//       'price': 'Contact us',
//       'seats': 'Unlimited seats',
//       'storage': '1TB+ storage',
//     },
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       appBar: AppBar(
//         backgroundColor: Colors.black,
//         title: const Text('Choose Your Plan'),
//         centerTitle: true,
//       ),
//       body: Center(
//         child: SizedBox(
//           height: 500,
//           child: Stack(
//             alignment: Alignment.center,
//             children: List.generate(plans.length, (index) {
//               final isSelected = selectedIndex == index;
//               final scale = isSelected ? 1.0 : 0.85;
//               final verticalOffset = isSelected ? 0.0 : 30.0;
//               final opacity = isSelected ? 1.0 : 0.6;

//               return AnimatedPositioned(
//                 duration: const Duration(milliseconds: 300),
//                 curve: Curves.easeInOut,
//                 left: MediaQuery.of(context).size.width / 2 -
//                     150 +
//                     (index - selectedIndex) * 200,
//                 top: verticalOffset,
//                 child: GestureDetector(
//                   onTap: () {
//                     setState(() {
//                       selectedIndex = index;
//                     });
//                   },
//                   child: AnimatedScale(
//                     scale: scale,
//                     duration: const Duration(milliseconds: 300),
//                     child: Opacity(
//                       opacity: opacity,
//                       child: buildPlanCard(
//                         plans[index]['title']!,
//                         plans[index]['price']!,
//                         plans[index]['seats']!,
//                         plans[index]['storage']!,
//                       ),
//                     ),
//                   ),
//                 ),
//               );
//             }),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget buildPlanCard(
//       String title, String price, String seats, String storage) {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
//       padding: const EdgeInsets.all(20),
//       width: 300,
//       height: 400,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(20),
//         gradient: const LinearGradient(
//           colors: [Colors.deepPurple, Colors.black],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.deepPurple.withOpacity(0.5),
//             blurRadius: 15,
//             offset: const Offset(0, 10),
//           ),
//         ],
//       ),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Text(title,
//               style: const TextStyle(
//                   color: Colors.white,
//                   fontSize: 26,
//                   fontWeight: FontWeight.bold)),
//           const SizedBox(height: 20),
//           Text(price,
//               style: const TextStyle(color: Colors.white70, fontSize: 22)),
//           const SizedBox(height: 20),
//           Text(seats, style: const TextStyle(color: Colors.white70)),
//           Text(storage, style: const TextStyle(color: Colors.white70)),
//         ],
//       ),
//     );
//   }
// }

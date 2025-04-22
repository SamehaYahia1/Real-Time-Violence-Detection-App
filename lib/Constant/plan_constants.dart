import '../../Models/plan_model.dart';

class AppConstants {
  static List<PlanModel> plans = [
    // PlanModel(
    //   title: 'Common',
    //   price: '\$9.99 / month',
    //   users: '1 account',
    //   features: [
    //     'Unlimited movies ad-free',
    //     'Free anywhere cancel option',
    //   ],
    // ),
    PlanModel(
      title: 'Plus',
      price: '\$14.99 / month',
      users: 'Up to 6 accounts',
      features: [
        '6 personal accounts for family members',
        'Family Mix: playlist for your family',
        'Explicit content filters you set',
      ],
    ),
    PlanModel(
      title: 'Premium',
      price: '\$4.99 / month',
      users: '1 account',
      features: [
        'Special for current students',
        'Show ID required',
        'Listen to music ad-free',
      ],
    ),
  ];
}

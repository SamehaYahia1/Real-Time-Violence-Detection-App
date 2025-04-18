import 'package:flutter/material.dart';


class UserPage extends StatefulWidget {
  final String userName;
  const UserPage({super.key, required this.userName});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Page'),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class BackgroundContainer extends StatelessWidget {
  final Widget child;

  const BackgroundContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("Assets/images/camera_bg.png"),
          fit: BoxFit.scaleDown,
          alignment: Alignment(0, 0.15),
          colorFilter: ColorFilter.mode(
            Color(0xFFE9F0FF),
            BlendMode.dstATop,
          ),
        ),
      ),
      child: child,
    );
  }
}

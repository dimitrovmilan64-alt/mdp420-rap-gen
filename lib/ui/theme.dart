import 'package:flutter/material.dart';

const ironGreen = Color(0xFF00FF66);
const ironGreenSoft = Color(0xFF37FF88);
const ironDark = Color(0xFF010603);
const ironPanel = Color(0xFF031108);
const ironPanelRaised = Color(0xFF061A0D);

class IronBackground extends StatelessWidget {
  final Widget child;
  const IronBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          center: Alignment(0.0, -0.78),
          radius: 1.35,
          colors: [
            Color(0xFF063319),
            Color(0xFF011008),
            ironDark,
            Colors.black,
          ],
          stops: [0.0, 0.35, 0.72, 1.0],
        ),
      ),
      child: SafeArea(child: child),
    );
  }
}

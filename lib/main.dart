import 'package:flutter/material.dart';
import 'screens/generate_screen.dart';
import 'ui/theme.dart';

void main() {
  runApp(const MdpRapApp());
}

class MdpRapApp extends StatelessWidget {
  const MdpRapApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MDP 420 Rap Gen',
      theme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
        scaffoldBackgroundColor: ironDark,
        colorScheme: const ColorScheme.dark(
          primary: ironGreen,
          surface: ironPanel,
        ),
      ),
      home: const GenerateScreen(),
    );
  }
}

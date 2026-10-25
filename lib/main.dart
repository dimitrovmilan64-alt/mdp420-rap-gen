import 'package:flutter/material.dart';
import 'screens/generate_screen.dart';
import 'screens/history_screen.dart';
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
      home: const MainNav(),
    );
  }
}

class MainNav extends StatefulWidget {
  const MainNav({super.key});

  @override
  State<MainNav> createState() => _MainNavState();
}

class _MainNavState extends State<MainNav> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _index,
        children: const [
          GenerateScreen(),
          HistoryScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        backgroundColor: ironDark,
        selectedItemColor: ironGreen,
        unselectedItemColor: Colors.white54,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.auto_awesome), label: "Генератор"),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: "История"),
        ],
      ),
    );
  }
}

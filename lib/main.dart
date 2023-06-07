import 'package:flutter/material.dart';
import 'package:swn_play/pages/app_page.dart';
import 'package:swn_play/pages/game_route.dart';

void main() {
  runApp(const SWNPlayApp());
}

class SWNPlayApp extends StatelessWidget {
  const SWNPlayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SWN Play',
      theme: ThemeData(
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _tab = 0;
  final List<Widget> _pages = [
    AppPage(),
    GamePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_tab],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tab,
        onDestinationSelected: (value) => {
          setState(() {
            _tab = value;
          })
        },
        destinations: const <NavigationDestination>[
          NavigationDestination(icon: Icon(Icons.adb), label: "Приложения"),
          NavigationDestination(icon: Icon(Icons.gamepad), label: "Игры"),
          NavigationDestination(icon: Icon(Icons.settings), label: "Настройки")
        ],
      ),
    );
  }
}
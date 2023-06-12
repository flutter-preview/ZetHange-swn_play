import 'package:flutter/material.dart';
import 'package:swn_play/pages/app_route.dart';
import 'package:swn_play/pages/game_route.dart';
import 'package:swn_play/pages/search_route.dart';
import 'package:swn_play/pages/settings_route.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
        navigationBarTheme: const NavigationBarThemeData(
            backgroundColor: Colors.white, indicatorColor: Colors.green),
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
    const GamePage(),
    const AppPage(),
    const SearchPage(),
    const SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  _pages[_tab],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tab,
        onDestinationSelected: (value) => {
          setState(() {
            _tab = value;
          })
        },
        destinations: const <NavigationDestination>[
          NavigationDestination(icon: Icon(Icons.gamepad), label: "Игры"),
          NavigationDestination(icon: Icon(Icons.adb), label: "Приложения"),
          NavigationDestination(icon: Icon(Icons.search), label: "Поиск"),
          NavigationDestination(icon: Icon(Icons.settings), label: "Настройки")
        ],
      ),
    );
  }
}

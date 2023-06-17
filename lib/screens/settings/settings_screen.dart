import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swn_play/screens/settings/login.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen>
    with WidgetsBindingObserver {
  late bool isLoggedIn = false;

  void getData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      isLoggedIn = preferences.getBool("isLoggedIn") ?? false;
    });
    debugPrint("isLoggedIn: $isLoggedIn");
  }

  void unLogin() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.remove("isLoggedIn");
    setState(() {
      isLoggedIn = false;
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      getData();
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Настройки'),
      ),
      body: Container(
        child: Column(
          children: [
            Center(
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Image(
                      image: Image.network(
                        "https://avatar-management--avatars.us-west-2.prod.public.atl-paas.net/default-avatar.png",
                      ).image,
                      width: 100,
                    ),
                  ),
                  const SizedBox(height: 10),
                  FilledButton(
                    onPressed: () {
                      if (isLoggedIn) {
                        unLogin();
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginPage(),
                          ),
                        );
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith(
                        (states) {
                          return Colors.amberAccent;
                        },
                      ),
                    ),
                    child: Text(
                        isLoggedIn ? "Выйти из аккаунта" : "Войти в аккаунт"),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

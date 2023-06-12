import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swn_play/screens/settings/login.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String _profile = "";

  void getData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    _profile = preferences.getString("profile")!;
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  void setProfile() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    preferences.setString("profile", "app");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(toolbarHeight: 0),
      body: Column(
        children: [
          Text("Профиль: $_profile"),
          ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginPage()));
              },
              child: const Text("set state"))
        ],
      ),
    );
  }
}

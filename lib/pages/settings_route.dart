import 'package:appcheck/appcheck.dart' as appCheck;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swn_play/api/repository/apps_repository.dart';
import 'package:swn_play/screens/settings/login.dart';

// import 'package:swn_play/screens/settings/login.dart';
import 'package:swn_play/studies/app.dart';

import '../api/models/apps.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late Future<List<AppSummary>> _olderApps;
  late bool isLoggedIn = false;

  void getData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      isLoggedIn = preferences.getBool("isLoggedIn") ?? false;
    });
    debugPrint("isLoggedIn: " + isLoggedIn.toString());
  }

  Future<List<AppSummary>> getOlderApps() async {
    List<appCheck.AppInfo>? installedApps =
        await appCheck.AppCheck.getInstalledApps();

    List<Package> packageList = installedApps!
        .map((appInfo) => Package(
              packageName: appInfo.packageName,
              version: appInfo.versionName ?? '',
            ))
        .toList();

    return getUpdateApps(packageList);
  }

  @override
  void initState() {
    getData();
    _olderApps = getOlderApps();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(toolbarHeight: 0),
      body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
            padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  color: Colors.white,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    child: InkWell(
                      child: Row(children: [
                        Column(children: const [Icon(Icons.account_circle)]),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(isLoggedIn ? "Вы вошли в аккаунт, круто" : "Вы не вошли в аккаунт")
                      ]),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const LoginPage()),
                        );
                      },
                    ),
                  ),
                ),
                const Text(
                  "Обновления:",
                  style: TextStyle(fontSize: 20),
                ),
              ],
            )),
        SizedBox(
          height: MediaQuery.of(context).size.height - 112 - 46.9 - 44,
          child: FutureBuilder<List<AppSummary>>(
            future: _olderApps,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final post = snapshot.data![index];
                    return AppListWidget(
                      id: post.id,
                      title: post.title,
                      logo: post.logo,
                      developer: post.developer,
                    );
                  },
                );
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ),
      ]),
    );
  }
}

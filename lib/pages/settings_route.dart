import 'package:appcheck/appcheck.dart' as appCheck;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swn_play/api/repository/apps_repository.dart';
// import 'package:swn_play/screens/settings/login.dart';
import 'package:swn_play/studies/app.dart';

import '../api/models/apps.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String _profile = "";
  late Future<List<AppSummary>> _olderApps;

  void getData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    _profile = preferences.getString("profile")!;
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

  void setProfile() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    preferences.setString("profile", "app");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(toolbarHeight: 0),
      body: FutureBuilder<List<AppSummary>>(
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
    );
  }
}

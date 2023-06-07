import 'dart:io';
import 'package:app_installer/app_installer.dart';
import 'package:flutter/material.dart';
import 'package:appcheck/appcheck.dart';
import 'package:dio/dio.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:swn_play/api/models/apps.dart';
import 'package:swn_play/api/repository/apps_repository.dart';

class AppScreen extends StatefulWidget {
  final int id;
  final String title;

  const AppScreen({super.key, required this.id, required this.title});

  @override
  State<AppScreen> createState() => _AppScreenState();
}

class _AppScreenState extends State<AppScreen> {
  late Future<App> _futureApp;
  late bool _installed = false;
  double? _progress;
  String _status = '';

  Future<void> checkPackageName() async {
    App gettedApp = await _futureApp;
    final String package = gettedApp.packageName;
    AppCheck.checkAvailability(package).then(
      (app) => {
        setState(() {
          _installed = true;
        })
      },
    );
  }

  @override
  void initState() {
    _futureApp = fetchAppById(widget.id);
    checkPackageName();
    super.initState();
  }

  Future<void> playApp() async {
    App gettedApp = await _futureApp;
    final String package = gettedApp.packageName;
    await AppCheck.launchApp(package);
  }

  Future<void> requestPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
      Permission.requestInstallPackages,
    ].request();
  }

  Future<void> installApk(String filePath) async {
    await AppInstaller.installApk(filePath);
  }

  Future<void> downloadApp() async {
    await requestPermissions();
    App gettedApp = await _futureApp;
    String url = gettedApp.downloadLink;
    String fileName = '${gettedApp.title}.apk';
    Directory dir = Directory('/storage/emulated/0/Download/SWN Play');
    String savePath = '${dir.path}/$fileName';

    debugPrint("Downloading");
    await Dio().download(url, savePath);
    debugPrint("Downloaded successfully");
    await installApk(savePath);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        margin: const EdgeInsets.only(left: 5, right: 5, top: 5),
        child: FutureBuilder<App>(
          future: _futureApp,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(snapshot.data!.title,
                      style: const TextStyle(fontSize: 20)),
                  Text(snapshot.data!.downloadLink),
                  _installed
                      ? TextButton(
                          onPressed: playApp, child: const Text("Запустить"))
                      : ElevatedButton(
                          onPressed: downloadApp,
                          child: const Text('Download')),
                  const SizedBox(height: 8),
                ],
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}

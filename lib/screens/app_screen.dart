import 'dart:io';
import 'package:app_installer/app_installer.dart';
import 'package:flutter/material.dart';
import 'package:appcheck/appcheck.dart';
import 'package:dio/dio.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:google_fonts/google_fonts.dart';

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
  bool _isLoading = false;
  String _progress = "0%";

  Future<void> checkPackageName() async {
    App gettedApp = await _futureApp;
    final String package = gettedApp.packageName;
    AppCheck.checkAvailability(package).then(
      (app) => {
        debugPrint("app installed"),
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

  void onReceiveProgress(received, total) {
    if (total != -1) {
      if ((received / total * 100) == 100) {
        setState(() {
          _isLoading = false;
          _progress = "";
        });
      } else {
        setState(() {
          _isLoading = true;
          _progress = (received / total * 100).toStringAsFixed(0) + '%';
        });
      }
    }
  }

  Future<void> playApp() async {
    App gettedApp = await _futureApp;
    final String package = gettedApp.packageName;
    await AppCheck.launchApp(package);
  }

  Future<void> downloadApp() async {
    await [
      Permission.storage,
    ].request();
    App gettedApp = await _futureApp;
    String url = gettedApp.downloadLink;
    String fileName = '${gettedApp.title}.apk';
    Directory dir = Directory('/storage/emulated/0/Download/SWN Play');
    String savePath = '${dir.path}/$fileName';

    debugPrint("Downloading");
    await Dio().download(url, savePath, onReceiveProgress: onReceiveProgress);
    debugPrint("Downloaded successfully");
    await [
      Permission.requestInstallPackages,
    ].request();
    debugPrint(savePath);
    await AppInstaller.installApk(savePath);
    setState(() {
      _installed = true;
    });
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
                  ClipRRect(
                      borderRadius: BorderRadius.circular(15.0),
                      child: Image(
                        width: 80,
                        image: NetworkImage(snapshot.data!.logo),
                      )),
                  Text(
                    "Описание: ${snapshot.data!.description}",
                    style: GoogleFonts.roboto(),
                  ),
                  Text("имя пакета: ${snapshot.data!.packageName}"),
                  Text("Ссылка: ${snapshot.data!.downloadLink}"),
                  _installed
                      ? TextButton(
                          onPressed: playApp, child: const Text("Запустить"))
                      : ElevatedButton(
                          onPressed: _isLoading ? null : downloadApp,
                          child: Text(_isLoading ? _progress : 'Download')),
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

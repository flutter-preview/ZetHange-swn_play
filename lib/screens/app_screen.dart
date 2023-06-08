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
  bool _isLoading = false;
  double _progress = 0;
  CancelToken cancelToken = CancelToken();

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
      if ((received / total * 100) == 100 || cancelToken.isCancelled) {
        setState(() {
          _isLoading = false;
          _progress = 0;
        });
      } else {
        setState(() {
          _isLoading = true;
          _progress = (received / total);
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

    await Dio().download(
      url,
      savePath,
      cancelToken: cancelToken,
      onReceiveProgress: onReceiveProgress,
    );

    await [
      Permission.requestInstallPackages,
    ].request();
    debugPrint(savePath);
    await AppInstaller.installApk(savePath);
    setState(() {
      _installed = true;
    });
  }

  void cancelDownload() {
    cancelToken.cancel("Download cancelled by user");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
        child: FutureBuilder<App>(
          future: _futureApp,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      ClipRRect(
                          borderRadius: BorderRadius.circular(15.0),
                          child: Image(
                            width: 80,
                            image: NetworkImage(snapshot.data!.logo),
                          )),
                      Container(
                        margin: const EdgeInsets.only(left: 5),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(snapshot.data!.title,
                                  style: const TextStyle(fontSize: 18)),
                              Text(
                                snapshot.data!.developer,
                                style: const TextStyle(color: Colors.grey),
                              )
                            ]),
                      ),
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 5),
                    child: _installed
                        ? ElevatedButton(
                            onPressed: playApp,
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 48),
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text("Запустить"),
                          )
                        : ElevatedButton(
                            onPressed:
                                _isLoading ? cancelDownload : downloadApp,
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 48),
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                            ),
                            child: _isLoading
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                        CircularProgressIndicator(
                                            value: _progress,
                                            color: Colors.white),
                                      ])
                                : const Text('Загрузить'),
                          ),
                  ),
                  const SizedBox(height: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text("Описание",
                                textAlign: TextAlign.left,
                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
                            Icon(Icons.chevron_right)
                          ]),
                      const SizedBox(height: 10),
                      Text(
                        snapshot.data!.description,
                      ),
                    ],
                  ),
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

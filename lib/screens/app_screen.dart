import 'dart:io';
import 'package:app_installer/app_installer.dart';
import 'package:flutter/material.dart';
import 'package:appcheck/appcheck.dart';
import 'package:dio/dio.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:swn_play/api/models/apps.dart';
import 'package:swn_play/api/repository/apps_repository.dart';
import 'package:swn_play/screens/app/app_description_screen.dart';
import 'package:swn_play/studies/app/info_app.dart';

class AppScreen extends StatefulWidget {
  final int id;
  final String title;

  const AppScreen({super.key, required this.id, required this.title});

  @override
  State<AppScreen> createState() => _AppScreenState();
}

class _AppScreenState extends State<AppScreen> with WidgetsBindingObserver {
  late Future<App> _futureApp;
  late bool _installed = false;
  String _installedPackageVersion = "";
  bool _isLoading = false;
  double _progress = 0;

  Future<void> checkPackageName() async {
    App gettedApp = await _futureApp;
    final String package = gettedApp.packageName;
    AppCheck.checkAvailability(package).then(
      (app) => {
        setState(() {
          _installed = true;
          _installedPackageVersion = app!.versionName!;
        })
      },
    );
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    _futureApp = fetchAppById(widget.id);
    viewAppById(widget.id);
    checkPackageName();
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      checkPackageName();
    }
  }

  void onReceiveProgress(received, total) {
    if (total != -1) {
      if ((received / total * 100) == 100) {
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
    await [
      Permission.requestInstallPackages,
    ].request();
    App gettedApp = await _futureApp;
    String url = gettedApp.downloadLink;
    String fileName = '${gettedApp.title}-${gettedApp.latestVersion}.apk';
    Directory dir = Directory('/storage/emulated/0/Download/SWN Play');
    String savePath = '${dir.path}/$fileName';
    downloadAppById(gettedApp.id);

    await Dio().download(
      url,
      savePath,
      onReceiveProgress: onReceiveProgress,
    );

    debugPrint(savePath);
    await AppInstaller.installApk(savePath);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: FutureBuilder<App>(
          future: _futureApp,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return SingleChildScrollView(
                padding: const EdgeInsets.only(top: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(15.0),
                          child: Image(
                            width: 80,
                            image: NetworkImage(snapshot.data!.logo),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                snapshot.data!.title,
                                style: const TextStyle(fontSize: 18),
                              ),
                              Text(
                                snapshot.data!.developer,
                                style: const TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      child: Builder(
                        builder: (BuildContext context) {
                          if (_installed &&
                              _installedPackageVersion ==
                                  snapshot.data!.latestVersion) {
                            return ElevatedButton(
                              onPressed: playApp,
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size(double.infinity, 48),
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                              ),
                              child: const Text("Запустить"),
                            );
                          } else if (_installed &&
                              _installedPackageVersion !=
                                  snapshot.data!.latestVersion) {
                            return ElevatedButton(
                              onPressed: _isLoading ? null : downloadApp,
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size(double.infinity, 48),
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                              ),
                              child: _isLoading
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        CircularProgressIndicator(
                                            value: _progress,
                                            color: Colors.green),
                                        const SizedBox(width: 10),
                                        Text(
                                            '${(_progress * 100).toStringAsFixed(0)}%')
                                      ],
                                    )
                                  : const Text('Обновить'),
                            );
                          } else {
                            return ElevatedButton(
                              onPressed: _isLoading ? null : downloadApp,
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size(double.infinity, 48),
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                              ),
                              child: _isLoading
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        CircularProgressIndicator(
                                          value: _progress,
                                          color: Colors.green,
                                        ),
                                        const SizedBox(width: 10),
                                        Text(
                                            '${(_progress * 100).toStringAsFixed(0)}%')
                                      ],
                                    )
                                  : const Text('Загрузить'),
                            );
                          }
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    InfoAppWidget(app: snapshot.data!),
                    const SizedBox(
                      height: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AppDescriptionScreen(
                                  app: snapshot.data!,
                                  installedPackageVersion:
                                      _installedPackageVersion,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Описание",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500),
                                ),
                                Icon(Icons.chevron_right)
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          snapshot.data!.description,
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(5),
                      child: const Text(
                        "Скриншоты",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w500),
                      ),
                    ),
                    const SizedBox(height: 10),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: const PageScrollPhysics(),
                      controller: PageController(
                        viewportFraction:
                            120 / (MediaQuery.of(context).size.width - 20),
                      ),
                      child: Row(
                        children: [
                          for (var screenshot in snapshot.data!.screenshots)
                            Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image(
                                    image: Image.network(screenshot).image,
                                    width:
                                        MediaQuery.of(context).size.width - 20,
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
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

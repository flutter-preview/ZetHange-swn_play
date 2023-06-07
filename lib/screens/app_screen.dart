import 'package:appcheck/appcheck.dart';
import 'package:flutter/material.dart';
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
                  Text(_installed ? "установленно" : "не установленно"),
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

import 'package:flutter/material.dart';
import 'package:swn_play/api/models/apps.dart';

class InfoAppWidget extends StatelessWidget {
  final App app;

  const InfoAppWidget({super.key, required this.app});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 20,
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Column(
          children: [
            const Icon(Icons.adb),
            Text("Тип: ${app.type == "game" ? "игра" : "приложение"}"),
          ],
        ),
        const SizedBox(width: 10),
        Column(
          children: [
            const Icon(Icons.account_tree_rounded),
            Text("Версия: ${app.latestVersion}"),
          ],
        ),
        const SizedBox(width: 10),
        Column(
          children: [
            const Icon(Icons.download),
            Text("Скачиваний: ${app.downloadedQuantity}"),
          ],
        ),
      ]),
    );
  }
}

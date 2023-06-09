import 'package:flutter/material.dart';

class AppDescriptionScreen extends StatelessWidget {
  final String title;
  final String descriptionFull;
  final String latestVersion;
  final int viewedQuantity;
  final int downloadedQuantity;

  const AppDescriptionScreen({
    super.key,
    required this.title,
    required this.descriptionFull,
    required this.latestVersion,
    required this.viewedQuantity,
    required this.downloadedQuantity,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Описание"),
        ),
        body: Container(
            margin: const EdgeInsets.only(right: 10, left: 10),
            child: SingleChildScrollView(
                child: Column(
              children: [
                const SizedBox(height: 10),
                Text(descriptionFull),
                const Divider(color: Colors.grey),
                Container(
                  padding: const EdgeInsets.all(5),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [const Text("Версия:"), Text(latestVersion)],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Количество просмотров:"),
                          Text(viewedQuantity.toString())
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Количество скачиваний:"),
                          Text(downloadedQuantity.toString())
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ))));
  }
}

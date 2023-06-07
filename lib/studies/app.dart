import 'package:flutter/material.dart';
import 'package:swn_play/screens/app_screen.dart';

class AppListWidget extends StatelessWidget {
  final String title;
  final String logo;
  final int id;

  const AppListWidget(
      {super.key, required this.title, required this.logo, required this.id});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => AppScreen(id: id, title: title)));
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 5),
        child: Row(
          children: <Widget>[
            ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: Image(
                  width: 80,
                  image: NetworkImage(logo),
                )),
            Container(
                margin: const EdgeInsets.only(left: 10),
                child: Text(title, style: const TextStyle(fontSize: 18.0)))
          ],
        ),
      ),
    );
  }
}

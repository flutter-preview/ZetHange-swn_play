import 'package:flutter/material.dart';
import 'package:swn_play/screens/app_screen.dart';

class AppListWidget extends StatelessWidget {
  final String title;
  final String logo;
  final String developer;
  final int id;

  const AppListWidget(
      {super.key,
      required this.title,
      required this.logo,
      required this.id,
      required this.developer});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 5),
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AppScreen(id: id, title: title)));
        },
        child: Container(
          padding:
              const EdgeInsets.only(left: 10, right: 10, top: 2, bottom: 2),
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
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: const TextStyle(fontSize: 18.0)),
                      Text(developer,
                          style: const TextStyle(
                              fontSize: 15.0, color: Colors.grey)),
                    ]),
              )
            ],
          ),
        ),
      ),
    );
  }
}

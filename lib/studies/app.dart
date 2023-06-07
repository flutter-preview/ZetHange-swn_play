import 'package:flutter/material.dart';

class AppWidget extends StatelessWidget {
  final String title, logo;

  const AppWidget({super.key, required this.title, required this.logo});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 5),
      child: Row(
        children: <Widget>[
          ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Image(
                width: 80,
                image: NetworkImage(logo),
              )),
          Container(
              margin: const EdgeInsets.only(left: 10),
              child: Text(title, style: const TextStyle(fontSize: 18.0)))
        ],
      ),
    );
  }
}

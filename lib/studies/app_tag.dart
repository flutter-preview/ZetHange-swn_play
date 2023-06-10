import 'dart:ui';

import 'package:flutter/material.dart';

class AppTag extends StatelessWidget {
  final String title;
  final String background;
  final String link;

  const AppTag({
    super.key,
    required this.title,
    required this.background,
    required this.link,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Stack(
      children: [
        // Background image
        Image.network(link),

        // Blurred container
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.5),
            borderRadius: BorderRadius.circular(10),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(),
          ),
        ),

        // Other widgets on top of the blurred container
        Text('Hello, world!'),
        // ...
      ],
    ));
  }
}

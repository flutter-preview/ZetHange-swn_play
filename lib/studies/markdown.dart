import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';

class MyMarkdownWidget extends StatelessWidget {
  final String markdown;
  final controller = ScrollController();

  MyMarkdownWidget(this.markdown, {super.key});

  _launchURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return MarkdownBody(
        selectable: true,
        data: markdown,
        onTapLink: (String text, String? href, String title) => {
              debugPrint('text: ${text}, href ${href}, title: ${title}'),
              _launchURL(href!)
            });
  }
}

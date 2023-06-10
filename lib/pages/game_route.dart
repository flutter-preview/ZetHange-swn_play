import 'package:flutter/material.dart';
import 'package:swn_play/api/models/pagination.dart';
import 'package:swn_play/api/repository/apps_repository.dart';
import 'package:swn_play/studies/app.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  late Future<Pagination> _futureApps;

  @override
  void initState() {
    super.initState();
    _futureApps = fetchApps("game");
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FutureBuilder<Pagination>(
        future: _futureApps,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.content.length,
              itemBuilder: (context, index) {
                final post = snapshot.data!.content[index];
                return AppListWidget(
                  id: post.id,
                  title: post.title,
                  logo: post.logo,
                  developer: post.developer,
                );
              },
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}

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
    _futureApps = fetchApps(type: "game");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(0),
          child: Container(
            margin: const EdgeInsets.only(left: 10, right: 10),
            child: TextField(
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(vertical: 15),
                prefixIcon: const Icon(Icons.search),
                hintText: 'Поиск...',
                filled: true,
                fillColor: Colors.green.shade300,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                  borderSide: BorderSide(color: Colors.green.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                  borderSide: BorderSide(color: Colors.green.shade300),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _futureApps = fetchApps(type: "game", q: value);
                });
              },
            ),
          ),
        ),
      ),
      body: FutureBuilder<Pagination>(
        future: _futureApps,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              padding: const EdgeInsets.only(top: 5),
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

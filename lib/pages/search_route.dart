import 'package:flutter/material.dart';
import 'package:swn_play/api/models/pagination.dart';

import '../api/repository/apps_repository.dart';
import '../studies/app.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late Future<Pagination> _futureApps;

  @override
  void initState() {
    super.initState();
    _futureApps = fetchApps(pageSize: 15);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          decoration: const InputDecoration(
            hintText: 'Поиск...',
          ),
          onChanged: (value) {
            setState(() {
              _futureApps = fetchApps(pageSize: 15, q: value);
            });
          },
        ),
      ),
      body: Center(
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
      ),
    );
  }
}

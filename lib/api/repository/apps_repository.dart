import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:swn_play/api/api.dart';
import 'package:swn_play/api/models/apps.dart';

Future<List<App>> fetchApps() async {
  final response = await http
      .get(Uri.parse('${Api.apiUrl}/apps'));

  if (response.statusCode == 200) {
    final List<dynamic> jsonData = json.decode(response.body);
    final List<App> appList = jsonData.map((json) => App.fromJson(json)).toList();
    debugPrint(appList.toString());
    return appList;
  } else {
    throw Exception('Failed to load apps: ${response.statusCode}');
  }
}

Future<App> fetchAppById(int id) async {
  final response = await http
      .get(Uri.parse('${Api.apiUrl}/apps/$id'));

  if (response.statusCode == 200) {
    final app = App.fromJson(json.decode(response.body));
    debugPrint(app.toString());
    return app;
  } else {
    throw Exception('Failed to load app with id $id: ${response.statusCode}');
  }
}
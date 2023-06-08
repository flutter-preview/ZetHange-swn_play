import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:swn_play/api/api.dart';
import 'package:swn_play/api/models/apps.dart';
import 'package:swn_play/api/models/pagination.dart';

Future<Pagination> fetchApps({int page = 1, int pageSize = 150}) async {
  final response = await http
      .get(Uri.parse('${Api.apiUrl}/apps?page=${page}&pageSize=${pageSize}'));

  if (response.statusCode == 200) {
    final jsonMap = jsonDecode(utf8.decode(response.bodyBytes));
    final Pagination pagination = Pagination.fromJson(jsonMap);
    return pagination;
  } else {
    throw Exception('Failed to load apps: ${response.statusCode}');
  }
}

Future<App> fetchAppById(int id) async {
  Map<String, String> headers = {
    'Content-Type': 'application/json; charset=utf-8',
  };

  final response =
      await http.get(Uri.parse('${Api.apiUrl}/apps/$id'), headers: headers);

  if (response.statusCode == 200) {
    final app = App.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
    debugPrint(app.toString());
    return app;
  } else {
    throw Exception('Failed to load app with id $id: ${response.statusCode}');
  }
}

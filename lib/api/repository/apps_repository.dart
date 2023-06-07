import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:swn_play/api/api.dart';
import 'package:swn_play/api/models/apps.dart';

Future<List<App>> fetchApps() async {
  const API_URL = Api.API_URL;
  debugPrint("$API_URL/apps");

  final response = await http
      .get(Uri.parse('$API_URL/apps'));
  debugPrint("success");

  if (response.statusCode == 200) {
    final List<dynamic> jsonData = json.decode(response.body);
    final List<App> appList = jsonData.map((json) => App.fromJson(json)).toList();
    debugPrint(appList.toString());
    return appList;
  } else {
    throw Exception('Failed to load apps: $response.statusCode');
  }
}
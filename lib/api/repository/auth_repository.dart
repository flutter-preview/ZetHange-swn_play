import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:swn_play/api/api.dart';

Future<String> login(String email, String password) async {
  final response = await http.post(Uri.parse('${Api.apiUrl}/auth/login'),
      body: jsonEncode({"email": email, "password": password}),
      headers: {'Content-Type': 'application/json'});

  if (response.statusCode == 200) {
    final jsonMap = jsonDecode(utf8.decode(response.bodyBytes));
    final token = jsonMap["token"];
    return token;
  } else {
    return "Неправильная почта или пароль";
  }
}

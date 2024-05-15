import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class InventoryRepository {
  final SharedPreferences sharedPreferences;
  InventoryRepository({required this.sharedPreferences});

  Future<String?> getToken() async {
    return sharedPreferences.getString('token');
  }

  Future<http.Response> authorizedGet(String url) async {
    String? token = await getToken();
    if (token != null) {
      return http.get(Uri.parse(url), headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      });
    } else {
      throw Exception('No token available');
    }
  }

  Future<http.Response> authorizedPost(String url, dynamic json) async {
    String? token = await getToken();
    if (token != null) {
      return http.post(Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token'
          },
          body: jsonEncode(json));
    } else {
      throw Exception('No token available');
    }
  }
}

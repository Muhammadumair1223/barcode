import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/login_response.dart';
import '../utils/app_constants.dart';

class AuthRepository {
  final SharedPreferences sharedPreferences;
  AuthRepository({required this.sharedPreferences});

  Future<void> login(String userName, String password) async {
    final response = await http.post(
      Uri.parse('${AppConstants.urlBase}${AppConstants.login}'),
      body: json.encode({'email': userName, 'password': password}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      dynamic data = json.decode(response.body);

      LoginResponse? loginResponse = LoginResponse.fromJson(data);

      String accessToken = loginResponse.token;

      await sharedPreferences.setString('token', accessToken);
      await sharedPreferences.setString('phone', userName);
    } else {
      throw Exception('Login failed');
    }
  }

  Future<void> logout(context) async {
    await sharedPreferences.remove('token');
    Navigator.pushReplacementNamed(context, '/login');
  }

  bool isLogged() {
    var bResult = sharedPreferences.containsKey('token');
    return bResult;
  }
}

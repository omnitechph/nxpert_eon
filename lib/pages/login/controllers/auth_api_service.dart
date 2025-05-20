import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'auth_api_service.g.dart';

class AuthApiService {
  static const String baseUrl = "http://192.168.1.120:1880/login";

  Future<Map<String, dynamic>> login(String userId, String password) async {
    final http.Client client = http.Client();
    try{
      final http.Response response = await http.post(
        Uri.parse(baseUrl),
        headers: <String, String>{"Content-Type": "application/json"},
        body: jsonEncode(<String, String>{"userId": userId, "password": password}),
      );
      if (response.statusCode == 200) {
        return response.body!='[]'? jsonDecode(response.body)[0] : <String, dynamic>{};
      } else {
        throw Exception("Failed to login: ${response.body}");
      }
    }finally{
      client.close();
    }
  }
}

@riverpod
AuthApiService authApiService(Ref ref) => AuthApiService();
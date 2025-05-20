import 'dart:convert';

import 'package:http/http.dart' as http;

class LogsApiService{
  Future<List<dynamic>> getLogs(String machine, String dateFrom, String dateTo) async {
    final String baseUrl = 'http://192.168.1.120:1880/logs?machine=$machine&dateFrom=$dateFrom&dateTo=$dateTo';
    final http.Response response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('ADC Machining Logs API failed: ${response.body}');
    }
  }
}
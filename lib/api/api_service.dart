import 'dart:convert';
import 'package:eco_picker/data/ranking.dart';
import 'package:http/http.dart' as http;

class ApiService {
  final String _baseUrl = 'http://localhost:15000'; // 백엔드 기본 URL

  Future<Map<String, dynamic>> fetchUserInfo() async {
    final response = await http.get(Uri.parse('$_baseUrl/user/info'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load user info');
    }
  }

  Future<Ranking> fetchWeeklyRanking() async {
    final response = await http.post(Uri.parse('$_baseUrl/ranking/weekly'));
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load weekly rankers');
    }
  }

  Future<Ranking> fetchDailyRanking() async {
    final response = await http.post(Uri.parse('$_baseUrl/ranking/daily'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load daily rankers');
    }
  }

  Future<Ranking> fetchMonthlyRanking() async {
    final response = await http.post(Uri.parse('$_baseUrl/ranking/monthly'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load monthly rankers');
    }
  }
}

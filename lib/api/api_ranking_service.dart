import 'dart:convert';
import 'package:eco_picker/data/ranking.dart';
import 'package:http/http.dart' as http;
import 'token_manager.dart';
import '../utils/constants.dart';

class ApiRankingService {
  final TokenManager _tokenManager = TokenManager();

  Future<Ranking> fetchWeeklyRanking() async {
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${await _tokenManager.getAccessToken()}',
    };
    final body = json.encode({"offset": 0, "limit": 10});
    final response = await http.post(Uri.parse('$baseUrl/ranking/weekly'),
        headers: headers, body: body);

    if (response.statusCode == 200) {
      // Parse the JSON response into a Ranking object
      final jsonResponse = json.decode(response.body) as Map<String, dynamic>;
      return Ranking.fromJson(jsonResponse);
    } else {
      throw Exception('Failed to load weekly rankers');
    }
  }

  Future<Ranking> fetchDailyRanking() async {
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${await _tokenManager.getAccessToken()}',
    };
    final body = json.encode({"offset": 0, "limit": 10});
    final response = await http.post(Uri.parse('$baseUrl/ranking/daily'),
        headers: headers, body: body);

    if (response.statusCode == 200) {
      // Parse the JSON response into a Ranking object
      final jsonResponse = json.decode(response.body) as Map<String, dynamic>;
      return Ranking.fromJson(jsonResponse);
    } else {
      throw Exception('Failed to load daily rankers');
    }
  }

  Future<Ranking> fetchMonthlyRanking() async {
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${await _tokenManager.getAccessToken()}',
    };
    final body = json.encode({"offset": 0, "limit": 10});
    final response = await http.post(Uri.parse('$baseUrl/ranking/monthly'),
        headers: headers, body: body);

    if (response.statusCode == 200) {
      // Parse the JSON response into a Ranking object
      final jsonResponse = json.decode(response.body) as Map<String, dynamic>;
      return Ranking.fromJson(jsonResponse);
    } else {
      throw Exception('Failed to load monthly rankers');
    }
  }
}

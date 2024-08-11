import 'dart:convert';
import 'package:eco_picker/data/ranking.dart';
import '../data/user.dart';
import '../utils/constants.dart';
import 'api_service.dart';

class ApiRankingService {
  Future<Ranking> fetchRanking() async {
    const url = '$baseUrl/ranking';
    final headers = {
      'Content-Type': 'application/json',
    };
    final body = {"offset": 0, "limit": 10};
    final response = await ApiService().post(url, headers, body);
    if (response.statusCode == 200) {
      // Parse the JSON response into a Ranking object
      final jsonResponse = json.decode(response.body);
      return Ranking.fromJson(jsonResponse['ranking']);
    } else if (response.statusCode == 403) {
      throw Exception('LOG_OUT');
    } else {
      throw Exception('Failed to load rankers');
    }
  }

  Future<UserStatistics> fetchRanker(int id) async {
    String url = '$baseUrl/ranker/$id';
    final headers = {
      'Content-Type': 'application/json',
    };
    final response = await ApiService().get(url, headers);
    if (response.statusCode == 200) {
      // Parse the JSON response into a Ranking object
      final data = json.decode(response.body) as Map<String, dynamic>;
      return UserStatistics.fromJson(data['rankerDetail']);
    } else if (response.statusCode == 403) {
      throw Exception('LOG_OUT');
    } else {
      throw Exception('Failed to load ranker detail');
    }
  }
}

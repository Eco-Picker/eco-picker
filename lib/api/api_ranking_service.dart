import 'dart:convert';
import 'package:eco_picker/data/ranking.dart';
import 'package:http/http.dart' as http;
import '../data/user.dart';
import 'token_manager.dart';
import '../utils/constants.dart';

class ApiRankingService {
  final TokenManager _tokenManager = TokenManager();

  Future<Ranking> fetchRanking() async {
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${await _tokenManager.getAccessToken()}',
    };
    final body = json.encode({"offset": 0, "limit": 10});
    final response = await http.post(Uri.parse('$baseUrl/ranking'),
        headers: headers, body: body);

    if (response.statusCode == 200) {
      // Parse the JSON response into a Ranking object
      final jsonResponse = json.decode(response.body);
      return Ranking.fromJson(jsonResponse['ranking']);
    } else {
      throw Exception('Failed to load rankers');
    }
  }

  Future<UserStatistics> fetchRanker(int id) async {
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${await _tokenManager.getAccessToken()}',
    };
    final response =
        await http.get(Uri.parse('$baseUrl/ranker/$id'), headers: headers);

    if (response.statusCode == 200) {
      // Parse the JSON response into a Ranking object
      final data = json.decode(response.body) as Map<String, dynamic>;
      print('ranker data: $data');
      return UserStatistics.fromJson(data['rankerDetail']);
    } else {
      throw Exception('Failed to load ranker detail');
    }
  }
}

import 'dart:convert';
import 'package:eco_picker/data/newsletter.dart';
import 'package:http/http.dart' as http;
import 'token_manager.dart';

class ApiNewsletterService {
  final String _baseUrl = 'http://localhost:15000';
  final TokenManager _tokenManager = TokenManager();

  Future<NewsList> fetchNewsList({int offset = 0, int limit = 10}) async {
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${await _tokenManager.getAccessToken()}',
    };
    final body = json.encode({"offset": offset, "limit": limit});
    final response = await http.post(Uri.parse('$_baseUrl/news_list'),
        headers: headers, body: body);

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body) as Map<String, dynamic>;
      return NewsList.fromJson(jsonResponse);
    } else {
      throw Exception('Failed to load news list');
    }
  }

  Future<NewsList> fetchEventList({int offset = 0, int limit = 10}) async {
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${await _tokenManager.getAccessToken()}',
    };
    final body = json.encode({"offset": offset, "limit": limit});
    final response = await http.post(Uri.parse('$_baseUrl/events'),
        headers: headers, body: body);

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body) as Map<String, dynamic>;
      return NewsList.fromJson(jsonResponse);
    } else {
      throw Exception('Failed to load news list');
    }
  }

  Future<NewsList> fetchEduList({int offset = 0, int limit = 10}) async {
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${await _tokenManager.getAccessToken()}',
    };
    final body = json.encode({"offset": offset, "limit": limit});
    final response = await http.post(
        Uri.parse('$_baseUrl/educational_contents'),
        headers: headers,
        body: body);

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body) as Map<String, dynamic>;
      return NewsList.fromJson(jsonResponse);
    } else {
      throw Exception('Failed to load news list');
    }
  }

  Future<NewsSummary> fetchRandomNews() async {
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${await _tokenManager.getAccessToken()}',
    };
    final response = await http.get(
        Uri.parse('$_baseUrl/random_newsletter_summary'),
        headers: headers);

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body) as Map<String, dynamic>;
      return NewsSummary.fromJson(jsonResponse['newsletterSummary']);
    } else {
      throw Exception('Failed to generate random newsletter');
    }
  }
}

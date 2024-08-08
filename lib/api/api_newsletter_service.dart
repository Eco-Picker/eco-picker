import 'dart:convert';
import 'package:eco_picker/data/newsletter.dart';
import 'package:http/http.dart' as http;
import 'token_manager.dart';
import '../utils/constants.dart';

class ApiNewsletterService {
  final TokenManager _tokenManager = TokenManager();

  Future<NewsList> fetchNewsList(
      {required int offset, required int limit, String? category}) async {
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${await _tokenManager.getAccessToken()}',
    };
    final String body;
    if (category == null) {
      body = json.encode({"offset": offset, "limit": limit});
    } else {
      body =
          json.encode({"offset": offset, "limit": limit, "category": category});
    }
    final response = await http.post(Uri.parse('$baseUrl/newsletter_summaries'),
        headers: headers, body: body);

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body) as Map<String, dynamic>;
      return NewsList.fromJson(jsonResponse);
    } else {
      throw Exception('Failed to load news list');
    }
  }

  Future<Newsletter> fetchNewsletter(int id) async {
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${await _tokenManager.getAccessToken()}',
    };
    final response =
        await http.get(Uri.parse('$baseUrl/newsletter/$id'), headers: headers);

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return Newsletter.fromJson(jsonResponse['newsletter']);
    } else {
      throw Exception('Failed to load newsletter');
    }
  }

  Future<NewsSummary> fetchRandomNews() async {
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${await _tokenManager.getAccessToken()}',
    };
    final response = await http
        .get(Uri.parse('$baseUrl/random_newsletter_summary'), headers: headers);

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body) as Map<String, dynamic>;
      return NewsSummary.fromJson(jsonResponse['newsletterSummary']);
    } else {
      throw Exception('Failed to generate random newsletter');
    }
  }
}

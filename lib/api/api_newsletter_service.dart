import 'dart:convert';
import 'package:eco_picker/data/newsletter.dart';
import 'api_service.dart';
import '../utils/constants.dart';

class ApiNewsletterService {
  Future<NewsList> fetchNewsList(
      {required int offset, required int limit, String? category}) async {
    final url = '$baseUrl/newsletter_summaries';
    final headers = {
      'Content-Type': 'application/json',
    };
    final Map<String, Object> body;
    if (category == null) {
      body = {"offset": offset, "limit": limit};
    } else {
      body = {"offset": offset, "limit": limit, "category": category};
    }
    final response = await ApiService().post(url, headers, body);
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body) as Map<String, dynamic>;
      return NewsList.fromJson(jsonResponse);
    } else if (response.statusCode == 403) {
      throw Exception('LOG_OUT');
    } else {
      throw Exception('Failed to load news list');
    }
  }

  Future<Newsletter> fetchNewsletter(int id) async {
    final url = '$baseUrl/newsletter/$id';
    final headers = {
      'Content-Type': 'application/json',
    };
    final response = await ApiService().get(url, headers);
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return Newsletter.fromJson(jsonResponse['newsletter']);
    } else if (response.statusCode == 403) {
      throw Exception('LOG_OUT');
    } else {
      throw Exception('Failed to load newsletter');
    }
  }

  Future<NewsSummary> fetchRandomNews() async {
    final url = '$baseUrl/random_newsletter_summary';
    final headers = {
      'Content-Type': 'application/json',
    };
    final response = await ApiService().get(url, headers);
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body) as Map<String, dynamic>;
      return NewsSummary.fromJson(jsonResponse['newsletterSummary']);
    } else if (response.statusCode == 403) {
      throw Exception('LOG_OUT');
    } else {
      throw Exception('Failed to generate random newsletter');
    }
  }
}

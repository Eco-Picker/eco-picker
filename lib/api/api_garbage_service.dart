import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import '../data/garbage.dart';
import 'token_manager.dart';
import '../utils/constants.dart';

class ApiGarbageService {
  final TokenManager _tokenManager = TokenManager();

  Future<Garbage> analyzeGarbage(String category, File image) async {
    final uri = Uri.parse('$baseUrl/garbage/analyze');
    final request = http.MultipartRequest('POST', uri)
      ..fields['category'] = category
      ..files.add(
        await http.MultipartFile.fromPath(
          'image',
          image.path,
          contentType: MediaType('image', 'jpeg'),
        ),
      )
      ..headers['Authorization'] =
          'Bearer ${await _tokenManager.getAccessToken()}';

    final response = await request.send();
    final responseBody = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      // Parse the JSON response into a Ranking object
      final jsonResponse = json.decode(responseBody);
      return Garbage.fromJson(jsonResponse['garbage']);
    } else {
      throw Exception('Failed to analyze');
    }
  }
}

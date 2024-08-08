import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import '../data/garbage.dart';
import 'token_manager.dart';
import '../utils/constants.dart';

class ApiGarbageService {
  final TokenManager _tokenManager = TokenManager();

  Future<Map<String, dynamic>> analyzeGarbage(File image) async {
    final uri = Uri.parse('$baseUrl/analyze');

    final headers = {
      'Authorization': 'Bearer ${await _tokenManager.getAccessToken()}',
      'Content-Type': 'multipart/form-data'
    };

    final request = http.MultipartRequest('POST', uri)
      ..headers.addAll(headers)
      ..files.add(await http.MultipartFile.fromPath(
        'file',
        image.path,
        contentType: MediaType('image', 'jpeg'),
      ));

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    print(response.statusCode);

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body) as Map<String, dynamic>;
      return jsonResponse;
    } else {
      throw Exception('Failed to analyze');
    }
  }

  Future<bool> saveGarbage(Garbage garbage) async {
    final uri = Uri.parse('$baseUrl/save');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${await _tokenManager.getAccessToken()}',
    };
    final body = json.encode({"garbage": garbage.toJson()});
    final response = await http.post(uri, headers: headers, body: body);
    if (response.statusCode == 200) {
      return true;
    } else {
      print(response.statusCode);
      throw Exception('Failed to save');
    }
  }

  Future<GarbageLocation> getGarbageList() async {
    final uri = Uri.parse('$baseUrl/maps');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${await _tokenManager.getAccessToken()}',
    };

    final response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body) as Map<String, dynamic>;
      return GarbageLocation.fromJson(jsonResponse);
    } else {
      throw Exception('Failed to load garbage list');
    }
  }

  Future<Garbage> getGarbageByID(int id) async {
    final uri = Uri.parse('$baseUrl/garbage/$id');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${await _tokenManager.getAccessToken()}',
    };

    final response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body) as Map<String, dynamic>;
      return Garbage.fromJson(jsonResponse['garbage']);
    } else {
      throw Exception('Failed to load garbage list');
    }
  }
}

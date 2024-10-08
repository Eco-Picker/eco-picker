import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import '../data/garbage.dart';
import '../utils/constants.dart';
import 'api_service.dart';

class ApiGarbageService {
  Future<Map<String, dynamic>> analyzeGarbage(File image) async {
    final url = '$baseUrl/garbage/analyze';

    final headers = {
      'Content-Type': 'multipart/form-data',
    };

    final file = await http.MultipartFile.fromPath(
      'file',
      image.path,
      contentType: MediaType('image', 'jpeg'),
    );

    final response = await ApiService().postMultipart(url, headers, [file]);
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body) as Map<String, dynamic>;
      return jsonResponse;
    } else if (response.statusCode == 403) {
      throw Exception('LOG_OUT');
    } else {
      throw Exception('Failed to analyze');
    }
  }

  Future<bool> saveGarbage(Garbage garbage) async {
    final url = '$baseUrl/garbage/save';
    final headers = {
      'Content-Type': 'application/json',
    };
    final body = {"garbage": garbage.toJson()};
    final response = await ApiService().post(url, headers, body);
    if (response.statusCode == 200) {
      return true;
    } else if (response.statusCode == 403) {
      throw Exception('LOG_OUT');
    } else {
      throw Exception('Failed to save');
    }
  }

  Future<GarbageLocation> getGarbageList() async {
    final url = '$baseUrl/maps';
    final headers = {
      'Content-Type': 'application/json',
    };
    final response = await ApiService().get(url, headers);

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body) as Map<String, dynamic>;
      return GarbageLocation.fromJson(jsonResponse);
    } else if (response.statusCode == 403) {
      throw Exception('LOG_OUT');
    } else {
      throw Exception('Failed to load garbage list');
    }
  }

  Future<Garbage> getGarbageByID(int id) async {
    final url = '$baseUrl/garbage/$id';
    final headers = {
      'Content-Type': 'application/json',
    };

    final response = await ApiService().get(url, headers);

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body) as Map<String, dynamic>;
      return Garbage.fromJson(jsonResponse['garbage']);
    } else if (response.statusCode == 403) {
      throw Exception('LOG_OUT');
    } else {
      throw Exception('Failed to load garbage list');
    }
  }
}

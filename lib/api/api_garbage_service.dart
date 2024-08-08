import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import '../data/garbage.dart';
import '../utils/constants.dart';
import 'api_service.dart';

class ApiGarbageService {
  Future<Map<String, dynamic>> analyzeGarbage(File image) async {
    const url = '$baseUrl/analyze';

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
    } else {
      throw Exception('Failed to analyze');
    }
  }

  Future<bool> saveGarbage(Garbage garbage) async {
    const url = '$baseUrl/save';
    final headers = {
      'Content-Type': 'application/json',
    };
    final body = {"garbage": garbage.toJson()};
    final response = await ApiService().post(url, headers, body);
    if (response.statusCode == 200) {
      return true;
    } else {
      print(response.statusCode);
      throw Exception('Failed to save');
    }
  }

  Future<GarbageLocation> getGarbageList() async {
    const url = '$baseUrl/maps';
    final headers = {
      'Content-Type': 'application/json',
    };
    final response = await ApiService().get(url, headers);

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body) as Map<String, dynamic>;
      return GarbageLocation.fromJson(jsonResponse);
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
    } else {
      throw Exception('Failed to load garbage list');
    }
  }
}

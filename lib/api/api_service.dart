import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/constants.dart';
import 'token_manager.dart';

class ApiService {
  final TokenManager _tokenManager = TokenManager();

  Future<http.Response> post(String url, Map<String, String> headers,
      [Map<String, dynamic>? body]) async {
    final accessToken = await _tokenManager.getAccessToken();
    headers['Authorization'] = 'Bearer $accessToken';

    final response = await http.post(Uri.parse(url),
        headers: headers, body: jsonEncode(body));

    return response;
  }

  Future<http.Response> get(
    String url,
    Map<String, String> headers,
  ) async {
    final accessToken = await _tokenManager.getAccessToken();

    headers['Authorization'] = 'Bearer $accessToken';

    final response = await http.get(Uri.parse(url), headers: headers);

    return response;
  }

  Future<http.Response> postMultipart(
    String url,
    Map<String, String> headers,
    List<http.MultipartFile> files,
  ) async {
    final accessToken = await _tokenManager.getAccessToken();
    headers['Authorization'] = 'Bearer $accessToken';

    final request = http.MultipartRequest('POST', Uri.parse(url))
      ..headers.addAll(headers)
      ..files.addAll(files);

    final streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    return response;
  }

  Future<bool> refreshToken() async {
    const url = '$baseUrl/auth/renew_access_token';
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${await _tokenManager.getAccessToken()}',
    };
    final refreshToken = await _tokenManager.getRefreshToken();

    if (refreshToken == null) {
      return false;
    }

    final body = json.encode({
      'refreshToken': refreshToken,
    });

    try {
      final response =
          await http.post(Uri.parse(url), headers: headers, body: body);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['accessToken'] != null) {
          // Save the new access token and retain the old refresh token
          await _tokenManager.saveTokens(
            data['accessToken'],
            refreshToken, // Retaining the old refresh token
          );
          return true;
        } else {
          print('No access token returned from server');
          return false;
        }
      } else {
        await _tokenManager.clearTokens();
        print('Failed to refresh token, logging out');
        return false;
      }
    } catch (e) {
      print('Network error: $e');
      return false;
    }
  }
}

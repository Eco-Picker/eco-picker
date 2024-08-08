import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import '../screens/sign_in_screen.dart';
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

    if (response.statusCode == 401) {
      // Token expired, try to refresh it
      final refreshResponse = await refreshToken();
      if (refreshResponse) {
        // Retry the original request with new token
        final newAccessToken = await _tokenManager.getAccessToken();
        headers['Authorization'] = 'Bearer $newAccessToken';
        return http.post(Uri.parse(url),
            headers: headers, body: jsonEncode(body));
      }
    }

    return response;
  }

  Future<http.Response> get(
    String url,
    Map<String, String> headers,
  ) async {
    final accessToken = await _tokenManager.getAccessToken();
    headers['Authorization'] = 'Bearer $accessToken';

    final response = await http.get(Uri.parse(url), headers: headers);

    if (response.statusCode == 401) {
      // Token expired, try to refresh it
      final refreshResponse = await refreshToken();
      if (refreshResponse) {
        // Retry the original request with new token
        final newAccessToken = await _tokenManager.getAccessToken();
        headers['Authorization'] = 'Bearer $newAccessToken';
        return http.get(Uri.parse(url), headers: headers);
      }
    }

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

    if (response.statusCode == 401) {
      final refreshResponse = await refreshToken();
      if (refreshResponse) {
        final newAccessToken = await _tokenManager.getAccessToken();
        headers['Authorization'] = 'Bearer $newAccessToken';

        final retryRequest = http.MultipartRequest('POST', Uri.parse(url))
          ..headers.addAll(headers)
          ..files.addAll(files);

        final retryStreamedResponse = await retryRequest.send();
        response = await http.Response.fromStream(retryStreamedResponse);
      }
    }

    return response;
  }

  Future<bool> refreshToken() async {
    const url = '$baseUrl/p/auth/renew_access_token';
    final headers = {'Content-Type': 'application/json'};
    final refreshToken = await _tokenManager.getRefreshToken();

    if (refreshToken == null) {
      print('No refresh token available');
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
        await _tokenManager.saveTokens(
            data['accessToken'], data['refreshToken']);
        print('Token refreshed: $data');
        return true;
      } else {
        // Log out when refresh token is terminated
        await _tokenManager.clearTokens();
        print('Failed to refresh token, logging out');
        Provider.of<MyAppState>(context as BuildContext, listen: false)
            .signOut();
        Navigator.of(context as BuildContext).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => SignInScreen()),
          (route) => false,
        );
        return false;
      }
    } catch (e) {
      print('Network error: $e');
      return false;
    }
  }
}

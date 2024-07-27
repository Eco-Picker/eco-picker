// user, authentication
import 'dart:convert';
import 'package:eco_picker/data/user.dart';
import 'package:http/http.dart' as http;
import 'token_manager.dart';

class ApiUserService {
  final String _baseUrl = 'http://localhost:15000'; // 백엔드 기본 URL
  final TokenManager _tokenManager = TokenManager();

  Future<User> fetchUserInfo() async {
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${await _tokenManager.getAccessToken()}',
    };
    final response =
        await http.get(Uri.parse('$_baseUrl/user/info'), headers: headers);

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body) as Map<String, dynamic>;
      return User.fromJson(jsonResponse);
    } else {
      throw Exception('Failed to load user info');
    }
  }

  Future<void> signUp(String username, String password, String email) async {
    final url = Uri.parse('$_baseUrl/p/auth/signup');
    final headers = {'Content-Type': 'application/json'};
    final body = json.encode({
      'username': username,
      'password': password,
      'email': email,
    });

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        // Handle successful response
        final data = json.decode(response.body);
        print('Sign-up successful: $data');
      } else {
        // Handle errors
        final error = json.decode(response.body);
        print('Failed to sign up: $error');
      }
    } catch (e) {
      // Handle network errors
      print('Network error: $e');
    }
  }

  Future<String> login(String username, String password) async {
    final url = Uri.parse('$_baseUrl/p/auth/login');
    print(url);
    final headers = {'Content-Type': 'application/json'};
    final body = json.encode({
      'username': username,
      'password': password,
    });

    print("login request: $body");

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        // Handle successful response
        final data = json.decode(response.body);
        final accessToken = data['accessToken'];
        final refreshToken = data['refreshToken'];

        if (accessToken == null || refreshToken == null) {
          print(data);
          return "failed";
        }

        await _tokenManager.saveTokens(
            data['accessToken'], data['refreshToken']);
        print('Login successful: $data');
        return "success";
      } else {
        // Handle errors
        final error = json.decode(response.body);
        print('Failed to login: $error');
        return "failed";
      }
    } catch (e) {
      // Handle network errors
      print('Network error: $e');
      return "failed";
    }
  }

  Future<void> refreshToken() async {
    final url = Uri.parse('$_baseUrl/p/auth/renew_access_token');
    final headers = {'Content-Type': 'application/json'};
    final refreshToken = await _tokenManager.getRefreshToken();

    if (refreshToken == null) {
      print('No refresh token available');
      return;
    }

    final body = json.encode({
      'refreshToken': refreshToken,
    });

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        await _tokenManager.saveTokens(
            data['accessToken'], data['refreshToken']);
        print('Token refreshed: $data');
      } else {
        // Refresh token이 만료된 경우 로그아웃 처리
        await _tokenManager.clearTokens();
        print('Failed to refresh token, logging out');
      }
    } catch (e) {
      print('Network error: $e');
    }
  }

  Future<void> logout() async {
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${await _tokenManager.getAccessToken()}',
    };
    final response =
        await http.post(Uri.parse('$_baseUrl/auth/logout'), headers: headers);

    if (response.statusCode == 200) {
      await _tokenManager.clearTokens();
      print('Logged out');
      return json.decode(response.body);
    } else {
      final code = response.statusCode;
      print('statusCode: $code');
      throw Exception('Failed to logout');
    }
  }
}

import 'dart:convert';
import 'package:eco_picker/data/user.dart';
import 'package:http/http.dart' as http;
import 'api_service.dart';
import 'token_manager.dart';
import '../utils/constants.dart';

class ApiUserService {
  final TokenManager _tokenManager = TokenManager();

  Future<User> fetchUserInfo() async {
    const url = '$baseUrl/user/info';
    final headers = {'Content-Type': 'application/json'};

    final response = await ApiService().get(url, headers);
    if (response.statusCode == 200) {
      final data = json.decode(response.body) as Map<String, dynamic>;
      return User.fromJson(data['userInfo']);
    } else if (response.statusCode == 403) {
      throw Exception('LOG_OUT');
    } else {
      throw Exception('Failed to load user info');
    }
  }

  Future<UserStatistics> fetchUserStatistics() async {
    const url = '$baseUrl/user/statistics';
    final headers = {'Content-Type': 'application/json'};
    final response = await ApiService().get(url, headers);
    if (response.statusCode == 200) {
      final data = json.decode(response.body) as Map<String, dynamic>;

      return UserStatistics.fromJson(data['userStatistics']);
    } else if (response.statusCode == 403) {
      throw Exception('LOG_OUT');
    } else {
      throw Exception('Failed to load user statistics');
    }
  }

  Future<String> changePassword(
      String password, String newPassword, String confirmPassword) async {
    const url = '$baseUrl/user/update_password';
    final headers = {'Content-Type': 'application/json'};
    final body = {
      "password": password,
      "newPassword": newPassword,
      "confirmNewPassword": confirmPassword
    };
    final response = await ApiService().post(url, headers, body);
    final data = json.decode(response.body);
    if (response.statusCode == 200) {
      return data['code'] == 'INVALID_PASSWORD'
          ? 'Please type a vaild password.'
          : 'pass';
    } else if (response.statusCode == 403) {
      throw Exception('LOG_OUT');
    } else {
      throw Exception('Failed to load user info');
    }
  }

  Future<String> signUp(String username, String password, String email) async {
    final url = Uri.parse('$baseUrl/p/auth/signup');
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
        if (data['result'] == true) {
          return 'true';
        } else {
          if (data['code'] == 'ALREADY_REGISTERED_USERNAME') {
            return 'Username already registered. Please try with another username.';
          } else if (data['code'] == 'ALREADY_REGISTERED_EMAIL') {
            return 'Email already registered. Please try with another email.';
          } else {
            return 'Please use vaild password.';
          }
        }
      } else {
        // Handle errors
        final error = json.decode(response.body);
        return ('Failed to sign up: $error');
      }
    } catch (e) {
      // Handle network errors
      return ('Network error: $e');
    }
  }

  Future<String> login(String username, String password) async {
    const url = '$baseUrl/p/auth/login';
    final headers = {'Content-Type': 'application/json'};
    final body = {
      'username': username,
      'password': password,
    };

    try {
      final response = await http.post(Uri.parse(url),
          headers: headers, body: jsonEncode(body));

      if (response.statusCode == 200) {
        // Handle successful response
        final data = json.decode(response.body);

        if (data['result'] == true) {
          await _tokenManager.saveTokens(
              data['accessToken'], data['refreshToken']);
          return "success";
        } else {
          return "Login failed.\nPlease check your username or password.";
        }
      } else {
        return "Failed to login:\n ${response.statusCode}";
      }
    } catch (e) {
      // Handle network errors
      return "Network error:\n ${e.toString()}";
    }
  }

  Future<void> logout() async {
    const url = '$baseUrl/auth/logout';
    final headers = {'Content-Type': 'application/json'};
    final response = await ApiService().post(url, headers);
    if (response.statusCode == 200) {
      await _tokenManager.clearTokens();
      return json.decode(response.body);
    } else {
      throw Exception('Failed to logout');
    }
  }

  Future<bool> sendTemporaryPassword(String email) async {
    const url = '$baseUrl/p/auth/send_temp_password';
    final headers = {'Content-Type': 'application/json'};
    final body = {
      'email': email,
    };
    final response = await ApiService().post(url, headers, body);
    try {
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['result'];
      } else {
        final code = response.statusCode;
        print('statusCode: $code');
        throw Exception('Failed to send temporary password.');
      }
    } catch (e) {
      // Handle network errors
      throw "Network error:\n ${e.toString()}";
    }
  }
}

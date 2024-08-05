import 'dart:convert';
import 'package:eco_picker/data/user.dart';
import 'package:dio/dio.dart';
import 'api_client.dart';
import 'token_manager.dart';
import '../utils/constants.dart';

class ApiUserService {
  final ApiClient _apiClient = ApiClient();
  final TokenManager _tokenManager = TokenManager();

  Future<User> fetchUserInfo() async {
    try {
      final response = await _apiClient.dio.get('/user/info');
      return User.fromJson(response.data['userInfo']);
    } catch (e) {
      throw Exception('Failed to load user info: $e');
    }
  }

  Future<UserStatistics> fetchUserStatistics() async {
    try {
      final response = await _apiClient.dio.get('/user/statistics');
      return UserStatistics.fromJson(response.data['userStatistics']);
    } catch (e) {
      throw Exception('Failed to load user statistics: $e');
    }
  }

  Future<String> changePassword(
      String password, String newPassword, String confirmPassword) async {
    try {
      final response = await _apiClient.dio.post(
        '/user/update_password',
        data: {
          "password": password,
          "newPassword": newPassword,
          "confirmNewPassword": confirmPassword
        },
      );
      final data = response.data;
      if (response.statusCode == 200) {
        return data['code'] ? 'Please type a valid password.' : 'pass';
      } else if (response.statusCode == 400) {
        return data['errors']['message'];
      } else {
        throw Exception('Failed to change password');
      }
    } catch (e) {
      throw Exception('Failed to change password: $e');
    }
  }

  Future<String> signUp(String username, String password, String email) async {
    try {
      final response = await _apiClient.dio.post(
        '/auth/signup',
        data: {
          'username': username,
          'password': password,
          'email': email,
        },
      );
      final data = response.data;
      if (data['result'] == true) {
        return 'true';
      } else {
        if (data['code'] == 'ALREADY_REGISTERED_USERNAME') {
          return 'Username already registered. Please try with another username.';
        } else if (data['code'] == 'ALREADY_REGISTERED_EMAIL') {
          return 'Email already registered. Please try with another email.';
        } else {
          return 'Please use a valid password.';
        }
      }
    } catch (e) {
      throw Exception('Failed to sign up: $e');
    }
  }
Future<String> login(String username, String password) async {
  try {
    final response = await _apiClient.dio.post(
      '/p/auth/login',
      data: {
        'username': username,
        'password': password,
      },
      options: Options(
        headers: {
          'Content-Type': 'application/json',
        },
      ),
    );

    if (response.statusCode == 200) {
      final data = response.data;
      if (data['result'] == true) {
        await _tokenManager.saveTokens(
            data['accessToken'], data['refreshToken']);
        return "success";
      } else {
        return "Login failed. Please check your username or password.";
      }
    } else {
      return "Failed to login: ${response.statusCode}";
    }
  } catch (e) {
    if (e is DioError) {
      print('Dio error occurred: ${e.response?.data}');
      print('Dio error headers: ${e.response?.headers}');
      print('Dio error request: ${e.requestOptions}');
    }
    throw Exception('Failed to login: $e');
  }
}


  Future<void> refreshToken() async {
    final refreshToken = await _tokenManager.getRefreshToken();
    if (refreshToken != null) {
      final newAccessToken = await _apiClient.refreshAccessToken(refreshToken);
      if (newAccessToken != null) {
        await _tokenManager.saveTokens(newAccessToken, refreshToken);
        print('Token refreshed');
      } else {
        await _tokenManager.clearTokens();
        print('Failed to refresh token, logging out');
      }
    } else {
      print('No refresh token available');
    }
  }

  Future<void> logout() async {
    try {
      final response = await _apiClient.dio.post('/auth/logout');
      if (response.statusCode == 200) {
        await _tokenManager.clearTokens();
        print('Logged out');
      } else {
        throw Exception('Failed to logout');
      }
    } catch (e) {
      throw Exception('Failed to logout: $e');
    }
  }

  Future<bool> sendTemporaryPassword(String email) async {
    try {
      final response = await _apiClient.dio.post(
        '/auth/send_temp_password',
        data: {'email': email},
      );
      return response.data['result'];
    } catch (e) {
      throw Exception('Failed to send temporary password: $e');
    }
  }
}

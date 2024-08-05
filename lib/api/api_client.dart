import 'package:dio/dio.dart';
import 'token_manager.dart';
import '../utils/constants.dart';

class ApiClient {
  final Dio _dio = Dio();
  final TokenManager _tokenManager = TokenManager();

  ApiClient() {
    _dio.options.baseUrl = baseUrl;
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final accessToken = await _tokenManager.getAccessToken();
          if (accessToken != null) {
            options.headers['Authorization'] = 'Bearer $accessToken';
          }
          return handler.next(options);
        },
        onError: (DioError e, handler) async {
          if (e.response?.statusCode == 401) {
            final refreshToken = await _tokenManager.getRefreshToken();
            if (refreshToken != null) {
              final newAccessToken = await refreshAccessToken(refreshToken);
              if (newAccessToken != null) {
                await _tokenManager.saveTokens(newAccessToken, refreshToken);

                final options = e.requestOptions;
                options.headers['Authorization'] = 'Bearer $newAccessToken';
                final cloneReq = await _dio.request(
                  options.path,
                  options: Options(
                    method: options.method,
                    headers: options.headers,
                  ),
                  data: options.data,
                  queryParameters: options.queryParameters,
                );
                return handler.resolve(cloneReq);
              }
            }
          }
          return handler.next(e);
        },
      ),
    );
  }

  Future<String?> refreshAccessToken(String refreshToken) async {
    try {
      final response = await _dio.post(
        '/auth/renew_access_token',
        data: {'refreshToken': refreshToken},
      );
      return response.data['accessToken'];
    } catch (e) {
      print('Error refreshing token: $e');
      return null;
    }
  }

  Dio get dio => _dio;
}

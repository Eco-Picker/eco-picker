import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TokenManager {
  Future<void> saveTokens(String accessToken, String refreshToken) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('accessToken', accessToken);
    await prefs.setString('refreshToken', refreshToken);
  }

  Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');
    final tokenPayload =
        JwtDecoder.decode(accessToken!); // Decodes the JWT payload
    final expiration = tokenPayload['exp'] * 1000;
    final now = DateTime.now().millisecondsSinceEpoch;
    if (expiration < now) {
      return null;
    }
    return prefs.getString('accessToken');
  }

  Future<String?> getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('refreshToken');
  }

  Future<void> clearTokens() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('accessToken');
    await prefs.remove('refreshToken');
  }
}

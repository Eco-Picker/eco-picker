import 'dart:async';
import '../api/api_user_service.dart';

class TokenRefresher {
  final ApiUserService _ApiUserService = ApiUserService();
  Timer? _timer;

  void start() {
    _timer = Timer.periodic(Duration(days: 14), (timer) async {
      await _ApiUserService.refreshToken();
    });
  }

  void stop() {
    _timer?.cancel();
  }
}

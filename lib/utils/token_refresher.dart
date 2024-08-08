import 'dart:async';
import '../api/api_service.dart';

class TokenRefresher {
  Timer? _timer;

  void start() {
    _timer = Timer.periodic(Duration(days: 14), (timer) async {
      await ApiService().refreshToken();
    });
  }

  void stop() {
    _timer?.cancel();
  }
}

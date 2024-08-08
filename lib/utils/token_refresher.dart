import 'dart:async';
import '../api/api_service.dart';

import '../main.dart';

class TokenRefresher {
  final ApiService _apiService = ApiService();
  Timer? _timer;

  void start(MyAppState appState) {
    _timer = Timer.periodic(Duration(minutes: 9), (timer) async {
      final refreshSuccess = await _apiService.refreshToken();
      if (!refreshSuccess) {
        // If refresh fails, log out the user
        // appState.signOut();
      }
    });
  }

  void stop() {
    _timer?.cancel();
  }
}

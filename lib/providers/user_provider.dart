import 'package:flutter/material.dart';
import '../api/api_user_service.dart';
import '../data/user.dart';

class UserProvider with ChangeNotifier {
  User? _user;
  bool _isLoading = true;

  User? get user => _user;
  bool get isLoading => _isLoading;

  UserProvider() {
    fetchUser();
  }

  Future<void> fetchUser() async {
    try {
      _user = await ApiUserService().fetchUserInfo();
    } catch (e) {
      print('Error fetching user info: $e');
      _user = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setUser(User user) {
    _user = user;
    _isLoading = false;
    notifyListeners();
  }
}

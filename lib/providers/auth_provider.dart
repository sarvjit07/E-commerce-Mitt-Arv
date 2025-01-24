import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  bool _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;

  void login(String email, String password) {
    // Example logic for login (you can expand it)
    if (email == "user@example.com" && password == "1234567") {
      _isLoggedIn = true;
      notifyListeners();
    } else {
      throw Exception("Invalid credentials");
    }
  }

  void logout() {
    _isLoggedIn = false;
    notifyListeners();
  }
}

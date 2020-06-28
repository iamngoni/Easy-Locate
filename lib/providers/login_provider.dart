import 'package:flutter/material.dart';

class LoginProvider extends ChangeNotifier {
  String _username;
  String _password;
  String get username => _username;
  String get password => _password;
  void setUsername(name) {
    _username = name;
    notifyListeners();
  }

  void setPassword(password) {
    _password = password;
    notifyListeners();
  }
}

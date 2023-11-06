import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  String email = '';
  String password = '';
  String name = '';
  String token = '';
  int id = 0;

  void login(String email, String password, String name, String token, int id) {
    this.email = email;
    this.password = password;
    this.name = name;
    this.token = token;
    this.id = id;
    notifyListeners();
  }
}

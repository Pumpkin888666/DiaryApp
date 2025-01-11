import 'package:flutter/material.dart';

class UserInformation extends ChangeNotifier {
  String? _UserToken;
  String? _Username;

  String? get UserToken => _UserToken;
  String? get Username => _Username;

  void set_username(String name) {
    _Username = name;
    notifyListeners();
  }

  void set_usertoken(String token) {
    _UserToken = token;
    notifyListeners();
  }


}

import 'package:flutter/material.dart';

class UserInformation extends ChangeNotifier {
  String? _UserToken;
  String? _Username;
  Map? _User_Information;
  bool ini_status = false;

  Map? get User_Information => _User_Information;
  String? get UserToken => _UserToken;
  String? get Username => _Username;

  void set_information(Map arg) {
    _User_Information = arg;
    ini_status = true;
    notifyListeners();
  }
  void set_username(String name) {
    _Username = name;
    notifyListeners();
  }
}

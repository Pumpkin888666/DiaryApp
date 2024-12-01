import 'package:flutter/material.dart';

class AppInI extends ChangeNotifier {
  Map? _app_ini;
  bool ini_status = false;

  Map? get app_ini => _app_ini;

  String apiUrl = 'http://api.com/api.php';
  String appName = 'diaryapp';
  String appKey = 'ec3fabd5fb4d521b79ebd7e533b5b261';
  int uid = 1;
  int pid = 1;

  void set_ini(Map arg) {
    _app_ini = arg;
    ini_status = true;
    notifyListeners();
  }
}

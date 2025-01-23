import 'package:flutter/material.dart';

class AppInI extends ChangeNotifier {
  Map? _app_ini;
  bool ini_status = false;

  Map? get app_ini => _app_ini;

  String apiUrl = 'https://ex-api.pumpkin8.cn/';

  void set_ini(Map arg) {
    _app_ini = arg;
    ini_status = true;
    notifyListeners();
  }
}

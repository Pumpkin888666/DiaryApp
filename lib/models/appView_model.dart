import 'package:flutter/material.dart';

class AppViewModel extends ChangeNotifier {
  int selectedIndex = 0;
  bool isEdit = false;
  String? diaryCode;

  void change_select(int index) {
    selectedIndex = index;
    notifyListeners();
  }

  void change_edit_bool(bool i){
    isEdit = i;
    notifyListeners();
  }

  void change_diaryCdoe(dc){
    diaryCode = dc;
    notifyListeners();
  }

}

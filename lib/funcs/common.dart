import 'package:diaryapp/models/app_ini.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

// 配合着PumpkinButton用的
double getStrUILength(String str, [double? other]) {
  double width = 0;
  for (int i = 0; i < str.length; i++) {
    if (str[i].codeUnitAt(0) >= 0x0041 && str[i].codeUnitAt(0) <= 0x007A ||
        str[i].codeUnitAt(0) >= 0x0041 && str[i].codeUnitAt(0) <= 0x005A ||
        str[i].codeUnitAt(0) >= 0x0030 && str[i].codeUnitAt(0) <= 0x0039) {
      width += 12;
    } else {
      width += 25;
    }
  }
  return width + (other ?? 0);
}

// 获取时间戳
int getTime() {
  return (DateTime.now().millisecondsSinceEpoch / 1000).floor();
}

// 时间戳毫秒级
int getTimeM() {
  return (DateTime.now().millisecondsSinceEpoch).floor();
}



// 获取每日一言
Future<Map> Dayan(BuildContext context) async {
  final appInI = Provider.of<AppInI>(context, listen: false);
  try {
    var response = await http.get(
      Uri.parse('${appInI.apiUrl}dayan'),
    );
    var res = jsonDecode(response.body);
    return res['data'];
  } catch (e) {
    print(e);
    return {'dayan':'Dayan Service Error','di':-1};
  }
}

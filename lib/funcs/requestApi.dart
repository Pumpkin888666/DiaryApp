import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:provider/provider.dart';
import 'package:diaryapp/models/app_ini.dart';
import 'package:diaryapp/models/user_information.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:diaryapp/pages/login.dart';
import 'package:diaryapp/widget/PumpkinPopup.dart';

Future<dynamic> requestApi(BuildContext context, String act,
    [Map<String, dynamic>? data]) async {
  final appInI = Provider.of<AppInI>(context, listen: false);
  final app_ini = appInI.app_ini ?? Map();

  final userInformation = Provider.of<UserInformation>(context, listen: false);
  String? UserToken = userInformation.UserToken ?? null;
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (UserToken != null) {
    // update heartbeat
    prefs.setInt(
        'heartbeat', (DateTime.now().millisecondsSinceEpoch / 1000).floor());
  }

  if (app_ini.containsKey('must_login_act')) {
    if (app_ini['must_login_act'].contains(act) && UserToken == null) {
      // Login Dialog or go to login
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  List errorCode = [-1001, -1002, -1003, -1004];
  List tokenCode = [-2002, -2005, -2006];
  // 请求验证身份
  var bytes = utf8.encode(
      '${appInI.pid}${appInI.uid}${appInI.appKey}${appInI.appName}$act${(DateTime.now().millisecondsSinceEpoch / 1000).floor()}');
  var check = md5.convert(bytes);
  try {
    Map<String, dynamic> requestData = {
      'act': act,
      'pid': appInI.pid.toString(),
      'check': check.toString(),
    };
    requestData.addAll(data ?? {});
    String jsonBody = json.encode(requestData);
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };
    final response = await http.post(Uri.parse(appInI.apiUrl),
        headers: headers, body: jsonBody);

    // 检查响应
    var res = json.decode(response.body);
    var checkBytes = utf8
        .encode('${check.toString()}${appInI.appKey}${res['code']}${res['t']}');
    var resCheck = md5.convert(checkBytes).toString();
    if (res['check'] != resCheck) {
      return false;
    }

    // 请求错误检查
    if (errorCode.contains(res['code'])) {
      return false;
    }

    // token 检查
    if (act != 'login' && tokenCode.contains(res['code'])) {
      prefs.remove('token');
      prefs.remove('heartbeat');
      Navigator.pushReplacementNamed(context, '/login');
    }

    // 检查通过
    return response;
  } catch (e) {
    print(e);
    return false;
  }
}

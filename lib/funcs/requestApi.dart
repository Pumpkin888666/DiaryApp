import 'package:diaryapp/funcs/common.dart';
import 'package:diaryapp/pages/PumpkinConfirm.dart';
import 'package:diaryapp/pages/confirmPages/AppStatusError.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:provider/provider.dart';
import 'package:diaryapp/models/app_ini.dart';
import 'package:diaryapp/models/user_information.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:diaryapp/funcs/machineCode.dart';

Future<dynamic> requestApi(BuildContext context, String act,
    [Map<String, dynamic>? data, int? resent]) async {
  // 请求密钥
  const String _apiKey =
      'Z4GqQH\$G8\$L2TpNm\$ZtS+U61dzF)Av82j*&yBc1oZxJauHEB2zyFfwW-x0A^K#c&J9mk3KL/0p!wFtD2J@lY69';

  // 获取本机机器码
  String i = await getMachineCode();

  // 获取APP配置中 API地址
  final appInI = Provider.of<AppInI>(context, listen: false);
  final app_ini = appInI.app_ini ?? Map();

  // 获取UserToken进行身份验证
  final userInformation = Provider.of<UserInformation>(context, listen: false);
  String? UserToken = userInformation.UserToken ?? null;
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if(UserToken == null){
    var u = prefs.getString('token') ?? null;
    if(u != null){
      UserToken = u;
    }
  }
  if (UserToken != null) {
    // 更新心跳时间
    prefs.setInt(
        'heartbeat', getTime());
  }

  if (app_ini.containsKey('must_login_act')) {
    if (app_ini['must_login_act'].contains(act) && UserToken == null) {
      // 如果该请求是必须登录的请求 并且UserToken不存在 就跳转登录界面
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  // 定义错误码
  List localErrorCode = [-1000, -1001, -1002, -1003, 500, 999];
  List tokenCode = [-2004, -2005, -2006,-2007];

  // 计算随机请求身份验证值
  var bytes = utf8.encode(
      '$_apiKey${(getTime() / 100).floor()}$i');
  var check = md5.convert(bytes);

  try {
    String jsonBody = json.encode(data ?? {});
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'api-key': check.toString(),
      'machine-code': i.toString(),
    };

    // add token
    if (UserToken != null) {
      headers.addAll({
        'token': UserToken.toString(),
      });
    }

    final response = await http.post(Uri.parse('${appInI.apiUrl}api/$act'),
        headers: headers, body: jsonBody);

    // 检查响应
    var res = json.decode(response.body);
    if(res['t'] - getTime() > 30){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('请求延迟过高，请检查网络设置。[t]'),
          duration: Duration(seconds: 2), // Snackbar 显示的时间
        ),
      );
      return false;
    }
    var checkBytes = utf8.encode(
        '$_apiKey${res['msg']}${res['code']}${res['t']}');
    var resCheck = md5.convert(checkBytes).toString();
    if (res['check'] != resCheck) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('响应验证不通过。'),
          duration: Duration(seconds: 2), // Snackbar 显示的时间
        ),
      );
      return false;
    }

    print(res['code']);
    // 请求错误检查
    if (localErrorCode.contains(res['code'])) {
      resent ??= 0;
      if (res['code'] == -1000 || res['code'] == 999) {
        if(resent <= 3){
          // Auth 错误 Try again提示 进行自动重发
          print('resent : $resent');
          var newRes =
          await requestApi(context, act, data = data, resent = resent + 1);
          return newRes;
        }
      }
      if(res['code'] == -2007){
        Navigator.pushNamed(context, '/login');
      }
      if (res['code'] != 999) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PumpkinConfirm(
              cancel: false,
              url: 'assets/icon/Message-Warning-256.png',
              isNetworkImage: false,
              height: MediaQuery.of(context).size.height,
              fit: BoxFit.contain,
              width: 100,
              i_height: 100,
              decoration: const BoxDecoration(color: Colors.red),
              child: AppStatusError(
                appStatus: res['code'] == -1003 ? false : true,
                serverStatus: res['code'] == 500 ? false : true,
                localStatus: res['code'] == 500 ? true : false,
              ),
            ),
          ),
        );
        return false;
      }
    }

    // token 检查
    if (act != 'login' && tokenCode.contains(res['code'])) {
      prefs.remove('token');
      prefs.remove('heartbeat');
      if (act != 'getAppInI') {
        Navigator.pushReplacementNamed(context, '/login');
      }
    }

    if(res['code'] == -1){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(res['msg']),
          duration: const Duration(seconds: 2), // Snackbar 显示的时间
        ),
      );
    }

    // 检查通过
    return response;
  } catch (e) {
    print(e);
    return false;
  }
}

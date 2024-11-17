import 'package:http/http.dart' as http;
import '../config.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';

Future<dynamic> getData(act) async{
  // 请求验证身份
  var bytes = utf8.encode('${pid}${uid}${appKey}${appName}${act}${(DateTime.now().millisecondsSinceEpoch / 1000).floor()}');
  var check = md5.convert(bytes);
  try {
    final response = await http.post(Uri.parse(apiUrl),body: {
      'act':act,
      'pid':pid.toString(),
      'check':check.toString(),
    });

    // 检查响应
    var res = json.decode(response.body);
    var checkBytes = utf8.encode('${check.toString()}${appKey}${res['code']}${res['t']}');
    var resCheck = md5.convert(checkBytes).toString();
    if(res['check'] != resCheck){
      return false;
    }

    // 检查通过
    return res['code'] < 0? false : response;
  } catch (e) {
    print(e);
    return false;
  }
}
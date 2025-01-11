import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart'; // 用于计算 SHA256

Future<String> getMachineCode() async {
  // 获取 MAC 地址
  String macAddress = await _getMacAddress();

  // 获取硬盘序列号
  String diskSerialNumber = await _getDiskSerialNumber();

  // 获取系统信息
  String systemInfo = _getSystemInfo();

  // 合并信息
  String combinedInfo = "$macAddress$diskSerialNumber$systemInfo";

  // 计算 SHA256 哈希值
  String SHA256 = _generateSHA256(combinedInfo);

  // 计算MD5
  String machineCode = _generateMD5(SHA256);

  return machineCode;
}

// 获取 MAC 地址
Future<String> _getMacAddress() async {
  try {
    // 获取 MAC 地址的代码
    if (Platform.isLinux || Platform.isMacOS || Platform.isWindows) {
      var result = await Process.run('ifconfig', ['-a']);
      var output = result.stdout.toString();
      RegExp regExp = RegExp(r"([0-9A-Fa-f]{2}(:[0-9A-Fa-f]{2}){5})");
      final matches = regExp.allMatches(output);
      if (matches.isNotEmpty) {
        // 获取第一个匹配的 MAC 地址
        return matches.first.group(0) ?? 'unknown-mac';
      }
    }
  } catch (e) {
    // 获取 MAC 地址失败时返回默认值
    return 'unknown-mac';
  }
  return 'unknown-mac';  // 如果未找到 MAC 地址，返回默认值
}

// 获取硬盘序列号（仅适用于 Windows）
Future<String> _getDiskSerialNumber() async {
  String serialNumber = 'unknown-disk';
  if (Platform.isWindows) {
    try {
      // 调用 wmim 获取硬盘序列号
      var result = await Process.run('wmic', ['diskdrive', 'get', 'serialnumber']);
      var output = result.stdout.toString();
      var serialNumberList = output.split('\n');
      if (serialNumberList.isNotEmpty && serialNumberList.length > 1) {
        serialNumber = serialNumberList[1].trim();
      }
    } catch (e) {
      serialNumber = 'unknown-disk';  // 获取硬盘序列号失败时返回默认值
    }
  }
  return serialNumber;
}

// 获取系统信息
String _getSystemInfo() {
  var systemInfo = {
    'system': Platform.operatingSystem,
    'node': Platform.localHostname,
    'release': Platform.operatingSystemVersion,
    'machine': Platform.isLinux ? 'Linux' : (Platform.isWindows ? 'Windows' : 'MacOS'),
  };

  return systemInfo.toString();
}

// 计算 SHA256 哈希
String _generateSHA256(String input) {
  var bytes = utf8.encode(input);  // 将字符串转为字节数组
  var digest = sha256.convert(bytes);  // 计算 SHA256 哈希
  return digest.toString();  // 返回哈希值字符串
}

String _generateMD5(String input){
  var bytes = utf8.encode(input);
  var digest = md5.convert(bytes);
  return digest.toString();
}
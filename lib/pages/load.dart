import 'package:flutter/material.dart';
import 'dart:convert';
import '../funcs/getData.dart';

class Load extends StatefulWidget {
  const Load({super.key});

  @override
  State<Load> createState() => _LoadState();
}

class _LoadState extends State<Load> {
  String _message = '正在检查软件可用性';
  bool _reCheck = false;
  Color _textColor = Colors.black;
  int _reCheckTimes = 0;
  int _maxReCheckTimes = 5;

  @override
  void initState() {
    super.initState();
    _getAppInI();
  }

  Future<void> _getAppInI() async {
    try {
      var StartTime = DateTime.now().millisecondsSinceEpoch;
      final response = await getData('getAppInI');
      var EndTime = DateTime.now().millisecondsSinceEpoch;
      var LoadTime = EndTime - StartTime;

      if (response != false) {
        final data = json.decode(response.body);
        if (LoadTime < 1000) {
          await Future.delayed(const Duration(milliseconds: 1000));
        }
        setState(() {
          if (data['code'] == 0) {
            _message = '正在加载软件资源';
          }
          _textColor = Colors.black;
          _reCheck = false;
        });
        Navigator.pushNamed(context, '/login');
      } else {
        // 请求失败
        setState(() {
          _message = '服务器错误';
          _reCheck = true;
          _textColor = Colors.red;
        });
      }
    } catch (e) {
      print(e);
      // 处理异常
      setState(() {
        _message = '无法连接到服务器，请检查网络。';
        _reCheck = true;
        _textColor = Colors.red;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 50,
            ),
            Hero(tag: 'logoHero', child: Image.asset('assets/logo.png')),
            const SizedBox(
              height: 130,
            ),
            Text(
              _message,
              style: TextStyle(fontSize: 20, color: _textColor),
            ),
            const SizedBox(
              height: 20,
            ),
            !_reCheck
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () {
                      if (_reCheckTimes < _maxReCheckTimes) {
                        setState(() {
                          _reCheck = false;
                          _getAppInI();
                          _reCheckTimes++;
                        });
                      }
                    },
                    child: const Text('重试')),
          ],
        ),
      ),
    );
  }
}

import 'package:diaryapp/main.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import '../funcs/requestApi.dart';
import 'package:provider/provider.dart';
import '../models/app_ini.dart';

class Load extends StatefulWidget {
  const Load({super.key});

  @override
  State<Load> createState() => _LoadState();
}

class _LoadState extends State<Load> {
  String _message = '正在检查软件可用性';
  bool _reCheck = false;
  Color _textColor = Colors.black;

  @override
  void initState() {
    super.initState();
    _getAppInI();
  }

  Future<void> _getAppInI() async {
    try {
      final response = await requestApi('getAppInI');

      if (response != false) {
        final data = json.decode(response.body);
        setState(() {
          if (data['code'] == 0) {
            _message = '正在加载软件资源';
            _textColor = Colors.black;
            _reCheck = false;
          }else{
            _message = 'Cloud Error ${data['code']}';
            _textColor = Colors.red;
            _reCheck = true;
          }
        });
        final app_ini = data['data'];
        final appInI = Provider.of<AppInI>(context,listen: false);
        appInI.set_ini(app_ini);
        await precacheImage(
            NetworkImage(
                app_ini['login_post_url']
            ),
            context);
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
            Hero(
                tag: 'logoHero',
                child: Image.asset(
                  'assets/logo.png',
                  width: 220,
                  height: 220,
                  fit: BoxFit.cover,
                )),
            const SizedBox(
              height: 80,
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
                      setState(() {
                        _reCheck = false;
                        _getAppInI();
                      });
                    },
                    child: const Text('重试')),
          ],
        ),
      ),
    );
  }
}

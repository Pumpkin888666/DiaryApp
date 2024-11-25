import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:diaryapp/funcs/requestApi.dart';
import 'package:provider/provider.dart';
import 'package:diaryapp/models/app_ini.dart';
import 'package:diaryapp/widget/PumpkinImage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:diaryapp/funcs/getStrUILength.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _loginFormKey = GlobalKey<FormState>();
  String _message = 'Login';
  ButtonStyle _loginButtonStyle = ButtonStyle();
  bool _isLoading = false;
  double _loginButtonWidth = 110;
  Icon _buttonIcon = const Icon(Icons.login);
  String? _loginToken;
  bool? _isLogin;

  @override
  void initState() {
    super.initState();
    _checkLogin();
  }

  Future<void> _login() async {
    if (_loginFormKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _loginButtonWidth = 80;
      });
      await Future.delayed(const Duration(seconds: 1)); // 让按钮动画好看一点 呵呵

      Map<String, dynamic> LoginForm = {
        'username': _usernameController.text,
        'password': _passwordController.text,
      };

      final response = await requestApi('app_login', LoginForm);
      if (response != false) {
        Map data = jsonDecode(response.body);
        setState(() {
          _isLoading = false;
        });
        switch (data['code']) {
          case 0:
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.setString('token', data['data']['token']);
            await prefs.setInt('heartbeat',
                (DateTime.now().millisecondsSinceEpoch / 1000).floor());
            setState(() {
              _isLoading = false;
              _message = '登录成功';
              _loginButtonWidth = getStrUILength(_message,30);
              _buttonIcon = const Icon(Icons.check);
              _loginButtonStyle = ElevatedButton.styleFrom(
                backgroundColor: Colors.green, // 背景颜色
                foregroundColor: Colors.white, // 字体颜色
              );
            });
            Navigator.pushNamed(context, '/home');
            break;
          case -2001:
            setState(() {
              _message = '未知账户';
              _loginButtonWidth = getStrUILength(_message,30);
              _buttonIcon = const Icon(Icons.person);
            });
            break;
          case -2002:
            setState(() {
              _message = '账户状态异常';
              _loginButtonWidth = getStrUILength(_message,30);
              _buttonIcon = const Icon(Icons.error_outline);
            });
            break;
          case -2003:
            setState(() {
              _message = '密码错误';
              _loginButtonWidth = getStrUILength(_message,30);
              _buttonIcon = const Icon(Icons.password);
            });
        }
        setState(() {
          // 在这之前登录成功不会有这个效果
          if (data['code'] != 0) {
            _loginButtonStyle = ElevatedButton.styleFrom(
              backgroundColor: Colors.red, // 背景颜色
              foregroundColor: Colors.white, // 字体颜色
            );
          }
        });
      } else {
        setState(() {
          _isLoading = false;
          _message = 'Cloud Error';
          _loginButtonStyle = ElevatedButton.styleFrom(
            backgroundColor: Colors.red, // 背景颜色
            foregroundColor: Colors.white, // 字体颜色
          );
          _loginButtonWidth = getStrUILength(_message,30);
          _buttonIcon = const Icon(Icons.error_outline);
        });
      }
    }
  }

  Future<void> _checkLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = await prefs.getString('token');
    int? heartbeat = await prefs.getInt('heartbeat');
    if (token != null && token.isNotEmpty && heartbeat != null) {
      final appInI = Provider.of<AppInI>(context, listen: false);
      final app_ini = appInI.app_ini;
      if (app_ini!['login_catch_time'] <
          (DateTime.now().millisecondsSinceEpoch / 1000).floor() - heartbeat) {
        setState(() {
          _isLogin = false;
          _loginToken = null;
          prefs.remove('token');
          prefs.remove('heartbeat');
        });
      } else {
        setState(() {
          _isLogin = true;
          _loginToken = token;
        });
      }
    } else {
      setState(() {
        _isLogin = false;
        _loginToken = null;
      });
    }
  }

  Future<void> _removeLocalLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isLogin = false;
      _loginToken = null;
    });
    prefs.remove('token');
    prefs.remove('heartbeat');
  }

  @override
  Widget build(BuildContext context) {
    final appInI = Provider.of<AppInI>(context);
    final app_ini = appInI.app_ini;

    return Scaffold(
      body: Row(
        children: [
          SizedBox(
            width: 300,
            child: Column(
              children: [PumpkinImage(url: app_ini!['login_post_url'])],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                SizedBox(
                    height: _isLogin == null || _isLogin == true ? 100 : 0),
                Hero(
                    tag: 'logoHero',
                    child: Image.asset(
                      'assets/logo.png',
                      width: 150,
                      height: 150,
                      fit: BoxFit.cover,
                    )),
                _isLogin == null || _isLogin == true
                    ? Container(
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 50,
                            ),
                            Text(
                              _isLogin == null ? '正在检查本地登录' : '您已登录，是否继续？',
                              style: const TextStyle(fontSize: 20),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            _isLogin == null
                                ? const CircularProgressIndicator()
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ElevatedButton.icon(
                                        onPressed: () {
                                          Navigator.pushNamed(context, '/home');
                                        },
                                        icon: const Icon(Icons.east),
                                        label: const Text('直接登录'),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.green, // 背景颜色
                                          foregroundColor: Colors.white, // 字体颜色
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      ElevatedButton.icon(
                                        onPressed: _removeLocalLogin,
                                        icon: const Icon(Icons.close),
                                        label: const Text('登录新账户'),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red, // 背景颜色
                                          foregroundColor: Colors.white, // 字体颜色
                                        ),
                                      ),
                                    ],
                                  ),
                          ],
                        ),
                      )
                    : Container(
                        child: Column(
                          children: [
                            const Text(
                              '登录以继续',
                              style: TextStyle(fontSize: 30),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Form(
                              key: _loginFormKey,
                              child: Column(
                                children: [
                                  SizedBox(
                                    width: 360,
                                    child: TextFormField(
                                      controller: _usernameController,
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: '用户名',
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return '请输入用户名';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  SizedBox(
                                    width: 360,
                                    child: TextFormField(
                                      controller: _passwordController,
                                      obscureText: true,
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: '密码',
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return '请输入密码';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            AnimatedContainer(
                              height: 35,
                              curve: Curves.easeInOut,
                              duration: const Duration(milliseconds: 150),
                              // 设置按钮大小变化的过渡时间
                              width: _loginButtonWidth,
                              child: ElevatedButton.icon(
                                icon: _isLoading ? null : _buttonIcon,
                                onPressed:
                                    _isLoading ? null : _login, // 加载时禁用按钮
                                style: _loginButtonStyle,
                                label: AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 150),
                                  // 设置按钮内部内容过渡的时间
                                  transitionBuilder: (Widget child,
                                      Animation<double> animation) {
                                    // 使用 FadeTransition 或其他过渡效果
                                    return FadeTransition(
                                        opacity: animation, child: child);
                                  },
                                  child: _isLoading
                                      ? const SizedBox(
                                          width: 15, // 设置加载动画的宽度
                                          height: 15, // 设置加载动画的高度
                                          child: CircularProgressIndicator(
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                    Colors.white),
                                            strokeWidth: 3, // 设置加载动画的宽度
                                          ),
                                        )
                                      : Text(
                                          _message,
                                          softWrap: false,
                                          overflow: TextOverflow.clip,
                                        ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            ElevatedButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, '/');
                                },
                                child: const Text('点我重新加载配置'))
                          ],
                        ),
                      )
              ],
            ),
          )
        ],
      ),
    );
  }
}

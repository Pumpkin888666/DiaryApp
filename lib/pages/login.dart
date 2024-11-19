import 'package:flutter/material.dart';
import 'dart:convert';
import '../funcs/requestApi.dart';
import 'package:provider/provider.dart';
import '../models/app_ini.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  double _postWidth = 0.0;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _loginFormKey = GlobalKey<FormState>();
  String _message = 'Login';
  String _message1 = 'Login';
  ButtonStyle _loginButtonStyle = ButtonStyle();
  bool _isLoading = false;
  double _loginButtonWidth = 110;
  final GlobalKey _loginButtonKey_hide = GlobalKey();
  Icon _buttonIcon = const Icon(Icons.login);

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 100), () {
      setState(() {
        _postWidth = 300;
      });
    });
  }

  Future<void> Login() async {
    if (_loginFormKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      await Future.delayed(const Duration(milliseconds: 10));
      RenderBox renderBox = _loginButtonKey_hide.currentContext?.findRenderObject() as RenderBox;
      var size = renderBox.size;
      setState(() {
        _loginButtonWidth = size.width + 30;
      });
      await Future.delayed(const Duration(seconds: 1)); // 让按钮动画好看一点 呵呵

      Map<String, dynamic> LoginForm = {
        'username': _usernameController.text,
        'password': _passwordController.text,
      };

      final response = await requestApi('app_login',LoginForm);
      if(response != false){
        Map data = jsonDecode(response.body);
        switch(data['code']){
          case 0:
            break;
          case -2001:
            setState(() {
              _message1 = '未知账户';
              _isLoading = false;
            });
            await Future.delayed(const Duration(milliseconds: 10));
            RenderBox renderBox = _loginButtonKey_hide.currentContext?.findRenderObject() as RenderBox;
            var size = renderBox.size;
            setState(() {
              _message = '未知账户';
              _loginButtonStyle = ElevatedButton.styleFrom(
                backgroundColor: Colors.red, // 背景颜色
                foregroundColor: Colors.white, // 字体颜色
              );
              _loginButtonWidth = size.width + 30;
              _buttonIcon = const Icon(Icons.error_outline);
            });
            break;
        }
      }else{
        setState(() {
          _message = 'Cloud Error';
        });
      }
    }
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
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: _postWidth,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Image.network(
                      app_ini!['login_post_url'],
                      width: _postWidth,
                      fit: BoxFit.fill,
                      height: MediaQuery.of(context).size.height,
                      loadingBuilder: (BuildContext context, Widget child,
                          ImageChunkEvent? loadingProgress) {
                        if (loadingProgress == null) {
                          // 图片加载完成，返回图片
                          return child;
                        } else {
                          // 图片加载过程中，返回进度指示器
                          return Column(
                            children: [
                              const SizedBox(
                                height: 200,
                              ),
                              Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes !=
                                          null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          (loadingProgress.expectedTotalBytes ??
                                              1)
                                      : null,
                                ),
                              ),
                            ],
                          );
                        }
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Hero(
                    tag: 'logoHero',
                    child: Image.asset(
                      'assets/logo.png',
                      width: 150,
                      height: 150,
                      fit: BoxFit.cover,
                    )),
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
                Column(
                  children: [

                AnimatedContainer(
                  height: 35,
                  curve: Curves.easeInOut,
                  duration: const Duration(milliseconds: 150), // 设置按钮大小变化的过渡时间
                  width: _loginButtonWidth,
                  child: ElevatedButton.icon(
                    icon: _isLoading ? null : _buttonIcon,
                    onPressed: _isLoading ? null : Login, // 加载时禁用按钮
                    style: _loginButtonStyle,
                    label: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 150), // 设置按钮内部内容过渡的时间
                      transitionBuilder: (Widget child, Animation<double> animation) {
                        // 使用 FadeTransition 或其他过渡效果
                        return FadeTransition(opacity: animation, child: child);
                      },
                      child: _isLoading
                          ? const SizedBox(
                        width: 15, // 设置加载动画的宽度
                        height: 15, // 设置加载动画的高度
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
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

                Container(
                  height: 0,
                  child: ElevatedButton(
                    key: _loginButtonKey_hide,
                    onPressed: _isLoading ? null : Login, // 加载时禁用按钮
                    child:  _isLoading
                          ? const SizedBox(
                        width: 15, // 设置加载动画的宽度
                        height: 15, // 设置加载动画的高度
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          strokeWidth: 3, // 设置加载动画的宽度
                        ),
                      )
                          : Text(
                        _message1,
                      ),
                  ),
                ),
                  ],
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
    );
  }
}

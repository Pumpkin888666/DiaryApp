import 'package:flutter/material.dart';
import 'dart:convert';
import '../funcs/getData.dart';

class Login extends StatefulWidget{
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  double _postWidth = 0.0;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 200),(){
      setState(() {
        _postWidth = 300;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          SizedBox(
            width: 300,
            child: Column(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  width: _postWidth,
                  child: Image.network('https://tse1-mm.cn.bing.net/th/id/OIP-C.YKoZzgmubNBxQ8j-mmoTKAHaEK?rs=1&pid=ImgDetMain',width: _postWidth,fit: BoxFit.fill,height: MediaQuery.of(context).size.height,),
                )
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Hero(tag: 'logoHero', child: Image.asset('assets/logo.png')),
                const Text('登录以继续',style: TextStyle(fontSize: 30),),
              ],
            ),
          )
        ],
      ),
    );
  }
}
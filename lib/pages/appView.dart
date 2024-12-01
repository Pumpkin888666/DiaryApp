import 'dart:convert';
import 'package:diaryapp/models/user_information.dart';
import 'package:flutter/material.dart';
import 'package:diaryapp/pages/appView/home.dart';
import 'package:diaryapp/funcs/requestApi.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:diaryapp/models/app_ini.dart';

class AppView extends StatefulWidget {
  const AppView({super.key});

  @override
  State<AppView> createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {

  @override
  void initState() {
    super.initState();
    _getUserInformation();
  }

  void _getUserInformation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    int? heartbeat = prefs.getInt('heartbeat');
    if (token != null && token.isNotEmpty && heartbeat != null) {
      final appInI = Provider.of<AppInI>(context, listen: false);
      final app_ini = appInI.app_ini;
      if (app_ini!['login_catch_time'] <
          (DateTime.now().millisecondsSinceEpoch / 1000).floor() - heartbeat) {
        Navigator.pushReplacementNamed(context, '/login');
      }else{
        Map<String, dynamic> Form = {
          'user_token':token,
        };
        final response = await requestApi(context, 'getAppUserInformation',Form);
        if(response != null){
          Map res = jsonDecode(response.body);
          final userInformation = Provider.of<UserInformation>(context, listen: false);
          userInformation.set_information(res['data']['Information']['ini'] ?? Map());
          userInformation.set_username(res['data']['Information']['username']);
        }
      }
    }else{
      Navigator.pushReplacementNamed(context, '/login');
    }

  }

  int _selectedIndex = 0;

  void _onDestinationSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _getSelectedPage() {
    switch (_selectedIndex) {
      case 0:
        return home();
      case 1:
        return Placeholder();
      default:
        return Center(child: Text('Page 1'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('diaryapp'),
        leading: null,
      ),
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: _selectedIndex,
            onDestinationSelected: _onDestinationSelected,
            labelType: NavigationRailLabelType.none,
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.home),
                label: Text('Home'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.search),
                label: Text('Search'),
              ),
            ],
          ),
          Expanded(child: _getSelectedPage()), // 根据选中的索引显示页面内容
        ],
      ),
    );
  }
}
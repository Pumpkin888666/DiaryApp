import 'package:flutter/material.dart';
import 'package:diaryapp/pages/appView/home.dart';
import 'package:diaryapp/pages/appView/write.dart';
import 'package:diaryapp/pages/appView/diarylist.dart';
import 'package:provider/provider.dart';
import 'package:diaryapp/models/appView_model.dart';

class AppView extends StatefulWidget {
  const AppView({super.key});

  @override
  State<AppView> createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {

  void _onDestinationSelected(int index) {
    var appview_model = Provider.of<AppViewModel>(context,listen: false);
    appview_model.change_select(index);
  }

  Widget _getSelectedPage(index) {
    switch (index) {
      case 0:
        return home();
      case 1:
        return Write();
      case 2:
        return DiaryList();
      default:
        return const Center(child: Text('当你看见我 说明你点的这个页面我没做 (●\'◡\'●)'));
    }
  }

  @override
  Widget build(BuildContext context) {
    var appview_model = Provider.of<AppViewModel>(context);
    var _index = appview_model.selectedIndex;

    return Scaffold(
      appBar: AppBar(
        title: const Text('DiaryApp'),
        leading: null,
      ),
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: _index,
            onDestinationSelected: _onDestinationSelected,
            labelType: NavigationRailLabelType.none,
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.home),
                label: Text('Home'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.mode_edit),
                label: Text('Write'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.list),
                label: Text('List'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.delete),
                label: Text('Trash'),
              ),

            ],
          ),
          Expanded(child: Align(
            alignment: Alignment.topLeft,
            child: _getSelectedPage(_index),
          )), // 根据选中的索引显示页面内容
        ],
      ),
    );
  }
}

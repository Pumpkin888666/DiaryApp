import 'package:diaryapp/models/user_information.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:diaryapp/widget/PumpkinLoading.dart';
import 'package:diaryapp/widget/PumpkinPopup.dart';

class home extends StatefulWidget {
  @override
  State<home> createState() => _homeState();
}

final GlobalKey<PumpkinPopupState> popup_key = GlobalKey();

class _homeState extends State<home> {
  @override
  void initState() {
    super.initState();
  }

  String _homeHello() {
    int hour = DateTime.now().hour;

    // 根据时间段返回不同的问候语
    if (hour >= 6 && hour < 12) {
      return '早上好';
    } else if (hour >= 12 && hour < 18) {
      return '下午好';
    } else if (hour >= 18 && hour < 22) {
      return '晚上好';
    } else {
      return '夜深了';
    }
  }

  void somefunc() async {
    popup_key.currentState?.auto(context);

    await Future.delayed(const Duration(seconds: 1));

    popup_key.currentState?.handoffLoading(context);
  }

  @override
  Widget build(BuildContext context) {
    final userInformation = Provider.of<UserInformation>(context);

    return userInformation.Username == null
        ? const Center(
            child: PumpkinLoading(),
          )
        : Row(
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      '${userInformation.Username},${_homeHello()}',
                      style: const TextStyle(fontSize: 40),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: somefunc,
                    label: const Text('popup'),
                    icon: Icon(Icons.ads_click),
                  ),
                ],
              ),
              PumpkinPopup(
                key: popup_key,
                defaultHeight: 300,
                defaultWidth: 500,
                child: some(),
                defaultLoading: true,
                whenHitBlack: true,
              ),
            ],
          );
  }
}

class some extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () {
          popup_key.currentState?.changeSize(Size(400, 200));
          print('success');
        },
        child: const Text('change size'));
  }
}

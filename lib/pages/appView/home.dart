import 'package:diaryapp/funcs/requestApi.dart';
import 'package:diaryapp/models/user_information.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:diaryapp/widget/PumpkinLoading.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';

class home extends StatefulWidget {
  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  final List<DateTime> _singleDatePickerValueWithDefaultValue = [
    DateTime.now(),
  ];
  final config = CalendarDatePicker2Config(
    selectedDayHighlightColor: Colors.amber[900],
    weekdayLabels: ['周日', '周一', '周二', '周三', '周四', '周五', '周六'],
    weekdayLabelTextStyle: const TextStyle(
      color: Colors.black87,
      fontWeight: FontWeight.bold,
    ),
    firstDayOfWeek: 1,
    controlsHeight: 50,
    controlsTextStyle: const TextStyle(
      color: Colors.black,
      fontSize: 15,
      fontWeight: FontWeight.bold,
    ),
    dayTextStyle: const TextStyle(
      color: Colors.amber,
      fontWeight: FontWeight.bold,
    ),
    disabledDayTextStyle: const TextStyle(
      color: Colors.grey,
    ),
    selectableDayPredicate: (day) => !day
        .difference(DateTime.now().subtract(const Duration(days: 3)))
        .isNegative,
  );

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

  void _changeCards(List<DateTime> dates){
    int time = ((dates[0].millisecondsSinceEpoch) / 1000).floor();

  }

  List<Container> cards = [
    Container(
      alignment: Alignment.center,
      child: const Text('1'),
      color: Colors.blue,
    ),
    Container(
      alignment: Alignment.center,
      child: const Text('2'),
      color: Colors.red,
    ),
    Container(
      alignment: Alignment.center,
      child: const Text('3'),
      color: Colors.purple,
    )
  ];

  @override
  Widget build(BuildContext context) {
    final userInformation = Provider.of<UserInformation>(context);
    
    return Row(
      children: [
        ElevatedButton(onPressed: (){
          requestApi(context, 'test_act');
        }, child: const Text('click me'))
      ],
    );

    return userInformation.Username == null
        ? const Center(
            child: PumpkinLoading(),
          )
        : Row(
            children: [
              Column(
                children: [
                  Text(
                    '${userInformation.Username}的心情日历',
                    style: const TextStyle(fontSize: 30),
                  ),

                  // 日历
                  SizedBox(
                    width: 400,
                    height: 400,
                    child: CalendarDatePicker2(
                      config: config,
                      value: _singleDatePickerValueWithDefaultValue,
                      onValueChanged: _changeCards,
                    ),
                  ),
                ],
              ),
              const Column(
                children: [
                  SizedBox(width: 70,)
                ],
              ),
              Column(
                children: [
                  const SizedBox(
                    height: 44,
                  ),
                  SizedBox(
                      height: 400,
                      width: 400,
                      child: CardSwiper(
                        cardsCount: cards.length,
                        cardBuilder: (context, index, percentThresholdX,
                                percentThresholdY) =>
                            cards[index],
                      )),
                ],
              )
            ],
          );
  }
}

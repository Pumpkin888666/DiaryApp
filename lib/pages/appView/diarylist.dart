import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:diaryapp/widget/PumpkinLoading.dart';
import 'package:diaryapp/funcs/requestApi.dart';
import 'package:provider/provider.dart';
import 'package:diaryapp/models/user_information.dart';
import 'package:diaryapp/models/appView_model.dart';

class DiaryList extends StatefulWidget {
  const DiaryList({super.key});

  @override
  State<DiaryList> createState() => _DiaryListState();
}

class _DiaryListState extends State<DiaryList> {
  bool _load = true;
  int _diaryCount = 10;
  List items = [];

  @override
  void initState() {
    super.initState();
    LoadDiary();
  }

  void LoadDiary() async {
    final userInformation =
        Provider.of<UserInformation>(context, listen: false);
    String? UserToken = userInformation.UserToken ?? null;
    if (UserToken == null) {
      Navigator.pushReplacementNamed(context, '/login');
    }
    var response = await requestApi(context, 'get_diary_list');
    var res = jsonDecode(response.body);
    if (res['code'] == 0) {
      setState(() {
        items = res['data']['diary'];
        _load = false;
        _diaryCount = items.length;
      });
    }
  }

  void look(diary_code){
    var appview_model = Provider.of<AppViewModel>(context,listen: false);
    appview_model.change_diaryCdoe(diary_code);
    Navigator.pushNamed(context, '/look');
  }

  void edit(diary_code){
    var appview_model = Provider.of<AppViewModel>(context,listen: false);
    appview_model.change_diaryCdoe(diary_code);
    appview_model.change_edit_bool(true);
    appview_model.change_select(1);
  }

  @override
  Widget build(BuildContext context) {
    if (_load) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            PumpkinLoading(),
            SizedBox(
              height: 10,
            ),
            Text('正在打开日记本...'),
          ],
        ),
      );
    }
    return Container(
      child: ListView.builder(
          itemCount: _diaryCount,
          itemBuilder: (BuildContext context, int index) {
            return Theme(
              data: ThemeData(
                  colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue)),
              child: Card(
                elevation: 7,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text(
                            '日期:${items[index]['create_time']}'),
                        const SizedBox(
                          width: 10,
                        ),
                        const Spacer(),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            child: Row(
                              children: [
                                Theme(
                                  data: ThemeData(
                                      colorScheme: ColorScheme.fromSeed(
                                          seedColor: Colors.green)),
                                  child: ElevatedButton.icon(
                                    onPressed: (){
                                      look(items[index]['diary_code']);
                                    },
                                    style: ButtonStyle(
                                      shape: WidgetStateProperty.all(
                                        const RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.zero, // 设置为0表示方形
                                        ),
                                      ),
                                    ),
                                    label: const Text('查看'),
                                    icon: const Icon(
                                      Icons.open_in_full,
                                      size: 16,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Theme(
                                  data: ThemeData(
                                      colorScheme: ColorScheme.fromSeed(
                                          seedColor: Colors.blue)),
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      edit(items[index]['diary_code']);
                                    },
                                    style: ButtonStyle(
                                      shape: WidgetStateProperty.all(
                                        const RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.zero, // 设置为0表示方形
                                        ),
                                      ),
                                    ),
                                    label: const Text('编辑'),
                                    icon: const Icon(
                                      Icons.edit,
                                      size: 16,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Theme(
                                  data: ThemeData(
                                      colorScheme: ColorScheme.fromSeed(
                                          seedColor: Colors.red)),
                                  child: ElevatedButton.icon(
                                    onPressed: () {},
                                    style: ButtonStyle(
                                      shape: WidgetStateProperty.all(
                                        const RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.zero, // 设置为0表示方形
                                        ),
                                      ),
                                    ),
                                    label: const Text('删除'),
                                    icon: const Icon(
                                      Icons.delete,
                                      size: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

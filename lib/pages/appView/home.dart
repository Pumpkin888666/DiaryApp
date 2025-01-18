import 'package:flutter/material.dart';
import 'package:diaryapp/funcs/common.dart';
import 'package:provider/provider.dart';
import 'package:diaryapp/models/appView_model.dart';

class home extends StatefulWidget {
  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  Map dayan = {'dayan':'loading'};

  @override
  void initState() {
    super.initState();
    getDayan();
  }

  Future getDayan() async {
    Map d = await Dayan(context);
    setState(() {
      dayan = d;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          SizedBox(
            height: 150,
            width: 300,
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Stack(
                children: [
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(16),
                          bottomLeft: Radius.circular(16),
                        ),
                        child: Container(
                          width: 30, // 设置 Icon 的宽度
                          height: 150, // 设置 Icon 的高度
                          color: Colors.blueAccent, // 背景颜色
                          child: const Center(
                            child: Icon(
                              Icons.tag_faces_sharp,
                              size: 30,
                            ),
                          ),
                        ),
                      ),
                      // 使用 Expanded 确保Column占满剩余空间
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              '今天心情怎么样？',
                              style: TextStyle(fontSize: 24),
                            ),
                            SizedBox(
                              width: 200,
                              child: Tooltip(
                                message: '点击刷新|此Dayan的ID是${dayan['di'].toString()}',
                                child: GestureDetector(
                                  onTap: getDayan, // 捕获点击事件
                                  child: Text(
                                    dayan['dayan'].toString(),
                                    softWrap: true, // 控制自动换行
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.black54
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  // 使用 Align 来确保按钮在右下角
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton.icon(
                        onPressed: () {
                          var appview_model =
                              Provider.of<AppViewModel>(context, listen: false);
                          appview_model.change_select(1);
                        },
                        label: const Text('写个日记'),
                        icon: const Icon(Icons.navigate_next),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

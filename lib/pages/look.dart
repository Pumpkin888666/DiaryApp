import 'dart:convert';
import 'package:diaryapp/widget/PumpkinLoading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:provider/provider.dart';
import 'package:diaryapp/models/appView_model.dart';
import 'package:diaryapp/funcs/requestApi.dart';

class Look extends StatefulWidget {
  const Look({super.key});

  @override
  State<Look> createState() => _LookState();
}

class _LookState extends State<Look> {
  bool _isLoad = true;
  QuillController _controller = QuillController.basic();
  Map _otherDetail = {};

  @override
  void initState() {
    super.initState();
    loadDiary();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void loadDiary() async {
    await Future.delayed(const Duration(seconds: 1));
    var appview_model = Provider.of<AppViewModel>(context, listen: false);
    if (appview_model.diaryCode == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('参数错误 [ld001]'),
          duration: Duration(seconds: 1), // Snackbar 显示的时间
        ),
      );
    }
    Map<String, dynamic> data = {'diary_code': appview_model.diaryCode};
    var response = await requestApi(context, 'get_diary', data = data);
    var res = jsonDecode(response.body);
    if (res['code'] == 0) {
      setState(() {
        _controller.readOnly = true;
        _controller.document =
            Document.fromJson(jsonDecode(res['data']['text']));
        _isLoad = false;
        _otherDetail = res['data']['od'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('日记查看'),
      ),
      body: _isLoad
          ? const Center(
              child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                PumpkinLoading(),
                SizedBox(
                  height: 5,
                ),
                Text('正在查看日记...'),
              ],
            ))
          : Row(
              children: [
                Container(
                  width: 800,
                  child: Column(
                    children: [
                      Expanded(
                        child: QuillEditor.basic(
                          controller: _controller,
                          configurations: const QuillEditorConfigurations(),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 184,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Divider(height: 2.0, indent: 0.0, color: Colors.grey),
                      const SizedBox(
                        height: 10,
                      ),
                      Text('作者:${_otherDetail['author'].toString()}'),
                      const SizedBox(
                        height: 10,
                      ),
                      const Divider(height: 2.0, indent: 0.0, color: Colors.grey),
                      const SizedBox(
                        height: 10,
                      ),
                      Text('创建时间:${_otherDetail['create_time']}'),
                      const SizedBox(
                        height: 10,
                      ),
                      const Divider(height: 2.0, indent: 0.0, color: Colors.grey),
                      const SizedBox(
                        height: 10,
                      ),
                      Text('修改时间:${_otherDetail['update_time']}'),
                    ],
                  ),
                )
              ],
            ),
    );
  }
}

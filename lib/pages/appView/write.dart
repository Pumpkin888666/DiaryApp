import 'dart:convert';
import 'package:diaryapp/models/user_information.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:provider/provider.dart';
import 'package:diaryapp/models/appView_model.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:diaryapp/funcs/common.dart';

class Write extends StatefulWidget {
  const Write({super.key});

  @override
  State<Write> createState() => _WriteState();
}

class _WriteState extends State<Write> {
  final QuillController _controller = QuillController.basic();

  bool _isDraft = true;
  String? _date;
  String? _update_date;

  @override
  void initState() {
    super.initState();
    checkStatus();
  }

  void remove_draft() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('has_draft');
    prefs.remove('draft_t');
    prefs.remove('draft_ut');
    prefs.remove('draft_text');
    prefs.remove('has_draft');
  }

  void checkStatus() async {
    var appview_model = Provider.of<AppViewModel>(context, listen: false);
    bool isEdit = appview_model.isEdit;

    if (isEdit) {
      setState(() {
        _isDraft = false;
      });
      // edit load

      return; // 阻止继续加载草稿
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool has_draft = prefs.getBool('has_draft') ?? false;

    // 检查这个草稿是不是此登录用户的
    String? draft_user_token = prefs.getString('draft_user_token');
    final userInformation =
        Provider.of<UserInformation>(context, listen: false);
    String? UserToken = userInformation.UserToken ?? null;
    if (draft_user_token != UserToken && has_draft == true) {
      // 不是就移除全部缓存
      print('error draft token');
      remove_draft();
      setState(() {
        _date =
            DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now()).toString();
      });
      return;
    }

    if (has_draft == true && isEdit == false) {
      // 判断是否是新的日记 如果是并且还有本地缓存的话就自动加载
      print('load draft');
      DateTime? draft_t =
          DateTime.fromMillisecondsSinceEpoch(prefs.getInt('draft_t') ?? 0);
      DateTime? draft_ut =
          DateTime.fromMillisecondsSinceEpoch(prefs.getInt('draft_ut') ?? 0);
      String draft_text = prefs.getString('draft_text') ?? '';
      setState(() {
        _update_date =
            DateFormat('yyyy-MM-dd HH:mm').format(draft_ut).toString();
        _date = DateFormat('yyyy-MM-dd HH:mm').format(draft_t).toString();
        _isDraft = true;
        _controller.document = Document.fromJson(jsonDecode(draft_text));
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('草稿加载成功 上次编辑时间：${DateFormat('yyyy-MM-dd HH:mm').format(draft_ut).toString()}'),
          duration: Duration(seconds: 1), // Snackbar 显示的时间
        ),
      );
    } else if (has_draft == false && isEdit == false) {
      // 如果没有本地缓存就直接创建一个新的
      setState(() {
        _isDraft = true;
        _date =
            DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now()).toString();
      });
    }
  }

  void save_draft() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final json = jsonEncode(_controller.document.toDelta().toJson());
    prefs.setString('draft_text', json);
    prefs.setInt('draft_t',
        DateFormat('yyyy-MM-dd HH:mm').parse(_date!).millisecondsSinceEpoch);
    prefs.setInt('draft_ut', getTimeM());
    prefs.setBool('has_draft', true);
    final userInformation =
        Provider.of<UserInformation>(context, listen: false);
    String? UserToken = userInformation.UserToken ?? null;
    prefs.setString('draft_user_token', UserToken!);
    print('save draft ok');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('草稿保存成功'),
        duration: Duration(seconds: 1), // Snackbar 显示的时间
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      SizedBox(
        width: 704,
        child: Column(
          children: [
            QuillSimpleToolbar(
              controller: _controller,
              configurations: const QuillSimpleToolbarConfigurations(),
            ),
            Expanded(
              child: QuillEditor.basic(
                controller: _controller,
                configurations: const QuillEditorConfigurations(),
              ),
            ),
          ],
        ),
      ),
      Expanded(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              color: Colors.red,
              height: 300,
              child: ListView(
                children: const [Text('已保存日记显示区')],
              )),
          const SizedBox(
            height: 10,
          ),
          const Divider(height: 2.0, indent: 0.0, color: Colors.grey),
          const SizedBox(
            height: 10,
          ),
          Text('创建日期：$_date'),
          _update_date != null ? Text('上次保存：$_update_date') : Container(),
          SizedBox(
            height: 20,
            child: Tooltip(
              message: _isDraft ? '请先保存到云端再分享哦~' : '与朋友分享你的美好回忆',
              child: ElevatedButton.icon(
                onPressed: _isDraft
                    ? null
                    : () {
                        print('share event');
                      },
                label: const Text('分享'),
                icon: const Icon(
                  Icons.share,
                  size: 16,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          const Divider(height: 2.0, indent: 0.0, color: Colors.grey),
          const SizedBox(
            height: 10,
          ),
          Theme(
            data: ThemeData(
                colorScheme: ColorScheme.fromSeed(seedColor: Colors.green)),
            child: ElevatedButton.icon(
                onPressed: save_draft,
                label: const Text('保存草稿到本地'),
                icon: const Icon(Icons.save)),
          ),
          const SizedBox(
            height: 5,
          ),
          Theme(
            data: ThemeData(
                colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue)),
            child: ElevatedButton.icon(
                onPressed: () {},
                label: const Text('保存日记到云端'),
                icon: const Icon(Icons.cloud_upload_outlined)),
          ),
          const SizedBox(
            height: 5,
          ),
          SizedBox(
            height: 20,
            width: 170,
            child: Theme(
              data: ThemeData(
                  colorScheme: ColorScheme.fromSeed(seedColor: Colors.red)),
              child: ElevatedButton.icon(
                  onPressed: _isDraft
                      ? () {
                          remove_draft();
                          setState(() {
                            _isDraft = true;
                            _controller.document = Document();
                            _update_date = null;
                            _date = DateFormat('yyyy-MM-dd HH:mm')
                                .format(DateTime.now());
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('草稿删除成功'),
                              duration: Duration(seconds: 1), // Snackbar 显示的时间
                            ),
                          );
                        }
                      : null,
                  label: const Text('删除本地草稿'),
                  icon: const Icon(
                    Icons.delete,
                    size: 18,
                  )),
            ),
          ),
        ],
      )),
    ]);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

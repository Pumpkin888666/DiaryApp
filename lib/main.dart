import 'package:flutter/material.dart';
import 'package:flutter_quill/translations.dart';
import 'package:window_manager/window_manager.dart';
import 'package:diaryapp/pages/load.dart';
import 'package:diaryapp/pages/login.dart';
import 'package:diaryapp/pages/look.dart';
import 'package:diaryapp/pages/appView.dart';
import 'package:provider/provider.dart';
import 'package:diaryapp/models/app_ini.dart';
import 'package:diaryapp/models/user_information.dart';
import 'package:diaryapp/models/appView_model.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main(List<String> args) async {
  // WindowsManager初始化
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();
  windowManager.setResizable(false);

  WindowOptions windowOptions = const WindowOptions(
    size: Size(1000, 600),
    center: true,
    backgroundColor: Colors.transparent,
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.normal,
  );
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AppInI()),
        // AppInI Model
        ChangeNotifierProvider(create: (context) => UserInformation()),
        // UserInformation Model
        ChangeNotifierProvider(create: (context) => AppViewModel()),
        // AppView Model
      ],
      child: const App(),
    ),
  );
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.purple),
        useMaterial3: true,
        fontFamily: 'Alibaba-PuHuiTi-Medium',
      ),
      routes: {
        '/': (context) => const Load(),
        '/login': (context) => const Login(),
        '/appview': (context) => const AppView(),
        '/look':(context) => const Look(),
      },
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        FlutterQuillLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', 'US'),  // 支持英文
        Locale('zh', 'CN'),  // 支持中文
      ],
    );
  }
}

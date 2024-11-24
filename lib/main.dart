import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';
import 'package:diaryapp/pages/load.dart';
import 'package:diaryapp/pages/login.dart';
import 'package:diaryapp/pages/Home.dart';
import 'package:provider/provider.dart';
import 'package:diaryapp/models/app_ini.dart';

void main(List<String> args) async {
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
        ChangeNotifierProvider(create: (context) => AppInI()), // AppInI model
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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      routes: {
        '/': (context) => const Load(),
        '/login': (context) => const Login(),
        '/home': (context) => const Home(),
      },
    );
  }
}

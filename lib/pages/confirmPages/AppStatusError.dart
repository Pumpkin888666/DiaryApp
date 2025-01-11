import 'package:diaryapp/funcs/getStrUILength.dart';
import 'package:diaryapp/widget/PumpkinLoading.dart';
import 'package:flutter/material.dart';

class AppStatusError extends StatefulWidget {
  final bool appStatus;
  final bool serverStatus;
  final bool localStatus;
  const AppStatusError({super.key, required this.appStatus, required this.serverStatus, required this.localStatus});

  @override
  State<AppStatusError> createState() => _AppStatusErrorState();
}

class _AppStatusErrorState extends State<AppStatusError> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 60,),
          Center(
            child: Hero(
                tag: 'logoHero',
                child: Image.asset(
                  'assets/logo.png',
                  width: 180,
                  height: 180,
                  fit: BoxFit.cover,
                )),
          ),
          const SizedBox(height: 10,),
          const Text('状态异常',style: TextStyle(fontSize: 30,color: Colors.red),),

          const SizedBox(height: 30,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('服务器状态：',style: TextStyle(fontSize: 20),),
              Text(widget.serverStatus ? '正常' : '异常',style: TextStyle(fontSize: 20,color: widget.serverStatus ? Colors.green : Colors.red),)
            ],
          ),

          const SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('软件状态：',style: TextStyle(fontSize: 20),),
              Text(widget.appStatus ? '正常' : '异常',style: TextStyle(fontSize: 20,color: widget.appStatus ? Colors.green : Colors.red),)
            ],
          ),

          const SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('本地状态：',style: TextStyle(fontSize: 20),),
              Text(widget.localStatus ? '正常' : '异常',style: TextStyle(fontSize: 20,color: widget.localStatus ? Colors.green : Colors.red),)
            ],
          ),

          const SizedBox(
            height: 10,
          ),

          ElevatedButton.icon(onPressed: (){
            Navigator.pushReplacementNamed(context, '/');
          }, label: const Text('重新尝试'),icon: const Icon(Icons.restart_alt_outlined),)

        ],
      ),
    );
  }
}

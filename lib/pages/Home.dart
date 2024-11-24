import 'package:flutter/material.dart';

class Home extends StatefulWidget{
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Home Page',style: TextStyle(fontSize: 30),),
            const SizedBox(height: 10,),
            ElevatedButton(onPressed: (){
              Navigator.pushNamed(context, '/login');
            }, child: const Text('Return')),
          ],
        ),
      ),
    );
  }
}
import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:ghulam_app/screens/beranda.dart';
import 'package:ghulam_app/utils/constants.dart';
import 'package:ghulam_app/screens/welcome.dart';

class SplashScreenPage extends StatefulWidget{
  @override
  _SplashScreenPageState createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  @override
  void initState(){
    super.initState();
    startSpashScreen();
  }
  startSpashScreen() async {
    var duration = const Duration(seconds: 5);
    return Timer(duration, (){
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_){
            return HomePage();
          })
      );
    });
  }
  @override
  Widget build(BuildContext context){
    return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
            child:
            Padding(
              padding: const EdgeInsets.only(left: 0, right:0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('images/logo.png', width: (1 / 2) * MediaQuery.of(context).size.width,),
                  const SizedBox(height: 15),
                  Text('BeShop', style: TextStyle(color: kPrimaryColor, fontSize: 30, fontWeight: FontWeight.bold),)
                ],
              ),
            )
        )
    );
  }
}
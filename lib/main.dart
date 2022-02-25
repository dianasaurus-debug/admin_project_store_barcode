import 'package:ghulam_app/screens/splash_screen_view.dart';
import 'package:flutter/material.dart';

void main(){
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Splash Screen',
    home: SplashScreenPage(),
    theme: ThemeData(fontFamily: 'Quicksand', scaffoldBackgroundColor: Colors.white),

  ));
}
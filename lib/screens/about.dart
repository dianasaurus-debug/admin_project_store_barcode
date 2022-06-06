
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:ghulam_app/utils/constants.dart';


class AboutPage extends StatefulWidget {
  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.clear, color: kPrimaryLightColor, size: 20),
            onPressed: () => Navigator.of(context).pop(),
          ),
          centerTitle: true,
          title:Text('Tentang Kami', style: TextStyle(color: Colors.black, fontSize : 20),),
          elevation: 0,
          backgroundColor: Color(0xffffffff),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children : [
              Center(
                child : Image.asset('images/about_us.jpg')
              ),
              Text('BeStore', style: TextStyle(fontSize : 25, fontWeight: FontWeight.bold, color : kPrimaryColor)),
              SizedBox(height : 15),
              Text(textAbout, style: TextStyle(fontSize : 15, color : Colors.black), textAlign: TextAlign.justify,),
            ]
          ),
        ));
  }
}

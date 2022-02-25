import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:ghulam_app/utils/constants.dart';
import 'package:ghulam_app/widgets/bottom_navbar.dart';


class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.clear, color: Colors.grey, size: 40),
            onPressed: () => Navigator.of(context).pop(),
          ),
          centerTitle: true,
          title: Text('History', style: TextStyle(color: Colors.black, fontSize : 20),),
          elevation: 0,
          backgroundColor: Color(0xffffffff),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.only(top : 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                  padding: const EdgeInsets.only(left: 30, right: 30),
                  child: Text('Ini halaman history')
              )
            ],
          ),
        ),
      bottomNavigationBar: BottomNavbar(current : 2),
    );
  }
}

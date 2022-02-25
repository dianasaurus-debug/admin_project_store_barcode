import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ghulam_app/screens/cart.dart';
import 'package:ghulam_app/screens/daftar_favorit.dart';
import 'package:ghulam_app/screens/login_index.dart';
import 'package:ghulam_app/screens/register_index.dart';
import 'package:ghulam_app/utils/constants.dart';


class SecondAppBar extends StatelessWidget implements PreferredSizeWidget {
  final AppBar appBar;
  final isAuth;
  final title;

  /// you can add more fields that meet your needs

  const SecondAppBar({Key? key, required this.appBar, required this.isAuth, required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {

    return AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: kPrimaryLightColor, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        elevation: 0,
        centerTitle: true,
        title:Text('${title}', style: TextStyle(color: Colors.black, fontSize : 20),),
        actions:  (isAuth ==false) ? [
        IconButton(
            icon: Icon(Icons.login,
                color: kPrimaryLightColor),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginIndexPage()),
              );
            }),
        IconButton(
            icon: Icon(Icons.app_registration,
                color: kPrimaryLightColor),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RegisterIndexPage()),
              );
            }),
        ] : [
    IconButton(
    icon: Icon(Icons.favorite,
        color: Colors.pink),
    onPressed: () {
    Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => FavoritPage()),
    );
    }),
    IconButton(
    icon: Icon(Icons.shopping_cart,
    color: kPrimaryLightColor),
    onPressed: () {
    Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => CartPage()),
    );
    }),
    ],
    );
  }

  @override
  Size get preferredSize => new Size.fromHeight(appBar.preferredSize.height);
}
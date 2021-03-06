import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ghulam_app/screens/cart.dart';
import 'package:ghulam_app/screens/daftar_favorit.dart';
import 'package:ghulam_app/screens/login_index.dart';
import 'package:ghulam_app/screens/register_index.dart';
import 'package:ghulam_app/utils/constants.dart';


class BaseAppBar extends StatelessWidget implements PreferredSizeWidget {
  final AppBar appBar;
  final isAuth;

  /// you can add more fields that meet your needs

  const BaseAppBar({Key? key, required this.appBar, required this.isAuth})
      : super(key: key);

  @override
  Widget build(BuildContext context) {

    return AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        elevation: 0,
        title:
        Container(
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(20)),
          child: TextFormField(
            decoration: InputDecoration(
              icon: Icon(CupertinoIcons.search, color: kPrimaryLightColor),
              border: InputBorder.none,
              hintText: 'Cari',
              // contentPadding:
              //     EdgeInsets.symmetric(horizontal: 5, vertical: 1),
            ),
          ),
        ),
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
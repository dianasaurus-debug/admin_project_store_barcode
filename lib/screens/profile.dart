import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:ghulam_app/controllers/auth_controller.dart';
import 'package:ghulam_app/models/user.dart';
import 'package:ghulam_app/screens/about.dart';
import 'package:ghulam_app/screens/edit_profile.dart';
import 'package:ghulam_app/screens/faq.dart';
import 'package:ghulam_app/screens/forgot_password.dart';
import 'package:ghulam_app/screens/login_index.dart';
import 'package:ghulam_app/screens/register_index.dart';
import 'package:ghulam_app/utils/constants.dart';
import 'package:ghulam_app/widgets/bottom_navbar.dart';
import 'package:ghulam_app/widgets/second_app_bar.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  int isAuth = 2;
  bool authAppBar = false;

  void _checkIfLoggedIn() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');

    if (token != null) {
      setState(() {
        isAuth = 1;
        authAppBar = true;
      });
    } else {
      setState(() {
        isAuth = 0;
        authAppBar = false;
      });
    }
  }



  final List<Widget> listMenu = [
    ListTile(
        leading: Icon(Icons.person, color: Colors.black),
        title: Text(
          "Edit Profil",
          style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold),
        ),
        // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),
        trailing: Icon(Icons.keyboard_arrow_right,
            color: kPrimaryLightColor, size: 30.0)),
    ListTile(
        leading: Icon(Icons.lock, color: Colors.black),
        title: Text(
          "Ubah Password",
          style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold),
        ),
        // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),
        trailing: Icon(Icons.keyboard_arrow_right,
            color: kPrimaryLightColor, size: 30.0)),
    ListTile(
        leading: Icon(Icons.question_answer, color: Colors.black),
        title: Text(
          "FAQ",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),
        trailing: Icon(Icons.keyboard_arrow_right,
            color: kPrimaryLightColor, size: 30.0)),
    ListTile(
        leading: Icon(Icons.store, color: Colors.black),
        title: Text(
          "Tentang",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),
        trailing: Icon(Icons.keyboard_arrow_right,
            color: kPrimaryLightColor, size: 30.0)),
    ListTile(
        leading: Icon(Icons.logout, color: Colors.black),
        title: Text(
          "Logout",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),
        trailing: Icon(Icons.keyboard_arrow_right,
            color: kPrimaryLightColor, size: 30.0))
  ];
  final List<Widget> listPages = [
    EditProfile(),
    PasswordUpdate(),
    BantuanPage(),
    AboutPage()
  ];
  late Future<User> futureDetailUser;

  @override
  void initState() {
    // TODO: implement initState
    _checkIfLoggedIn();
    futureDetailUser = AuthController().getProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SecondAppBar(
        appBar: AppBar(),
        isAuth: authAppBar,
        title: 'Profil',
      ),
      body: isAuth != 2
          ? (isAuth == 1
              ? FutureBuilder<User>(
                  future: futureDetailUser,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return SingleChildScrollView(
                        padding: EdgeInsets.only(top: 15),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Padding(
                                padding: const EdgeInsets.only(
                                    left: 30, right: 30, bottom: 15),
                                child: Column(children: [
                                  Row(children: [
                                    if (snapshot.data!.photo_path != null)
                                      CircleAvatar(
                                        radius: 43,
                                        backgroundColor: kPrimaryLightColor,
                                        child: CircleAvatar(
                                          radius: 40,
                                          backgroundImage: NetworkImage(
                                              IMG_URL +
                                                  snapshot.data!.photo_path),
                                        ),
                                      )
                                    else
                                      CircleAvatar(
                                        radius: 43,
                                        backgroundColor: kPrimaryLightColor,
                                        child: CircleAvatar(
                                          radius: 40,
                                          backgroundImage: AssetImage('images/user.png'),
                                        ),
                                      ),
                                    const SizedBox(width: 15),
                                    Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                              'Hello, ${snapshot.data!.first_name}',
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                  color: kPrimaryColor,
                                                  fontSize: 18)),
                                          const SizedBox(height: 5),
                                          Row(children: [
                                            Icon(Icons.email),
                                            const SizedBox(width: 3),
                                            Text(
                                              '${snapshot.data!.email}',
                                              style: TextStyle(
                                                  color: kPrimaryColor,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ]),
                                        ])
                                  ]),
                                ])),
                            Container(
                                padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                                alignment: Alignment.centerLeft,
                                margin: EdgeInsets.only(top: 15),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(30),
                                      topLeft: Radius.circular(30)),
                                  boxShadow: <BoxShadow>[
                                    BoxShadow(
                                        color: Colors.grey.withOpacity(0.2),
                                        blurRadius: 0.5,
                                        spreadRadius: 0.1,
                                        offset: Offset(0.0, -3))
                                  ],
                                ),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            RichText(
                                              text: TextSpan(
                                                children: [
                                                  WidgetSpan(
                                                    child: Icon(
                                                        Icons
                                                            .monetization_on_rounded,
                                                        size: 25,
                                                        color:
                                                            kPrimaryLightColor),
                                                  ),
                                                  TextSpan(
                                                      text: snapshot.data!
                                                                  .saldo !=
                                                              null
                                                          ? 'Rp. ${snapshot.data!.saldo!.jumlah}'
                                                          : 'Belum isi saldo',
                                                      style: TextStyle(
                                                          color: Colors.black54,
                                                          fontSize: 17)),
                                                ],
                                              ),
                                            ),
                                            RichText(
                                              text: TextSpan(
                                                children: [
                                                  TextSpan(
                                                      text: "Detail saldo ",
                                                      style: TextStyle(
                                                          color: Colors.grey,
                                                          fontSize: 15)),
                                                  WidgetSpan(
                                                    child: Icon(
                                                        Icons
                                                            .arrow_forward_ios_rounded,
                                                        size: 13,
                                                        color: Colors.grey),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ]),
                                      SizedBox(height: 10),
                                      ListView.separated(
                                          itemCount: listMenu.length,
                                          shrinkWrap: true,
                                          itemBuilder: (context, index) {
                                            return GestureDetector(
                                                onTap: () {
                                                  if (index ==
                                                      (listMenu.length - 1)) {
                                                    logout();
                                                  } else {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              listPages[index]),
                                                    );
                                                  }
                                                },
                                                child: listMenu[index]);
                                          },
                                          // The separators
                                          separatorBuilder: (context, index) {
                                            return Divider(
                                              color: kPrimaryLightColor,
                                            );
                                          }),
                                    ]))
                          ],
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Text('${snapshot.error}');
                    }
                    // By default, show a loading spinner.
                    return Center(
                        child: CircularProgressIndicator(
                      backgroundColor: Colors.green,
                    ));
                  },
                )
              : Center(
                  child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.login, size: 100, color: kPrimaryColor),
                            SizedBox(height: 10),
                            Text(
                                'Silahkan login atau daftar untuk melihat profil',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center),
                            SizedBox(height: 20),
                            GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => LoginIndexPage()),
                                  );
                                },
                                child: Container(
                                  height: 50,
                                  margin: EdgeInsets.symmetric(horizontal: 50),
                                  decoration: BoxDecoration(
                                    color: kPrimaryColor,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Login',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                )),
                            SizedBox(height: 10),
                            GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            RegisterIndexPage()),
                                  );
                                },
                                child: Container(
                                  height: 50,
                                  margin: EdgeInsets.symmetric(horizontal: 50),
                                  decoration: BoxDecoration(
                                    color: kPrimaryColor,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Daftar',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                )),
                          ]))))
          : Center(
              child: CircularProgressIndicator(
              backgroundColor: Colors.green,
            )),
      bottomNavigationBar: BottomNavbar(current: 3),
    );
  }
  void logout() async {
    var res = await AuthController().postData({}, '/logout');
    var body = json.decode(res.body);
    print(body);
    if (body['success']) {

      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.remove('user');
      localStorage.remove('token');
      Alert(
        context: context,
        type: AlertType.success,
        title: "Berhasil!",
        desc: "Anda telah keluar dari akun.",
        buttons: [
          DialogButton(
            child: Text(
              "OK",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () =>  Navigator.push(
              context,
              new MaterialPageRoute(builder: (context) => LoginIndexPage()),
            ),
            width: 120,
          )
        ],
      ).show();
    } else {
      Alert(
        context: context,
        type: AlertType.error,
        title: "Gagal logout!",
        desc: "Err ${body['message']}",
        buttons: [
          DialogButton(
            child: Text(
              "OK",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () => Navigator.pop(context),
            width: 120,
          )
        ],
      ).show();
    }
  }
}

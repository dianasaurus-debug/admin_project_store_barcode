import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ghulam_app/controllers/auth_controller.dart';
import 'package:ghulam_app/screens/profile.dart';
import 'package:ghulam_app/utils/constants.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class PasswordUpdate extends StatefulWidget {
  @override
  _PasswordUpdateState createState() => _PasswordUpdateState();
}

class _PasswordUpdateState extends State<PasswordUpdate> {
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  final _globalKey = GlobalKey<ScaffoldMessengerState>();

  var password;
  var new_password;
  var alamat;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xffffffff),
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            'Update Password',
            style: TextStyle(color: Colors.black),
          ),
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
          elevation: 0,
        ),
        body: SingleChildScrollView(
            child: Padding(
                padding: EdgeInsets.all(20),
                child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        TextFormField(
                          decoration: InputDecoration(
                            label: Text('Masukkan password Lama',
                                style: TextStyle(
                                    fontSize: 16,
                                    color: kPrimaryColor)),
                            hintStyle: TextStyle(
                              color: kPrimaryColor,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          obscureText: true,
                          validator: (passwordValue) {
                            if (passwordValue!.isEmpty) {
                              return 'Password lama tidak boleh kosong';
                            }
                            password = passwordValue;
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            label: Text('Masukkan password Baru',
                                style: TextStyle(
                                    fontSize: 16,
                                    color: kPrimaryColor)),
                            hintStyle: TextStyle(
                              color: kPrimaryColor,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          obscureText: true,
                          validator: (passwordValue) {
                            if (passwordValue!.isEmpty) {
                              return 'Password baru tidak boleh kosong';
                            }
                            new_password = passwordValue;
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        GestureDetector(
                            onTap: () {
                              if (_formKey.currentState!.validate()) {
                                _updatePassword();
                              }
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
                                  _isLoading ? 'Proccessing...' : 'Update',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ))
                      ],
                    )))));
  }

  void _updatePassword() async {
    setState(() {
      _isLoading = true;
    });
    var data = {
      'password': password,
      'new_password': new_password,
      '_method': 'PUT'
    };

    var res = await AuthController().postData(data, '/change/password');
    var body = json.decode(res.body);
    print(body);
    if (body['success']) {
      Alert(
        context: context,
        type: AlertType.success,
        title: "Berhasil!",
        desc: "Password Anda telah diperbaharui.",
        buttons: [
          DialogButton(
            child: Text(
              "OK",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () =>  Navigator.push(
              context,
              new MaterialPageRoute(builder: (context) => ProfilePage()),
            ),
            width: 120,
          )
        ],
      ).show();
    } else {
      Alert(
        context: context,
        type: AlertType.error,
        title: "Gagal Update!",
        desc: "Pastikan password lama benar.",
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
    setState(() {
      _isLoading = false;
    });
  }
}
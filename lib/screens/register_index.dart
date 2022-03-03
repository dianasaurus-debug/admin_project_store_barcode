import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:ghulam_app/controllers/auth_controller.dart';
import 'package:ghulam_app/screens/beranda.dart';
import 'package:ghulam_app/screens/input_otp.dart';
import 'package:ghulam_app/utils/constants.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';


class RegisterIndexPage extends StatefulWidget {
  @override
  _RegisterIndexPageState createState() => _RegisterIndexPageState();
}

class _RegisterIndexPageState extends State<RegisterIndexPage> {
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  var email;
  var password;
  var nama_lengkap;
  var phone;

  @override
  Widget build(BuildContext context) {
    final ButtonStyle styleButton = ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
      onPrimary: Colors.white,
      primary: kPrimaryColor,
      padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
      shape: new RoundedRectangleBorder(
        borderRadius: new BorderRadius.circular(30.0),
      ),
    );
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.clear, color: kPrimaryLightColor, size: 20),
            onPressed: () => Navigator.of(context).pop(),
          ),
          elevation: 0,
          backgroundColor: Color(0xffffffff),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                  padding: const EdgeInsets.only(left: 30, right: 30),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>
                      [
                        SizedBox(
                          width: (280 / 375) * MediaQuery.of(context).size.width,
                          child: AspectRatio(
                            aspectRatio: 1.5,
                            child: Image.asset('images/signup.png'),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                              'Daftar',
                              textAlign: TextAlign.left,
                              style: TextStyle(fontWeight: FontWeight.w700, color: kPrimaryColor, fontSize: 30)
                          ),
                        ),
                        const SizedBox(height: 20),
                        Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              TextFormField(
                                // The validator receives the text that the user has entered.
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Nama lengkap tidak boleh kosong';
                                  }
                                  nama_lengkap = value;

                                  return null;
                                },
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  icon: Icon(Icons.person),
                                  suffixIcon: InkWell(
                                      child: Icon(Icons.clear, size: 14), onTap: () {
                                     nama_lengkap = '';
                                  }),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: kPrimaryLightColor, width: 2),
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: kPrimaryLightColor, width: 2),
                                  ),
                                  errorBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red, width: 2),
                                  ),
                                  focusedErrorBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red, width: 2),
                                  ),
                                  hintText: 'Nama lengkap',
                                ),

                              ),
                              const SizedBox(height: 15),
                              TextFormField(

                                // The validator receives the text that the user has entered.
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'E-Mail tidak boleh kosong';
                                  }
                                  email = value;

                                  return null;
                                },
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  icon: Icon(Icons.email),
                                  suffixIcon: InkWell(
                                      child: Icon(Icons.clear, size: 14), onTap: () {
                                    email = '';
                                  }),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: kPrimaryLightColor, width: 2),
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: kPrimaryLightColor, width: 2),
                                  ),
                                  errorBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red, width: 2),
                                  ),
                                  focusedErrorBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red, width: 2),
                                  ),
                                  hintText: 'E-Mail',
                                ),

                              ),
                              const SizedBox(height: 15),
                              TextFormField(

                                // The validator receives the text that the user has entered.
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'E-Mail tidak boleh kosong';
                                  }
                                  phone = value;

                                  return null;
                                },
                                keyboardType: TextInputType.phone,
                                decoration: InputDecoration(
                                  icon: Icon(Icons.phone),
                                  suffixIcon: InkWell(
                                      child: Icon(Icons.clear, size: 14), onTap: () {
                                    phone = '';
                                  }),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: kPrimaryLightColor, width: 2),
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: kPrimaryLightColor, width: 2),
                                  ),
                                  errorBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red, width: 2),
                                  ),
                                  focusedErrorBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red, width: 2),
                                  ),
                                  hintText: 'Nomor telepon',
                                ),

                              ),
                              const SizedBox(height: 15),
                              TextFormField(
                                // The validator receives the text that the user has entered.
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Password tidak boleh kosong';
                                  }
                                  password = value;
                                  return null;
                                },
                                keyboardType: TextInputType.text,
                                obscureText: true,
                                decoration: InputDecoration(
                                  icon: Icon(Icons.lock),
                                  suffixIcon: InkWell(
                                      child: Icon(Icons.clear, size: 14), onTap: () {
                                    password = '';
                                  }),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: kPrimaryLightColor, width: 2),
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: kPrimaryLightColor, width: 2),
                                  ),
                                  errorBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red, width: 2),
                                  ),
                                  focusedErrorBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red, width: 2),
                                  ),
                                  hintText: 'Password',
                                ),

                              ),
                              const SizedBox(height: 30),

                              ElevatedButton(
                                style: styleButton,
                                onPressed: () {
                                  // Validate returns true if the form is valid, or false otherwise.
                                  if (_formKey.currentState!.validate()) {
                                    // If the form is valid, display a snackbar. In the real world,
                                    // you'd often call a server or save the information in a database.
                                    _register();
                                  }
                                },
                                child: Text(
                                    _isLoading? 'Memuat...' : 'Daftar',
                                    style : TextStyle(fontSize : 16)),
                              ),

                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            text: 'Sudah punya akun? ',
                            style: TextStyle(color: Colors.black, fontSize: 15),
                            children: const <TextSpan>[
                              TextSpan(text: 'Login', style: TextStyle(fontWeight: FontWeight.bold, color: kPrimaryColor, fontSize: 15)),
                            ],
                          ),
                        ),

                      ]
                  )
              )
            ],
          ),
        ));
  }
  void _register() async{
    setState(() {
      _isLoading = true;
    });
    var lastName = '';
    var parts  = nama_lengkap.split(" ");
    var firstName = parts[0];
    parts.removeAt(0);
    lastName = parts.join(" ");
    var data = {};
    if(lastName!=''){
      data = {
        'email' : email,
        'first_name' : firstName,
        'last_name' : lastName,
        'password' : password,
        'phone' : phone
      };
    } else {
      data = {
        'email' : email,
        'first_name' : firstName,
        'password' : password,
        'phone' : phone
      };
    }

    var res = await AuthController().authData(data, '/register');
    var body = json.decode(res.body);
    if(body['success']){
      Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (context) => InputOTP(email: email)
        ),
      );
    }else{
      Alert(
        context: context,
        type: AlertType.error,
        title: "Gagal Daftar!",
        desc: body['message'],
        buttons: [
          DialogButton(
            child: const Text(
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

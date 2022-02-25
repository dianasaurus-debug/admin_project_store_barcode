import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:ghulam_app/controllers/auth_controller.dart';
import 'package:ghulam_app/screens/beranda.dart';
import 'package:ghulam_app/utils/constants.dart';
import 'package:ghulam_app/widgets/bottom_navbar.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';


class InputOTP extends StatefulWidget {
  final String email;

  const InputOTP({Key? key, required this.email}) : super(key: key);

  @override
  _InputOTPState createState() => _InputOTPState();
}

class _InputOTPState extends State<InputOTP> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  var kode_otp;
  final ButtonStyle styleButton = ElevatedButton.styleFrom(
    textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
    onPrimary: Colors.white,
    primary: kPrimaryColor,
    padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
    shape: new RoundedRectangleBorder(
      borderRadius: new BorderRadius.circular(30.0),
    ),
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
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
                            child: Image.asset('images/otp.png'),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Align(
                          alignment: Alignment.centerLeft,
                          child:
                          Column(
                            children : [
                              Text(
                                  'Masukkan OTP',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(fontWeight: FontWeight.w700, color: kPrimaryColor, fontSize: 30)
                              ),
                              Text(
                                  'Masukkan 6 digit kode yang telah kami kirim ke E-Mail ${widget.email}',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(fontWeight: FontWeight.normal, color: Colors.grey, fontSize: 15)
                              ),
                            ]
                          )
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
                                    return 'Kode OTP tidak boleh kosong';
                                  }
                                  kode_otp = value;

                                  return null;
                                },
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  icon: Icon(Icons.password),
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
                                  hintText: 'Masukkan kode OTP',
                                ),

                              ),
                              const SizedBox(height: 10),
                              ElevatedButton(
                                style: styleButton,
                                onPressed: () {
                                  // Validate returns true if the form is valid, or false otherwise.
                                  if (_formKey.currentState!.validate()) {
                                    // If the form is valid, display a snackbar. In the real world,
                                    // you'd often call a server or save the information in a database.
                                    _postOtp();
                                  }
                                },
                                child: Text(
                                    _isLoading? 'Memuat...' : 'Kirim',
                                    style : TextStyle(fontSize : 16)),
                              ),

                            ],
                          ),
                        ),
                        const SizedBox(height: 30),
                        RichText(
                          textAlign: TextAlign.left,
                          text: TextSpan(
                            text: 'Kode OTP akan bertahan selama ',
                            style: TextStyle(color: Colors.black, fontSize: 15),
                            children: const <TextSpan>[
                              TextSpan(text: '10 menit', style: TextStyle(fontWeight: FontWeight.bold, color: kPrimaryColor, fontSize: 15)),
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
  void _postOtp() async{
    setState(() {
      _isLoading = true;
    });
    var data = {
      'kode_otp' : kode_otp,
    };

    var res = await AuthController().putData(data, '/verify/otp');
    var body = json.decode(res.body);
    print(body);
    if(body['success']){
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.setString('token', json.encode(body['access_token'])); //Simpan token di local storage
      localStorage.setString('user', json.encode(body['data']));
      Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (context) => HomePage()
        ),
      );
    }else{
      Alert(
        context: context,
        type: AlertType.error,
        title: "Gagal Verifikasi!",
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

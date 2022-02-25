// import 'package:darurat_app/login_pemilik_kos.dart';
// import 'package:darurat_app/register_pemilik_kos.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:ghulam_app/screens/login_index.dart';
import 'package:ghulam_app/screens/register_index.dart';
import 'package:ghulam_app/utils/constants.dart';

class WelcomePage extends StatelessWidget {
  Widget build(BuildContext context) {
    final ButtonStyle styleButton = ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
      onPrimary: Colors.black,
      padding: EdgeInsets.fromLTRB(100, 15, 100, 15),
      side: BorderSide(color: kPrimaryColor),
    );
    return Scaffold(
        body: Container(
          color: Colors.white,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                  padding: const EdgeInsets.only(left: 30, right: 30),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>
                      [
                        Text('Welcome',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 30,
                                color: Colors.black,
                                fontFamily: 'Roboto')
                        ),
                        const SizedBox(height: 30),
                        OutlinedButton(
                          onPressed: () {
                            Route route = MaterialPageRoute(
                                builder: (context) => LoginIndexPage());
                            Navigator.push(context, route);
                          },
                          style: styleButton,
                          child: const Text('LOGIN'),
                        ),
                        const SizedBox(height: 20),
                        OutlinedButton(
                          style: styleButton,
                          onPressed: () {
                            Route route = MaterialPageRoute(
                                builder: (context) => RegisterIndexPage());
                            Navigator.push(context, route);
                          },
                          child: const Text('REGISTER'),
                        ),
                      ]))
            ],
          ),
        ));
  }
}

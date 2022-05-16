import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ghulam_app/controllers/auth_controller.dart';
import 'package:ghulam_app/screens/cart.dart';
import 'package:ghulam_app/screens/login_index.dart';
import 'package:ghulam_app/screens/register_index.dart';
import 'package:ghulam_app/utils/constants.dart';
import 'package:ghulam_app/widgets/bottom_navbar.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ScanPage extends StatefulWidget {
  @override
  _ScanPageState createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  final _formKey = GlobalKey<FormState>();
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  var array_of_kode_barang = [];
  bool isAuth = false;
  var _isLoading = false;

  void _checkIfLoggedIn() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');
    if (token != null) {
      setState(() {
        _isLoading = true;
      });

      var res = await AuthController().getData('/profile');
      var body = json.decode(res.body);
      if (body['success']) {
        setState(() {
          isAuth = true;
        });
      } else {
        setState(() {
          isAuth = true;
        });
        showSnackBar('Silahkan login terlebih dahulu');
        Navigator.push(
          context,
          new MaterialPageRoute(builder: (context) => LoginIndexPage()),
        );
      }
      setState(() {
        _isLoading = false;
      });

    }
    else {
      setState(() {
        isAuth = false;
      });
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    _checkIfLoggedIn();

  }
  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  // @override
  // void reassemble() {
  //   super.reassemble();
  //   if (Platform.isAndroid) {
  //     controller!.pauseCamera();
  //   }
  //   controller!.resumeCamera();
  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.clear, color: Colors.grey, size: 40),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        title: Text('Scan Barang', style: TextStyle(color: Colors.black, fontSize : 20),),
        elevation: 0,
        backgroundColor: Color(0xffffffff),
      ),
      body:
      isAuth != 2 ? (isAuth==1 ?
      Column(
        children: <Widget>[
          Expanded(flex: 4, child: _buildQrView(context)), //tampilan qr code
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.all(8),
                      child: ElevatedButton(
                          onPressed: () async {
                            await controller?.toggleFlash();
                            setState(() {});
                          },
                          child: FutureBuilder(
                            future: controller?.getFlashStatus(),
                            builder: (context, snapshot) {
                              return snapshot.data == true ? Icon(Icons.flash_on) : Icon(Icons.flash_off);
                            },
                          )),
                    ),
                    Container(
                      margin: const EdgeInsets.all(8),
                      child: ElevatedButton(
                          onPressed: () async {
                            await controller?.flipCamera();
                            setState(() {});
                          },
                          child: FutureBuilder(
                            future: controller?.getCameraInfo(),
                            builder: (context, snapshot) {
                              if (snapshot.data != null) {
                                return snapshot.data == 'back' ? Icon(Icons.camera_front) : Icon(Icons.camera_front);
                              } else {
                                return const Text('loading');
                              }
                            },
                          )),
                    )
                  ],
                ),
                ElevatedButton(
                    onPressed: () {
                      // _showModalBottomSheet();
                    },
                    style: ElevatedButton.styleFrom(
                      primary: kPrimaryLightColor,
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0),
                      ),
                      padding: EdgeInsets.all(8),
                    ),
                    child: Text('Daftar Barang',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold)))
              ],
            ),
          ) //tampilan tombol bawah qr code
        ],
      )
          : Center(child: Padding(
          padding : EdgeInsets.all(20),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.login,
                    size: 100,
                    color: kPrimaryColor),
                SizedBox(
                    height : 10
                ),
                Text('Silahkan login atau daftar untuk scan dan beli barang', style: TextStyle(fontSize: 20, fontWeight : FontWeight.bold, ), textAlign: TextAlign.center),
                SizedBox(
                    height : 20
                ),
                GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginIndexPage()),
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
                SizedBox(
                    height : 10
                ),
                GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RegisterIndexPage()),
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

              ])
      ))) : Center(child: CircularProgressIndicator(backgroundColor: Colors.green,))

      ,
      bottomNavigationBar: BottomNavbar(current : 1),
    );
  }
  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
        MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) { //saat qr view bisa nangkep codenya
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
      if(result!=null){
        controller.pauseCamera();
        print(result);
        setState(() {
          array_of_kode_barang.add(result);
        });
          // controller.pauseCamera();
        //   Navigator.of(context).push(MaterialPageRoute(
        //     builder: (context) => CartPage(),
        //   ));
        // // if(widget.kodeBarang!=result!.code){
        // //   controller.pauseCamera();
        // //   showAlertDialog(context);
        // // } else {
        // //   controller.pauseCamera();
        // //   Navigator.of(context).push(MaterialPageRoute(
        // //     builder: (context) => ProductDetail(kodeBarang : result!.code),
        // //   ));
        // // }
        showSnackBar('Barang berhasil ditambahkan ke daftar!');
        print(array_of_kode_barang);
      }
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  showAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () {
        controller?.resumeCamera();
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Kode tidak cocok!"),
      content: Text("Pastikan Anda scan QR Code yang sesuai."),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void showSnackBar(message) {
    final snackBarContent = SnackBar(
      behavior: SnackBarBehavior.floating,
      content: Text("${message}"),
      action: SnackBarAction(
          label: 'Tutup', onPressed: _scaffoldKey.currentState!.hideCurrentSnackBar),
    );
    _scaffoldKey.currentState!.showSnackBar(snackBarContent);
  }


  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}

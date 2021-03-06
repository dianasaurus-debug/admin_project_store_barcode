import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ghulam_app/controllers/auth_controller.dart';
import 'package:ghulam_app/models/product.dart';
import 'package:ghulam_app/screens/cart.dart';
import 'package:ghulam_app/utils/constants.dart';
import 'package:ghulam_app/widgets/bottom_navbar.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:rflutter_alert/rflutter_alert.dart';


class ScanByCode extends StatefulWidget {
  final Product? product;

  const ScanByCode({Key? key, required this.product}) : super(key: key);

  @override
  _ScanByCodeState createState() => _ScanByCodeState();
}

class _ScanByCodeState extends State<ScanByCode> {
  final _formKey = GlobalKey<FormState>();
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  var array_of_kode_barang = [];
  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }
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
        title: Text('Scan Produk ${widget.product!.nama_barang}', style: TextStyle(color: Colors.black, fontSize : 15),),
        elevation: 0,
        backgroundColor: Color(0xffffffff),
      ),
      body: Column(
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
              ],
            ),
          ) //tampilan tombol bawah qr code
        ],
      ),
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
      print('im listening');
      setState(() {
        result = scanData;
      });
      if(result!=null){
        if(widget.product!.kode_barang!=result!.code){
          controller.pauseCamera();
          showAlertDialog(context);
        } else {
          controller.stopCamera();
          scan();
        }
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
  void scan() async{
    var res = await AuthController().putDataAuth({}, '/cart/scan/${widget.product!.id}');
    var body = json.decode(res.body);
    print(body);
    if(body['success']){
      showSnackBar('Berhasil scan produk!');
      Future.delayed(Duration(milliseconds: 200), () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => CartPage(),
        ));
      });

    }else{
      Alert(
        context: context,
        type: AlertType.error,
        title: "Gagal scan produk!",
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
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}

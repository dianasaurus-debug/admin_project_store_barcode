import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:ghulam_app/controllers/auth_controller.dart';
import 'package:ghulam_app/controllers/product_controller.dart';
import 'package:ghulam_app/models/product.dart';
import 'package:ghulam_app/screens/cart.dart';
import 'package:ghulam_app/screens/login_index.dart';
import 'package:ghulam_app/utils/constants.dart';
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetailPage extends StatefulWidget {
  final Product? product;
  const DetailPage({Key? key, required this.product}) : super(key: key);
  @override
  State<StatefulWidget> createState() => new DetailPageState();
}

class DetailPageState extends State<DetailPage> {
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool _isLoading = false;

  var isPressed = false;
  int _jumlahBarang = 0;
  int totalBayar = 0;
  int isAuth = 2;
  bool authAppBar = false;

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
          isAuth = 1;
          authAppBar = true;
        });
      } else {
        setState(() {
          isAuth = 1;
          authAppBar = true;
        });
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginIndexPage()),
        );
      }
      setState(() {
        _isLoading = false;
      });

    } else {
      setState(() {
        isAuth = 0;
        authAppBar = false;
      });
    }
  }
  void _is_in_wishlist(id) async {
    var res = await AuthController().getData('/wishlist/exist/${id}');
    var body = json.decode(res.body);
    if (body['success']) {
      if(body['is_exist']){
        setState(() {
          isPressed = true;
        });
      } else {
        setState(() {
          isPressed = false;
        });
      }
         } else {
      showSnackBar('Gagal mendapatkan data wishlist');
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _checkIfLoggedIn();
    _is_in_wishlist(widget.product!.id);
  }

  @override
  Widget build(BuildContext context) {
    final formatCurrency =
        new NumberFormat.simpleCurrency(locale: 'id_ID', decimalDigits: 0);
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          icon:
              Icon(Icons.arrow_back_ios_rounded, color: Colors.grey, size: 25),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        actions: [
          isAuth == 1 ?
          Padding(
              padding: const EdgeInsets.all(10),
              child:
              Row(
                children : [
                  IconButton(
                        icon: Icon(
                          Icons.favorite,
                          color: (isPressed) ? Colors.pink : Colors.pink[100],
                          size: 30,
                        ),
                        onPressed: () {
                          setState(() {
                            _add_to_wishlist(widget.product!.id);
                          });
                        }),
                  IconButton(
                    icon: Icon(
                      CupertinoIcons.cart_fill_badge_plus,
                      size: 25,
                      color: kPrimaryLightColor,
                    ),
                    onPressed: () {
                      _add_to_cart(widget.product!.id);
                    },
                  )

                ]
              )) : Container()
        ],
        elevation: 0,
        backgroundColor: Color(0xffffffff),
      ),
      body: ListView(children: [
        SizedBox(
          width: (300 / 375) * MediaQuery.of(context).size.width,
          child: AspectRatio(
            aspectRatio: 1.5,
            child: Image.network(IMG_URL + widget.product!.gambar),
          ),
        ),
        Container(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(top: 15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(30), topLeft: Radius.circular(30)),
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 0.5,
                    spreadRadius: 0.1,
                    offset: Offset(0.0, -3))
              ],
            ),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(
                    mainAxisAlignment : MainAxisAlignment.spaceBetween,
                    children : [
                      Text(
                        '${widget.product!.nama_barang}',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: kPrimaryColor,
                            fontSize: 20),
                      ),
                    ]
                  ),

              SizedBox(height: 8),
              Row(children: [
                RatingBarIndicator(
                  rating: double.parse(widget.product!.rating.toString()),
                  itemBuilder: (context, index) => Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  itemCount: 5,
                  itemSize: 22.0,
                  direction: Axis.horizontal,
                ),
                Text(
                  ' (15 Ulasan)',
                  style: TextStyle(color: Colors.black, fontSize: 15),
                ),
              ]),
              SizedBox(height: 8),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text(
                    '${formatCurrency.format(int.parse(widget.product!.harga_jual))}',
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.w900)),
                Text(
                  '${widget.product!.stok} Stok tersedia',
                  style: TextStyle(color: Colors.black, fontSize: 15),
                ),
              ]),
              SizedBox(height: 17),
              Text('Deskripsi',
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text(
                '${widget.product!.deskripsi}',
                style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.normal),
                textAlign: TextAlign.justify,
              ),
              SizedBox(height: 15),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children : [
                        Text('Jumlah',
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                                fontWeight: FontWeight.bold)),
                        Row(
                            children : [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shadowColor: Colors.transparent,
                                  primary: Colors.grey[200],
                                  shape: CircleBorder(),
                                  padding: EdgeInsets.all(5),
                                ),
                                child: Icon(
                                  CupertinoIcons.minus,
                                  size: 15,
                                  color: kPrimaryLightColor,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _jumlahBarang--;
                                    totalBayar!=0?totalBayar-=int.parse(widget.product!.harga_jual):totalBayar=0;
                                  });
                                },
                              ),
                              Text(
                                  '${_jumlahBarang}',
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold)
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shadowColor: Colors.transparent,
                                  primary: Colors.grey[200],
                                  shape: CircleBorder(),
                                  padding: EdgeInsets.all(5),
                                ),
                                child: Icon(
                                  CupertinoIcons.add,
                                  size: 15,
                                  color: kPrimaryLightColor,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _jumlahBarang++;
                                    totalBayar+=int.parse(widget.product!.harga_jual);
                                  });
                                },
                              ),
                            ]
                        )
                      ]
                  ),
                  Divider(),
                  SizedBox(
                    height: 8,
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children : [
                        Text('Total dibayar',
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                                fontWeight: FontWeight.bold)),
                        Text('${formatCurrency.format(totalBayar)}',
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.red,
                                fontWeight: FontWeight.bold)),
                      ]
                  ),
                  SizedBox(
                    height: 15,
                  ),


            ]))
      ]),
    );
  }

  _showModalBottomSheet() {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
        ),
        context: context,
        builder: (context) {
          return Padding(
            padding : EdgeInsets.all(20),
            child : Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children : [
                      Text('Jumlah',
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.bold)),
                      Text('${_jumlahBarang}',
                          style: TextStyle(
                              fontSize: 18,
                              color: kPrimaryColor,
                              fontWeight: FontWeight.bold))
                    ]
                ),
                SizedBox(
                  height: 5,
                ),
                Divider(),
                SizedBox(
                  height: 8,
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children : [
                      Text('Total dibayar',
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.bold)),
                      Text('Rp ${totalBayar}',
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.red,
                              fontWeight: FontWeight.bold)),
                    ]
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  children : [
                    Expanded(
                        child: ElevatedButton(
                            onPressed: () {
                              totalBayar>0 ? _showModalBottomSheet() : null;
                            },
                            style: ElevatedButton.styleFrom(
                              primary: kPrimaryLightColor,
                              shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(30.0),
                              ),
                              padding: EdgeInsets.all(15),
                            ),
                            child: Text('Checkout',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold))))
                  ]
                )

              ],
            )
          );
        });
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
  void _add_to_wishlist(id) async {
    setState(() {
      _isLoading = true;
    });
    if(isPressed==false){
      var res = await AuthController().getData('/wishlist/add/${id}');
      var body = json.decode(res.body);
      if (body['success']) {
        showSnackBar('Berhasil menambahkan ke wishlist');
        setState(() {
          isPressed = true;
        });
      } else {
        showSnackBar('Gagal menambahkan ke wishlist');
      }
      setState(() {
        _isLoading = false;
      });
    } else {
      var res = await AuthController().getData('/wishlist/remove/${id}');
      var body = json.decode(res.body);
      if (body['success']) {
        showSnackBar('Berhasil menghapus dari wishlist');
        setState(() {
          isPressed = false;
        });
      } else {
        showSnackBar('Gagal menghapus dari wishlist');
      }
      setState(() {
        _isLoading = false;
      });
    }

  }
  void _add_to_cart(id) async{
    var data = {
      'product_id' : id,
      'jumlah' : _jumlahBarang,
    };
    if(isAuth==1){
      var res = await AuthController().postData(data, '/cart/add');
      var body = json.decode(res.body);
      print(data);
      if(body['success']){
        Navigator.push(
          context,
          new MaterialPageRoute(
              builder: (context) => CartPage()
          ),
        );
      }else{
        Alert(
          context: context,
          type: AlertType.error,
          title: "Gagal Menambahkan ke cart!",
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
    } else {
      showSnackBar('Mohon login terlebih dahulu untuk menambahkan ke cart!');
    }

  }

}

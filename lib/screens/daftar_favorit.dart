// import 'package:darurat_app/login_pemilik_kos.dart';
// import 'package:darurat_app/register_pemilik_kos.dart';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:badges/badges.dart';
import 'package:ghulam_app/controllers/auth_controller.dart';
import 'package:ghulam_app/controllers/product_controller.dart';
import 'package:ghulam_app/models/product.dart';
import 'package:ghulam_app/models/wishlist.dart';
import 'package:ghulam_app/screens/detail_screen.dart';
import 'package:ghulam_app/utils/constants.dart';
import 'package:ghulam_app/widgets/bottom_navbar.dart';
import 'package:ghulam_app/widgets/second_app_bar.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class FavoritPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new FavoritPageState();
}
class FavoritPageState extends State<FavoritPage> {
  final formatCurrency = new NumberFormat.simpleCurrency(locale: 'id_ID');
  late Future<List<Wishlist>> futureListProduct;
  var array_of_orders = [];
  int isAuth = 2;
  var jumlah_barang = [];
  var jumlah = [];
  var harga_barang = [];
  var id_barang = [];

  var total = 0;
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

  @override
  void initState() {
    // TODO: implement initState
    _checkIfLoggedIn();
    futureListProduct = ProductNetwork().getFromWishlist();
  }

  Future<List<Wishlist>> _refreshProducts(BuildContext context) async {
    futureListProduct = ProductNetwork().getFromWishlist();
    return futureListProduct;
  }
  Widget build(BuildContext context) {
    final ButtonStyle styleButton = ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
      onPrimary: Colors.black,
      padding: EdgeInsets.fromLTRB(100, 15, 100, 15),
      primary: Color(0xfff5c32b),
    );

    return Scaffold(
        appBar: SecondAppBar(
          appBar: AppBar(),
          isAuth: authAppBar,
          title: 'Wishlist',
        ),
      body: RefreshIndicator(
          color: Colors.white,
          backgroundColor: kPrimaryColor,
          onRefresh: () => _refreshProducts(context),
          child: Stack(
            children: <Widget>[ListView(), FutureBuilder<List<Wishlist>>(
                future: futureListProduct,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data!.length != 0) {
                      return ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data!.length,
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                              child: Card(
                                elevation: 8.0,
                                margin: new EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 6.0),
                                child: Container(
                                  // decoration: BoxDecoration(color: Color.fromRGBO(64, 75, 96, .9)),
                                  child: ListTile(
                                      contentPadding:
                                      EdgeInsets.symmetric(
                                          horizontal: 7.0,
                                          vertical: 5.0),
                                      leading: AspectRatio(
                                        aspectRatio: 3.0 / 4.0,
                                        child: Image.network(IMG_URL +
                                            snapshot.data![index].product!.gambar),
                                      ),
                                      title: Text(
                                        snapshot.data![index].product!.nama_barang,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),
                                      subtitle: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                          MainAxisAlignment.end,
                                          children: [
                                            Text(
                                                '${formatCurrency.format(int.parse(snapshot.data![index].product!.harga_jual))}',
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    color:
                                                    Colors.redAccent,
                                                    fontWeight:
                                                    FontWeight.bold)),

                                          ]),
                                      trailing : TextButton(
                                        child : Text('Hapus', style : TextStyle(color : Colors.red)),
                                        onPressed:  (){
                                          remove(snapshot.data![index].id);
                                        },
                                      )
                                      ),
                                ),
                              ),
                              onTap: () => {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => DetailPage(
                                          product: snapshot
                                              .data![index].product)),
                                )
                              },
                            );
                          });
                    } else {
                      return Center(child: Text('Tidak ada barang di wishlist'));
                    }
                  } else if (snapshot.hasError) {
                    print(snapshot.hasData);
                    return Text("Error : ${snapshot.error}");
                  }
                  return Center(child: CircularProgressIndicator());
                })],
          ))
    );
  }
  void remove(id) async {
    var res = await AuthController().getData('/wishlist/remove/${id}');
    var body = json.decode(res.body);
    print(body);
    if (body['success']) {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) => super.widget));
    } else {
      Alert(
        context: context,
        type: AlertType.error,
        title: "Gagal!",
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
}

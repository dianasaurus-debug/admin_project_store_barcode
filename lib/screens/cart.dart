import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ghulam_app/controllers/auth_controller.dart';
import 'package:ghulam_app/controllers/product_controller.dart';
import 'package:ghulam_app/models/cart.dart';
import 'package:ghulam_app/models/user.dart';
import 'package:ghulam_app/screens/detail_screen.dart';
import 'package:ghulam_app/screens/login_index.dart';
import 'package:ghulam_app/models/product.dart';
import 'package:ghulam_app/qr_view.dart';
import 'package:ghulam_app/screens/product_detail.dart';
import 'package:ghulam_app/screens/scan_byproduct.dart';
import 'package:ghulam_app/utils/constants.dart';
import 'package:ghulam_app/widgets/app_bar.dart';
import 'package:ghulam_app/widgets/bottom_navbar.dart';
import 'package:ghulam_app/widgets/second_app_bar.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class CartPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new CartPageState();
}

class CartPageState extends State<CartPage> {
  final formatCurrency = new NumberFormat.simpleCurrency(locale: 'id_ID');
  late Future<List<Cart>> futureListProduct;
  late Future<User> futureUser;
  var array_of_orders = [];
  var jumlah_barang = [];
  var jumlah = [];
  var harga_barang = [];
  var id_barang = [];

  var total = 0;
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

  @override
  void initState() {
    // TODO: implement initState
    _checkIfLoggedIn();
    futureListProduct = ProductNetwork().getFromCarts();
    futureUser = AuthController().getProfile();
  }

  Future<List<Cart>> _refreshProducts(BuildContext context) async {
    futureListProduct = ProductNetwork().getFromCarts();
    futureUser = AuthController().getProfile();
    return futureListProduct;
  }

  Widget build(BuildContext context) {
    final ButtonStyle styleButton = ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
      onPrimary: Colors.black,
      padding: EdgeInsets.fromLTRB(100, 15, 100, 15),
      primary: kPrimaryColor,
    );
    return
      Scaffold(
        appBar: SecondAppBar(
          appBar: AppBar(),
          isAuth: authAppBar,
          title: 'Keranjang',
        ),
        body:
        RefreshIndicator(
        color: Colors.white,
    backgroundColor: kPrimaryColor,
    onRefresh: () => _refreshProducts(context),
    child: Stack(
      children: <Widget>[ListView(), FutureBuilder<User>(
        future: futureUser,
        builder: (context, userData) {
          if (userData.hasData) {
            return FutureBuilder<List<Cart>>(
                future: futureListProduct,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
                      ///This schedules the callback to be executed in the next frame
                      /// thus avoiding calling setState during build
                      for (var i = 0; i < snapshot.data!.length; i++) {
                        if(jumlah_barang.length<snapshot.data!.length){
                          setState(() {
                            jumlah_barang.add(snapshot.data![i].jumlah);
                          });
                          if(snapshot.data![i].is_scanned==1){
                            setState(() {
                              jumlah.add(snapshot.data![i].jumlah);
                              harga_barang.add(snapshot.data![i].product!.harga_jual);
                              id_barang.add(snapshot.data![i].product!.id);
                              total+=snapshot.data![i].total;
                            });
                          }
                        }

                      }
                    });
                    if (jumlah_barang.length != 0) {
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
                                            snapshot.data![index].product!
                                                .gambar),
                                      ),
                                      title: Text(
                                        snapshot.data![index].product!
                                            .nama_barang,
                                        softWrap: false,
                                        overflow: TextOverflow.ellipsis,
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
                                            Row(children: [
                                              Row(
                                                  mainAxisSize:
                                                  MainAxisSize.min,
                                                  mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .center,
                                                  children: [
                                                    ElevatedButton(
                                                      style:
                                                      ElevatedButton.styleFrom(shadowColor: Colors.transparent, primary: Colors.grey[200], shape: CircleBorder(), minimumSize: Size.zero,
                                                        // Set this
                                                        padding:
                                                        EdgeInsets.all(
                                                            3), // and this
                                                      ),
                                                      child: Icon(
                                                        CupertinoIcons.minus,
                                                        size: 12,
                                                        color:
                                                        kPrimaryLightColor,
                                                      ),
                                                      onPressed: () async {
                                                        var data = {
                                                          'product_id' : snapshot.data![index].product!.id,
                                                          'jumlah' : jumlah[index],
                                                        };
                                                        var res = await AuthController().postData(data, '/cart/add');
                                                        var body = json.decode(res.body);
                                                        print(data);
                                                        if(body['success']){
                                                          setState(() {
                                                            jumlah_barang[index] =jumlah_barang[index] - 1;
                                                          });
                                                          if(snapshot.data![index].is_scanned==1){
                                                            setState(() {
                                                              jumlah[index] = jumlah[index] - 1;
                                                              total = total- int.parse(snapshot.data![index].product!.harga_jual);
                                                            });

                                                          }
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
                                                      },
                                                    ),
                                                    Text(
                                                        '${jumlah_barang[index]}',
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            color: Colors
                                                                .black,
                                                            fontWeight:
                                                            FontWeight
                                                                .bold)),
                                                    ElevatedButton(
                                                      style:
                                                      ElevatedButton
                                                          .styleFrom(
                                                        shadowColor: Colors
                                                            .transparent,
                                                        primary: Colors
                                                            .grey[200],
                                                        shape:
                                                        CircleBorder(),
                                                        minimumSize:
                                                        Size.zero,
                                                        // Set this
                                                        padding:
                                                        EdgeInsets.all(
                                                            3), // and this
                                                      ),
                                                      child: Icon(
                                                        CupertinoIcons
                                                            .add,
                                                        size: 12,
                                                        color:
                                                        kPrimaryLightColor,
                                                      ),
                                                      onPressed: () async {
                                                        var data = {
                                                          'product_id' : snapshot.data![index].product!.id,
                                                          'jumlah' : jumlah[index],
                                                        };
                                                        var res = await AuthController().postData(data, '/cart/add');
                                                        var body = json.decode(res.body);
                                                        print(data);
                                                        if(body['success']){
                                                          setState(() {
                                                            jumlah_barang[index] =jumlah_barang[index] + 1;
                                                          });
                                                          if(snapshot.data![index].is_scanned==1){
                                                            setState(() {
                                                              jumlah[index] = jumlah[index] + 1;
                                                              total = total+ int.parse(snapshot.data![index].product!.harga_jual);
                                                            });
                                                          }
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
                                                      },
                                                    ),
                                                  ]),
                                              TextButton(
                                                child : Text('Hapus', style : TextStyle(color : Colors.red)),
                                                onPressed:  (){
                                                  remove(snapshot.data![index].id);
                                                },
                                              )
                                            ])
                                          ]),
                                      trailing: snapshot.data![index].is_scanned == 0
                                          ? Column(children: [
                                        if (userData.data!.saldo !=
                                            null &&
                                            int.parse(userData
                                                .data!
                                                .saldo!
                                                .jumlah) >=
                                                int.parse(snapshot
                                                    .data![index]
                                                    .product!
                                                    .harga_jual))
                                          ElevatedButton(
                                              onPressed: () {
                                                Navigator.of(
                                                    context)
                                                    .push(
                                                    MaterialPageRoute(
                                                      builder: (context) => ScanByCode(
                                                          product: snapshot
                                                              .data![
                                                          index]
                                                              .product),
                                                    ));
                                              },
                                              style: ElevatedButton
                                                  .styleFrom(
                                                primary:
                                                kPrimaryLightColor,
                                                shape:
                                                new RoundedRectangleBorder(
                                                  borderRadius:
                                                  new BorderRadius
                                                      .circular(
                                                      30.0),
                                                ),
                                                padding:
                                                EdgeInsets.all(
                                                    8),
                                              ),
                                              child: Text('Scan',
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                      FontWeight
                                                          .bold)))
                                        else
                                          Text('Saldo Tidak cukup',
                                              style: TextStyle(
                                                  fontWeight:
                                                  FontWeight
                                                      .bold,
                                                  fontSize: 12,
                                                  color:
                                                  Colors.red)),
                                      ])
                                          : Column(
                                          mainAxisAlignment:
                                          MainAxisAlignment
                                              .spaceBetween,
                                          children: [
                                            Text('Terscan',
                                                style: TextStyle(
                                                    fontWeight:
                                                    FontWeight
                                                        .bold,
                                                    fontSize: 12,
                                                    color:
                                                    kPrimaryLightColor)),
                                            IconButton(
                                                padding:
                                                EdgeInsets.zero,
                                                constraints:
                                                BoxConstraints(),
                                                icon: Icon(
                                                    Icons.delete,
                                                    color:
                                                    Colors.red),
                                                onPressed: () {
                                                  remove_scan(
                                                      snapshot
                                                          .data![
                                                      index]
                                                          .product!
                                                          .id);
                                                }),
                                          ])),
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
                      return Center(child: Text('Tidak ada barang di keranjang'));
                    }
                  } else if (snapshot.hasError) {
                    print(snapshot.hasData);
                    return Text("Error : ${snapshot.error}");
                  }
                  return Center(child: CircularProgressIndicator());
                });
          } else if (userData.hasError) {
            return Text('${userData.error}');
          }
          // By default, show a loading spinner.
          return Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.green,
              ));
        },
      )],
    )),
        persistentFooterButtons: [
          Container(
              child: Padding(
                  padding: EdgeInsets.all(20),
                  child:
                  Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text('Jumlah Total : Rp ${total}', style : TextStyle(fontWeight : FontWeight.bold, fontSize : 18)),
                        SizedBox(height : 10),
                        Row(children: [
                          Expanded(
                              child: ElevatedButton(
                                  onPressed: () {
                                    total>0 ? checkout() : null;
                                  },
                                  style: ElevatedButton.styleFrom(
                                    primary: total>0 ? kPrimaryLightColor : Colors.grey,
                                    shape: new RoundedRectangleBorder(
                                      borderRadius:
                                      new BorderRadius.circular(30.0),
                                    ),
                                    padding: EdgeInsets.all(15),
                                  ),
                                  child: Text('Checkout',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold))))
                        ])
                      ])
              ))
        ],
      );


  }

  void remove_scan(id) async {
    var res = await AuthController().putDataAuth({}, '/cart/unscan/${id}');
    var body = json.decode(res.body);
    print(body);
    if (body['success']) {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) => super.widget));
    } else {
      Alert(
        context: context,
        type: AlertType.error,
        title: "Gagal hapus scan produk!",
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
  void remove(id) async {
    var res = await AuthController().deleteData({}, '/cart/delete/${id}');
    var body = json.decode(res.body);
    print(body);
    if (body['success']) {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) => super.widget));
    } else {
      Alert(
        context: context,
        type: AlertType.error,
        title: "Gagal hapus produk!",
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

  void checkout() async{
    var array_of_orders = [];
    for(var i=0;i<id_barang.length;i++){
      array_of_orders.add({
        'id' : id_barang[i],
        'harga' : harga_barang[i],
        'jumlah' : jumlah[i]
      });
    }
    var data = {
      'products' : array_of_orders
    };
    var res = await AuthController().postData(data, '/order/create');
    var body = json.decode(res.body);
    print(body);
    if (body['success']) {
      var id_order = body['data']['id'];
      Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (context) => ProductDetail(id_order : id_order)
        ),
      );
    } else {
      Alert(
        context: context,
        type: AlertType.error,
        title: "Gagal hapus scan produk!",
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

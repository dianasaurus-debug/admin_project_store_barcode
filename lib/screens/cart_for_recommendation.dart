import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ghulam_app/controllers/auth_controller.dart';
import 'package:ghulam_app/controllers/category_controller.dart';
import 'package:ghulam_app/controllers/product_controller.dart';
import 'package:ghulam_app/models/cart.dart';
import 'package:ghulam_app/models/category.dart';
import 'package:ghulam_app/models/parameter.dart';
import 'package:ghulam_app/models/sub_category.dart';
import 'package:ghulam_app/screens/cart.dart';
import 'package:ghulam_app/screens/detail_screen.dart';
import 'package:ghulam_app/screens/login_index.dart';
import 'package:ghulam_app/models/product.dart';
import 'package:ghulam_app/qr_view.dart';
import 'package:ghulam_app/screens/product_detail.dart';
import 'package:ghulam_app/screens/recommendations.dart';
import 'package:ghulam_app/utils/constants.dart';
import 'package:ghulam_app/widgets/app_bar.dart';
import 'package:ghulam_app/widgets/bottom_navbar.dart';
import 'package:ghulam_app/widgets/second_app_bar.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';


class CartRecommendationPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new CartRecommendationPageState();
}

class CartRecommendationPageState extends State<CartRecommendationPage> {
  final formatCurrency = new NumberFormat.simpleCurrency(locale: 'id_ID');
  late Future<List<Cart>> futureListProduct;
  late Future<List<Category>> futureListCategory;
  late Future<List<Category>> futureListCategoryNew;
  var rekomenHarga = 1;
  var rekomenRating = 1;
  var rekomenSupplier = 1;
  var array_of_orders = [];
  var jumlah = [];
  var harga_barang = [];
  var id_barang = [];
  var jumlah_barang = [];

  Category rekomenKategori = Category( '', 0);
  var rekomenSubKategori = 1;
  var _isLoading = false;
  int isAuth = 2;
  bool authAppBar = false;
  void _checkIfLoggedIn() async{
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');
    if(token != null){
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
    futureListCategory = CategoryNetwork().getCategories();
    futureListCategoryNew = CategoryNetwork().getCategories();
  }

  Widget build(BuildContext context) {
    final ButtonStyle styleButton = ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
      onPrimary: Colors.black,
      padding: EdgeInsets.fromLTRB(100, 15, 100, 15),
      primary: kPrimaryColor,
    );
    return Scaffold(
      appBar: SecondAppBar(
        appBar: AppBar(),
        isAuth: authAppBar,
        title: 'Keranjang',
      ),
      body: FutureBuilder<List<Cart>>(
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
                      });
                    }
                  }

                }
              });
              if(jumlah_barang.length!=0){
                return Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children : [
                    ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data!.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                              title: Text('${snapshot.data![index].product!.nama_barang}',
                                  softWrap: false,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: kPrimaryColor,
                              fontSize: 15)),
                              subtitle: Text(
                                  '${formatCurrency.format(int.parse(snapshot.data![index].product!.harga_jual))}',
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500)),
                              leading: AspectRatio(
                                aspectRatio: 1.5,
                                child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    child: Image.network(IMG_URL + snapshot.data![index].product!.gambar)
                                ),
                              ),
                              trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment:MainAxisAlignment.center,
                                  children : [
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        shadowColor: Colors.transparent,
                                        primary: Colors.grey[200],
                                        shape: CircleBorder(),
                                        minimumSize: Size.zero, // Set this
                                        padding: EdgeInsets.all(3), // and this
                                      ),
                                      child: Icon(
                                        CupertinoIcons.minus,
                                        size: 12,
                                        color: kPrimaryLightColor,
                                      ),
                                      onPressed: () async {
                                        setState(() {
                                          jumlah_barang[index] =jumlah_barang[index] - 1;
                                        });
                                        var data = {
                                          'product_id' : snapshot.data![index].product!.id,
                                          'jumlah' : jumlah_barang[index],
                                        };
                                        var res = await AuthController().postData(data, '/cart/add');
                                        var body = json.decode(res.body);
                                        print(data);
                                        if(!body['success']){
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
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold)
                                    ),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        shadowColor: Colors.transparent,
                                        primary: Colors.grey[200],
                                        shape: CircleBorder(),
                                        minimumSize: Size.zero, // Set this
                                        padding: EdgeInsets.all(3), // and this
                                      ),
                                      child: Icon(
                                        CupertinoIcons.add,
                                        size: 12,
                                        color: kPrimaryLightColor,
                                      ),
                                      onPressed: () async {
                                        setState(() {
                                          jumlah_barang[index] =jumlah_barang[index] + 1;
                                        });
                                        var data = {
                                          'product_id' : snapshot.data![index].product!.id,
                                          'jumlah' : jumlah_barang[index],
                                        };
                                        var res = await AuthController().postData(data, '/cart/add');
                                        var body = json.decode(res.body);
                                        print(data);
                                        if(!body['success']){
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
                                  ]
                              )
                          );
                        }
                    ),
                    Padding(
                      padding: EdgeInsets.all(20),
                      child : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children : [
                            Text('Apakah ingin kami rekomendasikan lagi?'),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children : [
                                  ElevatedButton(
                                      onPressed: () {
                                        showModalBottomSheet(
                                            isScrollControlled: true,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.vertical(
                                                  top: Radius.circular(25.0)),
                                            ),
                                            context: context,
                                            builder: (context) {
                                              return StatefulBuilder(builder: (BuildContext
                                              context,
                                                  StateSetter
                                                  setState /*You can rename this!*/) {
                                                return SingleChildScrollView(
                                                    padding: EdgeInsets.all(20),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: <Widget>[
                                                        Wrap(children: [
                                                          FutureBuilder<List<Category>>(
                                                              future:
                                                              futureListCategoryNew,
                                                              builder: (context,
                                                                  data_kategori) {
                                                                if (data_kategori
                                                                    .hasData) {
                                                                  return Column(
                                                                      crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                      children: [
                                                                        Text('Kategori',
                                                                            style: TextStyle(
                                                                                fontSize:
                                                                                18,
                                                                                fontWeight:
                                                                                FontWeight.bold)),
                                                                        DropdownButtonFormField<
                                                                            Category>(
                                                                          elevation: 16,
                                                                          decoration:
                                                                          InputDecoration(
                                                                              focusedBorder:
                                                                              OutlineInputBorder(
                                                                                borderRadius:
                                                                                BorderRadius.circular(30.0),
                                                                                borderSide:
                                                                                BorderSide(color: kPrimaryColor, width: 2),
                                                                              ),
                                                                              enabledBorder:
                                                                              OutlineInputBorder(
                                                                                borderRadius:
                                                                                BorderRadius.circular(30.0),
                                                                                borderSide:
                                                                                BorderSide(color: kPrimaryLightColor, width: 2),
                                                                              ),
                                                                              errorBorder:
                                                                              OutlineInputBorder(
                                                                                borderRadius:
                                                                                BorderRadius.circular(30.0),
                                                                                borderSide:
                                                                                BorderSide(color: Colors.red, width: 2),
                                                                              ),
                                                                              focusedErrorBorder:
                                                                              OutlineInputBorder(
                                                                                borderRadius:
                                                                                BorderRadius.circular(30.0),
                                                                                borderSide:
                                                                                BorderSide(color: Colors.red, width: 2),
                                                                              ),
                                                                              hintText:
                                                                              'Pilih kategori',
                                                                              isDense:
                                                                              true),
                                                                          onChanged:
                                                                              (newValue) {
                                                                            setState(
                                                                                    () {
                                                                                  if (newValue !=
                                                                                      null) {
                                                                                    rekomenKategori =
                                                                                        newValue;
                                                                                  }
                                                                                });
                                                                          },
                                                                          items: data_kategori
                                                                              .data!
                                                                              .map((Category
                                                                          category) {
                                                                            return new DropdownMenuItem<
                                                                                Category>(
                                                                              value:
                                                                              category,
                                                                              child:
                                                                              new Text(
                                                                                category
                                                                                    .nama_kategori,
                                                                                style: new TextStyle(
                                                                                    color:
                                                                                    Colors.black),
                                                                              ),
                                                                            );
                                                                          }).toList(),
                                                                        ),
                                                                        SizedBox(
                                                                            height: 10),
                                                                        Text(
                                                                            'Sub Kategori',
                                                                            style: TextStyle(
                                                                                fontSize:
                                                                                18,
                                                                                fontWeight:
                                                                                FontWeight.bold)),
                                                                        rekomenKategori.id != 0 ? DropdownButtonFormField<SubCategory>(
                                                                          elevation:
                                                                          16,
                                                                          decoration: InputDecoration(
                                                                              focusedBorder: OutlineInputBorder(
                                                                                borderRadius: BorderRadius.circular(30.0),
                                                                                borderSide: BorderSide(color: kPrimaryColor, width: 2),
                                                                              ),
                                                                              enabledBorder: OutlineInputBorder(
                                                                                borderRadius: BorderRadius.circular(30.0),
                                                                                borderSide: BorderSide(color: kPrimaryLightColor, width: 2),
                                                                              ),
                                                                              errorBorder: OutlineInputBorder(
                                                                                borderRadius: BorderRadius.circular(30.0),
                                                                                borderSide: BorderSide(color: Colors.red, width: 2),
                                                                              ),
                                                                              focusedErrorBorder: OutlineInputBorder(
                                                                                borderRadius: BorderRadius.circular(30.0),
                                                                                borderSide: BorderSide(color: Colors.red, width: 2),
                                                                              ),
                                                                              hintText: 'Pilih sub kategori',
                                                                              isDense: true),
                                                                          onChanged:
                                                                              (newValue) {
                                                                            setState(
                                                                                    () {
                                                                                  if (newValue !=
                                                                                      null) {
                                                                                    rekomenSubKategori = newValue.id;
                                                                                  }
                                                                                });
                                                                          },
                                                                          items: rekomenKategori
                                                                              .sub_categories!
                                                                              .map((SubCategory
                                                                          category) {
                                                                            return new DropdownMenuItem<
                                                                                SubCategory>(
                                                                              value:
                                                                              category,
                                                                              child:
                                                                              new Text(
                                                                                category.nama_kategori,
                                                                                style: new TextStyle(color: Colors.black),
                                                                              ),
                                                                            );
                                                                          }).toList(),
                                                                        )
                                                                            :  DropdownButtonFormField<dynamic>(
                                                                          elevation: 16,
                                                                          decoration: InputDecoration(
                                                                              enabled : false,
                                                                              border: OutlineInputBorder(
                                                                                borderRadius: BorderRadius.circular(30.0),
                                                                              ),
                                                                              hintText: 'Pilih sub kategori',
                                                                              isDense: true),
                                                                          onChanged: null,
                                                                          items: null,
                                                                        )
                                                                      ]);
                                                                } else if (data_kategori
                                                                    .hasError) {
                                                                  return Text(
                                                                      "${data_kategori.error}");
                                                                }
                                                                return Center(
                                                                    child:
                                                                    LinearProgressIndicator());
                                                              }),
                                                          SizedBox(height: 10),
                                                          Text('Harga',
                                                              style: TextStyle(
                                                                  fontSize: 18,
                                                                  fontWeight:
                                                                  FontWeight.bold)),
                                                          SingleChildScrollView(
                                                              scrollDirection:
                                                              Axis.horizontal,
                                                              child: Row(
                                                                  children: list_label_bobot
                                                                      .map((e) => Container(
                                                                      margin: EdgeInsets.only(left: 7.0),
                                                                      child: ChoiceChip(
                                                                        label: Text(
                                                                            e.label),
                                                                        selected:
                                                                        rekomenHarga ==
                                                                            e.id,
                                                                        selectedColor:
                                                                        kPrimaryColor,
                                                                        onSelected:
                                                                            (bool
                                                                        selected) {
                                                                          setState(
                                                                                  () {
                                                                                rekomenHarga =
                                                                                    e.id;
                                                                              });
                                                                        },
                                                                        backgroundColor:
                                                                        kPrimaryLightColor,
                                                                        labelStyle:
                                                                        TextStyle(
                                                                            color:
                                                                            Colors.white),
                                                                      )))
                                                                      .toList())),
                                                          SizedBox(height: 10),
                                                          Text('Rating',
                                                              style: TextStyle(
                                                                  fontSize: 18,
                                                                  fontWeight:
                                                                  FontWeight.bold)),
                                                          SingleChildScrollView(
                                                              scrollDirection:
                                                              Axis.horizontal,
                                                              child: Row(
                                                                  children: list_label_bobot
                                                                      .map((e) => Container(
                                                                      margin: EdgeInsets.only(left: 7.0),
                                                                      child: ChoiceChip(
                                                                        label: Text(
                                                                            e.label),
                                                                        selected:
                                                                        rekomenRating ==
                                                                            e.id,
                                                                        selectedColor:
                                                                        kPrimaryColor,
                                                                        onSelected:
                                                                            (bool
                                                                        selected) {
                                                                          setState(
                                                                                  () {
                                                                                rekomenRating =
                                                                                    e.id;
                                                                              });
                                                                        },
                                                                        backgroundColor:
                                                                        kPrimaryLightColor,
                                                                        labelStyle:
                                                                        TextStyle(
                                                                            color:
                                                                            Colors.white),
                                                                      )))
                                                                      .toList())),
                                                          SizedBox(height: 10),
                                                          Text('Suplier',
                                                              style: TextStyle(
                                                                  fontSize: 18,
                                                                  fontWeight:
                                                                  FontWeight.bold)),
                                                          SingleChildScrollView(
                                                              scrollDirection:
                                                              Axis.horizontal,
                                                              child: Row(
                                                                  children: list_label_bobot
                                                                      .map((e) => Container(
                                                                      margin: EdgeInsets.only(left: 7.0),
                                                                      child: ChoiceChip(
                                                                        label: Text(
                                                                            e.label),
                                                                        selected:
                                                                        rekomenSupplier ==
                                                                            e.id,
                                                                        selectedColor:
                                                                        kPrimaryColor,
                                                                        onSelected:
                                                                            (bool
                                                                        selected) {
                                                                          setState(
                                                                                  () {
                                                                                rekomenSupplier =
                                                                                    e.id;
                                                                              });
                                                                        },
                                                                        backgroundColor:
                                                                        kPrimaryLightColor,
                                                                        labelStyle:
                                                                        TextStyle(
                                                                            color:
                                                                            Colors.white),
                                                                      )))
                                                                      .toList())),
                                                        ]),
                                                        SizedBox(height: 20),
                                                        Row(children: [
                                                          Expanded(
                                                              child: ElevatedButton(
                                                                  onPressed: () {
                                                                    _recommend();
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
                                                                          15.0),
                                                                    ),
                                                                    padding:
                                                                    EdgeInsets.all(
                                                                        15),
                                                                  ),
                                                                  child: Text(
                                                                      _isLoading ==
                                                                          false
                                                                          ? 'Rekomendasikan'
                                                                          : 'Memuat...',
                                                                      style: TextStyle(
                                                                          fontSize: 18,
                                                                          fontWeight:
                                                                          FontWeight
                                                                              .bold))))
                                                        ])
                                                      ],
                                                    ));
                                              });
                                            });
                                      },
                                      style: ElevatedButton.styleFrom(
                                        primary: kPrimaryLightColor,
                                        shape: new RoundedRectangleBorder(
                                          borderRadius: new BorderRadius.circular(30.0),
                                        ),
                                        padding: EdgeInsets.all(8),
                                      ),
                                      child: Text('Iya',
                                          style: TextStyle(
                                              fontSize: 15, fontWeight: FontWeight.bold))),
                                  SizedBox(width : 5),
                                  ElevatedButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          new MaterialPageRoute(
                                              builder: (context) => CartPage()
                                          )
                                        );
                                        },
                                      style: ElevatedButton.styleFrom(
                                        primary: Colors.blue,
                                        shape: new RoundedRectangleBorder(
                                          borderRadius: new BorderRadius.circular(30.0),
                                        ),
                                        padding: EdgeInsets.all(8),
                                      ),
                                      child: Text('Sudah',
                                          style: TextStyle(
                                              fontSize: 15, fontWeight: FontWeight.bold)))
                                ]
                            )
                          ]
                      )
                    )
                  ]
                );
              } else {
                return Center(
                    child: CircularProgressIndicator());
              }

            } else if (snapshot.hasError) {
              print(snapshot.hasData);
              return Text("Error : ${snapshot.error}");
            }
            return Center(
                child: CircularProgressIndicator());
          }),

    );
  }
  void _recommend() async {
    Parameter data = new Parameter(
        rekomenHarga, rekomenSupplier, rekomenRating, rekomenSubKategori);
    Navigator.push(
      context,
      new MaterialPageRoute(builder: (context) => Recommendation(data: data)),
    );
  }

}

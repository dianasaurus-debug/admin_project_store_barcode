import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ghulam_app/controllers/auth_controller.dart';
import 'package:ghulam_app/controllers/product_controller.dart';
import 'package:ghulam_app/models/parameter.dart';
import 'package:ghulam_app/screens/cart.dart';
import 'package:ghulam_app/screens/cart_for_recommendation.dart';
import 'package:ghulam_app/screens/detail_screen.dart';
import 'package:ghulam_app/models/product.dart';
import 'package:ghulam_app/utils/constants.dart';
import 'package:ghulam_app/widgets/app_bar.dart';
import 'package:ghulam_app/widgets/bottom_navbar.dart';
import 'package:ghulam_app/widgets/grid_product.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class Recommendation extends StatefulWidget {
  final Parameter data;

  const Recommendation({Key? key, required this.data}) : super(key: key);
  @override
  State<StatefulWidget> createState() => new RecommendationState();
}


class RecommendationState extends State<Recommendation> {
  // final formatCurrency = new NumberFormat.simpleCurrency(locale: 'id_ID');
  late Future<List<Product>> futureListProduct;
  final formatCurrency = new NumberFormat.simpleCurrency(locale: 'id_ID', decimalDigits: 0);

  bool isAuth = false;
  var jumlah = 1;
  var idSelected = 0;
  void _checkIfLoggedIn() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');
    if (token != null) {
      setState(() {
        isAuth = true;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    _checkIfLoggedIn();
    futureListProduct = ProductNetwork().getRecommendations(widget.data);
  }

  Widget build(BuildContext context) {
    final ButtonStyle styleButton = ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
      onPrimary: Colors.black,
      padding: EdgeInsets.fromLTRB(100, 15, 100, 15),
      primary: kPrimaryColor,
    );
    return Scaffold(
      appBar: AppBar(
        // leading: IconButton(
        //   icon: Icon(Icons.clear, color: Colors.grey, size: 40),
        //   onPressed: () => Navigator.of(context).pop(),
        // ),
        centerTitle: true,
        title: Text('Rekomendasi Produk', style: TextStyle(color: Colors.black, fontSize : 20),),
        elevation: 0,
        backgroundColor: Color(0xffffffff),
      ),
      body: Padding(
          padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
          child: FutureBuilder<List<Product>>(
              future: futureListProduct,
              builder: (context, products) {
                if (products.hasData) {
                  return Container(
                        height: MediaQuery.of(context).size.height * (0.53),
                        child: SingleChildScrollView(
                            child: products.data!.length > 0
                                ?
                            ListView.builder(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: products.data!.length,
                              itemBuilder: (BuildContext context, int index) {
                                return
                                  GestureDetector(
                                    child:  Card(
                                      elevation: 8.0,
                                      margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                                      child: Container(
                                        // decoration: BoxDecoration(color: Color.fromRGBO(64, 75, 96, .9)),
                                        child: ListTile(
                                            contentPadding: EdgeInsets.symmetric(horizontal: 7.0, vertical: 5.0),
                                            leading: AspectRatio(
                                              aspectRatio: 3.0 / 4.0,
                                              child: Image.network(IMG_URL + products.data![index].gambar),
                                            ),
                                            title: Text(
                                              products.data![index].nama_barang,
                                              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                                            ),
                                            // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),
                                            subtitle:Column(
                                              crossAxisAlignment : CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children : [
                                                Text('${formatCurrency.format(int.parse(products.data![index].harga_jual))}',
                                                    style: TextStyle(fontSize: 13, color: Colors.redAccent, fontWeight: FontWeight.bold)),
                                                Row(
                                                  children : [
                                                    Row(
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
                                                            onPressed: () {
                                                              setState(() {
                                                                jumlah--;
                                                              });
                                                            },
                                                          ),
                                                          Text(
                                                              '${jumlah}',
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
                                                            onPressed: () {
                                                              setState(() {
                                                                jumlah++;
                                                              });
                                                            },
                                                          ),
                                                        ]
                                                    ),
                                                    IconButton(
                                                        icon: Icon(Icons.shopping_cart,
                                                            color: kPrimaryLightColor),
                                                        onPressed: () {
                                                          print(products.data![index]);
                                                          if(products.data![index].is_in_cart==true){
                                                            Navigator.push(
                                                              context,
                                                              new MaterialPageRoute(
                                                                  builder: (context) => CartRecommendationPage()
                                                              ),
                                                            );
                                                          } else {
                                                            _add_to_cart(products.data![index].id);
                                                          }
                                                        }
                                                    )
                                                  ]
                                                )

                                              ]
                                            ),
                                            trailing: Container(
                                              decoration: BoxDecoration(color: index <= 2 ? kPrimaryLightColor : Colors.grey),
                                            child: Padding(
                                                  padding: const EdgeInsets.fromLTRB(10, 3, 10, 3),
                                                  child:
                                                      index <= 2 ?
                                                  Column(
                                                      mainAxisSize: MainAxisSize.min,
                                                    children : [
                                                      Text('TOP', style: TextStyle(fontSize: 10, color: Colors.white)),
                                                      Text('${index+1}', style: TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.bold))
                                                    ]
                                                  ) : Text('${index+1}', style: TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.bold))
                                              ),
                                            )
                                        ),
                                      ),
                                    ),
                                    onTap: () => {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                DetailPage(
                                                    product: products.data![index])),
                                      )
                                    },
                                  );
                              },
                            ) : Center(
                              child: Text('Produk kosong',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w100,
                                      color: kPrimaryColor)),
                            )));
                } else if (products.hasError) {
                  return Text("${products.error}");
                }
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        backgroundColor: kPrimaryColor,
                      ),
                      Text("\nMemuat data produk...")
                    ],
                  ),
                );
              })),
      bottomNavigationBar: BottomNavbar(current: 0),
    );
  }
  void _add_to_cart(id) async{
      var data = {
        'product_id' : id,
        'jumlah' : jumlah,
      };
    var res = await AuthController().postData(data, '/cart/add');
    var body = json.decode(res.body);
    print(data);
    if(body['success']){
      Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (context) => CartRecommendationPage()
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
  }


}

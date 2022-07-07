// import 'package:darurat_app/login_pemilik_kos.dart';
// import 'package:darurat_app/register_pemilik_kos.dart';
import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:ghulam_app/controllers/auth_controller.dart';
import 'package:ghulam_app/controllers/product_controller.dart';
import 'package:ghulam_app/models/order.dart';
import 'package:ghulam_app/screens/daftar_favorit.dart';
import 'package:ghulam_app/screens/history.dart';
import 'package:ghulam_app/screens/login_index.dart';
import 'package:ghulam_app/models/product.dart';
import 'package:ghulam_app/qr_view.dart';
import 'package:ghulam_app/screens/register_index.dart';
import 'package:ghulam_app/utils/constants.dart';
import 'package:ghulam_app/utils/size_config.dart';
import 'package:ghulam_app/widgets/bottom_navbar.dart';
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class ProductDetail extends StatefulWidget {
  final int? id_order;

  const ProductDetail({Key? key, required this.id_order}) : super(key: key);

  @override
  State<StatefulWidget> createState() => new ProductDetailState();
}

class ProductDetailState extends State<ProductDetail> {
  final formatCurrency = new NumberFormat.simpleCurrency(locale: 'id_ID');
  late Future<Order> futureOrder;

  @override
  void initState() {
    // TODO: implement initState
    futureOrder = ProductNetwork().getOneOrder(widget.id_order);
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
          backgroundColor: Colors.white,
          title: Text(
            'Checkout',
            style: TextStyle(color: kPrimaryColor),
          ),
          iconTheme: IconThemeData(
            color: kPrimaryColor, //change your color here
          ),
        ),
        body: FutureBuilder<Order>(
            future: futureOrder,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: snapshot.data!.products!.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Card(
                                elevation: 8.0,
                                margin: new EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 6.0),
                                child: Container(
                                  // decoration: BoxDecoration(color: Color.fromRGBO(64, 75, 96, .9)),
                                  child: ListTile(
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 7.0, vertical: 5.0),
                                    leading: AspectRatio(
                                      aspectRatio: 3.0 / 4.0,
                                      child: Image.network(IMG_URL +
                                          snapshot
                                              .data!.products![index].gambar),
                                    ),
                                    title: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child :
                                          Text('${snapshot.data!.products![index]
                                                .nama_barang} ${snapshot.data!.products![index].jumlah}x',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold),
                                          ),

                                          )
                                        ]),
                                    // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),
                                    subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Text(
                                              '${formatCurrency.format(int.parse(snapshot.data!.products![index].harga_jual))}',
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.redAccent,
                                                  fontWeight: FontWeight.bold)),
                                        ]),
                                  ),
                                ),
                              );
                            },
                          ),
                          SizedBox(height: 10),
                          Text('Total : Rp ${snapshot.data!.total}',
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold)),
                          SizedBox(height: 25),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                ElevatedButton(
                                    onPressed: () {
                                      pay(snapshot.data!.id);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      primary: kPrimaryLightColor,
                                      shape: new RoundedRectangleBorder(
                                        borderRadius:
                                            new BorderRadius.circular(30.0),
                                      ),
                                      padding: EdgeInsets.all(15),
                                    ),
                                    child: Text('Bayar',
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold))),
                                SizedBox(width: 10),
                                ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                HistoryPage()),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.red,
                                      shape: new RoundedRectangleBorder(
                                        borderRadius:
                                            new BorderRadius.circular(30.0),
                                      ),
                                      padding: EdgeInsets.all(15),
                                    ),
                                    child: Text('Batal',
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold)))
                              ])
                        ]));
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              return Padding(
                  padding: EdgeInsets.fromLTRB(20, 40, 20, 40),
                  child: CircularProgressIndicator());
            }));
  }

  void pay(id) async {
    var res = await AuthController().getData('/order/pay/${id}');
    var body = json.decode(res.body);
    print(body);
    if (body['success']) {
      Alert(
        context: context,
        type: AlertType.success,
        title: "Berhasil membayar produk!",
        desc: body['message'],
        buttons: [
          DialogButton(
            child: const Text(
              "OK",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () => {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HistoryPage()),
              )
            },
            width: 120,
          )
        ],
      ).show();
    } else {
      Alert(
        context: context,
        type: AlertType.error,
        title: "Gagal membayar produk!",
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

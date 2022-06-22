// import 'package:darurat_app/login_pemilik_kos.dart';
// import 'package:darurat_app/register_pemilik_kos.dart';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:ghulam_app/controllers/auth_controller.dart';
import 'package:ghulam_app/controllers/product_controller.dart';
import 'package:ghulam_app/models/product.dart';
import 'package:ghulam_app/qr_view.dart';
import 'package:ghulam_app/screens/cart.dart';
import 'package:ghulam_app/screens/product_detail.dart';
import 'package:ghulam_app/utils/constants.dart';
import 'package:ghulam_app/utils/size_config.dart';
import 'package:ghulam_app/widgets/bottom_navbar.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
// import 'package:intl/intl.dart';


class DetailAfterScan extends StatefulWidget {
  final String? kodeBarang;
  const DetailAfterScan({Key? key, required this.kodeBarang}) : super(key: key);

  @override
  State<StatefulWidget> createState() => new DetailAfterScanState();
}
class DetailAfterScanState extends State<DetailAfterScan> {
  // final formatCurrency = new NumberFormat.simpleCurrency(locale: 'id_ID');
  late Future<Product> futureProductbayar;
  var jumlah_barang = 1;
  var jumlah = 1;
  var harga_barang = 0;
  var id_barang = 0;

  var total = 0;

  @override
  void initState() {
    // TODO: implement initState
    futureProductbayar = ProductNetwork().getDetailProductByKode(widget.kodeBarang);
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
            'Detail Barang',
            style: TextStyle(color: kPrimaryColor),
          ),
          iconTheme: IconThemeData(
            color: kPrimaryColor, //change your color here
          ),

        ),
        body:
        FutureBuilder<Product>(
            future: futureProductbayar,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
                  ///This schedules the callback to be executed in the next frame
                  /// thus avoiding calling setState during build
                  if(total==0){
                    setState(() {
                      jumlah_barang = 1;
                      harga_barang = int.parse(snapshot.data!.harga_jual);
                      id_barang = snapshot.data!.id;
                      total=int.parse(snapshot.data!.harga_jual);
                    });
                  }


                });
                return Center(
                    child: SingleChildScrollView(
                        padding: EdgeInsets.all(30),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Image.network(
                                IMG_URL + snapshot.data!.gambar,
                                height: 100.0,
                                width: 100.0,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text('${snapshot.data!.nama_barang}',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: kPrimaryColor,
                                    fontSize: 30)),
                            SizedBox(height: 20),
                            Container(
                                padding: EdgeInsets.all(10),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10),
                                      bottomLeft: Radius.circular(10),
                                      bottomRight: Radius.circular(10)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.3),
                                      spreadRadius: 3,
                                      blurRadius: 5,
                                      offset: Offset(
                                          0, 3), // changes position of shadow
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Detail Pembelian',
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 20)),
                                    Divider(
                                      color: kSecondaryColor,
                                    ),
                                    SizedBox(height: 5),
                                    Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text('Harga',
                                              style: TextStyle(
                                                  color: Colors.grey)),
                                          SizedBox(height: 5),
                                          Text('Rp ${snapshot.data!.harga_jual}',
                                              style: TextStyle(
                                                  color: kPrimaryColor,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold)),
                                        ]),
                                    SizedBox(height: 8),
                                    Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text('Jumlah',
                                              style: TextStyle(
                                                  color: Colors.grey)),
                                          SizedBox(height: 5),
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
                                          setState(() {
                                            if(jumlah_barang>1&&total>0){
                                              jumlah_barang =jumlah_barang - 1;
                                              total = total - int.parse(snapshot.data!.harga_jual);
                                            }
                                          });
                                        },
                                      ),
                                      Text(
                                          '${jumlah_barang}',
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
                                          setState(() {
                                              jumlah_barang =jumlah_barang +1;
                                              total = total + int.parse(snapshot.data!.harga_jual);
                                          });
                                        },
                                      ),
                                    ]),
                                        ]),
                                    SizedBox(height: 8),
                                    Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text('Total',
                                              style: TextStyle(
                                                  color: Colors.grey)),
                                          SizedBox(height: 5),
                                          Text('Rp ${total}',
                                              style: TextStyle(
                                                  color: kPrimaryColor,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold)),
                                        ]),
                                    SizedBox(height: 10),
                                    Divider(
                                      color: kSecondaryColor,
                                    ),
                                    SizedBox(height: 5),
                                    SizedBox(height: 15),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children : [
                                        Expanded(
                                          child : ElevatedButton(
                                              onPressed: () {
                                                checkout();
                                              },
                                              style: ElevatedButton.styleFrom(
                                                primary: kPrimaryLightColor,
                                                shape: new RoundedRectangleBorder(
                                                  borderRadius: new BorderRadius.circular(30.0),
                                                ),
                                                padding: EdgeInsets.all(8),
                                              ),
                                              child: Text('Checkout', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold))),
                                        ),
                                        SizedBox(width: 15),
                                        Expanded(
                                          child : ElevatedButton(
                                              onPressed: () {
                                                _add_to_cart(snapshot.data!.id);
                                              },
                                              style: ElevatedButton.styleFrom(
                                                primary: kPrimaryLightColor,
                                                shape: new RoundedRectangleBorder(
                                                  borderRadius: new BorderRadius.circular(30.0),
                                                ),
                                                padding: EdgeInsets.all(8),
                                              ),
                                              child: Text('Keranjang',
                                                  style: TextStyle(
                                                      fontSize: 15, fontWeight: FontWeight.bold)))
                                        )
                                      ]
                                    )
                                  ],
                                )),
                            SizedBox(height: 20),
                          ],
                        )
                    )
                );
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              return Padding(padding: EdgeInsets.fromLTRB(20, 40, 20, 40), child: CircularProgressIndicator());
            })
    );
  }
  void checkout() async{
    print(jumlah);
    var array_of_orders = [];
      array_of_orders.add({
        'id' : id_barang,
        'harga' : harga_barang,
        'jumlah' : jumlah_barang
      });
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
        title: "Gagal checkout!",
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
  void _add_to_cart(id) async{

    var data = {
      'product_id' : id,
      'jumlah' : jumlah_barang,
    };
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
  }

}

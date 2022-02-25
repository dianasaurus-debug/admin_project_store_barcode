// import 'package:darurat_app/login_pemilik_kos.dart';
// import 'package:darurat_app/register_pemilik_kos.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:ghulam_app/controllers/product_controller.dart';
import 'package:ghulam_app/screens/daftar_favorit.dart';
import 'package:ghulam_app/screens/login_index.dart';
import 'package:ghulam_app/models/product.dart';
import 'package:ghulam_app/qr_view.dart';
import 'package:ghulam_app/screens/register_index.dart';
import 'package:ghulam_app/utils/constants.dart';
import 'package:ghulam_app/utils/size_config.dart';
import 'package:ghulam_app/widgets/bottom_navbar.dart';
// import 'package:intl/intl.dart';


class ProductDetail extends StatefulWidget {
  final String? kodeBarang;
  const ProductDetail({Key? key, required this.kodeBarang}) : super(key: key);

  @override
  State<StatefulWidget> createState() => new ProductDetailState();
}
class ProductDetailState extends State<ProductDetail> {
  // final formatCurrency = new NumberFormat.simpleCurrency(locale: 'id_ID');
  late Future<Product> futureProductbayar;

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
            'Checkout',
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
                                        Text(snapshot.data!.harga_jual,
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
                                        Text(
                                            '1',
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
                                        Text('Total',
                                            style: TextStyle(
                                                color: Colors.grey)),
                                        SizedBox(height: 5),
                                        Text('Rp.55.000',
                                            style: TextStyle(
                                                color: kPrimaryColor,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold)),
                                      ]),
                                  SizedBox(height: 10),
                                  Text('Keterangan Saldo',
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
                                        Text('Saldo Tersisa',
                                            style: TextStyle(
                                                color: Colors.grey)),
                                        SizedBox(height: 5),
                                        Text(
                                            'Rp. 50.000',
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
                                        Text('Saldo Setelah Pembelian',
                                            style: TextStyle(
                                                color: Colors.grey)),
                                        SizedBox(height: 5),
                                        Text('Rp.40.000',
                                            style: TextStyle(
                                                color: kPrimaryColor,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold)),
                                      ]),
                                  SizedBox(height: 15),
                                  GestureDetector(
                                      onTap: () {

                                      },
                                      child: Container(
                                        height: 50,
                                        decoration: BoxDecoration(
                                          color: kPrimaryColor,
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(10),
                                              topRight: Radius.circular(10),
                                              bottomLeft: Radius.circular(10),
                                              bottomRight: Radius.circular(10)),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey.withOpacity(0.3),
                                              spreadRadius: 3,
                                              blurRadius: 10,
                                              offset: Offset(
                                                  0, 3), // changes position of shadow
                                            ),
                                          ],
                                        ),
                                        child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                "Beli",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold),
                                              ),
                                            ]),
                                      )),
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
}

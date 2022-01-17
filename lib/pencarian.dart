// import 'package:darurat_app/login_pemilik_kos.dart';
// import 'package:darurat_app/register_pemilik_kos.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:ghulam_app/controllers/product_controller.dart';
import 'package:ghulam_app/daftar_favorit.dart';
import 'package:ghulam_app/login_index.dart';
import 'package:ghulam_app/models/product.dart';
import 'package:ghulam_app/qr_view.dart';
import 'package:ghulam_app/register_index.dart';
import 'package:ghulam_app/utils/constants.dart';
import 'package:ghulam_app/utils/size_config.dart';
import 'package:ghulam_app/widgets/bottom_navbar.dart';
// import 'package:intl/intl.dart';


class PencarianPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new PencarianPageState();
}
class PencarianPageState extends State<PencarianPage> {
  // final formatCurrency = new NumberFormat.simpleCurrency(locale: 'id_ID');
  late Future<List<Product>> futureListProduct;

  @override
  void initState() {
    // TODO: implement initState
    futureListProduct = ProductNetwork().getProducts();
  }
  Widget build(BuildContext context) {


    final ButtonStyle styleButton = ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
      onPrimary: Colors.black,
      padding: EdgeInsets.fromLTRB(100, 15, 100, 15),
      primary: kPrimaryColor,
    );
    return Scaffold(
        body: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(30,60,30,15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                alignment: Alignment.bottomLeft,
                child:Text('Toko', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),)
              ),
              const SizedBox(height: 20),
              TextField(
              onChanged: (value) {},
              decoration: InputDecoration(
                  isDense: true,
                  hintText: "Cari Barang",
                  prefixIcon: Icon(Icons.search, size: 35,),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)))),
            ),
              FutureBuilder<List<Product>>(
                  future: futureListProduct,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                            shrinkWrap: true,
                          itemCount: snapshot.data!.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Card(
                                child: Column(
                                  children: <Widget>[
                                    new
                                GestureDetector(
                                onTap: () {
                                setState(() {

                                });
                                },
                              child:
                              ListTile(
                                      leading: new Image.network(IMG_URL+snapshot.data![index].gambar, fit: BoxFit.cover,),
                                      title: new Text(
                                        snapshot.data![index].nama_barang,
                                        style: new TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
                                      ),
                                      subtitle: new Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            new Text('Rp. ${snapshot.data![index].harga_jual}',
                                                style: new TextStyle(
                                                    color: kPrimaryLightColor,
                                                    fontSize: 13.0, fontWeight: FontWeight.normal)),
                                          ]),
                                      trailing:
                                      Wrap(
                                        children: <Widget>[
                                          IconButton(
                                            icon: const Icon(Icons.shopping_cart, color: kPrimaryColor,),
                                            tooltip: 'Tambah ke keranjang',
                                            onPressed: () {

                                            }),
                                          IconButton(
                                              icon: const Icon(Icons.document_scanner, color: kPrimaryColor),
                                              tooltip: 'Beli',
                                              onPressed: () {
                                                Navigator.of(context).push(MaterialPageRoute(
                                                  builder: (context) => QRViewExample(kodeBarang: snapshot.data![index].kode_barang ),
                                                ));
                                              }),
                                        ],
                                      ),
                                    )
                                    )
                                  ],
                                ));
                          });
                    } else if (snapshot.hasError) {
                      return Text("${snapshot.error}");
                    }
                    return Padding(
                        padding: EdgeInsets.fromLTRB(20, 40, 20, 40),
                        child: CircularProgressIndicator());
                  })

            ],
          ),
        ),
        bottomNavigationBar: BottomNavbar(current : 0),
    );
  }
}

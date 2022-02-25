import 'package:flutter/material.dart';
import 'package:ghulam_app/controllers/product_controller.dart';
import 'package:ghulam_app/screens/detail_screen.dart';
import 'package:ghulam_app/screens/login_index.dart';
import 'package:ghulam_app/models/product.dart';
import 'package:ghulam_app/qr_view.dart';
import 'package:ghulam_app/utils/constants.dart';
import 'package:ghulam_app/widgets/app_bar.dart';
import 'package:ghulam_app/widgets/bottom_navbar.dart';
import 'package:ghulam_app/widgets/second_app_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';


class CartPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new CartPageState();
}

class CartPageState extends State<CartPage> {
  final formatCurrency = new NumberFormat.simpleCurrency(locale: 'id_ID');
  late Future<List<Product>> futureListProduct;
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
      appBar: SecondAppBar(
        appBar: AppBar(),
        isAuth: authAppBar,
        title: 'Keranjang',
      ),
      body: FutureBuilder<List<Product>>(
          future: futureListProduct,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(title: Text('${snapshot.data![index].nama_barang}', style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: kPrimaryColor,
                        fontSize: 15)),
                        subtitle: Text(
                            '${formatCurrency.format(int.parse(snapshot.data![index].harga_jual))}',
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
                            child: Image.network(IMG_URL + snapshot.data![index].gambar)
                          ),
                        ),
                        trailing: Icon(Icons.star));
                  }
              );
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            return Center(
                child: CircularProgressIndicator());
          }),
    );
  }
}

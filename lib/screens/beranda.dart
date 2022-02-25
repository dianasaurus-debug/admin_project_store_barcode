
import 'package:flutter/material.dart';
import 'package:ghulam_app/controllers/product_controller.dart';
import 'package:ghulam_app/models/category.dart';
import 'package:ghulam_app/screens/detail_screen.dart';
import 'package:ghulam_app/screens/login_index.dart';
import 'package:ghulam_app/models/product.dart';
import 'package:ghulam_app/qr_view.dart';
import 'package:ghulam_app/utils/constants.dart';
import 'package:ghulam_app/widgets/app_bar.dart';
import 'package:ghulam_app/widgets/bottom_navbar.dart';
import 'package:ghulam_app/widgets/category_chips.dart';
import 'package:ghulam_app/widgets/grid_product.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:intl/intl.dart';


class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new HomePageState();
}
class HomePageState extends State<HomePage> {
  // final formatCurrency = new NumberFormat.simpleCurrency(locale: 'id_ID');
  late Future<List<Product>> futureListProduct;
  late Future<List<Category>> futureListCategory;

  bool isAuth = false;
  void _checkIfLoggedIn() async{
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');
    if(token != null){
      setState(() {
        isAuth = true;
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
      appBar: BaseAppBar(
          appBar: AppBar(),
          isAuth: isAuth
      ),
      body: Padding(
          padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
          child:
          Column(
              children: [
                Align(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children:[
                          Text('Daftar Produk', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                          Text('Produk murah dan berkualitas!', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w100)),
                        ]
                    ),
                    alignment: Alignment.centerLeft
                ),
                SizedBox(height: 10,),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: <Widget>[
                      chipWidget('Makanan', Color(0xFF4db6ac)),
                      chipWidget('Minuman', Color(0xFF4db6ac)),
                      chipWidget('Perabotan', Color(0xFF4db6ac)),
                      chipWidget('Skincare', Color(0xFF4db6ac)),
                    ],
                  ),
                ),
                Container(
                    height: MediaQuery.of(context).size.height*(0.55),
                    child:SingleChildScrollView(
                        child:
                        FutureBuilder<List<Product>>(
                            future: futureListProduct,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return GridView.builder(
                                  physics: ScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: snapshot.data!.length,
                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 5, crossAxisSpacing: 7),
                                  itemBuilder: (BuildContext context, int index) {
                                    return GestureDetector(
                                      child: GridProduct(snapshot.data![index]),
                                      onTap: () => {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => DetailPage(product: snapshot.data![index])),
                                        )
                                      },
                                    );
                                  },
                                );
                              } else if (snapshot.hasError) {
                                return Text("${snapshot.error}");
                              }
                              return Center(child: Column(mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.center, children: [CircularProgressIndicator(backgroundColor: kPrimaryColor,),Text("\nMemuat data produk...")],),);
                            })
                    )
                )

              ]
          )

      ),
      bottomNavigationBar: BottomNavbar(current : 0),
    );
  }
}

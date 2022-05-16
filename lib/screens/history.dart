import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:ghulam_app/controllers/product_controller.dart';
import 'package:ghulam_app/models/order.dart';
import 'package:ghulam_app/screens/login_index.dart';
import 'package:ghulam_app/screens/product_detail.dart';
import 'package:ghulam_app/screens/register_index.dart';
import 'package:ghulam_app/utils/constants.dart';
import 'package:ghulam_app/widgets/bottom_navbar.dart';
import 'package:ghulam_app/widgets/second_app_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';


class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final _formKey = GlobalKey<FormState>();
  final formatCurrency = new NumberFormat.simpleCurrency(locale: 'id_ID');

  int isAuth = 2;
  bool authAppBar = false;
  late Future<List<Order>> futureListOrder;
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
  void initState() {
    // TODO: implement initState
    _checkIfLoggedIn();
    futureListOrder = ProductNetwork().allOrder();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SecondAppBar(
        appBar: AppBar(),
        isAuth: authAppBar,
        title: 'History Transaksi',
      ),
        body:
        isAuth != 2 ? (isAuth==1 ?
        FutureBuilder<List<Order>>(
            future: futureListOrder,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if(snapshot.data!.length>0){
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
                                  title: Row(
                                      children : [
                                        Text('Total: '),
                                        SizedBox(width : 5),
                                        Text(
                                            '${formatCurrency.format(int.parse(snapshot.data![index].total))}',
                                            style: TextStyle(
                                                fontSize: 13,
                                                color:
                                                Colors.redAccent,
                                                fontWeight:
                                                FontWeight.bold))
                                      ]
                                  ),
                                  subtitle : Column(
                                      children : [
                                        Row(
                                            children : [
                                              Text('Status: '),
                                              SizedBox(width : 5),
                                              snapshot.data![index].status == 1 ? Text('Lunas') : Text('Belum Lunas')
                                            ]
                                        ),
                                        SizedBox(width : 10),
                                        for(var i =0;i<snapshot.data![index].products!.length;i++)
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text('${snapshot.data![index].products![i].nama_barang}'),
                                              SizedBox(width: 5),
                                              Expanded(
                                                  child: Text('${snapshot.data![index].products![i].jumlah}x')
                                              )
                                            ],
                                          )
                                      ]
                                  )
                                // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),
                              ),
                            ),

                          ),
                          onTap: () => {
                            // Navigator.push(
                            //   context,
                            //   new MaterialPageRoute(
                            //   builder: (context) => ProductDetail(id_order : snapshot.data![index].id)
                            //   ),
                            // )
                          },
                        );
                      });
                } else {
                  return Center(child: Text('Tidak ada data transaksi'));
                }
              } else if (snapshot.hasError) {
                print(snapshot.hasData);
                return Text("Error : ${snapshot}");
              }
              return Center(child: CircularProgressIndicator());
            })
            : Center(child: Padding(
            padding : EdgeInsets.all(20),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.login,
                      size: 100,
                      color: kPrimaryColor),
                  SizedBox(
                      height : 10
                  ),
                  Text('Silahkan login atau daftar untuk melihat data pesanan', style: TextStyle(fontSize: 20, fontWeight : FontWeight.bold, ), textAlign: TextAlign.center),
                  SizedBox(
                      height : 20
                  ),
                  GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LoginIndexPage()),
                        );
                      },
                      child: Container(
                        height: 50,
                        margin: EdgeInsets.symmetric(horizontal: 50),
                        decoration: BoxDecoration(
                          color: kPrimaryColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            'Login',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      )),
                  SizedBox(
                      height : 10
                  ),
                  GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => RegisterIndexPage()),
                        );
                      },
                      child: Container(
                        height: 50,
                        margin: EdgeInsets.symmetric(horizontal: 50),
                        decoration: BoxDecoration(
                          color: kPrimaryColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            'Daftar',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      )),

                ])
        ))) : Center(child: CircularProgressIndicator(backgroundColor: Colors.green,))
      ,
      bottomNavigationBar: BottomNavbar(current : 2),
    );
  }
}

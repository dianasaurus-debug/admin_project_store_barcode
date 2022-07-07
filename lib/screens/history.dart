import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:ghulam_app/controllers/auth_controller.dart';
import 'package:ghulam_app/controllers/product_controller.dart';
import 'package:ghulam_app/models/order.dart';
import 'package:ghulam_app/models/product.dart';
import 'package:ghulam_app/screens/login_index.dart';
import 'package:ghulam_app/screens/product_detail.dart';
import 'package:ghulam_app/screens/register_index.dart';
import 'package:ghulam_app/utils/constants.dart';
import 'package:ghulam_app/utils/size_config.dart';
import 'package:ghulam_app/widgets/bottom_navbar.dart';
import 'package:ghulam_app/widgets/download_alert.dart';
import 'package:ghulam_app/widgets/pdf_reader.dart';
import 'package:ghulam_app/widgets/second_app_bar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';


class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  // Track the progress of a downloaded file here.
  double progress = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  // Track if the PDF was downloaded here.
  bool didDownloadPDF = false;

  // Show the progress status to the user.
  String progressString = 'File has not been downloaded yet.';

  final _formKey = GlobalKey<FormState>();
  final formatCurrency = new NumberFormat.simpleCurrency(locale: 'id_ID');
  PageController _controller = PageController();
  int isAuth = 2;
  bool authAppBar = false;
  List<int> product_ids = [];
  List<String> comment_review = [];
  List<double> comment_rating = [];
  int currentPage = 0;

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
  Widget _indicator(bool isActive) {
    return Container(
      height: 10,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 150),
        margin: EdgeInsets.symmetric(horizontal: 4.0),
        height: isActive
            ? 10:8.0,
        width: isActive
            ? 12:8.0,
        decoration: BoxDecoration(
          boxShadow: [
            isActive
                ? BoxShadow(
              color: Color(0XFF2FB7B2).withOpacity(0.72),
              blurRadius: 4.0,
              spreadRadius: 1.0,
              offset: Offset(
                0.0,
                0.0,
              ),
            )
                : BoxShadow(
              color: Colors.transparent,
            )
          ],
          shape: BoxShape.circle,
          color: isActive ? kPrimaryColor : Color(0XFFEAEAEA),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
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
                  return Column(
                      children : [
                        Expanded(
                          child : ListView.builder(
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
                                          title:
                                          Row(
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
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children : [
                                                Row(
                                                    children : [
                                                      Text('Status: '),
                                                      SizedBox(width : 5),
                                                      snapshot.data![index].status == 1 ? Text('Lunas') : Text('Belum Lunas')
                                                    ]
                                                ),
                                                Text('Tanggal : ${ parseDate(snapshot.data![index].created_at)}'),
                                                Text('List Produk', style: TextStyle(fontWeight: FontWeight.bold),),
                                                for(var i =0;i<snapshot.data![index].products!.length;i++)
                                                  Row(
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      Padding(padding: EdgeInsets.symmetric(horizontal: 2), child : Icon(Icons.fiber_manual_record, size: 10,)),
                                                      Expanded(
                                                        child :Text('${snapshot.data![index].products![i].nama_barang} ${snapshot.data![index].products![i].jumlah}x'),
                                                      )

                                                    ],
                                                  ),
                                              ]
                                          ),
                                          trailing: snapshot.data![index].status == 1 ?
                                          PopupMenuButton(
                                            itemBuilder: (context) {
                                              return [
                                                PopupMenuItem(
                                                  value: 'Nota',
                                                  child: Text('Nota'),
                                                ),
                                                PopupMenuItem(
                                                  value: 'Nilai',
                                                  child: Text('Nilai'),
                                                )
                                              ];
                                            },
                                            onSelected: (String value){
                                              if(value=='Nota'){
                                                downloadFile(context, '${API_URL}/order/nota/${snapshot.data![index].id}', 'nota.pdf');
                                              } else {
                                                setState(() {
                                                  product_ids.clear();
                                                  comment_review.clear();
                                                  comment_rating.clear();
                                                  currentPage = 0;
                                                });
                                                for(var i = 0;i<snapshot.data![index].products!.length;i++){
                                                  setState(() {
                                                    product_ids.add(snapshot.data![index].products![i].id);
                                                    comment_review.add('');
                                                    comment_rating.add(0.0);
                                                  });
                                                }
                                                _addRating(snapshot.data![index]);
                                              }
                                            },
                                          ) : ElevatedButton(
                                              onPressed: () {
                                                pay(snapshot.data![index].id);
                                              },
                                              style: ElevatedButton.styleFrom(
                                                primary: kPrimaryLightColor,
                                                shape: new RoundedRectangleBorder(
                                                  borderRadius:
                                                  new BorderRadius
                                                      .circular(
                                                      30.0),
                                                ),
                                                padding:
                                                EdgeInsets.all(
                                                    5),
                                              ),
                                              child: Text('Bayar',
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      fontWeight:
                                                      FontWeight
                                                          .bold)))
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
                              })
                        ),
                        Padding(
                          padding : EdgeInsets.all(10),
                          child : Row(
                              children : [
                                Expanded(
                                    child :ElevatedButton(
                                        onPressed: () async {
                                            downloadFile(context, '${API_URL}/order/all/nota', 'nota_all.pdf');
                                        },
                                        style: ElevatedButton.styleFrom(primary: kPrimaryColor,
                                          shape: new RoundedRectangleBorder(
                                            borderRadius: new BorderRadius.circular(30.0),
                                          ),
                                          padding: EdgeInsets.all(3),
                                        ),
                                        child: Text('Nota Semua Transaksi',
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight:
                                                FontWeight.bold)))
                                )
                              ]
                          )
                        )


                      ]
                    );
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
  Future downloadFile(BuildContext context, String url, String filename) async {
    print(url);
    PermissionStatus permission = await Permission.storage.status;

    if (permission != PermissionStatus.granted) {
      await Permission.storage.request();
      // access media location needed for android 10/Q
      await Permission.accessMediaLocation.request();
      // manage external storage needed for android 11/R
      await Permission.manageExternalStorage.request();
      startDownload(context, url, filename);
    } else {
      startDownload(context, url, filename);
    }
  }

  startDownload(BuildContext context, String url, String filename) async {
    Directory? appDocDir =  Directory('/storage/emulated/0/Download');

    String path = appDocDir.path + '/$filename';
    print(path);
    File file = File(path);
    if (!await file.exists()) {
      await file.create();
    } else {
      await file.delete();
      await file.create();
    }

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => DownloadAlert(
        url: url,
        path: path,
      ),
    ).then((v) {
      showSnackBar('Berhasil download nota');
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PDFScreen(path: file.path),
        ),
      );
    });
  }

  void showSnackBar(message) {
    final snackBarContent = SnackBar(
      behavior: SnackBarBehavior.floating,
      content: Text("${message}"),
      action: SnackBarAction(
          label: 'Tutup', onPressed: _scaffoldKey.currentState!.hideCurrentSnackBar),
    );
    _scaffoldKey.currentState!.showSnackBar(snackBarContent);
  }
  dynamic parseDate(date){
    DateTime parseDate =
    new DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").parse(date);
    var inputDate = DateTime.parse(parseDate.toString());
    var outputFormat = DateFormat('dd/MM/yyyy hh:mm');
    var outputDate = outputFormat.format(inputDate);
    return outputDate;
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
  // user defined function
  void _addRating(Order order) {
    List<Widget> _buildPageIndicator() {
      List<Widget> list = [];
      for (int j = 0; j < product_ids.length; j++) {
        list.add(j == currentPage ? _indicator(true) : _indicator(false));
      }
      return list;
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          scrollable: true,
          title: new Center(child:Text("Ulasan Anda")),
          content:
              Column(
                children : [
                  if(order.reviews==null)...[
                    Container(
                        width: MediaQuery.of(context).size.width*0.8,
                        height: MediaQuery.of(context).size.height*0.25,
                        child : PageView.builder(
                          controller: _controller,
                          reverse: false,
                          scrollDirection: Axis.horizontal,
                          onPageChanged: (int page) {
                            setState(() {
                              currentPage = page;
                            });
                          },
                          itemCount: product_ids.length,
                          itemBuilder: (BuildContext context, int i) {
                            return Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text('${order.products![i].nama_barang}', style : TextStyle(fontSize: 13), textAlign: TextAlign.center,),
                                  SizedBox(height : 2),
                                  RatingBar.builder(
                                      initialRating: 0,
                                      minRating: 1,
                                      direction: Axis.horizontal,
                                      allowHalfRating: true,
                                      itemCount: 5,
                                      itemSize: 25,
                                      itemPadding: EdgeInsets.symmetric(horizontal: 3.0),
                                      itemBuilder: (context, _) => Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                      ),
                                      onRatingUpdate: (val){
                                        setState(() {
                                          comment_rating[i] = val;
                                        });
                                      }
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  TextFormField(
                                    maxLines: 2,
                                    onChanged: (val){
                                      setState(() {
                                        comment_review[i] = val;
                                      });
                                    },
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: InputDecoration(
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: kPrimaryLightColor, width: 2),
                                      ),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: kPrimaryLightColor, width: 2),
                                      ),
                                      errorBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: Colors.red, width: 2),
                                      ),
                                      focusedErrorBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: Colors.red, width: 2),
                                      ),
                                      hintText: 'Komentar Anda..',
                                    ),

                                  ),
                                  SizedBox(height : 10),
                                ]);
                          },
                        )),
                  ] else ... [
                    Container(
                        width: MediaQuery.of(context).size.width*0.8,
                        height: MediaQuery.of(context).size.height*0.2,
                        child : PageView.builder(
                          controller: _controller,
                          reverse: false,
                          scrollDirection: Axis.horizontal,
                          onPageChanged: (int page) {
                            setState(() {
                              currentPage = page;
                            });
                          },
                          itemCount: order.reviews!.length,
                          itemBuilder: (BuildContext context, int i) {
                            return Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text('${order.reviews![i].product!.nama_barang}', style : TextStyle(fontSize: 13), textAlign: TextAlign.center,),
                                  SizedBox(height : 2),
                                  RatingBarIndicator(
                                      rating: double.parse(order.reviews![i].rating),
                                      direction: Axis.horizontal,
                                      itemCount: 5,
                                      itemSize: 25,
                                      itemPadding: EdgeInsets.symmetric(horizontal: 3.0),
                                      itemBuilder: (context, _) => Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                      ),

                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text('Komentar',
                                      style: TextStyle(
                                          color: kPrimaryColor,
                                          fontSize: 14,
                                          fontWeight:
                                          FontWeight.bold)),
                                  SizedBox(
                                    height: 2,
                                  ),
                                  Text('${order.reviews![i].comment}',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 12)),
                                  SizedBox(height : 10),
                                ]);
                          },
                        )),
                  ],
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children : [
                        for (Widget indicator in _buildPageIndicator())
                          indicator
                      ]
                  )
                ]
              ),
          actions: <Widget>[
            if(order.reviews==null)...[
              new ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.red,
                ),
                child: new Text("Tutup"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              new ElevatedButton(
                child: new Text("Simpan"),
                onPressed: () async {
                  var array_of_products = [];
                  for(var k = 0;k<product_ids.length;k++){
                    array_of_products.add({
                      'product_id' : product_ids[k],
                      'comment' : comment_review[k],
                      'rating' : comment_rating[k]
                    });
                  }
                  var data = {
                    'products' : array_of_products,
                    'order_id' : order.id,
                  };
                  var res = await AuthController().postData(data, '/order/rate');
                  var body = json.decode(res.body);
                  print(body);
                  if (body['success']) {
                    showSnackBar('Sukses memberikan rating!');
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HistoryPage()),
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
                },
              ),
            ] else ... [
              new ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.red,
                ),
                child: new Text("Tutup"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
            // usually buttons at the bottom of the dialog

          ],
        );
      },
    );
  }

}

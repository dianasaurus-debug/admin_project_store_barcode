import 'dart:async';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:ghulam_app/models/product.dart';
import 'package:ghulam_app/utils/constants.dart';
import 'package:intl/intl.dart';

class DetailPage extends StatefulWidget {
  final Product? product;

  const DetailPage({Key? key, required this.product}) : super(key: key);

  @override
  State<StatefulWidget> createState() => new DetailPageState();
}

class DetailPageState extends State<DetailPage> {
  final _formKey = GlobalKey<FormState>();
  var isPressed = false;
  int _jumlahBarang = 0;
  int totalBayar = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      isPressed = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final formatCurrency =
        new NumberFormat.simpleCurrency(locale: 'id_ID', decimalDigits: 0);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon:
              Icon(Icons.arrow_back_ios_rounded, color: Colors.grey, size: 25),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: IconButton(
                icon: Icon(
                  Icons.favorite,
                  color: (isPressed) ? Colors.pink : Colors.pink[100],
                  size: 30,
                ),
                onPressed: () {
                  setState(() {
                    isPressed = !isPressed;
                  });
                }),
          )
        ],
        elevation: 0,
        backgroundColor: Color(0xffffffff),
      ),
      body: ListView(children: [
        SizedBox(
          width: (300 / 375) * MediaQuery.of(context).size.width,
          child: AspectRatio(
            aspectRatio: 1.5,
            child: Image.network(IMG_URL + widget.product!.gambar),
          ),
        ),
        Container(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(top: 15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(30), topLeft: Radius.circular(30)),
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 0.5,
                    spreadRadius: 0.1,
                    offset: Offset(0.0, -3))
              ],
            ),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                '${widget.product!.nama_barang}',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: kPrimaryColor,
                    fontSize: 20),
              ),
              SizedBox(height: 8),
              Row(children: [
                RatingBarIndicator(
                  rating: double.parse(widget.product!.rating.toString()),
                  itemBuilder: (context, index) => Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  itemCount: 5,
                  itemSize: 22.0,
                  direction: Axis.horizontal,
                ),
                Text(
                  ' (15 Ulasan)',
                  style: TextStyle(color: Colors.black, fontSize: 15),
                ),
              ]),
              SizedBox(height: 8),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text(
                    '${formatCurrency.format(int.parse(widget.product!.harga_jual))}',
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.w900)),
                Text(
                  '200 Stok tersedia',
                  style: TextStyle(color: Colors.black, fontSize: 15),
                ),
              ]),
              SizedBox(height: 17),
              Text('Deskripsi',
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text(
                'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.',
                style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.normal),
                textAlign: TextAlign.justify,
              ),
              SizedBox(height: 15),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children : [
                        Text('Jumlah',
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                                fontWeight: FontWeight.bold)),
                        Row(
                            children : [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shadowColor: Colors.transparent,
                                  primary: Colors.grey[200],
                                  shape: CircleBorder(),
                                  padding: EdgeInsets.all(5),
                                ),
                                child: Icon(
                                  CupertinoIcons.minus,
                                  size: 15,
                                  color: kPrimaryLightColor,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _jumlahBarang--;
                                    totalBayar!=0?totalBayar-=int.parse(widget.product!.harga_jual):totalBayar=0;
                                  });
                                },
                              ),
                              Text(
                                  '${_jumlahBarang}',
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold)
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shadowColor: Colors.transparent,
                                  primary: Colors.grey[200],
                                  shape: CircleBorder(),
                                  padding: EdgeInsets.all(5),
                                ),
                                child: Icon(
                                  CupertinoIcons.add,
                                  size: 15,
                                  color: kPrimaryLightColor,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _jumlahBarang++;
                                    totalBayar+=int.parse(widget.product!.harga_jual);
                                  });
                                },
                              ),
                            ]
                        )
                      ]
                  ),
                  Divider(),
                  SizedBox(
                    height: 8,
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children : [
                        Text('Total dibayar',
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                                fontWeight: FontWeight.bold)),
                        Text('${formatCurrency.format(totalBayar)}',
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.red,
                                fontWeight: FontWeight.bold)),
                      ]
                  ),
                  SizedBox(
                    height: 15,
                  ),
              Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shadowColor: Colors.transparent,
                    primary: Colors.grey[100],
                    shape: CircleBorder(),
                    padding: EdgeInsets.all(20),
                  ),
                  child: Icon(
                    CupertinoIcons.cart_fill_badge_plus,
                    size: 30,
                    color: kPrimaryLightColor,
                  ),
                  onPressed: () {},
                ),
                SizedBox(width: 15),
                Expanded(
                    child: ElevatedButton(
                        onPressed: () {
                          _showModalBottomSheet();
                        },
                        style: ElevatedButton.styleFrom(
                          primary: kPrimaryLightColor,
                          shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0),
                          ),
                          padding: EdgeInsets.all(15),
                        ),
                        child: Text('Beli',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold))))
              ]),

            ]))
      ]),
    );
  }

  _showModalBottomSheet() {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
        ),
        context: context,
        builder: (context) {
          return Padding(
            padding : EdgeInsets.all(20),
            child : Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children : [
                      Text('Jumlah',
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.bold)),
                      Text('${_jumlahBarang}',
                          style: TextStyle(
                              fontSize: 18,
                              color: kPrimaryColor,
                              fontWeight: FontWeight.bold))
                    ]
                ),
                SizedBox(
                  height: 5,
                ),
                Divider(),
                SizedBox(
                  height: 8,
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children : [
                      Text('Total dibayar',
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.bold)),
                      Text('Rp ${totalBayar}',
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.red,
                              fontWeight: FontWeight.bold)),
                    ]
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  children : [
                    Expanded(
                        child: ElevatedButton(
                            onPressed: () {
                              _showModalBottomSheet();
                            },
                            style: ElevatedButton.styleFrom(
                              primary: kPrimaryLightColor,
                              shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(30.0),
                              ),
                              padding: EdgeInsets.all(15),
                            ),
                            child: Text('Checkout',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold))))
                  ]
                )

              ],
            )
          );
        });
  }
}

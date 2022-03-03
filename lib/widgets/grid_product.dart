import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:ghulam_app/models/product.dart';
import 'package:ghulam_app/utils/constants.dart';
import 'package:intl/intl.dart';

class GridProduct extends StatelessWidget {
  const GridProduct(this.product);

  @required
  final Product product;

  @override
  Widget build(BuildContext context) {
    final formatCurrency = new NumberFormat.simpleCurrency(locale: 'id_ID', decimalDigits: 0);

    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          AspectRatio(
            aspectRatio: 18.0 / 10.0,
            child: Image.network(IMG_URL + product.gambar),
          ),
          Padding(
            padding: EdgeInsets.all(MediaQuery.of(context).size.height*(0.01)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('${product.nama_barang}',
                    style: TextStyle(fontSize: 16, color: kPrimaryColor, fontWeight: FontWeight.w900)),
                const SizedBox(height: 5.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${formatCurrency.format(int.parse(product.harga_jual))}',
                        style: TextStyle(fontSize: 13, color: Colors.redAccent, fontWeight: FontWeight.bold)),
                    ClipOval(
                      child: Material(
                        color: kPrimaryLightColor,
                        child: InkWell(
                          onTap: (){},
                          child: Padding(
                            padding: const EdgeInsets.all(5),
                            child: Icon(Icons.add, size: 15, color: Colors.white,),
                          ),
                        ),
                      ),
                    )
                  ]
                )


              ],
            ),
          ),
        ],
      ),
    );
  }
}

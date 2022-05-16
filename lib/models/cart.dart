import 'package:ghulam_app/models/product.dart';

class Cart {
  late int jumlah;
  late int total;
  late int id;
  late int is_scanned;
  late  Product? product;


  Cart({this.jumlah = 0, this.total = 0,this.id = 0, this.is_scanned = 0});

  Cart.fromJson(Map<String, dynamic> json)
      : jumlah = json['jumlah'],
        total = json['total'],
        is_scanned = json['is_scanned'],
        product = json["product"] == null ? null : new Product.fromJson(json["product"]),
        id = json['id'];

  Map<String, dynamic> toJson() => {
    'id' : id,
    'jumlah': jumlah,
    'total': total,

  };
}
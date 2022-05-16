import 'package:ghulam_app/models/product.dart';

class Wishlist {
  late int id;
  late int user_id;

  late  Product? product;


  Wishlist({this.user_id = 0,this.id = 0});

  Wishlist.fromJson(Map<String, dynamic> json)
      : user_id = json['user_id'],
        product = json["product"] == null ? null : new Product.fromJson(json["product"]),
        id = json['id'];

  Map<String, dynamic> toJson() => {
    'id' : id,
    'user_id': user_id,

  };
}
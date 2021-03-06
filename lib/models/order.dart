import 'package:ghulam_app/models/product.dart';
import 'package:ghulam_app/models/review.dart';

class Order {
  late String total;
  late int id;
  late int status;
  late String created_at;
  late List<Review>? reviews;
  late  List<Product>? products;


  Order({this.total = '',this.id = 0, this.status = 0, this.created_at = ''});

  Order.fromJson(Map<String, dynamic> json)
      :total = json['total'],
        status = json['status'],
        created_at = json['created_at'],
        products = json["products"] == null ? null : List<Product>.from(json["products"].map((x) => new Product.fromJson(x))),
        reviews = json["rating"]!= null ? (json["rating"].isEmpty ? null : List<Review>.from(json["rating"].map((x) => new Review.fromJson(x)))) : null,
        id = json['id'];

  Map<String, dynamic> toJson() => {
    'id' : id,
    'total': total,

  };
}
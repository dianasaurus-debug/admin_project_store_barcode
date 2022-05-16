import 'package:ghulam_app/models/product.dart';

class Order {
  late String total;
  late int id;
  late int status;
  late  List<Product>? products;


  Order({this.total = '',this.id = 0, this.status = 0});

  Order.fromJson(Map<String, dynamic> json)
      :total = json['total'],
        status = json['status'],
        products = json["products"] == null ? null : List<Product>.from(json["products"].map((x) => new Product.fromJson(x))),
        id = json['id'];

  Map<String, dynamic> toJson() => {
    'id' : id,
    'total': total,

  };
}
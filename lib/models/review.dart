import 'package:ghulam_app/models/product.dart';

class Review {
  late String rating;
  late String comment;
  late int order_id;
  late int user_id;
  late Product? product;
  late int id;


  Review({this.rating = '', this.comment = '',this.order_id = 0, this.user_id = 0, this.id = 0});

  Review.fromJson(Map<String, dynamic> json)
      : rating = json['rating'],
        id = json['id'],
        order_id = json['order_id'],
        user_id = json['user_id'],
        product = json["product"] == null ? null : new Product.fromJson(json["product"]),
        comment = json['comment'];

  Map<String, dynamic> toJson() => {
    'id' : id,
    'order_id': order_id,
    'user_id': user_id,
    'comment': comment,
    'rating': rating,
  };
}
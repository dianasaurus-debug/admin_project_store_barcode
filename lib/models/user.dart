import 'package:ghulam_app/models/saldo.dart';

class User {
  late String first_name;
  late String last_name;
  late String email;
  late int id;
  late String phone;
  late String photo_path;
  late Saldo? saldo;


  User({this.id=0, this.first_name="",this.last_name="",this.email="", this.phone="", this.photo_path=""});

  User.fromJson(Map<String, dynamic> json)
      : first_name = json['first_name'],
        id = json['id'],
        last_name = json['last_name'],
        email = json['email'],
        phone = json['phone'],
        saldo = json["saldo"] == null ? null : new Saldo.fromJson(json["saldo"]),
        photo_path = json['photo_path'];

  Map<String, dynamic> toJson() => {
    'id' : id,
    'first_name': first_name,
    'last_name': last_name,
    'email': email,
    'phone' : phone,
    'photo_path' : photo_path
  };
}
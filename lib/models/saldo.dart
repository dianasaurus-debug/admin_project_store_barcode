import 'package:ghulam_app/models/user.dart';

class Saldo {
  late String jumlah;
  late int id;


  Saldo({this.id =0, this.jumlah=''});

  Saldo.fromJson(Map<String, dynamic> json)
      : jumlah = json['jumlah'],
        id = json['id'];

  Map<String, dynamic> toJson() => {
    'id' : id,
    'jumlah': jumlah,
  };
}

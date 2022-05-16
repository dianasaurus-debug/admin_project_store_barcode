import 'package:ghulam_app/models/sub_category.dart';

class Category {
  final String nama_kategori;
  final int id;
  late  List<SubCategory>? sub_categories;


  Category(this.nama_kategori,this.id);

  Category.fromJson(Map<String, dynamic> json)
      : nama_kategori = json['nama_kategori'],
        sub_categories = json["sub_categories"] == null ? null : List<SubCategory>.from(json["sub_categories"].map((x) => new SubCategory.fromJson(x))),
        id = json['id'];

  Map<String, dynamic> toJson() => {
    'id' : id,
    'nama_kategori': nama_kategori,
  };
}
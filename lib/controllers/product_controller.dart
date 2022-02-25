
import 'dart:convert';

import 'package:ghulam_app/models/product.dart';
import 'package:ghulam_app/utils/constants.dart';
import 'package:http/http.dart' as http;

class ProductNetwork {
  Future<List<Product>> getProducts() async {
    var full_url = API_URL+'/products';
    final res = await http.get(Uri.parse(full_url));

    if (res.statusCode == 200) {
      var json = jsonDecode(res.body);
      List data = json['data'];
      return data.map((products) => new Product.fromJson(products)).toList();
    } else {
      throw Exception('Failed to fetch data');
    }
  }

  Future<Product> getDetailProductByKode(kode) async {
    var full_url = API_URL+'/products/detail?kode_barang='+kode;
    final res = await http.get(Uri.parse(full_url));

    if (res.statusCode == 200) {
      var json = jsonDecode(res.body);
      var data = json['data'];
      return new Product.fromJson(data);
    } else {
      throw Exception('Failed to fetch data');
    }
  }


}
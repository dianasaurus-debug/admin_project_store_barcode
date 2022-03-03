
import 'dart:convert';

import 'package:ghulam_app/models/category.dart';
import 'package:ghulam_app/utils/constants.dart';
import 'package:http/http.dart' as http;

class CategoryNetwork {
  Future<List<Category>> getCategories() async {
    var full_url = API_URL+'/products/categories';
    final res = await http.get(Uri.parse(full_url));
    if (res.statusCode == 200) {
      var json = jsonDecode(res.body);
      List data = json['data'];
      return data.map((categories) => new Category.fromJson(categories)).toList();
    } else {
      throw Exception('Failed to fetch data');
    }
  }
}
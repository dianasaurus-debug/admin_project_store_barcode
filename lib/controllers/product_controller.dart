
import 'dart:convert';

import 'package:ghulam_app/models/cart.dart';
import 'package:ghulam_app/models/order.dart';
import 'package:ghulam_app/models/parameter.dart';
import 'package:ghulam_app/models/product.dart';
import 'package:ghulam_app/models/wishlist.dart';
import 'package:ghulam_app/utils/constants.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ProductNetwork {
  var token;

  _getToken() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    token = jsonDecode(localStorage.getString('token'));
  }
  _setHeaders() => {
    'Content-type' : 'application/json',
    'Accept' : 'application/json',
    'Authorization' : 'Bearer $token'
  };

  Future<List<Product>> getProducts() async {
    var full_url = API_URL+'/products';
    final res = await http.get(Uri.parse(full_url));

    if (res.statusCode == 200) {
      var json = jsonDecode(res.body);
      List data = json['data'];
      print(data);
      return data.map((products) => new Product.fromJson(products)).toList();
    } else {
      throw Exception('Failed to fetch data');
    }
  }

  Future<List<Cart>> getFromCarts() async {
    var full_url = API_URL+'/cart/all';
    await _getToken();
    final res = await http.get( Uri.parse(full_url),
        headers: _setHeaders());


    if (res.statusCode == 200) {
      var json = jsonDecode(res.body);
      List data = json['data'];
      print('data di cart');
      print(data);
      return data.map((carts) => new Cart.fromJson(carts)).toList();
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

  Future<Order> getOneOrder(id) async {
    var full_url = API_URL+'/order/detail/${id}';
    await _getToken();
    final res = await http.get( Uri.parse(full_url),
        headers: _setHeaders());

    if (res.statusCode == 200) {
      var json = jsonDecode(res.body);
      var data = json['data'];
      return new Order.fromJson(data);
    } else {
      throw Exception('Failed to fetch data');
    }
  }
  Future<List<Order>> allOrder() async {
    var full_url = API_URL+'/order/all';
    await _getToken();
    final res = await http.get( Uri.parse(full_url),
        headers: _setHeaders());
    if (res.statusCode == 200) {
      var json = jsonDecode(res.body);
      List data = json['data'];
      return data.map((orders) => new Order.fromJson(orders)).toList();
    } else {
      throw Exception('Failed to fetch data');
    }
  }

  Future<List<Product>> getRecommendations(Parameter data) async {
    var full_url = API_URL+'/products/recommendation?criteria_harga=${data.criteria_harga}&criteria_supplier=${data.criteria_supplier}&criteria_rating=${data.criteria_rating}&category_id=${data.category_id}';
    final res = await http.get(Uri.parse(full_url));

    if (res.statusCode == 200) {
      var json = jsonDecode(res.body);
      List data = json['data'];
      return data.map((products) => new Product.fromJson(products)).toList();
    } else {
      throw Exception('Failed to fetch data');
    }
  }

  Future<List<Wishlist>> getFromWishlist() async {
    var full_url = API_URL+'/wishlist/all';
    await _getToken();
    final res = await http.get( Uri.parse(full_url),
        headers: _setHeaders());


    if (res.statusCode == 200) {
      var json = jsonDecode(res.body);
      List data = json['data'];
      print(data);
      return data.map((products) => new Wishlist.fromJson(products)).toList();
    } else {
      throw Exception('Failed to fetch data');
    }
  }
  Future<Wishlist> addToWishlist(id) async {
    var full_url = API_URL+'/wwishlist/add/'+id;
    await _getToken();
    final res = await http.get( Uri.parse(full_url),
        headers: _setHeaders());

    if (res.statusCode == 200) {
      var json = jsonDecode(res.body);
      var data = json['data'];
      return new Wishlist.fromJson(data);
    } else {
      throw Exception('Failed to fetch data');
    }
  }
  Future<Wishlist> removeFromWishlist(id) async {
    var full_url = API_URL+'/wishlist/remove/'+id;
    final res = await http.get(Uri.parse(full_url));

    if (res.statusCode == 200) {
      var json = jsonDecode(res.body);
      var data = json['data'];
      return new Wishlist.fromJson(data);
    } else {
      throw Exception('Failed to fetch data');
    }
  }

}
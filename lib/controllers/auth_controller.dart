import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:ghulam_app/models/user.dart';
import 'package:ghulam_app/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
class AuthController {
  // ignore: prefer_typing_uninitialized_variables
  var token;

  _getToken() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    token = jsonDecode(localStorage.getString('token'));
  }

  Future<User> getProfile() async {
    var full_url = API_URL+'/profile';
    await _getToken();
    final res = await http.get( Uri.parse(full_url),
        headers: _setHeaders());

    if (res.statusCode == 200) {
      var json = jsonDecode(res.body);
      var data = json['data'];
      print(json);
      return new User.fromJson(data);
    } else {
      throw Exception(res.body);
    }
  }


  postData(data, apiUrl) async {
    var fullUrl = API_URL + apiUrl;
    await _getToken();
    return await http.post(
        Uri.parse(fullUrl),
        body: jsonEncode(data),
        headers: _setHeaders()
    );
  }

  getData(apiUrl) async {
    var fullUrl = API_URL + apiUrl;
    await _getToken();
    return await http.get(
        Uri.parse(fullUrl),
        headers: _setHeaders()
    );
  }

  authData(data, apiUrl) async {
    var fullUrl = API_URL + apiUrl;
    return await http.post(
        Uri.parse(fullUrl),
        body: jsonEncode(data),
        headers: _setHeaders()
    );
  }

  putData(data, apiUrl) async {
    var fullUrl = API_URL + apiUrl;
    return await http.put(
        Uri.parse(fullUrl),
        body: jsonEncode(data),
        headers: _setHeaders()
    );
  }
  putDataAuth(data, apiUrl) async {
    var fullUrl = API_URL + apiUrl;
    await _getToken();
    return await http.put(
        Uri.parse(fullUrl),
        body: jsonEncode(data),
        headers: _setHeaders()
    );
  }
  deleteData(data, apiUrl) async {
    var fullUrl = API_URL + apiUrl;
    await _getToken();
    return await http.delete(
        Uri.parse(fullUrl),
        body: jsonEncode(data),
        headers: _setHeaders()
    );
  }

  _setHeaders() => {
    'Content-type' : 'application/json',
    'Accept' : 'application/json',
    'Authorization' : 'Bearer $token'
  };

}
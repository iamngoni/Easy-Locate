import 'dart:convert';
import 'dart:io';

import 'package:easy_locate/models/categories.dart';
import 'package:easy_locate/models/product.dart';
import 'package:easy_locate/models/token.dart';
import 'package:easy_locate/models/token_id.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiCalls {
  static const baseUrl = "http://10.15.17.185:8080";
//  static const baseUrl = "http://hitwo-api.herokuapp.com";
  final Geolocator geoLocator = Geolocator()..forceAndroidLocationManager;

  // ignore: missing_return
  Future<JwtToken> login(username, password) async {
    var response;
    try {
      response = await http.post("$baseUrl/mobile/signin",
          body: {'username': username, 'password': password});
      if (response.statusCode == 200) {
        return JwtToken.fromJson(json.decode(response.body));
      } else {
        return null;
      }
    } on SocketException catch (e) {
      print(e);
    } catch (e) {
      print(e);
    }
  }

  register(username, email, mobileNumber, password) async {
    var response;
    try {
      response = await http.post("$baseUrl/mobile/signup", body: {
        'username': username,
        'email': email,
        'mobileNumber': mobileNumber,
        'password': password
      });
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
    }
  }

  Future<List<Products>> getProducts() async {
    var preferences = await SharedPreferences.getInstance();
    var token = preferences.getString("token");
    var products = List<Products>();
    try {
      var response = await http.get("$baseUrl/mobile/products", headers: {
        "Content-type": "application/json",
        "Accept": "application/json",
        "Authorization": "Bearer $token"
      });
      if (response.statusCode == 200) {
        var productsJson = json.decode(response.body);
        for (var productJson in productsJson) {
          products.add(Products.fromJSON(productJson));
        }
      }
    } on SocketException catch (e) {
      print(e);
      return [];
    } catch (e) {
      print(e);
      return [];
    }
    return products;
  }

  Future<Placemark> getActualLocation() async {
    LocationData data = await _getCoords();
    List<Placemark> placemarc;
    try {
      placemarc = await geoLocator.placemarkFromCoordinates(
          data.latitude, data.longitude);
    } catch (e) {
      print(e);
    }
    Placemark place = placemarc[0];
    return place;
  }

  _getCoords() async {
    Location location = new Location();
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();
    return _locationData;
  }

  // ignore: missing_return
  Future<bool> verifyMobileNumber(id, token) async {
    var response;
    try {
      response = await http.post("$baseUrl/mobile/utils/verify/$id/$token");
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
    }
  }

  getCode(number) async {
    var response;
    try {
      response = await http.post("$baseUrl/mobile/utils/get_token/$number");
      if (response.statusCode == 200) {
        return Id.fromJson(json.decode(response.body));
      } else {
        return false;
      }
    } catch (e) {
      print(e);
    }
  }

  Future<List<Category>> getCategories() async {
    var response;
    var categories = List<Category>();
    var preferences = await SharedPreferences.getInstance();
    var token = preferences.getString("token");
    try {
      response = await http.get("$baseUrl/public/categories", headers: {
        "Content-type": "application/json",
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      });
      if (response.statusCode == 200) {
        var _categories = json.decode(response.body);
        for (var category in _categories) {
          categories.add(Category.fromJson(category));
        }
        return categories;
      } else {
        print("categories fetch not successful");
        return [];
      }
    } catch (e) {
      print(e);
      return [];
    }
  }
}

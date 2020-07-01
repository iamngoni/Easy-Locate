import 'dart:convert';
import 'dart:io';
import 'package:easy_locate/models/message.dart';
import 'package:easy_locate/models/product.dart';
import 'package:easy_locate/models/token.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';

class ApiCalls {
  static const baseUrl = "http://192.168.43.175:8080";
  // static const baseUrl = "http://192.168.43.155:8080";
  final Geolocator geoLocator = Geolocator()..forceAndroidLocationManager;
  Position _currentPosition;
  // ignore: missing_return
  Future<JwtToken> login(username, password, context) async {
    var response;
    try {
      response = await http.post("$baseUrl/mobile/signin",
          body: {'username': username, 'password': password});
      ProgressHUD.of(context).dismiss();
      if (response.statusCode == 200) {
        return JwtToken.fromJson(json.decode(response.body));
      } else {
        Toast.show(
          "${response.statusCode}: ${StatusMessage.fromJson(json.decode(response.body)).message}",
          context,
          backgroundColor: Colors.grey.withOpacity(0.4),
          textColor: Colors.red,
        );
      }
    } on SocketException catch (e) {
      print(e);
    } catch (e) {
      print(e);
      Toast.show(
        "Error occured",
        context,
        backgroundColor: Colors.grey.withOpacity(0.4),
        textColor: Colors.red,
      );
    }
  }

  Future<List<Products>> getProducts(context) async {
    var products = List<Products>();
    try {
      var response = await http.get("$baseUrl/products");
      if (response.statusCode == 200) {
        var productsJson = json.decode(response.body);
        for (var productJson in productsJson) {
          products.add(Products.fromJSON(productJson));
        }
      }
    } on SocketException catch (e) {
      Toast.show("Failed to contact server", context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.BOTTOM,
          backgroundColor: Colors.grey.withOpacity(0.4));
    } catch (e) {
      Toast.show("Unknown error occured", context,
          duration: Toast.LENGTH_LONG,
          backgroundColor: Colors.grey.withOpacity(0.4),
          gravity: Toast.BOTTOM);
    }
    return products;
  }

  getAddressFromLatLng() async {
    await _getCurrentLocation();
    try {
      List<Placemark> p = await geoLocator.placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);
      Placemark place = p[0];
      return place;
    } catch (e) {
      print(e);
    }
  }

  _getCurrentLocation() async {
    await geoLocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      _currentPosition = position;
    }).catchError((e) {
      print(e);
    });
  }
}

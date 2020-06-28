import 'dart:convert';
import 'package:easy_locate/models/user.dart';
import 'package:easy_locate/statics/static.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

class ApiCalls{
  static const baseUrl = "http://192.168.43.175:8080";
  Future<User> login(username, password) async{
    var response;
    try{
      response = await http.post("$baseUrl/mobile.signin", body: {'username': username, 'password': password});
      if(response.statusCode == 200){
        return User.fromJson(json.decode(response.body));
      }
    }catch(e){
      Fluttertoast.showToast(
        msg: "Error occured",
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.grey.withOpacity(0.4),
        textColor: Colors.black,
        fontSize: 18.0,
      );
    }
  }
}
import 'dart:convert';
import 'package:easy_locate/models/message.dart';
import 'package:easy_locate/models/token.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
// import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class ApiCalls {
  // static const baseUrl = "http://192.168.43.175:8080";
  static const baseUrl = "http://10.15.5.149:8080";
  // ignore: missing_return
  Future<JwtToken> login(username, password, context) async {
    var response;
    try {
      response = await http.post("$baseUrl/mobile/signin", body: {
        'username': username, 'password': password
      });
      ProgressHUD.of(context).dismiss();
      if (response.statusCode == 200) {
        return JwtToken.fromJson(json.decode(response.body));
      }else{
        // Fluttertoast.showToast(
        //   msg: "${response.statusCode}: ${StatusMessage.fromJson(json.decode(response.body)).message}",
        //   backgroundColor: Colors.grey.withOpacity(0.4),
        //   textColor: Colors.black,
        //   fontSize: 18.0,
        // );
      }
    } catch (e) {
      print(e);
      // Fluttertoast.showToast(
      //   msg: "Error occured",
      //   backgroundColor: Colors.grey.withOpacity(0.4),
      //   textColor: Colors.black,
      //   fontSize: 18.0,
      // );
    }
  }
}

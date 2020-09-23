import 'package:easy_locate/api/apiCalls.dart';
import 'package:easy_locate/statics/static.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class ChangePassword extends StatefulWidget {
  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  ApiCalls _api = new ApiCalls();
  bool _isChanging = false;
  Future<dynamic> _place;
  final _formKey = GlobalKey<FormState>();
  String p1;
  String p2;
  @override
  void initState() {
    _place = _api.getActualLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Statics _statics = new Statics(context);
    return ModalProgressHUD(
      inAsyncCall: _isChanging,
      child: SafeArea(
        child: Scaffold(
          body: Container(
            height: _statics.height,
            width: _statics.width,
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: ListView(
              scrollDirection: Axis.vertical,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: <Widget>[
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: InkWell(
                              onTap: () => Navigator.of(context).pop(),
                              child: Icon(
                                Icons.arrow_back,
                                size: 30,
                              ),
                            ),
                          ),
                          SizedBox(width: 5),
                          SizedBox(
                            width: _statics.width * 0.5,
                            child: Text(
                              "Settings",
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                              softWrap: false,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.location_on,
                            size: 27,
                            color: Colors.grey,
                          ),
                          FutureBuilder(
                            future: _place,
                            // ignore: missing_return
                            builder: (context, snapshot) {
                              while (!snapshot.hasData) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 5.0),
                                  child: SizedBox(
                                    height: 18,
                                    width: 18,
                                    child: CircularProgressIndicator(
                                      backgroundColor: _statics.purplish,
                                    ),
                                  ),
                                );
                              }
                              var place = snapshot.data;
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text("${place.name}"),
                                  Text("${place.country}"),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Container(
                  height: _statics.height * 0.9,
                  width: _statics.width,
                  decoration: BoxDecoration(
                    color: _statics.purplish,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Container(
                      height: _statics.height * 0.9,
                      width: _statics.width,
                      child: ListView(
                        scrollDirection: Axis.vertical,
                        children: [
                          SizedBox(
                            height: 25,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                labelText: "Current Password",
                                labelStyle: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                                fillColor: Colors.white.withOpacity(0.8),
                                filled: true,
                              ),
                              // ignore: missing_return
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "Field can't be empty";
                                } else {
                                  print("Value is $value");
                                  setState(() {
                                    p1 = value;
                                  });
                                }
                              },
                              obscureText: true,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                labelText: "New Password",
                                labelStyle: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                                fillColor: Colors.white.withOpacity(0.8),
                                filled: true,
                              ),
                              obscureText: true,
                              // ignore: missing_return
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "Field can't be empty";
                                } else {
                                  setState(() {
                                    p2 = value;
                                  });
                                }
                              },
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              color: Colors.white,
                              child: MaterialButton(
                                onPressed: () async {
                                  if (_formKey.currentState.validate()) {
                                    setState(() {
                                      _isChanging = true;
                                    });
                                    print(p1);
                                    print(p2);
//                                    const baseUrl = "http://192.168.43.91:8081";
                                    const baseUrl = "http://10.15.10.162:8081";
                                    var response;
                                    var preferences =
                                        await SharedPreferences.getInstance();
                                    var token = preferences.getString("token");
                                    try {
                                      response = await http.post(
                                          "$baseUrl/mobile/change_password",
                                          body: {
                                            "currentPassword": p1,
                                            "newPassword": p2
                                          },
                                          headers: {
                                            "Accept": "application/json",
                                            "Authorization": "Bearer $token"
                                          });
                                      if (response.statusCode == 200) {
                                        setState(() {
                                          _isChanging = false;
                                        });
                                        Toast.show(
                                          "Success",
                                          context,
                                          gravity: Toast.BOTTOM,
                                          duration: Toast.LENGTH_SHORT,
                                        );
                                        Navigator.of(context).pop();
                                      } else {
                                        setState(() {
                                          _isChanging = false;
                                        });
                                        Toast.show(
                                          "Failed",
                                          context,
                                          gravity: Toast.BOTTOM,
                                          duration: Toast.LENGTH_SHORT,
                                        );
                                      }
                                    } catch (e) {
                                      print(e);
                                    }
                                  }
                                },
                                child: Text(
                                  "CHANGE PASSWORD",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

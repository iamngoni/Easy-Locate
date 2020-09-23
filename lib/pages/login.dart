import 'package:easy_locate/api/apiCalls.dart';
import 'package:easy_locate/models/token.dart';
import 'package:easy_locate/models/user.dart';
import 'package:easy_locate/pages/home.dart';
import 'package:easy_locate/pages/signup.dart';
import 'package:easy_locate/pages/verification.dart';
import 'package:easy_locate/statics/static.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  bool _sending = false;
  String _username;
  String _password;
  Future<User> user;
  @override
  Widget build(BuildContext context) {
    ApiCalls _api = ApiCalls();
    Statics _statics = new Statics(context);
    return ModalProgressHUD(
      inAsyncCall: _sending,
      child: Scaffold(
        body: SingleChildScrollView(
          child: SafeArea(
            child: Container(
              height: _statics.height,
              width: _statics.width,
              child: Column(
                children: <Widget>[
                  Container(
                    height: _statics.height * 0.3,
                    decoration: BoxDecoration(
                      color: _statics.purplish,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Image(
                            image: AssetImage("assets/images/logo.png"),
                            height: 75,
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "Login",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "to your account.",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      width: _statics.width,
                      child: Column(
                        children: <Widget>[
                          Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(height: _statics.height * 0.07),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0,
                                    vertical: 5.0,
                                  ),
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                      labelText: "Username",
                                      labelStyle: TextStyle(
                                        color: _statics.purplish,
                                      ),
                                      fillColor:
                                          _statics.purplish.withOpacity(0.2),
                                      focusColor: _statics.purplish,
                                      hoverColor: _statics.purplish,
                                      border: InputBorder.none,
                                      filled: true,
                                      prefixIcon: Icon(
                                        Icons.person_outline,
                                      ),
                                    ),
                                    // ignore: missing_return
                                    validator: (value) {
                                      if (value.isNotEmpty) {
                                        setState(() {
                                          this._username = value;
                                        });
                                      } else {
                                        return 'Username field can\'t be empty';
                                      }
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0,
                                    vertical: 5.0,
                                  ),
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                      labelText: "Password",
                                      labelStyle: TextStyle(
                                        color: _statics.purplish,
                                      ),
                                      fillColor:
                                          _statics.purplish.withOpacity(0.2),
                                      focusColor: _statics.purplish,
                                      hoverColor: _statics.purplish,
                                      border: InputBorder.none,
                                      filled: true,
                                      prefixIcon: Icon(
                                        Icons.lock_outline,
                                      ),
                                    ),
                                    obscureText: true,
                                    // ignore: missing_return
                                    validator: (value) {
                                      if (value.isNotEmpty) {
                                        if (value.length > 8) {
                                          setState(() {
                                            this._password = value;
                                          });
                                        } else {
                                          return 'Password length can\'t be less than 8 characters';
                                        }
                                      } else {
                                        return 'Password field can\'t be empty';
                                      }
                                    },
                                  ),
                                ),
                                SizedBox(
                                  height: _statics.height * 0.07,
                                ),
                                Container(
                                  width: _statics.width * 0.95,
                                  decoration: BoxDecoration(
                                    color: _statics.purplish,
                                  ),
                                  child: MaterialButton(
                                    child: Text(
                                      "CONTINUE",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    onPressed: () async {
                                      if (_formKey.currentState.validate()) {
                                        setState(() {
                                          _sending = true;
                                        });
                                        JwtToken _token = await _api.login(
                                          _username,
                                          _password,
                                        );
                                        setState(() {
                                          _sending = false;
                                        });
                                        Map<String, dynamic> _decodedToken =
                                            JwtDecoder.decode(_token.token);
                                        if (_decodedToken['isVerified'] ==
                                            false) {
                                          Toast.show(
                                              "Mobile number not verified",
                                              context,
                                              gravity: Toast.BOTTOM,
                                              duration: Toast.LENGTH_LONG,
                                              backgroundColor:
                                                  Colors.grey.withOpacity(0.4));
                                          return Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  MobileNumberVerification(),
                                            ),
                                          );
                                        }
                                        if (_token != null) {
                                          final preferences =
                                              await SharedPreferences
                                                  .getInstance();
                                          await preferences.setString(
                                              'token', _token.token);
                                          String savedToken =
                                              preferences.getString('token');
                                          if (savedToken != null ||
                                              savedToken != '') {
                                            Navigator.pop(context);
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (context) => Home(),
                                              ),
                                            );
                                          }
                                        } else {
                                          Toast.show("Exception!", context,
                                              backgroundColor:
                                                  Colors.grey.withOpacity(0.4),
                                              textColor: Colors.red,
                                              gravity: Toast.BOTTOM);
                                        }
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 15.0),
                            child: Row(
                              children: <Widget>[
                                Text("Not registered?"),
                                SizedBox(width: 10),
                                GestureDetector(
                                  onTap: () => Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (context) => SignUp())),
                                  child: Text(
                                    "Sign up here!",
                                    style: TextStyle(
                                      color: _statics.purplish,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

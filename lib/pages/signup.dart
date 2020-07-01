import 'package:easy_locate/api/apiCalls.dart';
import 'package:easy_locate/models/token.dart';
import 'package:easy_locate/models/user.dart';
import 'package:easy_locate/pages/home.dart';
import 'package:easy_locate/statics/static.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  ApiCalls _api = ApiCalls();
  String _username;
  String _password;
  String _mobileNumber;
  String _email;
  Future<User> user;
  @override
  Widget build(BuildContext context) {
    Statics _statics = new Statics(context);
    return Scaffold(
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
                            "Hello",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "Sign up for my account",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 25,
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
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(height: _statics.height * 0.07),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: TextFormField(
                              decoration: InputDecoration(
                                labelText: "Username",
                                labelStyle: TextStyle(
                                  color: _statics.purplish,
                                ),
                                fillColor: _statics.purplish,
                                focusColor: _statics.purplish,
                                hoverColor: _statics.purplish,
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
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: TextFormField(
                              decoration: InputDecoration(
                                labelText: "Password",
                                labelStyle: TextStyle(
                                  color: _statics.purplish,
                                ),
                                fillColor: _statics.purplish,
                                focusColor: _statics.purplish,
                                hoverColor: _statics.purplish,
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
                            height: _statics.height * 0.1,
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
                                  final progress = ProgressHUD.of(context);
                                  progress.showWithText("Signing in");
                                  JwtToken _token = await _api.login(
                                      _username, _password, context);
                                  // Map<String, dynamic> _decodedToken = JwtDecoder.decode(_token.token);
                                  if (_token != null) {
                                    final preferences =
                                        await SharedPreferences.getInstance();
                                    await preferences.setString(
                                        'token', _token.token);
                                    String savedToken =
                                        preferences.getString('token');
                                    if (savedToken != null ||
                                        savedToken != '') {
                                      Navigator.pop(context);
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) => Home()));
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

import 'package:easy_locate/api/apiCalls.dart';
import 'package:easy_locate/models/user.dart';
import 'package:easy_locate/pages/login.dart';
import 'package:easy_locate/pages/verification.dart';
import 'package:easy_locate/statics/static.dart';
import 'package:flutter/material.dart';
import 'package:localregex/localregex.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:toast/toast.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  String _username;
  String _password;
  String _mobileNumber;
  String _email;
  Future<User> user;
  bool _sending = false;

  bool testNumber(String number) {
    LocalRegex regex = new LocalRegex();
    if (regex.econet.hasMatch(number)) {
      print("passed");
      return true;
    } else if (regex.telecel.hasMatch(number)) {
      print("passed");
      return true;
    } else if (regex.netone.hasMatch(number)) {
      print("passed");
      return true;
    } else {
      print("failed");
      return false;
    }
  }

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
                              "Hello",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "Sign up for an account",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
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
                                    keyboardType: TextInputType.text,
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
                                      labelText: "Email",
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
                                        Icons.mail_outline,
                                      ),
                                    ),
                                    keyboardType: TextInputType.emailAddress,
                                    // ignore: missing_return
                                    validator: (value) {
                                      if (value.isNotEmpty) {
                                        setState(() {
                                          this._email = value;
                                        });
                                      } else {
                                        return 'Email field can\'t be empty';
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
                                      labelText: "Mobile Number",
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
                                        Icons.dialpad,
                                      ),
                                    ),
                                    keyboardType: TextInputType.phone,
                                    // ignore: missing_return
                                    validator: (value) {
                                      if (value.isNotEmpty) {
                                        if (testNumber(value)) {
                                          setState(() {
                                            this._mobileNumber = value;
                                          });
                                        } else {
                                          return 'Mobile number format not recognized';
                                        }
                                      } else {
                                        return 'Mobile number field can\'t be empty';
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
                                  height: _statics.height * 0.01,
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
                                        bool isCreated = await _api.register(
                                          _username,
                                          _email,
                                          _mobileNumber,
                                          _password,
                                        );
                                        setState(() {
                                          _sending = false;
                                        });
                                        if (isCreated) {
                                          Navigator.pop(context);
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  MobileNumberVerification(),
                                            ),
                                          );
                                        }
                                      } else {
                                        Toast.show("Exception!", context,
                                            backgroundColor:
                                                Colors.grey.withOpacity(
                                              0.4,
                                            ),
                                            textColor: Colors.red,
                                            gravity: Toast.BOTTOM);
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                              vertical: 15.0,
                            ),
                            child: Row(
                              children: <Widget>[
                                Text(
                                  "Already registered?",
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                GestureDetector(
                                  onTap: () => Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => Login(),
                                    ),
                                  ),
                                  child: Text(
                                    "Sign in here!",
                                    style: TextStyle(
                                      color: _statics.purplish,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
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

import 'package:easy_locate/api/apiCalls.dart';
import 'package:easy_locate/models/token_id.dart';
import 'package:easy_locate/pages/login.dart';
import 'package:easy_locate/statics/static.dart';
import 'package:flutter/material.dart';
import 'package:localregex/localregex.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:toast/toast.dart';

class MobileNumberVerification extends StatefulWidget {
  @override
  _MobileNumberVerificationState createState() =>
      _MobileNumberVerificationState();
}

class _MobileNumberVerificationState extends State<MobileNumberVerification> {
  final _formKey = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  int code;
  String _mobileNumber;
  bool _sending = false;
  bool _isSend = false;
  String _id;
  String _token;
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
                              "Verification",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "Mobile number needs to be verified",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: _statics.height * 0.7,
                    child: ListView(
                      scrollDirection: Axis.vertical,
                      children: <Widget>[
                        SizedBox(
                          height: _statics.height * 0.07,
                        ),
                        _isSend == false
                            ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Form(
                                  key: _formKey,
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
                                          return 'Mobile number format is not recognised';
                                        }
                                      } else {
                                        return 'Mobile number field cannot be missing';
                                      }
                                    },
                                  ),
                                ),
                              )
                            : Container(
                                height: 0,
                                width: 0,
                              ),
                        _isSend == false
                            ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  width: _statics.width * 0.9,
                                  decoration: BoxDecoration(
                                    color: _statics.purplish,
                                  ),
                                  child: MaterialButton(
                                    child: Text(
                                      "GET CODE",
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
                                        Id isSend =
                                            await _api.getCode(_mobileNumber);
                                        setState(() {
                                          _sending = !_sending;
                                        });
                                        if (isSend.status) {
                                          setState(() {
                                            _isSend = true;
                                            _id = isSend.id;
                                          });
                                        }
                                      }
                                    },
                                  ),
                                ),
                              )
                            : Container(
                                height: 0,
                                width: 0,
                              ),
                        _isSend == true
                            ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Form(
                                  key: _formKey2,
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                      labelText: "Token from SMS",
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
                                        Icons.looks_4,
                                      ),
                                    ),
                                    keyboardType: TextInputType.number,
                                    // ignore: missing_return
                                    validator: (value) {
                                      if (value.isNotEmpty) {
                                        setState(() {
                                          _token = value;
                                        });
                                      } else {
                                        return 'Token field can\'t be empty';
                                      }
                                    },
                                  ),
                                ),
                              )
                            : Container(
                                height: 0,
                                width: 0,
                              ),
                        _isSend == true
                            ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  width: _statics.width * 0.9,
                                  decoration: BoxDecoration(
                                    color: _statics.purplish,
                                  ),
                                  child: MaterialButton(
                                    child: Text(
                                      "VERIFY",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    onPressed: () async {
                                      if (_formKey2.currentState.validate()) {
                                        setState(() {
                                          _sending = true;
                                        });
                                        var isVerified = await _api
                                            .verifyMobileNumber(_id, _token);
                                        setState(() {
                                          _sending = false;
                                        });
                                        if (isVerified) {
                                          Toast.show(
                                              "Verified. Now sign in!", context,
                                              backgroundColor:
                                                  Colors.grey.withOpacity(0.4),
                                              gravity: Toast.BOTTOM,
                                              duration: Toast.LENGTH_LONG);
                                          Navigator.pop(context);
                                          return Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) => Login(),
                                            ),
                                          );
                                        } else {
                                          Toast.show("Error!", context,
                                              textColor: Colors.white,
                                              backgroundColor:
                                                  Colors.red.withOpacity(0.4),
                                              gravity: Toast.BOTTOM,
                                              duration: Toast.LENGTH_LONG);
                                          setState(() {
                                            _isSend = false;
                                          });
                                        }
                                      }
                                    },
                                  ),
                                ),
                              )
                            : Container(
                                height: 0,
                                width: 0,
                              ),
                      ],
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

import 'package:easy_locate/api/apiCalls.dart';
import 'package:easy_locate/models/user.dart';
import 'package:easy_locate/statics/static.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  ApiCalls _api = ApiCalls();
  String _username;
  String _password;
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
                                "Login",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "to your account.",
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
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
                                  validator: (value){
                                    if(value.isNotEmpty){
                                      setState(() {
                                        this._username = value;
                                      });
                                    }else{
                                      return 'Username field can\'t be empty';
                                    }
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
                                  validator: (value){
                                    if(value.isNotEmpty){
                                      if(value.length > 8){
                                        setState(() {
                                          this._password = value;
                                        });
                                      }else{
                                        return 'Password length can\'t be less than 8 characters';
                                      }
                                    }else{
                                      return 'Password field can\'t be empty';
                                    }
                                  },
                                ),
                              ),
                              SizedBox(height: _statics.height * 0.1,),
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
                                  onPressed: (){
                                    if(_formKey.currentState.validate()){
                                      final progress = ProgressHUD.of(context);
                                      progress.showWithText("Signing in");
                                      var user1 = _api.login(_username, _password);
                                      print(user1);
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
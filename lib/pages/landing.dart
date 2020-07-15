import 'dart:ui';

import 'package:easy_locate/pages/login.dart';
import 'package:easy_locate/pages/signup.dart';
import 'package:easy_locate/statics/static.dart';
import 'package:flutter/material.dart';

class Landing extends StatefulWidget {
  @override
  _LandingState createState() => _LandingState();
}

class _LandingState extends State<Landing> {
  @override
  Widget build(BuildContext context) {
    Statics _statics = new Statics(context);
    return Scaffold(
      body: Container(
        height: _statics.height,
        width: _statics.width,
        child: Stack(
          children: <Widget>[
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image(
                    image: AssetImage("assets/images/logo.png"),
                    height: 100,
                  ),
                  SizedBox(height: _statics.height * 0.2),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      width: _statics.width * 0.8,
                      decoration: BoxDecoration(
                        color: _statics.purplish,
                      ),
                      child: MaterialButton(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Login(),
                          ),
                        ),
                        child: Text(
                          "LOGIN",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      width: _statics.width * 0.8,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(color: _statics.purplish),
                      ),
                      child: MaterialButton(
                        onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => SignUp(),
                          ),
                        ),
                        child: Text(
                          "SIGNUP",
                          style: TextStyle(
                            color: _statics.purplish,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 5,
              child: Container(
                width: _statics.width,
                child: Text(
                  "Every Product Within Your Reach",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: _statics.purplish,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

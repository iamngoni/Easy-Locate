import 'dart:async';

import 'package:easy_locate/pages/home.dart';
import 'package:easy_locate/pages/landing.dart';
import 'package:easy_locate/statics/static.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isTimerDone = false;
  toOnboardingScreen() async {
    var preferences = await SharedPreferences.getInstance();
    var token = preferences.getString("token");
    if (token != null || token != '') {
      return Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Home(),
        ),
      );
    }
    setState(() {
      isTimerDone = true;
    });
    Navigator.push(context, MaterialPageRoute(builder: (context) => Landing()));
  }

  @override
  void initState() {
    Timer(Duration(seconds: 5), toOnboardingScreen);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Statics _statics = new Statics(context);
    return Scaffold(
      body: Container(
        height: _statics.height,
        width: _statics.width,
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Stack(
          children: <Widget>[
            Center(
              child: Image(
                image: AssetImage("assets/images/logo.png"),
                height: 100,
              ),
            ),
            Positioned(
              bottom: 5,
              child: Container(
                width: _statics.width,
                child: Center(
                  child: Column(
                    children: <Widget>[
                      isTimerDone == false
                          ? Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: SizedBox(
                                height: 10,
                                width: 10,
                                child: CircularProgressIndicator(
                                  backgroundColor: Colors.white,
                                ),
                              ),
                            )
                          : SizedBox(
                              height: 0,
                              width: 0,
                            ),
                      Text(
                        "Every Product Within Your Reach",
                        style: TextStyle(
                          color: _statics.purplish,
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
    );
  }
}

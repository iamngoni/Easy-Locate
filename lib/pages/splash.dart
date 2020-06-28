import 'dart:async';
import 'package:easy_locate/pages/landing.dart';
import 'package:easy_locate/statics/static.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isTimerDone = false;
  void toOnboardingScreen() async {
    setState(() {
      isTimerDone = true;
    });

    Navigator.push(context, MaterialPageRoute(
      builder: (context) => Landing()
    ));
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
              left: _statics.width * 0.25,
              child: Column(
                children: <Widget>[
                  isTimerDone == false ? Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: SizedBox(height: 10, width: 10, child: CircularProgressIndicator(backgroundColor: Colors.white,),),
                  ) : SizedBox(height: 0, width: 0,),
                  Text(
                    "Every Product Within Your Reach",
                    style: TextStyle(
                      color: _statics.purplish,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

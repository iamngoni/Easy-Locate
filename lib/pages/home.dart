import 'package:easy_locate/api/apiCalls.dart';
import 'package:easy_locate/statics/static.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  SharedPreferences _preferences;
  var _api = new ApiCalls();
  initialisePreferences() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences;
  }

  @override
  Widget build(BuildContext context) {
    Statics _statics = new Statics(context);
    initialisePreferences().then((preferences) {
      setState(() {
        _preferences = preferences;
      });
    });
    String token = _preferences.getString('token');
    // if(!JwtVerify().isExpired(token)){
    //   var progress = ProgressHUD.of(context);
    //   progress.showWithText('Session expired.');
    //   Timer(Duration(seconds: 2), (){
    //     progress.dismiss();
    //   });
    //   return Login();
    // }
    return SafeArea(
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
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Icon(
                            Icons.menu,
                            size: 30,
                          ),
                        ),
                        SizedBox(width: 5),
                        Text(
                          "Easy Locate",
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Icon(
                        Icons.location_on,
                        size: 27,
                        color: Colors.grey,
                      ),
                      FutureBuilder(
                        future: _api.getAddressFromLatLng(),
                        builder: (context, snapshot) {
                          while (!snapshot.hasData) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5.0),
                              child: SizedBox(
                                height: 18,
                                width: 18,
                                child: CircularProgressIndicator(
                                  backgroundColor: _statics.purplish,
                                ),
                              ),
                            );
                          }
                          print(snapshot.data);
                        },
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                height: _statics.height * 0.9,
                width: _statics.width,
                decoration: BoxDecoration(
                  color: _statics.purplish,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

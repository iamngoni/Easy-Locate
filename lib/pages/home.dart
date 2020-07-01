import 'package:easy_locate/api/apiCalls.dart';
import 'package:easy_locate/pages/all_products.dart';
import 'package:easy_locate/statics/static.dart';
import 'package:easy_locate/widgets/search.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
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
                          var place = snapshot.data;
                          print(place.name);
                          return Text(
                            "${place.name}"
                          );
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
                  // borderRadius: BorderRadius.circular(30.0),
                ),
                child: ListView(
                  children: <Widget>[
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              "What are you looking for?",
                              style: TextStyle(
                                fontSize: 27,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            CircleAvatar(backgroundColor: Colors.white, child: Icon(Icons.search, size: 20,),),
                          ],
                        ),
                      ),
                    ),
                    // Search(),
                    Divider(color: Colors.white,),
                    Container(
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                "Popular Products",
                              ),
                              GestureDetector(
                                onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProductsList())),
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      "View More",
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    Icon(
                                      Icons.arrow_forward,
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          FutureBuilder(
                            future: _api.getProducts(context),
                            // ignore: missing_return
                            builder: (context, snapshot){
                              while(!snapshot.hasData){
                                return Container(
                                  height: _statics.height * 0.3,
                                  width: _statics.width,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        "loading..."
                                      ),
                                      SizedBox(height: 15, width: 15, child: CircularProgressIndicator()),
                                    ],
                                  ),
                                );
                              }
                              var products = snapshot.data;
                              if(products.length  == 0 || products.length < 1){
                                return Container(
                                  height: _statics.height * 0.3,
                                  width: _statics.width,
                                  color: Colors.white,
                                  child: Center(
                                    child: Text(
                                      "No data found"
                                    ),
                                  ),
                                );
                              }
                              return Container(
                                height: _statics.height * 0.3,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: products.length < 1 ? 0 : products.length,
                                  
                                  itemBuilder: (context, index){
                                    return Card(
                                      child: Container(
                                        height: 200,
                                        width: 150,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                        ),
                                        child: Column(
                                          children: <Widget>[
                                            Container(
                                              height: 140,
                                              width: 150,
                                              decoration: BoxDecoration(
                                                
                                              ),
                                              child: Image(
                                                image: NetworkImage(products[index].imageUrl),
                                                fit: BoxFit.fitWidth,
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: <Widget>[
                                                  Text(
                                                    "${products[index].name}",
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      color: Colors.blue,
                                                      // borderRadius: BorderRadius.circular(15.0),
                                                    ),
                                                    child:Padding(
                                                      padding: const EdgeInsets.symmetric(horizontal: 3.0),
                                                      child: Text(
                                                        "\$${products[index].price}",
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: GestureDetector(
                                                onTap: null,
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.blue,
                                                  ),
                                                  child: Padding(
                                                    padding: EdgeInsets.all(8.0),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: <Widget>[
                                                        Text(
                                                          "More Details",
                                                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white,),
                                                        ),
                                                        SizedBox(
                                                          width: 5,
                                                        ),
                                                        Icon(
                                                          Icons.open_in_browser,
                                                          size: 15,
                                                          color: Colors.white,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

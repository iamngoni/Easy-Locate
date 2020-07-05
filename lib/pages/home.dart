import 'package:badges/badges.dart';
import 'package:easy_locate/api/apiCalls.dart';
import 'package:easy_locate/api/jwt.dart';
import 'package:easy_locate/models/categories.dart';
import 'package:easy_locate/models/product.dart';
import 'package:easy_locate/pages/login.dart';
import 'package:easy_locate/pages/products_list.dart';
import 'package:easy_locate/statics/static.dart';
import 'package:easy_locate/widgets/stars.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  SharedPreferences _preferences;
  Future<dynamic> _place;
  Future<List<Products>> _products;
  Future<List<Category>> _categories;
  var _api = new ApiCalls();
  final _formKey = GlobalKey<FormState>();
  initialisePreferences() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences;
  }

  @override
  void initState() {
    _place = _api.getActualLocation();
    _products = _api.getProducts();
    _categories = _api.getCategories();
    super.initState();
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
    if (!JwtVerify().isExpired(token)) {
      return Login();
    }
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
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.location_on,
                          size: 27,
                          color: Colors.grey,
                        ),
                        FutureBuilder(
                          future: _place,
                          // ignore: missing_return
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
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text("${place.name}"),
                                Text("${place.country}"),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                height: _statics.height * 0.9,
                width: _statics.width,
                decoration: BoxDecoration(
                  color: _statics.purplish,
                ),
                child: ListView(
                  children: <Widget>[
                    SizedBox(height: _statics.height * 0.03),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Stack(
                        children: <Widget>[
                          Form(
                            key: _formKey,
                            child: TextFormField(
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                labelText: "What are you looking for?",
                                labelStyle: TextStyle(
                                  color: Colors.white,
                                ),
                                fillColor: Colors.white.withOpacity(0.2),
                                filled: true,
                              ),
                            ),
                          ),
                          Positioned(
                            right: 0,
                            height: 65,
                            child: Container(
                              width: 60,
                              color: Colors.white.withOpacity(0.3),
                              child: Icon(
                                Icons.search,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: _statics.height * 0.01),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            "Popular products",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => ProductsList(),
                              ),
                            ),
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
                    ),
                    SizedBox(height: _statics.height * 0.015),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: _statics.height * 0.35,
                        child: FutureBuilder(
                          future: _products,
                          // ignore: missing_return
                          builder: (context, snapshot) {
                            while (!snapshot.hasData) {
                              return Shimmer.fromColors(
                                baseColor: Colors.white.withOpacity(0.4),
                                highlightColor: Colors.grey.withOpacity(0.3),
                                child: Container(
                                  height: _statics.height * 0.40,
                                  child: ListView(
                                    scrollDirection: Axis.horizontal,
                                    children: <Widget>[
                                      Card(
                                        child: Container(
                                          height: _statics.height * 0.35,
                                          width: _statics.width * 0.5,
                                          color: Colors.white.withOpacity(0.4),
                                        ),
                                      ),
                                      Card(
                                        child: Container(
                                          height: _statics.height * 0.35,
                                          width: _statics.width * 0.5,
                                          color: Colors.white.withOpacity(0.4),
                                        ),
                                      ),
                                      Card(
                                        child: Container(
                                          height: _statics.height * 0.35,
                                          width: _statics.width * 0.5,
                                          color: Colors.white.withOpacity(0.4),
                                        ),
                                      ),
                                      Card(
                                        child: Container(
                                          height: _statics.height * 0.35,
                                          width: _statics.width * 0.5,
                                          color: Colors.white.withOpacity(0.4),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }
                            var products = snapshot.data;
                            if (products.length == 0 || products.length < 1) {
                              return Container(
                                color: Colors.white,
                                width: _statics.width,
                                height: _statics.height * 0.35,
                                child: Center(
                                  child: Column(
                                    children: <Widget>[
                                      Image(
                                        image: AssetImage(
                                          "assets/images/nothing.png",
                                        ),
                                        height: _statics.height * 0.30,
                                      ),
                                      Text(
                                        "Nothing uploaded yet!",
                                        style: TextStyle(
                                          fontSize: 20,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }
                            return ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: products.length,
                              itemBuilder: (context, index) {
                                return Card(
                                  elevation: 20.0,
                                  child: Container(
                                    height: _statics.height * 0.40,
                                    width: _statics.width * 0.5,
                                    color: Colors.white.withOpacity(0.1),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          height: _statics.height * 0.18,
                                          width: _statics.width * 0.5,
                                          child: FadeInImage.assetNetwork(
                                            placeholder:
                                                'assets/images/loading.gif',
                                            image: products[index].imageUrl,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Container(
                                                width: _statics.width * 0.25,
                                                child: Text(
                                                  "${products[index].name} ${products[index].model}",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  softWrap: false,
                                                ),
                                              ),
                                              Badge(
                                                badgeColor: _statics.purplish,
                                                shape: BadgeShape.square,
                                                borderRadius: 20,
                                                toAnimate: false,
                                                badgeContent: Text(
                                                  "\$${products[index].price}",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Text(
                                                "Rating",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              StarsRating(
                                                value: products[index].rating,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Container(
                                            alignment: Alignment.center,
                                            height: 25,
                                            color: _statics.purplish,
                                            child: MaterialButton(
                                              onPressed: null,
                                              child: Text(
                                                "More Details",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
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
                            );
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            "Product Categories",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: _statics.height * 0.3,
                        child: FutureBuilder(
                          future: _categories,
                          // ignore: missing_return
                          builder: (context, snapshot) {
                            // ignore: missing_return
                            while (!snapshot.hasData) {
                              // ignore: missing_return
                              return Shimmer.fromColors(
                                baseColor: Colors.white.withOpacity(0.4),
                                highlightColor: Colors.grey.withOpacity(0.3),
                                child: Container(
                                  height: _statics.height * 0.40,
                                  child: ListView(
                                    scrollDirection: Axis.horizontal,
                                    children: <Widget>[
                                      Card(
                                        child: Container(
                                          height: _statics.height * 0.3,
                                          width: _statics.width * 0.5,
                                          color: Colors.white.withOpacity(0.4),
                                        ),
                                      ),
                                      Card(
                                        child: Container(
                                          height: _statics.height * 0.3,
                                          width: _statics.width * 0.5,
                                          color: Colors.white.withOpacity(0.4),
                                        ),
                                      ),
                                      Card(
                                        child: Container(
                                          height: _statics.height * 0.3,
                                          width: _statics.width * 0.5,
                                          color: Colors.white.withOpacity(0.4),
                                        ),
                                      ),
                                      Card(
                                        child: Container(
                                          height: _statics.height * 0.3,
                                          width: _statics.width * 0.5,
                                          color: Colors.white.withOpacity(0.4),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }
                            var categories = snapshot.data;
                            return ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: categories.length,
                              // ignore: missing_return
                              itemBuilder: (context, index) {
                                return Card(
                                  color: _statics.purplish,
                                  elevation: 20.0,
                                  child: Container(
                                    height: _statics.height * 0.3,
                                    width: _statics.width * 0.5,
                                    color: Colors.white.withOpacity(0.4),
                                    child: Row(
                                      children: <Widget>[
                                        RotatedBox(
                                          quarterTurns: 1,
                                          child: Text(
                                            categories[index]
                                                .name
                                                .toUpperCase(),
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                            softWrap: false,
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        Expanded(
                                          child: FadeInImage.assetNetwork(
                                            placeholder:
                                                'assets/images/loading.gif',
                                            image: categories[index].image,
                                            fit: BoxFit.cover,
                                            height: _statics.height * 0.3,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      height: _statics.height * 0.04,
                    ),
                    Container(
                      height: _statics.height * 0.05,
                      width: _statics.width,
                      color: Colors.white.withOpacity(0.8),
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text(
                          "Developed For Hit200",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
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
    );
  }
}

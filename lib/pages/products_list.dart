import 'package:easy_locate/api/apiCalls.dart';
import 'package:easy_locate/models/product.dart';
import 'package:easy_locate/pages/product_details.dart';
import 'package:easy_locate/statics/static.dart';
import 'package:flutter/material.dart';

class ProductsList extends StatefulWidget {
  @override
  _ProductsListState createState() => _ProductsListState();
}

class _ProductsListState extends State<ProductsList> {
  Future<dynamic> _place;
  Future<List<Products>> _products;
  var _api = new ApiCalls();

  @override
  void initState() {
    _place = _api.getActualLocation();
    _products = _api.getProducts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Statics _statics = new Statics(context);
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
                          child: InkWell(
                            onTap: () => Navigator.of(context).pop(),
                            child: Icon(
                              Icons.arrow_back,
                              size: 30,
                            ),
                          ),
                        ),
                        SizedBox(width: 5),
                        Text(
                          "Products",
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
                child: FutureBuilder(
                    future: _products,
                    builder: (context, snapshot) {
                      while (!snapshot.hasData) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      var products = snapshot.data;
                      return ListView.builder(
                        itemCount: products.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: GestureDetector(
                              onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProductDetails())),
                              child: Card(
                                color: Colors.white.withOpacity(0.8),
                                child: ListTile(
                                  leading: FadeInImage.assetNetwork(
                                    placeholder: '/assets/images/loading.gif',
                                    image: products[index].imageUrl,
                                    height: 50,
                                    width: 100,
                                    fit: BoxFit.cover,
                                  ),
                                  title: Text(
                                    products[index].name,
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
                                  subtitle: Text(
                                    products[index].model,
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
                                  trailing: Text(
                                    "\$${products[index].price}",
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

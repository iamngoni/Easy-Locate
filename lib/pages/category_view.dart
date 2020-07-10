import 'package:easy_locate/api/apiCalls.dart';
import 'package:easy_locate/models/product.dart';
import 'package:easy_locate/pages/product_details.dart';
import 'package:easy_locate/statics/static.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

class CategoryView extends StatefulWidget {
  final String _category;
  CategoryView(this._category);
  @override
  _CategoryViewState createState() => _CategoryViewState();
}

class _CategoryViewState extends State<CategoryView> {
  ApiCalls _api = new ApiCalls();
  Future<List<Products>> _products;
  Future<dynamic> _place;

  @override
  void initState() {
    _products = _api.getProductsByCategory(this.widget._category);
    _place = _api.getActualLocation();
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
                        SizedBox(
                          width: _statics.width * 0.5,
                          child: Text(
                            this.widget._category,
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                            softWrap: false,
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
                    if (products.length == 0 || products.length < 1) {
                      Toast.show(
                        "No products in ${this.widget._category}",
                        context,
                        gravity: Toast.BOTTOM,
                        duration: Toast.LENGTH_SHORT,
                        textColor: Colors.white,
                      );
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return ListView.builder(
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: GestureDetector(
                            onTap: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ProductDetails(products[index].id))),
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
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

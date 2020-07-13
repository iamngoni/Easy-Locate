import 'package:badges/badges.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:easy_locate/api/apiCalls.dart';
import 'package:easy_locate/models/product.dart';
import 'package:easy_locate/pages/mapview.dart';
import 'package:easy_locate/statics/static.dart';
import 'package:easy_locate/widgets/stars.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class ProductDetails extends StatefulWidget {
  final String _id;
  ProductDetails(this._id);
  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  Future<Products> _product;
  Future<dynamic> _place;
  ApiCalls _api = new ApiCalls();
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    _product = _api.getProductById(this.widget._id);
    _place = _api.getActualLocation();
    super.initState();
  }

  List _generateImages(List images) {
    List imagesList = [];
    for (var url in images) {
      imagesList.add(NetworkImage(url));
    }
    print(imagesList);
    return imagesList;
  }

  void _showRatingDialog(context) {
    bool _rating = false;
    showDialog(
      useSafeArea: true,
      context: context,
      builder: (BuildContext context) {
        // return alert dialog object
        return ModalProgressHUD(
          inAsyncCall: _rating,
          child: Container(
            height: MediaQuery.of(context).size.height * 0.5,
            child: AlertDialog(
              content: Container(
                height: Statics(context).height * 0.5,
                width: Statics(context).width,
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Divider(
                        color: Statics(context).purplish,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 10,
                        ),
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: "Rating (out of 5)",
                            border: InputBorder.none,
                            fillColor:
                                Statics(context).purplish.withOpacity(0.2),
                            filled: true,
                            prefixIcon: Icon(
                              Icons.star,
                            ),
                          ),
                          // ignore: missing_return
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Rating field can't be empty";
                            }
                            if (int.parse(value) < 1 || int.parse(value) > 5) {
                              return "Value exceeds limits";
                            }
                          },
                        ),
                      ),
                      Container(
                        width: Statics(context).width * 0.95,
                        color: Statics(context).purplish,
                        child: Row(
                          children: <Widget>[
                            MaterialButton(
                              child: Text(
                                "Rate Product",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              onPressed: () {
                                if (_formKey.currentState.validate()) {
                                  setState(() {
                                    _rating = !_rating;
                                  });
                                }
                              },
                            ),
                            MaterialButton(
                              child: Text(
                                "Rate Product",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              onPressed: () {
                                if (_formKey.currentState.validate()) {
                                  setState(() {
                                    _rating = !_rating;
                                  });
                                }
                              },
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
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Statics _statics = new Statics(context);
    return SafeArea(
      child: Scaffold(
        body: Container(
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
                          "Product Details",
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
                color: _statics.purplish,
                child: FutureBuilder(
                  future: _product,
                  // ignore: missing_return
                  builder: (context, snapshot) {
                    while (!snapshot.hasData) {
                      return Container(
                        height: _statics.height * 0.9,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                    var product = snapshot.data;
                    List images = [];
                    for (var imageUrl in product.gallery) {
                      images.add(imageUrl);
                    }
                    images.add(product.imageUrl);
                    return ListView(
                      scrollDirection: Axis.vertical,
                      children: [
                        SizedBox(
                          height: _statics.height * 0.4,
//                          width: _statics.width,
                          child: Carousel(
                            images: _generateImages(images),
                            dotColor: _statics.purplish,
                            dotIncreasedColor: Colors.white,
                          ),
                        ),
                        SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "${product.name} ${product.model}",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Badge(
                                badgeColor: Colors.white.withOpacity(0.8),
                                shape: BadgeShape.square,
                                borderRadius: 20,
                                toAnimate: false,
                                badgeContent: Text(
                                  "\$${product.price}",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Description",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Badge(
                                badgeColor: Colors.white.withOpacity(0.8),
                                shape: BadgeShape.square,
                                borderRadius: 20,
                                toAnimate: false,
                                badgeContent: Text(
                                  "${product.category}",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            product.description,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Product Rating",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              GestureDetector(
                                onTap: () => _showRatingDialog(context),
                                child: Badge(
                                  badgeColor: Colors.white.withOpacity(0.8),
                                  shape: BadgeShape.square,
                                  borderRadius: 20,
                                  toAnimate: false,
                                  badgeContent: StarsRating(
                                    value: product.rating,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Divider(
                            color: Colors.white,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Store Details",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Name",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Badge(
                                badgeColor: Colors.white.withOpacity(0.8),
                                shape: BadgeShape.square,
                                borderRadius: 20,
                                toAnimate: false,
                                badgeContent: Text(
                                  "${product.storeName}",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Location",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Badge(
                                badgeColor: Colors.white.withOpacity(0.8),
                                shape: BadgeShape.square,
                                borderRadius: 20,
                                toAnimate: false,
                                badgeContent: Text(
                                  "${product.storeAddress}",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            elevation: 20.0,
                            child: Container(
                              width: _statics.width * 0.9,
                              color: Colors.white.withOpacity(0.8),
                              child: MaterialButton(
                                onPressed: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        MapView(product.storeId, product.id),
                                  ),
                                ),
                                child: Text(
                                  "View On Map",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
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

import 'dart:core';

class Products {
  List<String> colors;
  List<String> metadata;
  List<dynamic> gallery;
  String storeName;
  String storeId;
  String storeAddress;
//  double storeLatitude;
//  double storeLongitude;
  String category;
  String description;
  int size;
  int rating;
  String name;
  String model;
  String imageUrl;
  double price;
  DateTime date;
  String id;

  Products(
      {this.size,
      this.rating,
      this.name,
      this.model,
      this.imageUrl,
      this.price,
      this.date,
      this.storeName,
      this.storeAddress,
      this.storeId,
      this.category,
      this.description,
      this.id,
      this.gallery});

  Products.fromJSON(Map<String, dynamic> json)
      : size = json['size'],
        rating = json['rating'],
        name = json['name'],
        model = json['model'],
        imageUrl = json['imageUrl'],
        price = json['price'].toDouble(),
        date = DateTime.parse(json['date']),
        storeName = json['storeName'],
        storeAddress = json['storeAddress'],
        storeId = json['storeId'],
        category = json['category'],
        description = json['description'],
        id = json['_id'],
        gallery = json['gallery'];
}

import 'package:easy_locate/api/apiCalls.dart';
import 'package:easy_locate/statics/static.dart';
import 'package:flutter/material.dart';

class ProductsList extends StatefulWidget {
  @override
  _ProductsListState createState() => _ProductsListState();
}

class _ProductsListState extends State<ProductsList> {
  @override
  Widget build(BuildContext context) {
    Statics _statics = new Statics(context);
    ApiCalls _api = new ApiCalls();
    return Scaffold(
      appBar: AppBar(
        title: Text("Products"),
      ),
      body: Container(
        height: _statics.height,
        width: _statics.width,
        child: FutureBuilder(
          future: _api.getProducts(),
          builder: (context, snapshot) {
            while (!snapshot.hasData) {
              return Center(
                  child: SizedBox(
                      height: 15,
                      width: 15,
                      child: CircularProgressIndicator()));
            }
            var products = snapshot.data;
            return ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Image(
                    image: NetworkImage(products[index].imageUrl),
                  ),
                  title: Text("${products[index].model}"),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

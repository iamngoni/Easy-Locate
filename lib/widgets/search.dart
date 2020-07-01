import 'package:flutter/material.dart';

class Search extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
  final _formKey = GlobalKey<FormState>();
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: TextFormField(
          decoration: InputDecoration(
            hintText: "e.g. Nike Airmax",
            hintStyle: TextStyle(color: Colors.white),
            labelText: "Search",
            labelStyle: TextStyle(color: Colors.white),
            border: OutlineInputBorder(
              gapPadding: 3.5,
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';

class Statics {
  double width;
  double height;
  Color purple = Color(0xFF6837C7);
  Color purplish = Color(0xFF8560e2);
  Color accentPurple = Color(0xFFa03fe2);
  Color orange = Color(0xFFFF6C58);
  Color lightOrange = Color(0xFFFFAA91);
  Statics(context) {
    this.width = MediaQuery.of(context).size.width;
    this.height = MediaQuery.of(context).size.height;
  }
}

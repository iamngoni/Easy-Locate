import 'package:flutter/material.dart';

class StarsRating extends StatelessWidget {
  final int value;
  const StarsRating({Key key, this.value = 0})
      : assert(value != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: List.generate(5, (index) {
          return Icon(
            index < value ? Icons.star : Icons.star_border,
            color: index < value ? Colors.amber : Colors.black,
            size: 20,
          );
        }),
      ),
    );
  }
}

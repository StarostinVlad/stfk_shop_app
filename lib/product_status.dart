import 'package:flutter/material.dart';

class ProductStatus extends StatelessWidget {
  final bool inStock;
  final double fontSize;

  const ProductStatus({Key key, this.inStock, this.fontSize}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var color = (inStock ? Colors.lightGreen : Colors.orangeAccent);
    return Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.5),
          border: Border(
            top: BorderSide(width: 1.0, color: color),
            left: BorderSide(width: 1.0, color: color),
            right: BorderSide(width: 1.0, color: color),
            bottom: BorderSide(width: 1.0, color: color),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(5.0),
          child: Text(
            (inStock ? 'В наличии' : 'Под заказ').toUpperCase(),
            style: TextStyle(fontSize: fontSize ?? 12),
          ),
        ));
  }
}

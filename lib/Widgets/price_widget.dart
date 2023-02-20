import 'package:flutter/material.dart';
import 'package:grocery_app/Widgets/text_widget.dart';

import '../Services/utils.dart';

class PriceList extends StatelessWidget {
  const PriceList(
      {Key? key,
      required this.salePrice,
      required this.price,
      required this.textPrice,
      required this.isOnsale})
      : super(key: key);
  final double salePrice, price;
  final String textPrice;
  final bool isOnsale;

  @override
  Widget build(BuildContext context) {

    final Color color = Utils(context).color;
    double userPrice = isOnsale ? salePrice : price;
    return FittedBox(
      child: Row(
        children: [
          TextWidget(
              text:
                  '\₹${(userPrice * int.parse(textPrice)).toStringAsFixed(2)}',
              color: Colors.green,
              textSize: 18.0),
          SizedBox(
            width: 5.0,
          ),
          Visibility(
            visible: isOnsale ? true : false,
            child: Text(
              '\₹${(price * int.parse(textPrice)).toStringAsFixed(2)}',
              style: TextStyle(
                  fontSize: 15.0,
                  color: color,
                  decoration: TextDecoration.lineThrough),
            ),
          ),
        ],
      ),
    );
  }
}

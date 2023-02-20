import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';

import 'package:grocery_app/services/global_methods.dart';

import '../../Inner Screen/product_details.dart';
import '../../services/utils.dart';
import '../../widgets/text_widget.dart';

class OrdersWidget extends StatefulWidget {
  const OrdersWidget({Key? key}) : super(key: key);

  @override
  State<OrdersWidget> createState() => _OrdersWidgetState();
}

class _OrdersWidgetState extends State<OrdersWidget> {
  @override
  Widget build(BuildContext context) {
    final Color color = Utils(context).color;
    Size size = Utils(context).getScreenSize;

    return ListTile(
      subtitle: Text('Paid: \₹150'),
      onTap: () {
        GlobalMethods.navigateTo(
            ctx: context, routeName: ProductDetails.routeName);
      },
      leading: FancyShimmerImage(
        width: size.width * 0.2,
        imageUrl: 'https://i.ibb.co/F0s3FHQ/Apricuts.png',
        boxFit: BoxFit.fill,
      ),
      title: TextWidget(text: 'apricot x 4', color: color, textSize: 18),
      trailing: TextWidget(text: '30/01/2023', color: color, textSize: 18),
    );
  }
}

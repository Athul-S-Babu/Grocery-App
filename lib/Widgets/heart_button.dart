import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:grocery_app/Providers/wishlist_provider.dart';
import 'package:provider/provider.dart';

import '../Consts/firebase_consts.dart';
import '../Services/global_methods.dart';
import '../Services/utils.dart';

class HeartButton extends StatelessWidget {
  const HeartButton(
      {Key? key, required this.productId, this.isInWishList = true})
      : super(key: key);

  final String productId;
  final bool isInWishList;

  @override
  Widget build(BuildContext context) {
    final Color color = Utils(context).color;
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    return GestureDetector(
      onTap: () {
        final User? user = authInstance.currentUser;


        if (user == null) {
          GlobalMethods.errorDialog(
              subtitle: 'No user found, Please login first', context: context);
          return;
        }
        wishlistProvider.addRemoveProductToWishlist(productId: productId);
      },
      child: Icon(
          isInWishList != null && isInWishList == true
              ? IconlyBold.heart
              : IconlyLight.heart,
          size: 22.0,
          color: isInWishList != null && isInWishList == true
              ? Colors.red
              : color),
    );
  }
}

import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grocery_app/Inner%20Screen/product_details.dart';
import 'package:grocery_app/Models/product_model.dart';
import 'package:grocery_app/Providers/cart_provider.dart';
import 'package:grocery_app/Providers/wishlist_provider.dart';

import 'package:grocery_app/Widgets/heart_button.dart';
import 'package:grocery_app/Widgets/price_widget.dart';
import 'package:grocery_app/Widgets/text_widget.dart';
import 'package:provider/provider.dart';

import '../Consts/firebase_consts.dart';
import '../Providers/wishlist_provider.dart';
import '../Providers/wishlist_provider.dart';
import '../Services/global_methods.dart';
import '../Services/utils.dart';

class FeedsWidget extends StatefulWidget {
  const FeedsWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<FeedsWidget> createState() => _FeedsWidgetState();
}

class _FeedsWidgetState extends State<FeedsWidget> {
  final _quantityTextController = TextEditingController();

  @override
  void initState() {
    _quantityTextController.text = '1';
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    _quantityTextController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color color = Utils(context).color;
    Size size = Utils(context).getScreenSize;
    final productModel = Provider.of<ProductModel>(context);
    final cartProvider = Provider.of<CartProvider>(context);
    bool? _isInCart = cartProvider.getCartItems.containsKey(productModel.id);
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    bool? _isInWishlist =
        wishlistProvider.getWishlistItems.containsKey(productModel.id);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        borderRadius: BorderRadius.circular(12),
        color: Theme.of(context).cardColor,
        child: InkWell(
          onTap: () {
            Navigator.pushNamed(context, ProductDetails.routeName,
                arguments: productModel.id);
            // GlobalMethods.navigateTo(
            //     ctx: context, routeName: ProductDetails.routeName);
          },
          borderRadius: BorderRadius.circular(12),
          child: Column(
            children: [
              FancyShimmerImage(
                imageUrl: productModel.imageUrl,
                height: size.width * 0.22,
                width: size.width * 0.22,
                boxFit: BoxFit.fill,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      flex: 3,
                      child: TextWidget(
                        text: productModel.title,
                        color: color,
                        maxLines: 1,
                        textSize: 18.0,
                        isTitle: true,
                      ),
                    ),
                    Flexible(
                        flex: 1,
                        child: HeartButton(
                          productId: productModel.id,
                          isInWishList: _isInWishlist,
                        ))
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      flex: 3,
                      child: PriceList(
                        price: productModel.price,
                        salePrice: productModel.salePrice,
                        textPrice: _quantityTextController.text,
                        isOnsale: productModel.isOnSale,
                      ),
                    ),
                    Flexible(
                      child: Row(
                        children: [
                          Flexible(
                            flex: 6,
                            child: FittedBox(
                              child: TextWidget(
                                textSize: 20.0,
                                text: productModel.isPiece ? 'Piece' : 'Kg',
                                color: color,
                                isTitle: true,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 5.0,
                          ),
                          Flexible(
                              flex: 2,
                              child: TextFormField(
                                controller: _quantityTextController,
                                key: const ValueKey('10'),
                                style: TextStyle(
                                  color: color,
                                  fontSize: 18.0,
                                ),
                                keyboardType: TextInputType.number,
                                maxLines: 1,
                                enabled: true,
                                onChanged: (Valuee) {
                                  setState(() {
                                    if (Valuee.isEmpty) {
                                      _quantityTextController.text = '1';
                                    }
                                  });
                                },
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp('[0-9.]'))
                                ],
                              ))
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Spacer(),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: _isInCart
                      ? null
                      : () {
                          final User? user = authInstance.currentUser;
                          print('user id is ${user!.uid}');

                          if (user == null) {
                            GlobalMethods.errorDialog(
                                subtitle: 'No user found, Please login first',
                                context: context);
                            return;
                          }
                          //if(_isInCart){return;}
                          cartProvider.addProductsToCart(
                              productId: productModel.id,
                              quantity:
                                  int.parse(_quantityTextController.text));
                        },
                  child: TextWidget(
                    text: _isInCart ? 'In cart' : 'Add to cart',
                    maxLines: 1,
                    color: color,
                    textSize: 20.0,
                  ),
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          Theme.of(context).cardColor),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(12.0),
                                  bottomRight: Radius.circular(12.0))))),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grocery_app/Models/cart_model.dart';
import 'package:grocery_app/Providers/products_provider.dart';
import 'package:grocery_app/Widgets/heart_button.dart';
import 'package:grocery_app/Widgets/text_widget.dart';
import 'package:provider/provider.dart';

import '../../Inner Screen/product_details.dart';
import '../../Models/product_model.dart';
import '../../Providers/cart_provider.dart';
import '../../Providers/wishlist_provider.dart';
import '../../Services/global_methods.dart';
import '../../Services/utils.dart';

class CartWidget extends StatefulWidget {
  const CartWidget({Key? key, this.q}) : super(key: key);
final q;
  @override
  State<CartWidget> createState() => _CartWidgetState();
}

class _CartWidgetState extends State<CartWidget> {
  final _qualityTextController = TextEditingController(text: '1');

  @override
  void initState() {
    _qualityTextController.text = widget.q.toString();
    super.initState();
  }

  @override
  void dispose() {
    _qualityTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color color = Utils(context).color;
    Size size = Utils(context).getScreenSize;
    final productProvider = Provider.of<ProductsProvider>(context);
    final cartModel = Provider.of<CartModel>(context);
    final getCurrProduct = productProvider.findProdById(cartModel.productId);
    double usedPrice = getCurrProduct.isOnSale
        ? getCurrProduct.salePrice
        : getCurrProduct.price;
    final cartProvider = Provider.of<CartProvider>(context);
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    bool? _isInWishlist =
    wishlistProvider.getWishlistItems.containsKey(getCurrProduct.id);
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, ProductDetails.routeName,
            arguments: cartModel.productId);
      },
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(3.0),
              child: Container(
                  decoration: BoxDecoration(
                      color: Theme.of(context).cardColor.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(12.0)),
                  child: Row(
                    children: [
                      Container(
                        height: size.width * 0.25,
                        width: size.width * 0.25,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12)),
                        child: Image.asset(
                          getCurrProduct.imageUrl,
                          fit: BoxFit.fill,
                        ),
                      ),
                      Column(
                        children: [
                          TextWidget(
                            text: getCurrProduct.title,
                            color: color,
                            textSize: 20.0,
                            isTitle: true,
                          ),
                          SizedBox(
                            height: 16.0,
                          ),
                          SizedBox(
                            width: size.width * 0.3,
                            child: Row(
                              children: [
                                _qualityController(
                                    fct: () {
                                      if (_qualityTextController.text == '1') {
                                        return;
                                      } else {
                                        cartProvider.reduceQuantityByOne(cartModel.productId);
                                        setState(() {
                                          _qualityTextController.text =
                                              (int.parse(_qualityTextController
                                                          .text) -
                                                      1)
                                                  .toString();
                                        });
                                      }
                                    },
                                    color: Colors.red,
                                    icon: CupertinoIcons.minus),
                                Flexible(
                                  flex: 1,
                                  child: TextField(
                                    controller: _qualityTextController,
                                    keyboardType: TextInputType.number,
                                    maxLines: 1,
                                    decoration: InputDecoration(
                                        focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide())),
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                          RegExp('[0-9]'))
                                    ],
                                    onChanged: (Value) {
                                      setState(() {
                                        if (Value.isEmpty) {
                                          _qualityTextController.text = '1';
                                        } else {
                                          return;
                                        }
                                      });
                                    },
                                  ),
                                ),
                                _qualityController(
                                    fct: () { cartProvider.increaseQuantityByOne(cartModel.productId);
                                      setState(() {

                                        _qualityTextController.text =
                                            (int.parse(_qualityTextController
                                                        .text) +
                                                    1)
                                                .toString();
                                      });
                                    },
                                    color: Colors.green,
                                    icon: CupertinoIcons.plus)
                              ],
                            ),
                          )
                        ],
                      ),
                      Spacer(),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: Column(
                          children: [
                            InkWell(
                              onTap: () {

                                cartProvider.removeOneItem( cartModel.productId);
                              },
                              child: Icon(
                                CupertinoIcons.cart_badge_minus,
                                color: Colors.red,
                                size: 20.0,
                              ),
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            HeartButton(
                              productId: getCurrProduct.id,
                              isInWishList: _isInWishlist,
                            ),
                            TextWidget(
                              text: '\$${usedPrice.toStringAsFixed(2)}',
                              color: color,
                              textSize: 18,
                              maxLines: 1,
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 5.0,
                      )
                    ],
                  )),
            ),
          )
        ],
      ),
    );
  }

  Widget _qualityController({
    required Function fct,
    required IconData icon,
    required Color color,
  }) {
    return Flexible(
      flex: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Material(
          color: color,
          borderRadius: BorderRadius.circular(12.0),
          child: InkWell(
            borderRadius: BorderRadius.circular(12.0),
            onTap: () {
              fct();
            },
            child: Padding(
              padding: const EdgeInsets.all(6.0),
              child: Icon(
                icon,
                color: Colors.white,
                size: 20.0,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:grocery_app/Screens/cart/cart_widget.dart';
import 'package:grocery_app/Widgets/empty_screen.dart';
import 'package:grocery_app/Services/global_methods.dart';
import 'package:grocery_app/Widgets/text_widget.dart';
import 'package:provider/provider.dart';

import '../../Providers/cart_provider.dart';
import '../../Services/utils.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color color = Utils(context).color;
    Size size = Utils(context).getScreenSize;
    final cartProvider = Provider.of<CartProvider>(context);
    final cartItemsList =
        cartProvider.getCartItems.values.toList().reversed.toList();
    return cartItemsList.isEmpty
        ? const EmptyScreen(
            imagePath: 'images/cart.png',
            title: 'Your cart is empty :)',
            subtitle: 'Add  something and make me happy',
            buttonText: 'Shop now')
        : Scaffold(
            appBar: AppBar(
              elevation: 0.0,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              title: TextWidget(
                text: 'Cart(${cartItemsList.length}))',
                color: color,
                textSize: 22.0,
                isTitle: true,
              ),
              actions: [
                IconButton(
                    onPressed: () {
                      GlobalMethods.warningDialog(
                          title: 'Empty your cart',
                          subtitle: 'Are you sure?',
                          fct: () {
                            cartProvider.clearCart();
                          },
                          context: context);
                    },
                    icon: Icon(
                      IconlyBroken.delete,
                      color: color,
                    ))
              ],
            ),
            body: Column(children: [
              _checkout(ctx: context),
              Expanded(
                child: ListView.builder(
                    itemCount: cartItemsList.length,
                    itemBuilder: (ctx, index) {
                      return ChangeNotifierProvider.value(
                          value: cartItemsList[index],
                          child: CartWidget(
                            q: cartItemsList[index].quantity,
                          ));
                    }),
              ),
            ]));
  }

  Widget _checkout({required BuildContext ctx}) {
    final Color color = Utils(ctx).color;
    Size size = Utils(ctx).getScreenSize;
    return SizedBox(
      width: double.infinity,
      height: size.height * 0.1,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Row(
          children: [
            Material(
              color: Colors.green,
              borderRadius: BorderRadius.circular(10.0),
              child: InkWell(
                borderRadius: BorderRadius.circular(10.0),
                onTap: () {},
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextWidget(
                    text: 'Order Now',
                    textSize: 20.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Spacer(),
            FittedBox(
              child: TextWidget(
                text: 'Total:\₹300',
                color: color,
                textSize: 18.0,
                isTitle: true,
              ),
            )
          ],
        ),
      ),
    );
  }
}

import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:grocery_app/Consts/constss.dart';
import 'package:grocery_app/Inner%20Screen/feeds_screen.dart';
import 'package:grocery_app/Inner%20Screen/on_sale_screen.dart';

import 'package:grocery_app/Services/global_methods.dart';
import 'package:grocery_app/Services/utils.dart';
import 'package:grocery_app/Widgets/feed_items.dart';
import 'package:grocery_app/Widgets/text_widget.dart';
import 'package:provider/provider.dart';

import '../Models/product_model.dart';
import '../Providers/products_provider.dart';
import '../Widgets/on_sale_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> _offerImages = [
    'images/New Offers/newoffer1.jpg',
    'images/New Offers/newoffer2.jpg',
    'images/New Offers/newoffer3.jpg',
    'images/New Offers/newoffer4.jpg',
    'images/New Offers/newoffer5.jpg'
  ];

  @override
  Widget build(BuildContext context) {
    final Color color = Utils(context).color;
    final Utils utils = Utils(context);
    GlobalMethods globalMethods = GlobalMethods();

    final themeState = Utils(context).getTheme;
    Size size = utils.getScreenSize;
    final productsProviders = Provider.of<ProductsProvider>(context);
    List<ProductModel> allProducts = productsProviders.getProducts;
    List<ProductModel> productsOnSale = productsProviders.getOnSaleProducts;


    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(children: [
            SizedBox(
              height: size.height * 0.33,
              child: Swiper(
                itemBuilder: (BuildContext context, int index) {
                  return Image.asset(
                    Constss.offerImages[index],
                    fit: BoxFit.fill,
                  );
                },
                autoplay: true,
                itemCount: Constss.offerImages.length,
                pagination: SwiperPagination(
                    alignment: Alignment.bottomCenter,
                    builder: DotSwiperPaginationBuilder(
                      color: Colors.white,
                      activeColor: Colors.red,
                    )),
                //control: SwiperControl(),
              ),
            ),
            SizedBox(
              height: 6.0,
            ),
            TextButton(
                onPressed: () {
                  GlobalMethods.navigateTo(
                      ctx: context, routeName: OnSaleScreen.routeName);
                },
                child: TextWidget(
                  text: 'View all',
                  maxLines: 10,
                  color: Colors.blue,
                  textSize: 20,
                )),
            SizedBox(
              height: 6.0,
            ),
            Row(
              children: [
                RotatedBox(
                  quarterTurns: -1,
                  child: Row(
                    children: [
                      SizedBox(
                        height: 5,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextWidget(
                            text: 'On Sale'.toUpperCase(),
                            color: Colors.red,
                            textSize: 22.0,
                            isTitle: true),
                      ),
                      SizedBox(
                        width: 5.0,
                      ),
                      Icon(
                        IconlyLight.discount,
                        color: Colors.red,
                      )
                    ],
                  ),
                ),
                SizedBox(
                  width: 8.0,
                ),
                Flexible(
                  child: SizedBox(
                    height: size.height * 0.24,
                    child: ListView.builder(
                        itemCount: productsOnSale.length < 10
                            ? productsOnSale.length
                            : 10,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (ctx, index) {
                          return ChangeNotifierProvider.value(
                              value: productsOnSale[index],
                              child: OnSaleWidget());
                        }),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10.0,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  TextWidget(
                    text: 'Our Products',
                    color: color,
                    textSize: 22.0,
                    isTitle: true,
                  ),
                  Spacer(),
                  TextButton(
                      onPressed: () {
                        GlobalMethods.navigateTo(
                            ctx: context, routeName: FeedsScreen.routeName);
                      },
                      child: TextWidget(
                        text: 'Browse all',
                        maxLines: 10,
                        color: Colors.blue,
                        textSize: 20,
                      )),
                ],
              ),
            ),
            GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                childAspectRatio: size.width / (size.height * 0.59),
                children: List.generate(
                    allProducts.length < 4
                        ? allProducts.length
                        : 4, (index) {
                  return ChangeNotifierProvider.value(
                    value: allProducts[index],
                    child: FeedsWidget(

                    ),
                  );
                }))
          ]),
        ),
      ),
    );
  }
}

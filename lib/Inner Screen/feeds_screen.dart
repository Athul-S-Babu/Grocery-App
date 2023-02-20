import 'package:flutter/material.dart';
import 'package:grocery_app/Models/product_model.dart';
import 'package:grocery_app/Providers/products_provider.dart';
import 'package:provider/provider.dart';

import '../Consts/constss.dart';
import '../Services/utils.dart';
import '../Widgets/back_widget.dart';
import '../Widgets/feed_items.dart';
import '../Widgets/text_widget.dart';

class FeedsScreen extends StatefulWidget {
  static const routeName = "/_FeedsScreenState";

  const FeedsScreen({Key? key}) : super(key: key);

  @override
  State<FeedsScreen> createState() => _FeedsScreenState();
}

class _FeedsScreenState extends State<FeedsScreen> {
  final TextEditingController? _searchTextController = TextEditingController();
  final FocusNode _searchTextFocusNode = FocusNode();

  @override
  void dispose() {
    _searchTextController!.dispose();
    _searchTextFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = Utils(context).getScreenSize;
    final Color color = Utils(context).color;
    final productsProviders = Provider.of<ProductsProvider>(context);
    List<ProductModel> allProducts = productsProviders.getProducts;
    return Scaffold(
      appBar: AppBar(
          leading: const BackWidget(),
          elevation: 0.0,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          centerTitle: true,
          title: TextWidget(
            text: 'All Products',
            color: color,
            textSize: 20.0,
            isTitle: true,
          )),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: kBottomNavigationBarHeight,
                child: TextField(
                  focusNode: _searchTextFocusNode,
                  controller: _searchTextController,
                  onChanged: (Valuee) {
                    setState(() {});
                  },
                  decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide:
                            BorderSide(color: Colors.greenAccent, width: 1.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: BorderSide(
                              color: Colors.greenAccent, width: 1.0)),
                      hintText: "What's in your mind",
                      prefixIcon: Icon(Icons.search),
                      suffix: IconButton(
                        onPressed: () {
                          _searchTextController!.clear();
                          _searchTextFocusNode.unfocus();
                        },
                        icon: Icon(
                          Icons.close,
                          color: _searchTextFocusNode.hasFocus
                              ? Colors.red
                              : color,
                        ),
                      )),
                ),
              ),
            ),
            GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                childAspectRatio: size.width / (size.height * 0.59),
                children: List.generate(allProducts.length, (index) {
                  return   ChangeNotifierProvider.value(
                      value: allProducts[index],
                    child:   FeedsWidget());
                }))
          ],
        ),
      ),
    );
  }
}

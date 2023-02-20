import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:grocery_app/Auth/login.dart';
import 'package:grocery_app/Consts/theme_data.dart';
import 'package:grocery_app/Inner%20Screen/cat_screen.dart';
import 'package:grocery_app/Inner%20Screen/feeds_screen.dart';
import 'package:grocery_app/Inner%20Screen/on_sale_screen.dart';
import 'package:grocery_app/Inner%20Screen/product_details.dart';
import 'package:grocery_app/Providers/cart_provider.dart';

import 'package:grocery_app/Providers/products_provider.dart';
import 'package:grocery_app/Providers/wishlist_provider.dart';
import 'package:grocery_app/Screens/Orders/orders_screen.dart';
import 'package:grocery_app/Screens/Viewed%20Recently/viewed_recently.dart';
import 'package:grocery_app/Screens/Wishlist/wishlist_screen.dart';
import 'package:grocery_app/Screens/btm_bar.dart';
import 'package:grocery_app/Screens/categories..dart';

import 'package:provider/provider.dart';

import 'Auth/forget_password.dart';
import 'Auth/register.dart';
import 'Providers/dark_theme_provider.dart';
import 'Providers/viewed_prod_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DarkThemeProvider themeChangeProvider = DarkThemeProvider();

  void getCurrentAppTheme() async {
    themeChangeProvider.setDarkTheme =
    await themeChangeProvider.darkThemePrefs.getTheme();
  }

  @override
  void initState() {
    getCurrentAppTheme();
    super.initState();
  }


  final Future<FirebaseApp> _firebaseInitialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _firebaseInitialization,
        builder: (context, snapshot)
    {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              )),
        );
      } else if (snapshot.hasError) {
        const MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Scaffold(
              body: Center(
                child: Text('An error occurred'),
              )),
        );
      }
      return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) {
            return themeChangeProvider;
          }),
          ChangeNotifierProvider(
            create: (_) => ProductsProvider(),
          ),
          ChangeNotifierProvider(
            create: (_) => CartProvider(),
          ),
          ChangeNotifierProvider(
            create: (_) => WishlistProvider(),
          ),
          ChangeNotifierProvider(
            create: (_) => ViewedProdProvider(),
          ),
          // ChangeNotifierProvider(
          //   create: (_) => OrdersProvider(),
          // ),
        ],
        child:
        Consumer<DarkThemeProvider>(builder: (context, themeProvider, child) {
          return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Flutter Demo',
              theme: Styles.themeData(themeProvider.getDarkTheme, context),
              home: BottomBarScreen(),
              routes: {
                OnSaleScreen.routeName: (ctx) => const OnSaleScreen(),
                FeedsScreen.routeName: (ctx) => const FeedsScreen(),
                ProductDetails.routeName: (ctx) => const ProductDetails(),
                WishlistScreen.routeName: (ctx) => const WishlistScreen(),
                OrdersScreen.routeName: (ctx) => const OrdersScreen(),
                ViewedRecentlyScreen.routeName: (ctx) =>
                const ViewedRecentlyScreen(),
                LoginScreen.routeName: (ctx) => const LoginScreen(),
                RegisterScreen.routeName: (ctx) => const RegisterScreen(),
                ForgetPasswordScreen.routeName: (ctx) =>
                const ForgetPasswordScreen(),
                CategoryScreen.routeName: (ctx) => const CategoryScreen(),
              });
        }),
      );
    });
  }
}


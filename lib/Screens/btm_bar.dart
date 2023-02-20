import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:badges/badges.dart' as badges;
import 'package:grocery_app/Providers/cart_provider.dart';
import 'package:grocery_app/Screens/categories..dart';
import 'package:grocery_app/Screens/home_screen.dart';
import 'package:grocery_app/Screens/user.dart';
import 'package:provider/provider.dart';

import '../Providers/dark_theme_provider.dart';
import '../Widgets/text_widget.dart';
import 'cart/cart_screen.dart';

class BottomBarScreen extends StatefulWidget {
  const BottomBarScreen({Key? key}) : super(key: key);

  @override
  State<BottomBarScreen> createState() => _BottomBarScreenState();
}

class _BottomBarScreenState extends State<BottomBarScreen> {
  int _selectedIndex = 0;
  final List<Map<String, dynamic>> _pages = [
    {'page': const HomeScreen(), 'title': 'Home Screen'},
    {'page': CategoriesScreen(), 'title': 'Categories Screen'},
    {'page': const CartScreen(), 'title': 'Cart Screen'},
    {'page': const UserScreen(), 'title': 'User Screen'}
  ];

  void _selectedPages(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeState = Provider.of<DarkThemeProvider>(context);
    bool isDark = themeState.getDarkTheme;

    return Scaffold(
      //appBar: AppBar(title: Text(_pages[_selectedIndex]['title'])),

      body: _pages[_selectedIndex]['page'],
      bottomNavigationBar: BottomNavigationBar(
          backgroundColor: isDark ? Theme.of(context).cardColor : Colors.white,
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          currentIndex: _selectedIndex,
          unselectedItemColor: isDark ? Colors.white12 : Colors.black12,
          selectedItemColor:
              isDark ? Colors.lightBlue.shade200 : Colors.black87,
          onTap: _selectedPages,
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                  _selectedIndex == 0 ? IconlyBold.home : IconlyLight.home),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(_selectedIndex == 1
                  ? IconlyBold.category
                  : IconlyLight.category),
              label: "Categories",
            ),
            BottomNavigationBarItem(
              icon: Consumer<CartProvider>(
                builder: (_,myCart,ch) {
                  return badges.Badge(
                    position: badges.BadgePosition.topEnd(top: -7, end: -7),
                    showBadge: true,
                    ignorePointer: false,
                    badgeContent: FittedBox(
                      child: TextWidget(
                        text:myCart.getCartItems.length.toString(),
                        color: Colors.white,
                        textSize: 15.0,
                      ),
                    ),



                    badgeStyle: badges.BadgeStyle(
                      shape: badges.BadgeShape.circle,
                      badgeColor: Colors.blue,
                      padding: EdgeInsets.all(5),
                      borderRadius: BorderRadius.circular(4),
                      borderSide: BorderSide(color: Colors.white, width: 2),
                      elevation: 0,
                    ),
                    child: Icon(
                        _selectedIndex == 2 ? IconlyBold.buy : IconlyLight.buy),
                  );
                }
              ),
              label: "Cart",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                  _selectedIndex == 3 ? IconlyBold.user2 : IconlyLight.user2),
              label: "User",
            )
          ]),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:grocery_app/Auth/forget_password.dart';
import 'package:grocery_app/Screens/Orders/orders_screen.dart';
import 'package:grocery_app/Screens/Viewed%20Recently/viewed_recently.dart';
import 'package:grocery_app/Screens/Wishlist/wishlist_screen.dart';
import 'package:grocery_app/Screens/loading_manager.dart';
import 'package:grocery_app/Services/global_methods.dart';
import 'package:grocery_app/Widgets/text_widget.dart';
import 'package:provider/provider.dart';

import '../Auth/login.dart';
import '../Consts/firebase_consts.dart';
import '../Providers/dark_theme_provider.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({Key? key}) : super(key: key);

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final TextEditingController _addressTextController = TextEditingController();

  @override
  void dispose() {
    _addressTextController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  String? _email;
  String? _name;
  String? address;
  bool _isLoading = false;
  final User? user = authInstance.currentUser;

  @override
  void initState() {
    getUserData();
    super.initState();
  }

  Future<void> getUserData() async {
    setState(() {
      _isLoading = true;
    });
    if (user == null) {
      setState(() {
        _isLoading = false;
      });
      return;
    }
    try {
      String _uid = user!.uid;

      final DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('users').doc(_uid).get();
      if (userDoc == null) {
        return;
      } else {
        _email = userDoc.get('email');
        _name = userDoc.get('name');
        address = userDoc.get('shipping-address');
        _addressTextController.text = userDoc.get('shipping-address');
      }
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      GlobalMethods.errorDialog(subtitle: '$error', context: context);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeState = Provider.of<DarkThemeProvider>(context);
    final Color color = themeState.getDarkTheme ? Colors.white : Colors.black;
    return Scaffold(
        body: LoadingManager(
      isLoading: _isLoading,
      child: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RichText(
                      text: TextSpan(
                          text: 'Hi,',
                          style: TextStyle(
                              color: Colors.cyanAccent,
                              fontSize: 27.0,
                              fontWeight: FontWeight.bold),
                          children: <TextSpan>[
                        TextSpan(
                            text: _name == null ? 'user' : _name,
                            style: TextStyle(
                                color: color,
                                fontSize: 25.0,
                                fontWeight: FontWeight.w600),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                print("My name is pressed");
                              })
                      ])),
                  SizedBox(
                    height: 5.0,
                  ),
                  TextWidget(
                      text: _email == null ? 'Email' : _email!,
                      color: color,
                      textSize: 18.0),
                  SizedBox(
                    height: 20.0,
                  ),
                  Divider(
                    thickness: 2.0,
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  _listTiles(
                      title: 'Address',
                      subtitle: address,
                      icon: IconlyLight.profile,
                      onPressed: () async {
                        await _showAddressDialog();
                      },
                      color: color),
                  _listTiles(
                      title: 'Orders',
                      icon: IconlyLight.bag,
                      onPressed: () {
                        GlobalMethods.navigateTo(
                            ctx: context, routeName: OrdersScreen.routeName);
                      },
                      color: color),
                  _listTiles(
                      title: 'Wishlist',
                      icon: IconlyLight.heart,
                      onPressed: () {
                        GlobalMethods.navigateTo(
                            ctx: context, routeName: WishlistScreen.routeName);
                      },
                      color: color),
                  _listTiles(
                      title: 'Forgot Password',
                      icon: IconlyLight.unlock,
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const ForgetPasswordScreen(),
                          ),
                        );
                      },
                      color: color),
                  _listTiles(
                      title: 'Viewed',
                      icon: IconlyLight.show,
                      onPressed: () {
                        GlobalMethods.navigateTo(
                            ctx: context,
                            routeName: ViewedRecentlyScreen.routeName);
                      },
                      color: color),
                  SwitchListTile(
                    title: TextWidget(
                        color: color,
                        textSize: 18.0,
                        text: themeState.getDarkTheme
                            ? 'Dark Mode'
                            : 'Light Mode'),
                    secondary: Icon(themeState.getDarkTheme
                        ? Icons.dark_mode_outlined
                        : Icons.light_mode_outlined),
                    onChanged: (bool value) {
                      setState(() {
                        themeState.setDarkTheme = value;
                      });
                    },
                    value: themeState.getDarkTheme,
                  ),
                  _listTiles(
                      title: user == null ? 'Login' : 'Logout',
                      icon:
                          user == null ? IconlyLight.login : IconlyLight.logout,
                      onPressed: () {
                        if (user == null) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                          );
                          return;
                        }
                        GlobalMethods.warningDialog(
                            title: 'Sign out',
                            subtitle: 'Do you wanna sign out?',
                            fct: () async {
                              await authInstance.signOut();
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const LoginScreen(),
                                ),
                              );
                            },
                            context: context);
                      },
                      color: color),
                ]),
          ),
        ),
      ),
    ));
  }

  Future<void> _showAddressDialog() async {
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Update'),
            content: TextField(
                onChanged: (value) {},
                controller: _addressTextController,
                maxLines: 5,
                decoration: InputDecoration(hintText: 'Your Address')),
            actions: [
              TextButton(
                  onPressed: () async {
                    String _uid = user!.uid;
                    try {
                      await FirebaseFirestore.instance
                          .collection('users')
                          .doc(_uid)
                          .update({
                        'shipping-address': _addressTextController.text,
                      });

                      Navigator.pop(context);
                      setState(() {
                        address = _addressTextController.text;
                      });
                    } catch (err) {
                      GlobalMethods.errorDialog(
                          subtitle: err.toString(), context: context);
                    }
                  },
                  child: Text('Update'))
            ],
          );
        });
  }

  Widget _listTiles({
    required String title,
    String? subtitle,
    required IconData icon,
    required Function onPressed,
    required Color color,
  }) {
    return ListTile(
        title: TextWidget(
          text: title,
          color: color,
          textSize: 22.0,
        ),
        subtitle: TextWidget(
          text: subtitle == null ? "" : subtitle,
          color: color,
          textSize: 18.0,
        ),
        leading: Icon(icon),
        trailing: Icon(IconlyLight.arrowRight2),
        onTap: () {
          onPressed();
        });
  }
}

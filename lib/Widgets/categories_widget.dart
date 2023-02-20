import 'package:flutter/material.dart';
import 'package:grocery_app/Inner%20Screen/cat_screen.dart';
import 'package:grocery_app/Screens/categories..dart';
import 'package:grocery_app/Widgets/text_widget.dart';
import 'package:provider/provider.dart';
import '../Providers/dark_theme_provider.dart';

class CategoriesWidget extends StatelessWidget {
  CategoriesWidget(
      {Key? key,
      required this.catText,
      required this.imgPath,
      required this.passedColor})
      : super(key: key);
  final String catText, imgPath;
  final passedColor;

  @override
  Widget build(BuildContext context) {
    final themeState = Provider.of<DarkThemeProvider>(context);
    double _screenWidth = MediaQuery.of(context).size.width;
    final Color color = themeState.getDarkTheme ? Colors.white : Colors.black;
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, CategoryScreen.routeName,
            arguments: catText);
      },
      child: Container(
        decoration: BoxDecoration(
            color: passedColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16.0),
            border:
                Border.all(color: passedColor.withOpacity(0.7), width: 2.0)),
        child: Column(
          children: [
            Container(
              height: _screenWidth * 0.3,
              width: _screenWidth * 0.3,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(imgPath), fit: BoxFit.fill)),
            ),
            TextWidget(
              text: catText,
              color: color,
              textSize: 20.0,
              isTitle: true,
            )
          ],
        ),
      ),
    );
  }
}

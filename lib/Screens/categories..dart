import 'package:flutter/material.dart';
import 'package:grocery_app/Services/utils.dart';
import 'package:grocery_app/Widgets/text_widget.dart';

import '../Widgets/categories_widget.dart';

class CategoriesScreen extends StatelessWidget {
  CategoriesScreen({Key? key}) : super(key: key);
  List<Color> gridColors = [
    const Color(0xff53B175),
    const Color(0xffF8A44C),
    const Color(0xffF7A593),
    const Color(0xffD3B0E0),
    const Color(0xffFDE598),
    const Color(0xffB7DFF5),
  ];
  final List<Map<String, dynamic>> catInfo = [
    {'imgPath': 'images/cat/fruits.png', 'catText': 'Fruits'},
    {'imgPath': 'images/cat/veg.png', 'catText': 'Vegetables'},
    {'imgPath': 'images/cat/Spinach.png', 'catText': 'Herbs'},
    {'imgPath': 'images/cat/nuts.png', 'catText': 'Nuts'},
    {'imgPath': 'images/cat/spices.png', 'catText': 'Spices'},
    {'imgPath': 'images/cat/grains.png', 'catText': 'Grains'},
  ];

  @override
  Widget build(BuildContext context) {
    final utils = Utils(context);
    Color color = utils.color;
    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: TextWidget(
            text: 'Categories',
            color: color,
            textSize: 24.0,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GridView.count(
            crossAxisCount: 2,
            childAspectRatio: 240 / 250,
            crossAxisSpacing: 10.0,
            mainAxisSpacing: 10.0,
            children: List.generate(6, (index) {
              return CategoriesWidget(
                  catText: catInfo[index]['catText'],
                  imgPath: catInfo[index]['imgPath'],
                  passedColor: gridColors[index]);
            }),
          ),
        ));
  }
}

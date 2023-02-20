import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Widgets/text_widget.dart';

class GlobalMethods {
  static navigateTo({required BuildContext ctx, required String routeName}) {
    Navigator.pushNamed(ctx, routeName);
  }

  static Future<void> warningDialog({
    required String title,
    required String subtitle,
    required Function fct,
    required BuildContext context,
  }) async {
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Row(
              children: [
                Image.asset(
                  'images/warning-sign.png',
                  height: 20.0,
                  width: 20.0,
                  fit: BoxFit.fill,
                ),
                SizedBox(
                  width: 8.0,
                ),
                Text(title)
              ],
            ),
            content: Text(subtitle),
            actions: [
              TextButton(
                  onPressed: () {
                    if (Navigator.canPop(context)) {
                      Navigator.pop(context);
                    }
                  },
                  child: TextWidget(
                    color: Colors.cyanAccent,
                    text: 'Cancel',
                    textSize: 18.0,
                  )),
              TextButton(
                  onPressed: () {
                    if (Navigator.canPop(context)) {
                      Navigator.pop(context);
                    }
                    fct();
                  },
                  child: TextWidget(
                    color: Colors.red,
                    text: 'Ok',
                    textSize: 18.0,
                  )),
            ],
          );
        });
  }

  static Future<void> errorDialog({
    required String subtitle,
    required BuildContext context,
  }) async {
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Row(
              children: [
                Image.asset(
                  'images/warning-sign.png',
                  height: 20.0,
                  width: 20.0,
                  fit: BoxFit.fill,
                ),
                SizedBox(
                  width: 8.0,
                ),
                Text('An Error occurred')
              ],
            ),
            content: Text(subtitle),
            actions: [
              TextButton(
                  onPressed: () {
                    if (Navigator.canPop(context)) {
                      Navigator.pop(context);
                    }
                  },
                  child: TextWidget(
                    color: Colors.red,
                    text: 'Ok',
                    textSize: 18.0,
                  )),
            ],
          );
        });
  }
}

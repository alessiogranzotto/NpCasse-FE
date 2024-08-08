import 'dart:ui';

import 'package:flutter/material.dart';

class CustomAlertDialog extends StatelessWidget {
  const CustomAlertDialog(
      {super.key,
      required this.title,
      required this.content,
      required this.yesCallBack,
      required this.noCallBack});
  final String title;
  final String content;
  final Function yesCallBack;
  final Function noCallBack;

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
        filter:
            ImageFilter.blur(sigmaX: 3, sigmaY: 3, tileMode: TileMode.mirror),
        child: AlertDialog(
          title: Text(title, style: const TextStyle(color: Colors.black)),
          content: Text(
            content,
          ),
          actions: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                  textStyle: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.bold)),
              child: const Text("Sì"),
              onPressed: () {
                Navigator.of(context).pop();
                yesCallBack();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                  textStyle: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.bold)),
              child: const Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
                noCallBack();
              },
            ),
          ],
        ));
  }
}

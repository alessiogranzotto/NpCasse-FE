import 'package:flutter/material.dart';

class SnackUtil {
  static stylishSnackBar(
      {required String text, required BuildContext context}) {
    return SnackBar(
      backgroundColor: Colors.blue[100],
      // behavior: SnackBarBehavior.floating,
      // margin: const EdgeInsets.all(40),

      dismissDirection: DismissDirection.up,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(50),
      elevation: 30,
      // margin: EdgeInsets.only(
      //     bottom: MediaQuery.of(context).size.height - 150,
      //     left: 10,
      //     right: 10),
      content: Text(
        text,
        style: Theme.of(context).textTheme.headlineMedium,
      ),
    );
  }
}

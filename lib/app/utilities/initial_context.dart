import 'package:flutter/material.dart';

class ContextKeeper {
  static late BuildContext buildContext;

  void init(BuildContext context) {
    buildContext = context;
  }
}
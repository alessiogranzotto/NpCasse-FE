import 'package:flutter/material.dart';

class NoDataResult extends StatelessWidget {
  const NoDataResult({required this.area, required this.message, this.icon, r});

  final String area;
  final String message;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Text(message),
    );
  }
}

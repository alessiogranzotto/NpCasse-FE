// import 'dart:math';
// import 'package:flutter/material.dart';

// class ObscuringTextEditingController extends TextEditingController {
//   @override
//   TextSpan buildTextSpan(
//       {required BuildContext context,
//       TextStyle? style,
//       required bool withComposing}) {
//     final text = value.text;
//     final obscuredLength = min(text.length, 5);
//     final obscuredText =
//         text.replaceRange(0, obscuredLength, '•' * obscuredLength);
//     return TextSpan(text: obscuredText, style: style);
//   }
// }

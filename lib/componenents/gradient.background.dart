// import 'package:flutter/material.dart';
// import 'package:np_casse/app/constants/keys.dart';
// import 'package:np_casse/app/utilities/extensions.dart';

// class GradientBackground extends StatelessWidget {
//   const GradientBackground({
//     required this.children,
//     this.colors = AppColors.defaultGradient,
//     super.key,
//   });

//   final List<Color> colors;
//   final List<Widget> children;

//   @override
//   Widget build(BuildContext context) {
//     return DecoratedBox(
//       decoration: BoxDecoration(gradient: LinearGradient(colors: colors)),
//       child: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             SizedBox(
//               height: context.heightFraction(sizeFraction: 0.1),
//             ),
//             ...children,
//           ],
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';

// /// Flutter code sample for [showDialog].

// class ReceiptDialog extends StatelessWidget {
//   const ReceiptDialog({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('AlertDialog Sample')),
//       body: Center(
//         child: OutlinedButton(
//           onPressed: () {
//             Navigator.of(context).restorablePush(_dialogBuilder);
//           },
//           child: const Text('Open Dialog'),
//         ),
//       ),
//     );
//   }

//   static Route<Object?> _dialogBuilder(
//       BuildContext context, Object? arguments) {
//     return DialogRoute<void>(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Basic dialog title'),
//           content: const Text(
//             'A dialog is a type of modal window that\n'
//             'appears in front of app content to\n'
//             'provide critical information, or prompt\n'
//             'for a decision to be made.',
//           ),
//           actions: <Widget>[
//             TextButton(
//               style: TextButton.styleFrom(
//                 textStyle: Theme.of(context).textTheme.labelLarge,
//               ),
//               child: const Text('Disable'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//             TextButton(
//               style: TextButton.styleFrom(
//                 textStyle: Theme.of(context).textTheme.labelLarge,
//               ),
//               child: const Text('Enable'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }
// }

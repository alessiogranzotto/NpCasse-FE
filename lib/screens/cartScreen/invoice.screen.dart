// import 'package:flutter/material.dart';

// class InvoiceScreen extends StatefulWidget {
//   const InvoiceScreen({super.key});

//   @override
//   State<InvoiceScreen> createState() => _InvoiceScreenState();
// }

// class _InvoiceScreenState extends State<InvoiceScreen> {
//   final List<bool> _selectedPayment = <bool>[true, false, false];

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         backgroundColor: Theme.of(context).colorScheme.background,
//         appBar: AppBar(
//           title: Text('Pagamento del carrello',
//               style: Theme.of(context).textTheme.headlineMedium),
//         ),
//         body: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: ToggleButtons(
//             direction: Axis.horizontal,
//             onPressed: (int index) {
//               setState(() {
//                 // The button that is tapped is set to true, and the others to false.
//                 for (int i = 0; i < _selectedPayment.length; i++) {
//                   _selectedPayment[i] = i == index;
//                 }
//               });
//             },
//             borderRadius: const BorderRadius.all(Radius.circular(8)),
//             selectedBorderColor: Colors.blueAccent[700],
//             selectedColor: Colors.black,
//             fillColor: Colors.blueAccent[200],
//             color: Colors.black,
//             // constraints: const BoxConstraints(
//             //   minHeight: 40.0,
//             //   minWidth: 80.0,
//             // ),
//             isSelected: _selectedPayment,
//             children: [
//               SizedBox(
//                 height: 50,
//                 width: 200,
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     const Icon(Icons.euro),
//                     Text('Contanti',
//                         style: Theme.of(context).textTheme.headlineSmall),
//                   ],
//                 ),
//               ),
//               SizedBox(
//                 height: 50,
//                 width: 200,
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     const Icon(Icons.euro),
//                     Text('Bancomat',
//                         style: Theme.of(context).textTheme.headlineSmall),
//                   ],
//                 ),
//               ),
//               SizedBox(
//                 height: 50,
//                 width: 200,
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     const Icon(Icons.credit_card),
//                     Text('Carta di credito',
//                         style: Theme.of(context).textTheme.headlineSmall),
//                   ],
//                 ),
//               ),
//               SizedBox(
//                 height: 50, //height of button
//                 width: 200,
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     const Icon(Icons.devices_other),
//                     Text('Assegni',
//                         style: Theme.of(context).textTheme.headlineSmall),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

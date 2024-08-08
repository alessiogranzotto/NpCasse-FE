// import 'package:flutter/material.dart';
// import 'package:np_casse/screens/cartScreen/sh.new.screen.dart';
// import 'package:np_casse/screens/cartScreen/sh.search.screen.dart';

// enum ShirtSize { extraSmall, small, medium, large, extraLarge }

// class ToggleSearchNewSh extends StatefulWidget {
//   const ToggleSearchNewSh({super.key});

//   @override
//   State<ToggleSearchNewSh> createState() => _ToggleSearchNewShState();
// }

// class _ToggleSearchNewShState extends State<ToggleSearchNewSh> {
//   final List<bool> _selectedArea = <bool>[true, false];
//   final List<String> _tabs = <String>["Ricerca anagrafica", "Nuova anagrafica"];
//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       initialIndex: 0,
//       length: 2,
//       child: Scaffold(
//                 appBar: AppBar( 
//             title: Text('Ricerca anagrafica ed inserimento nuova anagrafica',
//                 style: Theme.of(context).textTheme.headlineLarge),
//             bottom: TabBar(
//               indicator: const UnderlineTabIndicator(
//                   borderSide: BorderSide(
//                     width: 4,
//                     color: Color(0xFF646464),
//                   ),
//                   insets: EdgeInsets.only(left: 0, right: 8, bottom: 4)),
//               isScrollable: true,
//               labelPadding: const EdgeInsets.only(left: 16.0, right: 16.0),
//               tabs: _tabs
//                   .map((label) => Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Tab(
//                             child: Row(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             label == "Ricerca anagrafica"
//                                 ? const Icon(Icons.search)
//                                 : const Icon(Icons.add),
//                             Text(label,
//                                 style:
//                                     Theme.of(context).textTheme.headlineMedium),
//                           ],
//                         )),
//                       ))
//                   .toList(),
//             )

// //  const TabBar(
// //             tabs: <Widget>[
// //               Tab(
// //                 icon: Icon(Icons.search),
// //               ),
// //               Tab(
// //                 icon: Icon(Icons.add),
// //               )
// //             ],
// //           ),
//             ),
//         body: const TabBarView(
//           children: [
//             ShSearchScreen(),
//             ShNewScreen(),
//           ],
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:np_casse/core/notifiers/authentication.notifier.dart';
// import 'package:np_casse/screens/cartScreen/cart.screen.dart';
// import 'package:np_casse/screens/loginScreen/logout.view.dart';
// import 'package:np_casse/screens/projectScreen/project.screen.dart';
// import 'package:np_casse/screens/userAppIinstitutionScreen/user.app.institution.screen.dart';
// import 'package:np_casse/screens/wishlistScreen/wishlist.screen.dart';
// import 'package:provider/provider.dart';

// /// Flutter code sample for [NavigationDrawer].
 
// class HomeScreen2 extends StatefulWidget {
//   const HomeScreen2({super.key});

//   @override
//   State<HomeScreen2> createState() => _HomeScreen2State();
// }

// class _HomeScreen2State extends State<HomeScreen2> {
//   final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

//   int screenIndex = 0;
//   late bool showNavigationDrawer;

//   void handleScreenChanged(int selectedScreen) {
//     setState(() {
//       screenIndex = selectedScreen;
//     });
//   }

//   void openDrawer() {
//     scaffoldKey.currentState!.openEndDrawer();
//   }

//   List<Widget> buildScreens(BuildContext context) {
//     AuthenticationNotifier authenticationNotifier =
//         Provider.of<AuthenticationNotifier>(context);

//     int nrAssociazioni = authenticationNotifier.getNumberUserAppInstitution();
//     List<Widget> result = [];
//     result.add(const WishlistScreen());
//     result.add(const ProjectScreen());
//     if (nrAssociazioni > 1) {
//       result.add(const UserAppInstitutionScreen());
//     }
//     result.add(const CartScreen());
//     result.add(const LogoutScreen());
//     return result;
//   }

//   Widget buildBottomBarScaffold() {
//     return Scaffold(
//       body: Center(
//         child: buildScreens(context)[screenIndex],
//       ),
//       bottomNavigationBar: NavigationBar(
//         selectedIndex: screenIndex,
//         onDestinationSelected: (int index) {
//           setState(() {
//             screenIndex = index;
//           });
//         },
//         destinations: destinations.map(
//           (ExampleDestination destination) {
//             return NavigationDestination(
//               label: destination.label,
//               icon: destination.icon,
//               selectedIcon: destination.selectedIcon,
//               tooltip: destination.label,
//             );
//           },
//         ).toList(),
//       ),
//     );
//   }

//   Widget buildDrawerScaffold(BuildContext context) {
//     return Scaffold(
//       key: scaffoldKey,
//       body: SafeArea(
//         bottom: false,
//         top: false,
//         child: Row(
//           children: <Widget>[
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 5),
//               child: NavigationRail(
//                 minWidth: 50,
//                 destinations: destinations.map(
//                   (ExampleDestination destination) {
//                     return NavigationRailDestination(
//                       label: Text(destination.label),
//                       icon: destination.icon,
//                       selectedIcon: destination.selectedIcon,
//                     );
//                   },
//                 ).toList(),
//                 selectedIndex: screenIndex,
//                 useIndicator: true,
//                 onDestinationSelected: (int index) {
//                   setState(() {
//                     screenIndex = index;
//                   });
//                 },
//               ),
//             ),
//             const VerticalDivider(thickness: 1, width: 1),
//             Expanded(
//               child: Center(
//                 child: buildScreens(context)[screenIndex],
//               ),
//             ),
//           ],
//         ),
//       ),
//       endDrawer: NavigationDrawer(
//         onDestinationSelected: handleScreenChanged,
//         selectedIndex: screenIndex,
//         children: <Widget>[
//           Padding(
//             padding: const EdgeInsets.fromLTRB(28, 16, 16, 10),
//             child: Text(
//               'Header',
//               style: Theme.of(context).textTheme.titleSmall,
//             ),
//           ),
//           ...destinations.map(
//             (ExampleDestination destination) {
//               return NavigationDrawerDestination(
//                 label: Text(destination.label),
//                 icon: destination.icon,
//                 selectedIcon: destination.selectedIcon,
//               );
//             },
//           ),
//           const Padding(
//             padding: EdgeInsets.fromLTRB(28, 16, 28, 10),
//             child: Divider(),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     var i = MediaQuery.of(context).size.width;
//     showNavigationDrawer = MediaQuery.of(context).size.width >= 800;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return showNavigationDrawer
//         ? buildDrawerScaffold(context)
//         : buildBottomBarScaffold();
//   }
// }

// class MyDrawer extends StatefulWidget {
//   const MyDrawer({super.key});

//   @override
//   State<MyDrawer> createState() => _MyDrawerState();
// }

// class _MyDrawerState extends State<MyDrawer> {
//   @override
//   Widget build(BuildContext context) {
//     return const Placeholder();
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:np_casse/core/notifiers/authentication.notifier.dart';
// import 'package:np_casse/screens/cartScreen/cart.screen.dart';
// import 'package:np_casse/screens/loginScreen/logout.view.dart';
// import 'package:np_casse/screens/projectScreen/project.screen.dart';
// import 'package:np_casse/screens/userAppIinstitutionScreen/user.app.institution.screen.dart';
// import 'package:np_casse/screens/wishlistScreen/wishlist.screen.dart';
// import 'package:provider/provider.dart';

// class ExampleDestination {
//   const ExampleDestination(this.label, this.icon, this.selectedIcon);

//   final String label;
//   final Widget icon;
//   final Widget selectedIcon;
// }

// const List<ExampleDestination> destinations = <ExampleDestination>[
//   ExampleDestination(
//       'Messages', Icon(Icons.widgets_outlined), Icon(Icons.widgets)),
//   ExampleDestination(
//       'Profile', Icon(Icons.format_paint_outlined), Icon(Icons.format_paint)),
//   ExampleDestination(
//       'Settings', Icon(Icons.settings_outlined), Icon(Icons.settings)),
// ];

// class CustomBarDrawerWidget extends StatefulWidget {
//   const CustomBarDrawerWidget({super.key});

//   @override
//   State<CustomBarDrawerWidget> createState() => _CustomBarDrawerWidgetState();
// }

// class _CustomBarDrawerWidgetState extends State<CustomBarDrawerWidget> {
//   final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

//   int selectedMenu = 0;
//   late bool showNavigationDrawer;

//   void handleScreenChanged(int selectedScreen) {
//     setState(() {
//       selectedMenu = selectedScreen;
//     });
//   }

//   void openDrawer() {
//     scaffoldKey.currentState!.openEndDrawer();
//   }

//   List<Widget> drawerScreens = List.empty();
//   List<ListTile> drawerTile = List.empty();

//   @override
//   void initState() {
//     super.initState();
//     // ContextKeeper().init(context);
//     // drawerScreens = buildDrawerScreens(context);
//     // drawerTile = buildDrawerMenu(context);
//   }

//   List<Widget> buildDrawerScreens(BuildContext context) {
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

//   List<ListTile> buildDrawerMenu(BuildContext context) {
//     AuthenticationNotifier authenticationNotifier =
//         Provider.of<AuthenticationNotifier>(context);

//     int nrAssociazioni = authenticationNotifier.getNumberUserAppInstitution();
//     List<ListTile> result = [];
//     result.add(ListTile(
//       leading: const Icon(Icons.favorite_border),
//       title: const Text('Preferiti'),
//       onTap: () {
//         onItemTapped(context, 3);
//       },
//     ));

//     result.add(ListTile(
//       leading: const Icon(Icons.favorite_border),
//       title: const Text('Progetti'),
//       onTap: () {
//         onItemTapped(context, 3);
//       },
//     ));

//     if (nrAssociazioni > 1) {
//       result.add(ListTile(
//         leading: const Icon(Icons.favorite_border),
//         title: const Text('Associazioni'),
//         onTap: () {
//           onItemTapped(context, 3);
//         },
//       ));
//     }
//     result.add(ListTile(
//       leading: const Icon(Icons.favorite_border),
//       title: const Text('Carrello'),
//       onTap: () {
//         onItemTapped(context, 3);
//       },
//     ));
//     result.add(ListTile(
//       leading: const Icon(Icons.favorite_border),
//       title: const Text('Uscita'),
//       onTap: () {
//         onItemTapped(context, 3);
//       },
//     ));
//     return result;
//   }

//   void onItemTapped(BuildContext context, int index) {
//     setState(() {
//       selectedMenu = index;
//     });
//     Navigator.pop(context);
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => drawerScreens[index]),
//     );
//   }

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     var i = MediaQuery.of(context).size.width;
//   }

//   @override
//   Widget build(BuildContext context) {
//     drawerScreens = buildDrawerScreens(context);
//     drawerTile = buildDrawerMenu(context);
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 5),
//       child: NavigationRail(
//         minWidth: 100,
//         destinations: destinations.map(
//           (ExampleDestination destination) {
//             return NavigationRailDestination(
//               label: Text(destination.label),
//               icon: destination.icon,
//               selectedIcon: destination.selectedIcon,
//             );
//           },
//         ).toList(),
//         selectedIndex: selectedMenu,
//         useIndicator: true,
//         onDestinationSelected: (int index) {
//           setState(() {
//             selectedMenu = index;
//           });
//         },
//       ),
//     );
//   }
// }

// class CustomDrawerWidget extends StatefulWidget {
//   const CustomDrawerWidget({super.key});
//   @override
//   State<CustomDrawerWidget> createState() => _CustomDrawerWidgetState();
// }

// class _CustomDrawerWidgetState extends State<CustomDrawerWidget> {
//   int selectedMenu = 0;

//   List<Widget> drawerScreens = List.empty();
//   List<ListTile> drawerTile = List.empty();

//   @override
//   void initState() {
//     super.initState();
//     // ContextKeeper().init(context);
//     // drawerScreens = buildDrawerScreens(context);
//     // drawerTile = buildDrawerMenu(context);
//   }

//   List<Widget> buildDrawerScreens(BuildContext context) {
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

//   List<ListTile> buildDrawerMenu(BuildContext context) {
//     AuthenticationNotifier authenticationNotifier =
//         Provider.of<AuthenticationNotifier>(context);

//     int nrAssociazioni = authenticationNotifier.getNumberUserAppInstitution();
//     List<ListTile> result = [];
//     result.add(ListTile(
//       leading: const Icon(Icons.favorite_border),
//       title: const Text('Preferiti'),
//       onTap: () {
//         onItemTapped(context, 3);
//       },
//     ));

//     result.add(ListTile(
//       leading: const Icon(Icons.favorite_border),
//       title: const Text('Progetti'),
//       onTap: () {
//         onItemTapped(context, 3);
//       },
//     ));

//     if (nrAssociazioni > 1) {
//       result.add(ListTile(
//         leading: const Icon(Icons.favorite_border),
//         title: const Text('Associazioni'),
//         onTap: () {
//           onItemTapped(context, 3);
//         },
//       ));
//     }
//     result.add(ListTile(
//       leading: const Icon(Icons.favorite_border),
//       title: const Text('Carrello'),
//       onTap: () {
//         onItemTapped(context, 3);
//       },
//     ));
//     result.add(ListTile(
//       leading: const Icon(Icons.favorite_border),
//       title: const Text('Uscita'),
//       onTap: () {
//         onItemTapped(context, 3);
//       },
//     ));
//     return result;
//   }

//   void onItemTapped(BuildContext context, int index) {
//     setState(() {
//       selectedMenu = index;
//     });
//     Navigator.pop(context);
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => drawerScreens[index]),
//     );
//   }

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     var i = MediaQuery.of(context).size.width;
//   }

//   @override
//   Widget build(BuildContext context) {
//     drawerScreens = buildDrawerScreens(context);
//     drawerTile = buildDrawerMenu(context);
//     return Drawer(
//       // Add a ListView to the drawer. This ensures the user can scroll
//       // through the options in the drawer if there isn't enough vertical
//       // space to fit everything.
//       child: ListView(
//         // Important: Remove any padding from the ListView.
//         padding: EdgeInsets.zero,
//         children: [
//           Material(
//             color: Colors.blueAccent,
//             child: InkWell(
//               onTap: () {
//                 /// Close Navigation drawer before
//                 Navigator.pop(context);
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                       builder: (context) => const ProjectScreen()),
//                 );
//               },
//               child: Container(
//                 padding: EdgeInsets.only(
//                     top: MediaQuery.of(context).padding.top, bottom: 24),
//                 child: const Column(
//                   children: [
//                     CircleAvatar(
//                       radius: 52,
//                       backgroundImage: NetworkImage(
//                           'https://images.unsplash.com/photo-1554151228-14d9def656e4?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTB8fHNtaWx5JTIwZmFjZXxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=500&q=60'
//                           // 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8c21pbHklMjBmYWNlfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=500&q=60'
//                           ),
//                     ),
//                     SizedBox(
//                       height: 12,
//                     ),
//                     Text(
//                       'Sophia',
//                       style: TextStyle(fontSize: 28, color: Colors.white),
//                     ),
//                     Text(
//                       '@sophia.com',
//                       style: TextStyle(fontSize: 14, color: Colors.white),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//           const DrawerHeader(
//             decoration: BoxDecoration(
//               color: Colors.blue,
//             ),
//             child: Text('Drawer Header'),
//           ),
//           ListView.builder(
//             shrinkWrap: true,
//             itemCount: destinations.length,
//             itemBuilder: (context, index) {
//               return drawerTile[index];
//             },
//           ),
//         ],
//       ),
//     );

//     // return Drawer(
//     //   child: SingleChildScrollView(
//     //     child: Column(
//     //       crossAxisAlignment: CrossAxisAlignment.stretch,
//     //       children: [
//     //         /// Header of the Drawer
//     //         Material(
//     //           color: Colors.blueAccent,
//     //           child: InkWell(
//     //             onTap: () {
//     //               /// Close Navigation drawer before
//     //               Navigator.pop(context);
//     //               Navigator.push(
//     //                 context,
//     //                 MaterialPageRoute(
//     //                     builder: (context) => const ProjectScreen()),
//     //               );
//     //             },
//     //             child: Container(
//     //               padding: EdgeInsets.only(
//     //                   top: MediaQuery.of(context).padding.top, bottom: 24),
//     //               child: const Column(
//     //                 children: [
//     //                   CircleAvatar(
//     //                     radius: 52,
//     //                     backgroundImage: NetworkImage(
//     //                         'https://images.unsplash.com/photo-1554151228-14d9def656e4?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTB8fHNtaWx5JTIwZmFjZXxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=500&q=60'
//     //                         // 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8c21pbHklMjBmYWNlfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=500&q=60'
//     //                         ),
//     //                   ),
//     //                   SizedBox(
//     //                     height: 12,
//     //                   ),
//     //                   Text(
//     //                     'Sophia',
//     //                     style: TextStyle(fontSize: 28, color: Colors.white),
//     //                   ),
//     //                   Text(
//     //                     '@sophia.com',
//     //                     style: TextStyle(fontSize: 14, color: Colors.white),
//     //                   ),
//     //                 ],
//     //               ),
//     //             ),
//     //           ),
//     //         ),

//     //         /// Header Menu items
//     //         Column(
//     //           children: [
//     //             ListTile(
//     //               leading: const Icon(Icons.home_outlined),
//     //               title: const Text('Home'),
//     //               onTap: () {
//     //                 /// Close Navigation drawer before
//     //                 Navigator.pop(context);
//     //                 Navigator.push(
//     //                   context,
//     //                   MaterialPageRoute(
//     //                       builder: (context) => const WishlistScreen()),
//     //                 );
//     //               },
//     //             ),
//     //             ListTile(
//     //               leading: Icon(Icons.favorite_border),
//     //               title: Text('Favourites'),
//     //               onTap: () {
//     //                 /// Close Navigation drawer before
//     //                 Navigator.pop(context);
//     //                 Navigator.push(
//     //                   context,
//     //                   MaterialPageRoute(
//     //                       builder: (context) => const CartScreen()),
//     //                 );
//     //               },
//     //             ),
//     //             ListTile(
//     //               leading: const Icon(Icons.workspaces),
//     //               title: const Text('Workflow'),
//     //               onTap: () {},
//     //             ),
//     //             ListTile(
//     //               leading: const Icon(Icons.update),
//     //               title: const Text('Updates'),
//     //               onTap: () {},
//     //             ),
//     //             const Divider(
//     //               color: Colors.black45,
//     //             ),
//     //             ListTile(
//     //               leading: const Icon(Icons.account_tree_outlined),
//     //               title: const Text('Plugins'),
//     //               onTap: () {},
//     //             ),
//     //             ListTile(
//     //               leading: const Icon(Icons.notifications_outlined),
//     //               title: const Text('Notifications'),
//     //               onTap: () {},
//     //             ),
//     //           ],
//     //         )
//     //       ],
//     //     ),
//     //   ),
//     // );
//   }
// }

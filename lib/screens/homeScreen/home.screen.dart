import 'package:flutter/material.dart';
import 'package:np_casse/app/routes/app_routes.dart';
import 'package:np_casse/app/widget/custom_side_navigation_bar.dart/custom.side.navigation.bar.dart';
import 'package:np_casse/screens/cartScreen/cart.screen.dart';
import 'package:np_casse/screens/loginScreen/logout.view.dart';
import 'package:np_casse/screens/projectScreen/project.screen.dart';
import 'package:np_casse/screens/userAppIinstitutionScreen/user.app.institution.screen.dart';
import 'package:np_casse/screens/wishlistScreen/wishlist.screen.dart';

class MenuList {
  MenuList(
      this.screenRoute, this.label, this.icon, this.selectedIcon, this.screen);
  String screenRoute;
  String label;
  IconData icon;
  Widget selectedIcon;
  Widget screen;
}

List<MenuList> destinations = <MenuList>[
  MenuList(AppRouter.wishListRoute, 'Preferiti', Icons.favorite_outlined,
      const Icon(Icons.favorite), const WishlistScreen()),
  MenuList(AppRouter.projectRoute, 'Progetti', Icons.layers_outlined,
      const Icon(Icons.layers), const ProjectScreen()),
  MenuList(AppRouter.associazioniRoute, 'Associazioni', Icons.settings_outlined,
      const Icon(Icons.settings), const UserAppInstitutionScreen()),
  MenuList(AppRouter.cartRoute, 'Carrello', Icons.shopping_cart_outlined,
      const Icon(Icons.shopping_cart), const CartScreen()),
  MenuList(AppRouter.logoutRoute, 'Uscita', Icons.logout_outlined,
      const Icon(Icons.logout), const LogoutScreen()),
];

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  /// Views to display
  List<Widget> views = const [
    Center(
      child: Text('Dashboard'),
    ),
    Center(
      child: Text('Account'),
    ),
    Center(
      child: Text('Settings'),
    ),
  ];

  /// The currently selected index of the bar
  int selectedIndex = 0;

  List<SideNavigationBarItem> getSideNavigationBarItem() {
    List<SideNavigationBarItem> result = [];
    result = destinations
        .map((e) => SideNavigationBarItem(icon: e.icon, label: e.label))
        .toList();
    return result;
  }

  List<Widget> getScreenNavigationBarItem() {
    List<Widget> result = [];
    result = destinations.map((e) => e.screen).toList();
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// You can use an AppBar if you want to
      // appBar: AppBar(
      //   title: const Text('App'),
      // ),

      // The row is needed to display the current view
      body: Row(
        children: [
          /// Pretty similar to the BottomNavigationBar!
          SideNavigationBar(
            expandable: true,
            theme: SideNavigationBarTheme.blue(),
            // header: SideNavigationBarHeader(
            //     image: Image.network(
            //         width: 100,
            //         height: 100,
            //         'https://images.unsplash.com/photo-1554151228-14d9def656e4?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTB8fHNtaWx5JTIwZmFjZXxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=500&q=60'),
            //     title: const Text("Title"),
            //     subtitle: const Text("Subtitle")),
            footer: const SideNavigationBarFooter(label: Text("label")),
            selectedIndex: selectedIndex,
            items: getSideNavigationBarItem(),
            onTap: (index) {
              setState(() {
                selectedIndex = index;
              });
            },
          ),

          /// Make it take the rest of the available width
          Expanded(
            child: getScreenNavigationBarItem().elementAt(selectedIndex),
          )
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:np_casse/app/routes/app_routes.dart';
import 'package:np_casse/core/models/user.app.institution.model.dart';
import 'package:np_casse/core/models/user.model.dart';
import 'package:np_casse/core/notifiers/authentication.notifier.dart';
import 'package:np_casse/screens/cartScreen/cart.screen.dart';
import 'package:np_casse/screens/loginScreen/logout.view.dart';
import 'package:np_casse/screens/projectScreen/project.screen.dart';
import 'package:np_casse/screens/userAppIinstitutionScreen/user.app.institution.screen.dart';
import 'package:np_casse/screens/wishlistScreen/wishlist.screen.dart';
import 'package:provider/provider.dart';

class MenuList {
  MenuList(
      this.screenRoute, this.label, this.icon, this.selectedIcon, this.screen);
  String screenRoute;
  String label;
  Widget icon;
  Widget selectedIcon;
  Widget screen;
}

List<MenuList> destinations = <MenuList>[
  MenuList(
      AppRouter.wishListRoute,
      'Preferiti',
      const Icon(Icons.favorite_outlined),
      const Icon(Icons.favorite),
      const WishlistScreen()),
  MenuList(
      AppRouter.projectRoute,
      'Progetti',
      const Icon(Icons.layers_outlined),
      const Icon(Icons.layers),
      const ProjectScreen()),
  MenuList(
      AppRouter.associazioniRoute,
      'Associazioni',
      const Icon(Icons.settings_outlined),
      const Icon(Icons.settings),
      const UserAppInstitutionScreen()),
  MenuList(
      AppRouter.cartRoute,
      'Carrello',
      const Icon(Icons.shopping_cart_outlined),
      const Icon(Icons.shopping_cart),
      const CartScreen()),
  MenuList(AppRouter.logoutRoute, 'Uscita', const Icon(Icons.logout_outlined),
      const Icon(Icons.logout), const LogoutScreen()),
];

class CustomDrawerWidget extends StatefulWidget {
  const CustomDrawerWidget({super.key});
  @override
  State<CustomDrawerWidget> createState() => _CustomDrawerWidgetState();
}

class _CustomDrawerWidgetState extends State<CustomDrawerWidget> {
  int selectedMenu = 0;
  late UserModel cUserModel;
  late UserAppInstitutionModel cSelectedUserAppInstitution;
  // List<Widget> drawerScreens = List.empty();
  // List<ListTile> drawerTile = List.empty();

  @override
  void initState() {
    super.initState();
    // ContextKeeper().init(context);
    // drawerScreens = buildDrawerScreens(context);
    // drawerTile = buildDrawerMenu(context);
  }

  List<Widget> buildDrawerScreens(BuildContext context) {
    AuthenticationNotifier authenticationNotifier =
        Provider.of<AuthenticationNotifier>(context);

    int nrAssociazioni = authenticationNotifier.getNumberUserAppInstitution();
    List<Widget> result = [];
    result.add(const WishlistScreen());
    result.add(const ProjectScreen());
    if (nrAssociazioni > 1) {
      result.add(const UserAppInstitutionScreen());
    }
    result.add(const CartScreen());
    result.add(const LogoutScreen());
    return result;
  }

  void adjustMenu(BuildContext context) {
    AuthenticationNotifier authenticationNotifier =
        Provider.of<AuthenticationNotifier>(context);

    int nrAssociazioni = authenticationNotifier.getNumberUserAppInstitution();

    if (nrAssociazioni == 1) {
      destinations.removeWhere((element) => element.label == "Associazioni");
    }
  }

  void getUserData(BuildContext context) {
    AuthenticationNotifier authenticationNotifier =
        Provider.of<AuthenticationNotifier>(context);

    cUserModel = authenticationNotifier.getUser();

    cSelectedUserAppInstitution =
        authenticationNotifier.getSelectedUserAppInstitution();
  }

  void onItemTapped(BuildContext context, int index) {
    setState(() {
      selectedMenu = index;
    });
    // Navigator.pop(context);
    Navigator.of(context).pushNamed(destinations[index].screenRoute);
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) => destinations[index].screen),
    // );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    adjustMenu(context);
    getUserData(context);
    // drawerScreens = buildDrawerScreens(context);
    // drawerTile = buildDrawerMenu(context);
    return Drawer(
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the drawer if there isn't enough vertical
      // space to fit everything.
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          Material(
            // color: Colors.blueAccent,
            child: InkWell(
              // onTap: () {
              //   /// Close Navigation drawer before
              //   Navigator.pop(context);
              //   Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //         builder: (context) => const ProjectScreen()),
              //   );
              // },
              child: Container(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).padding.top, bottom: 24),
                child: Column(
                  children: [
                    const CircleAvatar(
                      radius: 52,
                      backgroundImage: NetworkImage(
                          'https://images.unsplash.com/photo-1554151228-14d9def656e4?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTB8fHNtaWx5JTIwZmFjZXxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=500&q=60'
                          // 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8c21pbHklMjBmYWNlfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=500&q=60'
                          ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Text(
                      '${cUserModel.name} ${cUserModel.surname}',
                      // style: const TextStyle(fontSize: 28, color: Colors.white),
                    ),
                    Text(
                      cUserModel.email,
                      // style: const TextStyle(fontSize: 14, color: Colors.white),
                    ),
                    Text(
                      cSelectedUserAppInstitution.roleUserAppInstitution,
                      // style: const TextStyle(fontSize: 14, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // const DrawerHeader(
          //   decoration: BoxDecoration(
          //     color: Colors.blue,
          //   ),
          //   child: Text('Drawer Header'),
          // ),
          ListView.builder(
            shrinkWrap: true,
            itemCount: destinations.length,
            itemBuilder: (context, index) {
              MenuList item = destinations[index];

              return ListTile(
                leading: item.icon,
                title: Text(item.label),
                onTap: () {
                  onItemTapped(context, index);
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

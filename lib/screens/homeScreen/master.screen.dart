import 'package:flutter/material.dart';
import 'package:flutter_lazy_indexed_stack/flutter_lazy_indexed_stack.dart';
import 'package:np_casse/app/routes/app_routes.dart';
import 'package:np_casse/componenents/customSideNavigationBar.dart/api/side_navigation_bar.dart';
import 'package:np_casse/componenents/customSideNavigationBar.dart/api/side_navigation_bar_footer.dart';
import 'package:np_casse/componenents/customSideNavigationBar.dart/api/side_navigation_bar_item.dart';
import 'package:np_casse/componenents/customSideNavigationBar.dart/api/side_navigation_bar_theme.dart';
import 'package:np_casse/core/models/user.app.institution.model.dart';
import 'package:np_casse/core/models/user.model.dart';
import 'package:np_casse/core/notifiers/authentication.notifier.dart';
import 'package:np_casse/core/notifiers/cart.notifier.dart';
import 'package:np_casse/core/notifiers/category.catalog.notifier.dart';
import 'package:np_casse/core/notifiers/product.attribute.notifier.dart';
import 'package:np_casse/core/notifiers/product.catalog.notifier.dart';
import 'package:np_casse/core/notifiers/shop.category.notifier.dart';
import 'package:np_casse/core/notifiers/wishlist.product.notifier.dart';
import 'package:np_casse/screens/cartScreen/cart.navigator.dart';
import 'package:np_casse/screens/categoryCatalogScreen/category.catalog.navigator.dart';
import 'package:np_casse/screens/institutionScreen/institution.view.dart';
import 'package:np_casse/screens/loginScreen/logout.view.dart';
import 'package:np_casse/screens/productAttributeScreen/product.attribute.navigator.dart';
import 'package:np_casse/screens/productCatalogScreen/product.catalog.navigator.dart';
import 'package:np_casse/screens/settingScreen/setting.screen.dart';
import 'package:np_casse/screens/shopScreen/shop.navigator.dart';
import 'package:np_casse/screens/userScreen/user.screen.dart';
import 'package:np_casse/screens/wishlistScreen/wishlist.screen.dart';
import 'package:provider/provider.dart';

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
  // MenuList(AppRouter.projectRoute, 'Progetti', Icons.layers_outlined,
  //     const Icon(Icons.layers), const ProjectNavigator()),
  MenuList(AppRouter.categoryOneShopRoute, 'Shop', Icons.shop,
      const Icon(Icons.layers), const ShopNavigator()),
  MenuList(AppRouter.institutionRoute, 'Associazioni', Icons.settings_outlined,
      const Icon(Icons.settings), const InstitutionScreen()),
  MenuList(AppRouter.cartRoute, 'Carrello', Icons.shopping_cart_outlined,
      const Icon(Icons.shopping_cart), const CartNavigator()),
  MenuList(AppRouter.settingRoute, 'Attributi prodotti', Icons.article_outlined,
      const Icon(Icons.settings), const ProductAttributeNavigator()),
  MenuList(AppRouter.settingRoute, 'Catalogo categorie', Icons.book,
      const Icon(Icons.settings), const CategoryCatalogNavigator()),
  MenuList(AppRouter.settingRoute, 'Catalogo prodotti', Icons.store,
      const Icon(Icons.settings), const ProductCatalogNavigator()),
  MenuList(AppRouter.settingRoute, 'Impostazioni', Icons.settings,
      const Icon(Icons.settings), const SettingScreen()),
  MenuList(AppRouter.userRoute, 'Utente', Icons.account_circle,
      const Icon(Icons.account_circle), const UserScreeen()),
  MenuList(AppRouter.logoutRoute, 'Uscita', Icons.logout_outlined,
      const Icon(Icons.logout), const LogoutScreen()),
];

class MasterScreen extends StatefulWidget {
  const MasterScreen({super.key});

  @override
  State<MasterScreen> createState() => _MasterScreenState();
}

class _MasterScreenState extends State<MasterScreen> {
  int _selectedIndex = 0;
  int nrProductinCart = 0;
  late UserModel cUserModel;
  late UserAppInstitutionModel cSelectedUserAppInstitution;
  // final List<GlobalKey<NavigatorState>> _navigatorKeys = [
  //   projectNavigatorKey,
  //   cartNavigatorKey
  // ];

  void getUserData(BuildContext context) {
    AuthenticationNotifier authenticationNotifier =
        Provider.of<AuthenticationNotifier>(context, listen: false);

    cUserModel = authenticationNotifier.getUser();

    cSelectedUserAppInstitution =
        authenticationNotifier.getSelectedUserAppInstitution();
  }

  void adjustMenu(BuildContext context) {
    AuthenticationNotifier authenticationNotifier =
        Provider.of<AuthenticationNotifier>(context);

    int nrAssociazioni = authenticationNotifier.getNumberUserAppInstitution();

    if (nrAssociazioni == 1) {
      destinations.removeWhere((element) => element.label == "Associazioni");
    }
    // destinations.removeWhere((element) => element.label == "Impostazioni");
    // destinations.removeWhere((element) => element.label == "Utente");
  }

  signOut(BuildContext context) {
    AuthenticationNotifier authenticationNotifier =
        Provider.of<AuthenticationNotifier>(context, listen: false);
    authenticationNotifier.userLogout(context);
  }

  @override
  void initState() {
    super.initState();
  }

  // Future<bool> _systemBackButtonPressed() async {
  //   if (_navigatorKeys[_selectedIndex].currentState?.canPop() == true) {
  //     _navigatorKeys[_selectedIndex]
  //         .currentState
  //         ?.pop(_navigatorKeys[_selectedIndex].currentContext);
  //     return false;
  //   } else {
  //     SystemChannels.platform.invokeMethod<void>('SystemNavigator.pop');
  //     return true; // Indicate that the back action is handled
  //   }
  // }

  List<SideNavigationBarItem> getSideNavigationBarItem() {
    List<SideNavigationBarItem> result = [];
    result = destinations
        .map((e) => SideNavigationBarItem(icon: e.icon, label: e.label))
        .toList();
    return result;
  }

  List<Widget> getScreenNavigationBarItem() {
    return destinations.map((e) => e.screen).toList();
  }

  @override
  Widget build(BuildContext context) {
    CartNotifier cartNotifier = Provider.of<CartNotifier>(context);
    // ProjectNotifier projectNotifier = Provider.of<ProjectNotifier>(context);
    WishlistProductNotifier wishlistProductNotifier =
        Provider.of<WishlistProductNotifier>(context);
    ProductAttributeNotifier productAttributeNotifier =
        Provider.of<ProductAttributeNotifier>(context);
    ProductCatalogNotifier productCatalogNotifier =
        Provider.of<ProductCatalogNotifier>(context);
    CategoryCatalogNotifier categoryCatalogNotifier =
        Provider.of<CategoryCatalogNotifier>(context);
    ShopCategoryNotifier shopCategoryNotifier =
        Provider.of<ShopCategoryNotifier>(context);

    adjustMenu(context);
    getUserData(context);
    // cartNotifier.refresh();
    //nrProductinCart = cartNotifier.nrProductInCart;
    return Scaffold(
      body: Row(
        children: [
          SideNavigationBar(
            expandable: true,
            theme: SideNavigationBarTheme.blue(),
            // header: SideNavigationBarHeader(
            //     image: null,
            //     title: Text(
            //       '${cUserModel.name} ${cUserModel.surname}',
            //       style: const TextStyle(fontSize: 14, color: Colors.white),
            //     ),
            //     subtitle: Column(
            //       children: [
            //         Text(cUserModel.email,
            //             style:
            //                 const TextStyle(fontSize: 14, color: Colors.white)),
            //         Text(cSelectedUserAppInstitution.roleUserAppInstitution,
            //             style:
            //                 const TextStyle(fontSize: 14, color: Colors.white)),
            //       ],
            //     )),
            footer: SideNavigationBarFooter(
                label: Column(
              children: [
                Text(
                  '${cUserModel.name} ${cUserModel.surname}',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                Text(
                  cUserModel.email,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                Text(
                  cSelectedUserAppInstitution.roleUserAppInstitution,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ],
            )),
            selectedIndex: _selectedIndex,
            items: getSideNavigationBarItem(),
            onTap: (index) {
              setState(() {
                _selectedIndex = index;
              });
              if (destinations.elementAt(index).label == "Preferiti") {
                wishlistProductNotifier.refresh();
                // } else if (destinations.elementAt(index).label == "Progetti") {
                //   projectNotifier.refresh();
                // } else
              } else if (destinations.elementAt(index).label == "Shop") {
                shopCategoryNotifier.refresh();
              } else if (destinations.elementAt(index).label == "Carrello") {
                cartNotifier.refresh();
              } else if (destinations.elementAt(index).label ==
                  "Attributi prodotti") {
                productAttributeNotifier.refresh();
              } else if (destinations.elementAt(index).label ==
                  "Catalogo prodotti") {
                productCatalogNotifier.refresh();
              } else if (destinations.elementAt(index).label ==
                  "Catalogo categorie") {
                categoryCatalogNotifier.refresh();
              } else if (destinations.elementAt(index).label == "Uscita") {
                signOut(context);
              }
            },
          ),
          Expanded(
            child: LazyIndexedStack(
                index: _selectedIndex, children: getScreenNavigationBarItem()),
          ),
        ],
      ),
    );
  }
}

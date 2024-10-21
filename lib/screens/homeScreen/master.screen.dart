import 'package:flutter/material.dart';
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
import 'package:np_casse/core/notifiers/report.notifier.dart';
import 'package:np_casse/core/notifiers/shop.category.notifier.dart';
import 'package:np_casse/core/notifiers/wishlist.product.notifier.dart';
import 'package:np_casse/screens/reportScreen/cart.history.screen.dart';
import 'package:np_casse/screens/reportScreen/cart.history.navigator.dart';
import 'package:np_casse/screens/cartScreen/cart.navigator.dart';
import 'package:np_casse/screens/categoryCatalogScreen/category.catalog.navigator.dart';
import 'package:np_casse/screens/institutionScreen/institution.view.dart';
import 'package:np_casse/screens/loginScreen/logout.view.dart';
import 'package:np_casse/screens/productAttributeScreen/product.attribute.navigator.dart';
import 'package:np_casse/screens/productCatalogScreen/product.catalog.navigator.dart';
import 'package:np_casse/screens/reportScreen/product.history.navigator.dart';
import 'package:np_casse/screens/settingScreen/setting.screen.dart';
import 'package:np_casse/screens/shopScreen/shop.navigator.dart';
import 'package:np_casse/screens/userScreen/user.screen.dart';
import 'package:np_casse/screens/wishlistScreen/wishlist.screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_lazy_indexed_stack/flutter_lazy_indexed_stack.dart';

class MenuList {
  MenuList(
    this.screenRoute,
    this.label,
    this.icon,
    this.selectedIcon,
    this.screen, {
    this.isVisible = true,
    this.subMenus,
  });

  String screenRoute;
  String label;
  IconData icon;
  Widget selectedIcon;
  Widget screen;
  bool isVisible; // Property to control visibility
  List<MenuList>? subMenus; // Property for submenus
}

List<MenuList> destinations = <MenuList>[
  MenuList(AppRouter.wishListRoute, 'Preferiti', Icons.favorite_outlined,
      const Icon(Icons.favorite), const WishlistScreen()),
  MenuList(AppRouter.categoryOneShopRoute, 'Shop', Icons.shop,
      const Icon(Icons.layers), const ShopNavigator()),
  MenuList(AppRouter.cartRoute, 'Carrello', Icons.shopping_cart_outlined,
      const Icon(Icons.shopping_cart), const CartNavigator()),
  MenuList(AppRouter.settingRoute, 'Attributi prodotti', Icons.article_outlined,
      const Icon(Icons.settings), const ProductAttributeNavigator()),
  MenuList(AppRouter.settingRoute, 'Catalogo categorie', Icons.book,
      const Icon(Icons.settings), const CategoryCatalogNavigator()),
  MenuList(AppRouter.settingRoute, 'Catalogo prodotti', Icons.store,
      const Icon(Icons.settings), const ProductCatalogNavigator()),
  MenuList(
    '',
    'Impostazioni',
    Icons.settings,
    const Icon(Icons.settings),
    Placeholder(),
    subMenus: [
      MenuList(
          AppRouter.institutionRoute,
          'Associazioni',
          Icons.settings_outlined,
          const Icon(Icons.settings),
          const InstitutionScreen()),
      MenuList(AppRouter.userRoute, 'Utente', Icons.account_circle,
          const Icon(Icons.account_circle), const UserScreeen()),
      MenuList(AppRouter.settingRoute, 'Impostazioni', Icons.store,
          const Icon(Icons.settings), const SettingScreen()),
    ],
  ),
  MenuList(
    '',
    'Report',
    Icons.dashboard,
    const Icon(Icons.dashboard),
    Placeholder(),
    subMenus: [
      MenuList(AppRouter.institutionRoute, 'Carrelli', Icons.dashboard,
          const Icon(Icons.dashboard), const CartHistoryNavigator()),
      MenuList(AppRouter.institutionRoute, 'Prodotti', Icons.dashboard,
          const Icon(Icons.dashboard), const ProductHistoryNavigator()),
    ],
  ),
  MenuList(AppRouter.logoutRoute, 'Uscita', Icons.logout_outlined,
      const Icon(Icons.logout), const LogoutScreen()),
];

class MasterScreen extends StatefulWidget {
  const MasterScreen({super.key});

  @override
  State<MasterScreen> createState() => _MasterScreenState();
}

class _MasterScreenState extends State<MasterScreen> {
  int _selectedMainMenuIndex = 0; // Track selected main menu index
  int? _selectedSubMenuIndex; // Track selected submenu index
  List<MenuList> currentDestinations = [];
  Set<int> visibleSubMenus = {}; // Track visible submenus by main menu index
  Widget? _currentScreen; // Track the current screen to display
  UserModel? cUserModel; // Make this nullable initially
  UserAppInstitutionModel? cSelectedUserAppInstitution;

  signOut(BuildContext context) {
    AuthenticationNotifier authenticationNotifier =
        Provider.of<AuthenticationNotifier>(context, listen: false);
    authenticationNotifier.userLogout(context);
  }

  @override
  void initState() {
    super.initState();
    getUserData(); // Fetch user data when the screen is initialized
    _currentScreen =
        destinations[_selectedMainMenuIndex].screen; // Set the initial screen
  }

  void getUserData() {
    AuthenticationNotifier authenticationNotifier =
        Provider.of<AuthenticationNotifier>(context, listen: false);

    // Fetch the user and institution models
    setState(() {
      cUserModel = authenticationNotifier.getUser();
      cSelectedUserAppInstitution =
          authenticationNotifier.getSelectedUserAppInstitution();
    });
  }

  void handleMenuTap(int index) {
    setState(() {
      final menu = currentDestinations[index];

      if (menu.label == 'Uscita') {
        signOut(context);
        return;
      }

      // Check if the selected menu has submenus
      if (menu.subMenus != null && menu.subMenus!.isNotEmpty) {
        visibleSubMenus.clear(); // Clear submenus
        visibleSubMenus.add(index);
        _selectedMainMenuIndex = index; // Set the selected main menu index
        _selectedSubMenuIndex = 0; // Clear any previously selected submenu
      } else {
        // If no submenu, clear the submenu selection and set the main screen
        _selectedMainMenuIndex = index;
        _selectedSubMenuIndex = null;
        visibleSubMenus.clear(); // Clear submenus
        _currentScreen = menu.screen;
      }
    });
  }

  void handleSubMenuTap(int mainMenuIndex, int subMenuIndex) {
    setState(() {
      // Update both main and submenu indices only if they are different
      if (_selectedMainMenuIndex != mainMenuIndex ||
          _selectedSubMenuIndex != subMenuIndex) {
        _selectedMainMenuIndex = mainMenuIndex;
        _selectedSubMenuIndex = subMenuIndex;
        _currentScreen =
            currentDestinations[mainMenuIndex].subMenus![subMenuIndex].screen;
      }
    });
  }

  List<SideNavigationBarItem> getSideNavigationBarItems(BuildContext context) {
    currentDestinations = destinations.where((menu) => menu.isVisible).toList();
    List<SideNavigationBarItem> items = [];

    // Iterate over main menu items
    for (int i = 0; i < currentDestinations.length; i++) {
      final menu = currentDestinations[i];

      // Add main menu item
      items.add(SideNavigationBarItem(
        icon: menu.icon,
        label: menu.label,
      ));

      // Add submenu items if they are visible
      if (visibleSubMenus.contains(i) && menu.subMenus != null) {
        for (int j = 0; j < menu.subMenus!.length; j++) {
          items.add(SideNavigationBarItem(
            icon: menu.subMenus![j].icon,
            label: menu.subMenus![j].label,
            margin: const EdgeInsets.only(
                left: 16.0), // Add left margin to submenu items
          ));
        }
      }
    }

    return items;
  }

  // Calculate selected index based on main and submenu indices
  int calculateSelectedIndex() {
    int selectedIndex = _selectedMainMenuIndex;
    int subMenuOffset = 0;

    // Calculate the offset based on the number of visible submenus in preceding main menus
    for (int i = 0; i < _selectedMainMenuIndex; i++) {
      if (currentDestinations[i].subMenus != null &&
          visibleSubMenus.contains(i)) {
        subMenuOffset += currentDestinations[i].subMenus!.length;
      }
    }

    // Adjust the index if a submenu is selected
    if (_selectedSubMenuIndex != null) {
      selectedIndex += subMenuOffset +
          _selectedSubMenuIndex! +
          1; // +1 for the main menu itself
    } else {
      selectedIndex += subMenuOffset;
    }

    return selectedIndex;
  }

  Widget getSelectedScreen() {
    // If a submenu is selected, return the submenu screen; otherwise return the selected screen
    if (_selectedSubMenuIndex != null) {
      return currentDestinations[_selectedMainMenuIndex]
          .subMenus![_selectedSubMenuIndex!]
          .screen;
    }
    return _currentScreen!; // Return the selected screen
  }

  @override
  Widget build(BuildContext context) {
    AuthenticationNotifier authenticationNotifier =
        Provider.of<AuthenticationNotifier>(context, listen: true);
    cUserModel = authenticationNotifier.getUser();
    cSelectedUserAppInstitution =
        authenticationNotifier.getSelectedUserAppInstitution();

    // Display a loading state while data is being fetched
    if (cUserModel == null || cSelectedUserAppInstitution == null) {
      return const Center(
          child:
              CircularProgressIndicator()); // Show loading spinner until data is available
    }

    CartNotifier cartNotifier = Provider.of<CartNotifier>(context);
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
    ReportNotifier reportNotifier = Provider.of<ReportNotifier>(context);

    return Scaffold(
      body: Row(
        children: [
          // Sidebar for main navigation
          SideNavigationBar(
            expandable: true,
            theme: SideNavigationBarTheme.blue(),
            footer: SideNavigationBarFooter(
              label: Column(
                children: [
                  Text(
                    '${cUserModel!.name} ${cUserModel!.surname}', // Safely unwrap nullable values
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  Text(
                    cUserModel!.email, // Safely unwrap nullable value
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  Text(
                    cSelectedUserAppInstitution!
                        .roleUserAppInstitution, // Safely unwrap
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  Text(
                    cSelectedUserAppInstitution!.idInstitutionNavigation
                        .nameInstitution, // Safely unwrap
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ],
              ),
            ),
            selectedIndex: calculateSelectedIndex(),
            items: getSideNavigationBarItems(context),
            onTap: (index) {
              int currentIndex = 0;

              for (int i = 0; i < currentDestinations.length; i++) {
                final menu = currentDestinations[i];
                if (menu.label == "Preferiti") {
                  wishlistProductNotifier.refresh();
                } else if (menu.label == "Shop") {
                  shopCategoryNotifier.refresh();
                } else if (menu.label == "Carrello") {
                  cartNotifier.refresh();
                } else if (menu.label == "Attributi prodotti") {
                  productAttributeNotifier.refresh();
                } else if (menu.label == "Catalogo prodotti") {
                  productCatalogNotifier.refresh();
                } else if (menu.label == "Catalogo categorie") {
                  categoryCatalogNotifier.refresh();
                }
                if (currentIndex == index) {
                  handleMenuTap(i);
                  return;
                }

                currentIndex++;

                if (visibleSubMenus.contains(i) && menu.subMenus != null) {
                  for (int j = 0; j < menu.subMenus!.length; j++) {
                    if (menu.subMenus![j].label == "Carrelli") {
                      reportNotifier.refresh();
                    }
                    if (currentIndex == index) {
                      handleSubMenuTap(i, j);
                      return;
                    }
                    currentIndex++;
                  }
                }
              }
            },
          ),

          // Expanded area to display the selected content
          Expanded(
            flex: 5,
            child: LazyIndexedStack(
              index: _selectedMainMenuIndex, // The main menu index
              children: currentDestinations.map((menu) {
                if (menu.subMenus != null &&
                    visibleSubMenus.contains(_selectedMainMenuIndex)) {
                  // Use LazyIndexedStack for the sub-menu screens
                  return LazyIndexedStack(
                    index: _selectedSubMenuIndex ??
                        0, // Default to the first submenu if none is selected
                    children: menu.subMenus!.map((submenu) {
                      return submenu.screen;
                    }).toList(),
                  );
                }
                // If no submenu is selected, return the main menu screen
                return menu.screen;
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

// void adjustMenu(BuildContext context) {
//   AuthenticationNotifier authenticationNotifier =
//       Provider.of<AuthenticationNotifier>(context);

//   int nrAssociazioni = authenticationNotifier.getNumberUserAppInstitution();

//   if (nrAssociazioni == 1) {
//     destinations.removeWhere((element) => element.label == "Associazioni");
//   }
//   // destinations.removeWhere((element) => element.label == "Impostazioni");
//   // destinations.removeWhere((element) => element.label == "Utente");
// }

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

// adjustMenu(context);
// getUserData(context);
// if (1 == 1) {
//   setState(() {});
// }
// cartNotifier.refresh();
// nrProductinCart = cartNotifier.nrProductInCart;

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

import 'package:flutter/material.dart';
import 'package:idle_detector_wrapper/idle_detector_wrapper.dart';
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
import 'package:np_casse/core/notifiers/shop.navigate.notifier.dart';
import 'package:np_casse/core/notifiers/shop.search.notifier.dart';
import 'package:np_casse/core/notifiers/wishlist.product.notifier.dart';
import 'package:np_casse/screens/reportScreen/cart.history.navigator.dart';
import 'package:np_casse/screens/cartScreen/cart.navigator.dart';
import 'package:np_casse/screens/categoryCatalogScreen/category.catalog.navigator.dart';
import 'package:np_casse/screens/institutionScreen/institution.view.dart';
import 'package:np_casse/screens/loginScreen/logout.view.dart';
import 'package:np_casse/screens/productAttributeScreen/product.attribute.navigator.dart';
import 'package:np_casse/screens/productCatalogScreen/product.catalog.navigator.dart';
import 'package:np_casse/screens/reportScreen/cart.history.screen.dart';
import 'package:np_casse/screens/reportScreen/product.history.navigator.dart';
import 'package:np_casse/screens/settingScreen/bluetooth.configuration.screen.dart';
import 'package:np_casse/screens/settingScreen/institution.setting.screen.dart';
import 'package:np_casse/screens/shopScreen/product.search.screen.dart';
import 'package:np_casse/screens/shopScreen/shop.navigator.dart';
import 'package:np_casse/screens/settingScreen/user.setting.screen.dart';
import 'package:np_casse/screens/wishlistScreen/wishlist.screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_lazy_indexed_stack/flutter_lazy_indexed_stack.dart';

class MenuList {
  MenuList(
    this.screenRoute,
    this.label,
    this.icon,
    this.selectedIcon,
    this.screen,
    this.intGrant, {
    this.subMenus,
  });

  String screenRoute;
  String label;
  IconData icon;
  Widget selectedIcon;
  Widget screen;
  int intGrant; // Property to control grant
  List<MenuList>? subMenus; // Property for submenus

  static int calculateGrant(String userGrant) {
    if (userGrant == 'User') {
      return 1;
    } else if (userGrant == 'InstitutionAdmin') {
      return 2;
    } else if (userGrant == 'Admin') {
      return 3;
    } else {
      return 0;
    }
  }
}

List<MenuList> destinations = <MenuList>[
  MenuList(AppRouter.wishListRoute, 'Preferiti', Icons.favorite_outlined,
      const Icon(Icons.favorite_outlined), const WishlistScreen(), 1),
  // MenuList(
  //   '',
  //   'Shop',
  //   Icons.shop,
  //   const Icon(Icons.shop),
  //   const Placeholder(),
  //   1,
  //   subMenus: [],
  // ),
  MenuList(AppRouter.categoryOneShopRoute, 'Naviga shop', Icons.shop,
      const Icon(Icons.shop), const ShopNavigator(), 1),
  MenuList(AppRouter.userRoute, 'Ricerca shop', Icons.search,
      const Icon(Icons.search), const ProductSearchScreen(), 1),
  MenuList(AppRouter.cartRoute, 'Carrello', Icons.shopping_cart,
      const Icon(Icons.shopping_cart), const CartNavigator(), 1),
  MenuList(AppRouter.settingRoute, 'Attributi prodotti', Icons.article_outlined,
      const Icon(Icons.article_outlined), const ProductAttributeNavigator(), 2),
  MenuList(AppRouter.settingRoute, 'Catalogo categorie', Icons.book,
      const Icon(Icons.book), const CategoryCatalogNavigator(), 2),
  MenuList(AppRouter.settingRoute, 'Catalogo prodotti', Icons.store,
      const Icon(Icons.store), const ProductCatalogNavigator(), 2),
  // MenuList(
  //   '',
  //   'Impostazioni',
  //   Icons.settings,
  //   const Icon(Icons.settings),
  //   Placeholder(),
  //   1,
  //   subMenus: [],
  // ),

  MenuList(AppRouter.userRoute, 'Impostazioni utente', Icons.account_circle,
      const Icon(Icons.account_circle), const UserSettingScreen(), 1),
  MenuList(AppRouter.settingRoute, 'Impostazioni ente', Icons.settings,
      const Icon(Icons.settings), const InstitutionSettingScreen(), 2),
  // MenuList(AppRouter.settingRoute, 'Generali', Icons.settings,
  //     const Icon(Icons.settings), const BluetoothConfigurationScreen(), 2),

  // MenuList(
  //   '',
  //   'Report',
  //   Icons.dashboard,
  //   const Icon(Icons.dashboard),
  //   Placeholder(),
  //   1,
  //   subMenus: [],
  // ),
  MenuList(AppRouter.institutionRoute, 'Report acquisti', Icons.dashboard,
      const Icon(Icons.dashboard), const CartHistoryNavigator(), 1),
  MenuList(AppRouter.institutionRoute, 'Report prodotti', Icons.dashboard,
      const Icon(Icons.dashboard), const ProductHistoryNavigator(), 1),
  MenuList(AppRouter.institutionRoute, 'Associazioni', Icons.settings_outlined,
      const Icon(Icons.settings_outlined), const InstitutionScreen(), 1),
  MenuList(AppRouter.logoutRoute, 'Uscita', Icons.logout_outlined,
      const Icon(Icons.logout), const LogoutScreen(), 1),
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
  UserAppInstitutionModel?
      previousSelectedInstitution; // Previous institution value

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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    AuthenticationNotifier authenticationNotifier =
        Provider.of<AuthenticationNotifier>(context, listen: true);
    UserAppInstitutionModel? currentInstitution =
        authenticationNotifier.getSelectedUserAppInstitution();

    // Check if the institution has changed
    if (currentInstitution != previousSelectedInstitution) {
      setState(() {
        cSelectedUserAppInstitution = currentInstitution;
        previousSelectedInstitution =
            currentInstitution; // Update previous value
        _selectedMainMenuIndex = 0; // Reset selected index to 0
        _selectedSubMenuIndex = null;
        visibleSubMenus.clear(); // Reset visible submenus
        resetNavigators();
        // recalculateMenu();
      });
    }
  }

  void recalculateMenu() {
    int currentIntGrant = MenuList.calculateGrant(
        cSelectedUserAppInstitution!.roleUserAppInstitution);
    currentDestinations = filterDestinations(currentIntGrant);
  }

  List<MenuList> filterDestinations(int currentIntGrant) {
    return destinations.where((menu) {
      return menu.intGrant <= currentIntGrant;
    }).map((menu) {
      if (menu.subMenus != null) {
        menu.subMenus = menu.subMenus!.where((submenu) {
          return submenu.intGrant <= currentIntGrant;
        }).toList();
      }
      return menu;
    }).toList();
  }

  void resetNavigators() {
    CartNavigatorKey.currentState?.popUntil((route) => route.isFirst);
    CategoryCatalogNavigatorKey.currentState
        ?.popUntil((route) => route.isFirst);
    ProductAttributeNavigatorKey.currentState
        ?.popUntil((route) => route.isFirst);
    ProductCatalogNavigatorKey.currentState?.popUntil((route) => route.isFirst);
    CartHistoryNavigatorKey.currentState?.popUntil((route) => route.isFirst);
    ShopNavigatorKey.currentState?.popUntil((route) => route.isFirst);
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
    AuthenticationNotifier authenticationNotifier =
        Provider.of<AuthenticationNotifier>(context, listen: true);
    UserAppInstitutionModel selectedUserAppInstitution =
        authenticationNotifier.getSelectedUserAppInstitution();
    int currentIntGrant = MenuList.calculateGrant(
        selectedUserAppInstitution.roleUserAppInstitution);

    currentDestinations =
        currentDestinations = filterDestinations(currentIntGrant);
    List<SideNavigationBarItem> items = [];

    // Iterate over main menu items and add items that match the user grant
    for (int i = 0; i < currentDestinations.length; i++) {
      final menu = currentDestinations[i];
      items.add(SideNavigationBarItem(
        icon: menu.icon,
        label: menu.label,
      ));

      // Add submenu items if they are visible and match the grant
      if (visibleSubMenus.contains(i) && menu.subMenus != null) {
        for (int j = 0; j < menu.subMenus!.length; j++) {
          items.add(SideNavigationBarItem(
            icon: menu.subMenus![j].icon,
            label: menu.subMenus![j].label,
            margin: const EdgeInsets.only(
                left: 16.0), // Add left margin for submenu items
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

    for (int i = 0; i < _selectedMainMenuIndex; i++) {
      if (currentDestinations[i].subMenus != null &&
          visibleSubMenus.contains(i)) {
        subMenuOffset += currentDestinations[i].subMenus!.length;
      }
    }

    if (_selectedSubMenuIndex != null &&
        currentDestinations[_selectedMainMenuIndex].subMenus != null &&
        _selectedSubMenuIndex! <
            currentDestinations[_selectedMainMenuIndex].subMenus!.length) {
      selectedIndex += subMenuOffset + _selectedSubMenuIndex! + 1;
    } else {
      selectedIndex += subMenuOffset;
    }

    return selectedIndex < getSideNavigationBarItems(context).length
        ? selectedIndex
        : 0; // Fallback to 0 if out of bounds
  }

  Widget getSelectedScreen() {
    if (_selectedSubMenuIndex != null &&
        _selectedMainMenuIndex < currentDestinations.length &&
        currentDestinations[_selectedMainMenuIndex].subMenus != null &&
        _selectedSubMenuIndex! <
            currentDestinations[_selectedMainMenuIndex].subMenus!.length) {
      return currentDestinations[_selectedMainMenuIndex]
          .subMenus![_selectedSubMenuIndex!]
          .screen;
    }
    return _currentScreen!;
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
    ShopNavigateNotifier shopNavigateNotifier =
        Provider.of<ShopNavigateNotifier>(context);
    ShopSearchNotifier shopSearchNotifier =
        Provider.of<ShopSearchNotifier>(context);

    // ShopCategoryNotifier shopCategoryNotifier =
    //     Provider.of<ShopCategoryNotifier>(context);
    ReportNotifier reportNotifier = Provider.of<ReportNotifier>(context);
    return IdleDetector(
      idleTime:
          Duration(minutes: int.tryParse(cUserModel!.userMaxInactivity) ?? 30),
      onIdle: () {
        signOut(context);
      },
      child: Scaffold(
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

                  if (currentIndex == index) {
                    if (menu.label == "Preferiti") {
                      wishlistProductNotifier.refresh();
                    } else if (menu.label == "Naviga shop") {
                      shopNavigateNotifier.refresh();
                    } else if (menu.label == "Ricerca shop") {
                      shopSearchNotifier.refresh();
                    } else if (menu.label == "Carrello") {
                      cartNotifier.refresh();
                    } else if (menu.label == "Attributi prodotti") {
                      productAttributeNotifier.refresh();
                    } else if (menu.label == "Catalogo prodotti") {
                      productCatalogNotifier.refresh();
                    } else if (menu.label == "Catalogo categorie") {
                      categoryCatalogNotifier.refresh();
                    } else if (menu.label == "Report acquisti") {
                      // reportNotifier.refresh();
                    } else if (menu.label == "Report prodotti") {
                      // reportNotifier.refresh();
                    }
                    handleMenuTap(i);
                    return;
                  }

                  currentIndex++;

                  // if (visibleSubMenus.contains(i) && menu.subMenus != null) {
                  //   for (int j = 0; j < menu.subMenus!.length; j++) {
                  //     if (currentIndex == index) {
                  //       if (menu.subMenus![j].label == "Carrelli") {
                  //         reportNotifier.refresh();
                  //       }
                  //       if (menu.subMenus![j].label == "Prodotti") {
                  //         reportNotifier.refresh();
                  //       }
                  //       handleSubMenuTap(i, j);
                  //       return;
                  //     }
                  //     currentIndex++;
                  //   }
                  // }
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
                    // Use IndexedStack for the sub-menu screens
                    return IndexedStack(
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

import 'package:flutter/material.dart';
import 'package:idle_detector_wrapper/idle_detector_wrapper.dart';
import 'package:np_casse/app/constants/assets.dart';
import 'package:np_casse/app/constants/colors.dart';
import 'package:np_casse/app/constants/keys.dart';
import 'package:np_casse/app/utilities/image_utils.dart';
import 'package:np_casse/core/models/user.app.institution.model.dart';
import 'package:np_casse/core/models/user.model.dart';
import 'package:np_casse/core/notifiers/authentication.notifier.dart';
import 'package:np_casse/core/notifiers/cart.notifier.dart';
import 'package:np_casse/core/notifiers/category.catalog.notifier.dart';
import 'package:np_casse/core/notifiers/comunication.notifier.dart';
import 'package:np_casse/core/notifiers/institution.attribute.institution.admin.notifier.dart';
import 'package:np_casse/core/notifiers/product.attribute.notifier.dart';
import 'package:np_casse/core/notifiers/product.catalog.notifier.dart';
import 'package:np_casse/core/notifiers/report.history.notifier.dart';
import 'package:np_casse/core/notifiers/report.product.notifier.dart';
import 'package:np_casse/core/notifiers/shop.navigate.notifier.dart';
import 'package:np_casse/core/notifiers/shop.search.notifier.dart';
import 'package:np_casse/core/notifiers/wishlist.product.notifier.dart';
import 'package:np_casse/screens/cartScreen/cart.navigator.dart';
import 'package:np_casse/screens/categoryCatalogScreen/category.catalog.navigator.dart';
import 'package:np_casse/screens/comunicationScreen/finalize.comunication.screen.dart';
import 'package:np_casse/screens/comunicationScreen/prepare.comunication.navigator.dart';
import 'package:np_casse/screens/institutionScreen/institution.view.dart';
import 'package:np_casse/screens/loginScreen/logout.view.dart';
import 'package:np_casse/screens/productAttributeScreen/product.attribute.navigator.dart';
import 'package:np_casse/screens/productCatalogScreen/product.catalog.navigator.dart';
import 'package:np_casse/screens/reportScreen/cart.history.navigator.dart';
import 'package:np_casse/screens/reportScreen/product.history.navigator.dart';
import 'package:np_casse/screens/settingScreen/institution.setting.screen.dart';
import 'package:np_casse/screens/settingScreen/user.setting.screen.dart';
import 'package:np_casse/screens/shopScreen/product.search.screen.dart';
import 'package:np_casse/screens/shopScreen/shop.navigator.dart';
import 'package:np_casse/screens/stakeholderScreen/stakeholder.navigator.screen.dart';
import 'package:np_casse/screens/wishlistScreen/wishlist.screen.dart';
import 'package:provider/provider.dart';

class MenuList {
  MenuList(
    this.label,
    this.icon,
    this.screen,
    this.intGrant,
    this.subMenus,
  );

  String label;
  IconData icon;
  Widget? screen;
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

class HomeScreen extends StatefulWidget {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedScreen = '';

  UserModel? cUserModel; // Make this nullable initially
  UserAppInstitutionModel? cSelectedUserAppInstitution;
  UserAppInstitutionModel?
      previousSelectedInstitution; // Previous institution value

  List<MenuList> destinations = <MenuList>[
    MenuList('Home', Icons.home, const Center(), 1, null),
    MenuList(
        'Preferiti', Icons.favorite_outlined, const WishlistScreen(), 1, null),
    MenuList('Shop', Icons.shop, null, 1, [
      MenuList('Naviga shop', Icons.navigation, const ShopNavigator(), 1, null),
      MenuList(
          'Ricerca shop', Icons.search, const ProductSearchScreen(), 1, null)
    ]),
    MenuList('Carrello', Icons.shopping_cart, const CartNavigator(), 1, null),
    MenuList('Cataloghi', Icons.book, null, 2, [
      MenuList('Attributi prodotti', Icons.article_outlined,
          const ProductAttributeNavigator(), 2, null),
      MenuList('Catalogo categorie', Icons.book,
          const CategoryCatalogNavigator(), 2, null),
      MenuList('Catalogo prodotti', Icons.store,
          const ProductCatalogNavigator(), 2, null),
    ]),
    MenuList('Donatori', Icons.people, const StakeholderNavigator(), 1, null),
    MenuList('Impostazioni', Icons.settings, null, 1, [
      MenuList('Impostazioni utente', Icons.settings, const UserSettingScreen(),
          1, null),
      MenuList('Impostazioni ente', Icons.settings,
          const InstitutionSettingScreen(), 2, null),
      // MenuList('Impostazioni amministratore', Icons.settings,
      //     const AdminSettingScreen(), 3, null),
    ]),
    MenuList('Comunicazioni', Icons.email, null, 3, [
      MenuList('Predisponi comunicazione', Icons.email,
          const PrepareComunicationNavigator(), 3, null),
      MenuList('Finalizza comunicazione', Icons.email,
          const FinalizeComunicationScreen(), 3, null),
      MenuList('Pianifica comunicazione', Icons.email,
          const PrepareComunicationNavigator(), 3, null),
    ]),
    MenuList('Report', Icons.dashboard, null, 1, [
      MenuList('Report acquisti', Icons.dashboard, const CartHistoryNavigator(),
          1, null),
      MenuList('Report prodotti', Icons.dashboard,
          const ProductHistoryNavigator(), 1, null),
    ]),
    MenuList('Associazioni', Icons.settings_outlined, const InstitutionScreen(),
        1, null),
    MenuList('Uscita', Icons.logout, const LogoutScreen(), 1, null),
  ];

  void _onItemTapped(String subMenu) {
    if (subMenu == 'Uscita') {
      signOut(context);
      return;
    }
    if (subMenu == "Preferiti") {
      WishlistProductNotifier wishlistProductNotifier =
          Provider.of<WishlistProductNotifier>(context, listen: false);
      wishlistProductNotifier.refresh();
    } else if (subMenu == "Naviga shop") {
      ShopNavigateNotifier shopNavigateNotifier =
          Provider.of<ShopNavigateNotifier>(context, listen: false);
      shopNavigateNotifier.refresh();
    } else if (subMenu == "Ricerca shop") {
      ShopSearchNotifier shopSearchNotifier =
          Provider.of<ShopSearchNotifier>(context, listen: false);
      shopSearchNotifier.refresh();
    } else if (subMenu == "Carrello") {
      CartNotifier cartNotifier =
          Provider.of<CartNotifier>(context, listen: false);
      cartNotifier.refresh();
    } else if (subMenu == "Attributi prodotti") {
      ProductAttributeNotifier productAttributeNotifier =
          Provider.of<ProductAttributeNotifier>(context, listen: false);
      productAttributeNotifier.refresh();
    } else if (subMenu == "Catalogo prodotti") {
      ProductCatalogNotifier productCatalogNotifier =
          Provider.of<ProductCatalogNotifier>(context, listen: false);
      productCatalogNotifier.refresh();
    } else if (subMenu == "Catalogo categorie") {
      CategoryCatalogNotifier categoryCatalogNotifier =
          Provider.of<CategoryCatalogNotifier>(context, listen: false);
      categoryCatalogNotifier.refresh();
    } else if (subMenu == "Impostazioni ente") {
      InstitutionAttributeInstitutionAdminNotifier
          institutionAttributeInstitutionAdminNotifier =
          Provider.of<InstitutionAttributeInstitutionAdminNotifier>(context,
              listen: false);
      institutionAttributeInstitutionAdminNotifier.setUpdate(true);
    }
    // else if (subMenu == "Impostazioni amministratore") {
    //   InstitutionAttributeAdminNotifier institutionAttributeAdminNotifier =
    //       Provider.of<InstitutionAttributeAdminNotifier>(context,
    //           listen: false);
    //   institutionAttributeAdminNotifier.setUpdate(true);
    // }
    else if (subMenu == "Predisponi comunicazione") {
      ComunicationNotifier comunicationNotifier =
          Provider.of<ComunicationNotifier>(context, listen: false);
      comunicationNotifier.refresh();
    } else if (subMenu == "Report acquisti") {
      ReportCartNotifier reportCartNotifier =
          Provider.of<ReportCartNotifier>(context, listen: false);
      reportCartNotifier.setUpdate(true);
    } else if (subMenu == "Report prodotti") {
      ReportProductNotifier reportProductNotifier =
          Provider.of<ReportProductNotifier>(context, listen: false);
      reportProductNotifier.setUpdate(true);
    }
    setState(() {
      selectedScreen = subMenu;
    });
  }

  List<Widget> _generateMenuItems(bool popContext) {
    List<Widget> _items = [];
    AuthenticationNotifier authenticationNotifier =
        Provider.of<AuthenticationNotifier>(context, listen: false);
    int nrAssociazioni = authenticationNotifier.getNumberUserAppInstitution();
    int cGrant = MenuList.calculateGrant(
        cSelectedUserAppInstitution!.roleUserInstitution);
    List<MenuList> workingDestinations = destinations;
    if (nrAssociazioni == 1) {
      workingDestinations
          .removeWhere((element) => element.label == "Associazioni");
    }

    for (int i = 0; i < workingDestinations.length; i++) {
      var cDestinations = workingDestinations[i];
      if (cDestinations.intGrant <= cGrant) {
        if (cDestinations.subMenus != null) {
          _items.add(ExpansionTile(
            shape: Border(),
            iconColor: Theme.of(context).colorScheme.primary,
            collapsedIconColor: Theme.of(context).colorScheme.primary,
            title: Text(cDestinations.label,
                style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 10)),
            leading: Icon(cDestinations.icon),
            children:
                _generateSubMenuItems(cDestinations.subMenus!, popContext),
          ));
        } else if (cDestinations.subMenus == null) {
          _items.add(ListTile(
            iconColor: Theme.of(context).colorScheme.primary,
            title: Text(cDestinations.label,
                style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 10)),
            leading: Icon(cDestinations.icon),
            onTap: () {
              _onItemTapped(cDestinations.label);
              if (popContext) {
                Navigator.pop(context);
              }
            },
          ));
        }
      }
    }
    return _items;
  }

  List<Widget> _generateSubMenuItems(List<MenuList> subMenu, bool popContext) {
    List<Widget> _items = [];
    int cGrant = MenuList.calculateGrant(
        cSelectedUserAppInstitution!.roleUserInstitution);
    for (int i = 0; i < subMenu.length; i++) {
      var cDestinations = subMenu[i];
      if (cDestinations.intGrant <= cGrant) {
        _items.add(Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: ListTile(
            iconColor: Theme.of(context).colorScheme.primary,
            title: Text(cDestinations.label,
                style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 10)),
            leading: Icon(cDestinations.icon),
            onTap: () {
              _onItemTapped(cDestinations.label);
              if (popContext) {
                Navigator.pop(context);
              }
            },
          ),
        ));
      }
    }
    return _items;
  }

  Widget? findDestination(String selectedScreen) {
    for (int i = 0; i < destinations.length; i++) {
      if (destinations[i].label == selectedScreen) {
        return destinations[i].screen;
      } else {
        int lenghtSubMenu = destinations[i].subMenus == null
            ? 0
            : destinations[i].subMenus!.length;
        for (int j = 0; j < lenghtSubMenu; j++) {
          if (destinations[i].subMenus![j].label == selectedScreen) {
            return destinations[i].subMenus![j].screen;
          }
        }
      }
    }
    return Center();
  }

  signOut(BuildContext context) {
    AuthenticationNotifier authenticationNotifier =
        Provider.of<AuthenticationNotifier>(context, listen: false);
    authenticationNotifier.userLogout(context);
  }

  // void resetNavigators() {
  //   CartNavigatorKey.currentState?.popUntil((route) => route.isFirst);
  //   CategoryCatalogNavigatorKey.currentState
  //       ?.popUntil((route) => route.isFirst);
  //   ProductAttributeNavigatorKey.currentState
  //       ?.popUntil((route) => route.isFirst);
  //   ProductCatalogNavigatorKey.currentState?.popUntil((route) => route.isFirst);
  //   CartHistoryNavigatorKey.currentState?.popUntil((route) => route.isFirst);
  //   ProductHistoryNavigatorKey.currentState?.popUntil((route) => route.isFirst);
  //   ShopNavigatorKey.currentState?.popUntil((route) => route.isFirst);
  //   StakeholderNavigatorKey.currentState?.popUntil((route) => route.isFirst);
  // }

  getIconByRole(String roleUserInstitution) {
    if (roleUserInstitution == "InstitutionAdmin") {
      return Icon(Icons.group);
    } else if (roleUserInstitution == "User") {
      return Icon(Icons.person);
    } else if (roleUserInstitution == "Admin") {
      return Icon(Icons.admin_panel_settings_outlined);
    }
  }

  @override
  void initState() {
    super.initState();
    AuthenticationNotifier authenticationNotifier =
        Provider.of<AuthenticationNotifier>(context, listen: false);
    cUserModel = authenticationNotifier.getUser();
    cSelectedUserAppInstitution =
        authenticationNotifier.getSelectedUserAppInstitution();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    AuthenticationNotifier authenticationNotifier =
        Provider.of<AuthenticationNotifier>(context, listen: true);
    UserAppInstitutionModel? currentInstitution =
        authenticationNotifier.getSelectedUserAppInstitution();

    if (currentInstitution != previousSelectedInstitution) {
      setState(() {
        cSelectedUserAppInstitution = currentInstitution;
        previousSelectedInstitution = currentInstitution;
        // resetNavigators();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return IdleDetector(
      idleTime:
          Duration(minutes: int.tryParse(cUserModel!.userMaxInactivity) ?? 30),
      onIdle: () {
        signOut(context);
      },
      child: LayoutBuilder(builder: (context, constraints) {
        double width = constraints.maxWidth;
        if (width <= 800) {
          return Scaffold(
            appBar: AppBar(),
            drawer: getDrawer(),
            body: Center(
              child: findDestination(selectedScreen),
            ),
          );
        } else {
          return Scaffold(
            body: Row(
              children: [
                getDrawer(),
                SizedBox(
                  width: width - 200,
                  child: findDestination(selectedScreen),
                ),
              ],
            ),
          );
        }
      }),
    );
  }

  getDrawer() {
    return Drawer(
      width: 200,
      shape: const RoundedRectangleBorder(
        borderRadius:
            BorderRadius.only(topRight: Radius.zero, bottomRight: Radius.zero),
      ),
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            margin: EdgeInsets.all(0),
            accountName: Text(
              cSelectedUserAppInstitution!
                  .idInstitutionNavigation.nameInstitution,
              style: TextStyle(color: CustomColors.darkBlue, fontSize: 10),
            ),
            accountEmail: Text(cUserModel!.email,
                style: TextStyle(color: CustomColors.darkBlue, fontSize: 10)),
            // currentAccountPicture: CircleAvatar(
            //     backgroundImage: AssetImage(AppAssets.splashImage)
            //     // NetworkImage(
            //     //     "https://appmaking.co/wp-content/uploads/2021/08/appmaking-logo-colored.png"),
            //     ),
            // decoration: BoxDecoration(

            //     // image: DecorationImage(
            //     //   image: Image.network(cSelectedUserAppInstitution != null
            //     //           ? cSelectedUserAppInstitution!
            //     //               .idInstitutionNavigation.urlLogoInstitution
            //     //           : '')
            //     //       .image,

            //     //   //AssetImage(AppAssets.splashImage),

            //     //   // NetworkImage(
            //     //   //   "https://appmaking.co/wp-content/uploads/2021/08/android-drawer-bg.jpeg",
            //     //   // ),
            //     //   fit: BoxFit.fill,
            //     // ),
            //     ),
            currentAccountPicture: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: (ImageUtils.getImageFromStringBase64ForLogo(
                          stringImage: cSelectedUserAppInstitution!
                              .idInstitutionNavigation.logoInstitution)
                      .image),
                  // image: NetworkImage(cSelectedUserAppInstitution != null
                  //     ? cSelectedUserAppInstitution!
                  //         .idInstitutionNavigation.urlLogoInstitution
                  //     : ''),
                  fit: BoxFit.contain,
                ),
              ),
              child: null,
            ),
            // currentAccountPicture: CircleAvatar(
            //   backgroundImage: NetworkImage(cSelectedUserAppInstitution != null
            //       ? cSelectedUserAppInstitution!
            //           .idInstitutionNavigation.urlLogoInstitution
            //       : ''),
            //   radius: 40,
            // ),

            otherAccountsPictures: [
              CircleAvatar(
                backgroundColor: CustomColors.darkBlue,
                child: getIconByRole(
                    cSelectedUserAppInstitution!.roleUserInstitution),
              ),
              // CircleAvatar(
              //   backgroundColor: Colors.white,
              //   backgroundImage: NetworkImage(
              //       "https://randomuser.me/api/portraits/men/47.jpg"),
              // ),
            ],
          ),
          Expanded(
            child: Container(
                color: CustomColors.darkBlue,
                child: ListView(
                    padding: EdgeInsets.all(0),
                    children: _generateMenuItems(false))),
          ),
          Container(
            width: 200,
            color: CustomColors.darkBlue,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Image(
                        image: AssetImage(AppAssets.logoGivePro_scritta_lato),
                        fit: BoxFit.fill,
                        // height: 50,
                        width: 100,
                        alignment: Alignment.center),
                    Text('(' + AppKeys.version + ')',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.primary)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

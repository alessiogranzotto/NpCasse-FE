import 'package:flutter/material.dart';
import 'package:np_casse/core/notifiers/authentication.notifier.dart';
import 'package:np_casse/core/notifiers/cart.notifier.dart';
import 'package:np_casse/core/notifiers/home.notifier.dart';
import 'package:np_casse/core/notifiers/project.notifier.dart';
import 'package:np_casse/core/notifiers/wishlist.product.notifier.dart';
import 'package:np_casse/screens/cartScreen/cart.screen.dart';
import 'package:np_casse/screens/wishlistScreen/wishlist.screen.dart';
import 'package:np_casse/screens/loginScreen/logout.view.dart';
import 'package:np_casse/screens/projectScreen/project.screen.dart';
import 'package:np_casse/screens/userAppIinstitutionScreen/user.app.institution.screen.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:provider/provider.dart';

import 'package:np_casse/app/utilities/initial_context.dart';

class HomeScreenPersistent extends StatefulWidget {
  const HomeScreenPersistent({super.key});

  @override
  State<HomeScreenPersistent> createState() => _HomeScreenPersistentState();
}

class _HomeScreenPersistentState extends State<HomeScreenPersistent> {
  final PersistentTabController _controller =
      PersistentTabController(initialIndex: 0);

  int nrProductinCart = 0;
  
  @override
  void initState() {
    super.initState();
    //int nrProductinCart = 0;
    ContextKeeper().init(context);
  }

  bool getStateManagement(int index) {
    if (index == 2) {
      return false;
    } else {
      return true;
    }
  }

  var currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    CartNotifier cartNotifier = Provider.of<CartNotifier>(context);
    AuthenticationNotifier authenticationNotifier =
        Provider.of<AuthenticationNotifier>(context);
    ProjectNotifier projectNotifier = Provider.of<ProjectNotifier>(context);
    WishlistProductNotifier wishlistProductNotifier =
        Provider.of<WishlistProductNotifier>(context);

    HomeNotifier homeNotifier = Provider.of<HomeNotifier>(context);

    _controller.index = homeNotifier.getHomeIndex;
    int nrAssociazioni = authenticationNotifier.getNumberUserAppInstitution();

    List<Widget> buildScreens() {
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

    List<PersistentBottomNavBarItem> getNavBarsItems() {
      List<PersistentBottomNavBarItem> result = [];
      result.add(PersistentBottomNavBarItem(
          icon: const Icon(Icons.favorite),
          title: ("Preferiti"),
          activeColorPrimary: Theme.of(context).colorScheme.secondaryContainer,
          inactiveColorPrimary: Theme.of(context).hintColor));
      result.add(PersistentBottomNavBarItem(
          icon: const Icon(Icons.layers),
          title: ("Progetti"),
          activeColorPrimary: Theme.of(context).colorScheme.secondaryContainer,
          inactiveColorPrimary: Theme.of(context).hintColor));
      if (nrAssociazioni > 1) {
        result.add(PersistentBottomNavBarItem(
          icon: const Icon(Icons.assignment),
          title: ("Associazioni"),
          activeColorPrimary: Theme.of(context).colorScheme.secondaryContainer,
          inactiveColorPrimary: Theme.of(context).hintColor,
        ));
      }

      result.add(PersistentBottomNavBarItem(
        // icon: const Icon(Icons.shopping_cart),
        icon: Badge(
            label: Text(
              nrProductinCart.toString(),
              style: const TextStyle(fontSize: 12),
            ),
            child: const Icon(Icons.shopping_cart)),
        title: ("Carrello"),
        activeColorPrimary: Theme.of(context).colorScheme.secondaryContainer,
        inactiveColorPrimary: Theme.of(context).hintColor,
        // onPressed: (context) {
        //   cartNotifier.setFirstRoute();
        // },
      ));
      result.add(PersistentBottomNavBarItem(
        icon: const Icon(Icons.logout),
        title: ("Uscita"),
        activeColorPrimary: Theme.of(context).colorScheme.secondaryContainer,
        inactiveColorPrimary: Theme.of(context).hintColor,
        onPressed: (context) {
          authenticationNotifier.userLogout();
        },
      ));
      return result;

      // var xxx = navBarsItems().where((element) => element.title == "Carrello");
      // xxx.first.icon ==
      //     Badge(
      //         label: Text(nrProductinCart.toString()),
      //         child: const Icon(Icons.shopping_cart));
      // return navBarsItems();
    }

    return PersistentTabView(context,
        controller: _controller,
        screens: buildScreens(),
        items: getNavBarsItems(),
        confineInSafeArea: true,
        backgroundColor:
            Theme.of(context).colorScheme.primary, // Default is Colors.white.
        handleAndroidBackButtonPress: true, // Default is true.
        resizeToAvoidBottomInset:
            true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
        stateManagement: homeNotifier.getStateManagement,
        //getStateManagement(_controller.index)

        // Default is true.
        hideNavigationBarWhenKeyboardShows:
            true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
        decoration: NavBarDecoration(
          borderRadius: BorderRadius.circular(10.0),
          colorBehindNavBar: Theme.of(context).colorScheme.primary,
        ),
        popAllScreensOnTapOfSelectedTab: false,
        popActionScreens: PopActionScreensType.all,
        // popAllScreensOnTapAnyTabs: false,
        itemAnimationProperties: const ItemAnimationProperties(
          // Navigation Bar's items animation properties.
          duration: Duration(milliseconds: 1000),
          curve: Curves.ease,
        ),
        screenTransitionAnimation: const ScreenTransitionAnimation(
          // Screen transition animation on change of selected tab.
          animateTabTransition: true,
          curve: Curves.ease,
          duration: Duration(milliseconds: 1),
        ),
        navBarStyle: NavBarStyle.style3, onItemSelected: (int index) {
      setState(() {
        _controller.index = index;
        homeNotifier.setActualHomeIndex(index);
        homeNotifier.setStateManagementTrue();
        if (index == 0) {
          wishlistProductNotifier.refresh();
        } else if (index == 1) {
          projectNotifier.refresh();
        } else if (index == 2) {
          cartNotifier.refresh();
        } else if (index == 0) {}
        // cartNotifier.refresh();
        // nrProductinCart = cartNotifier.nrProductInCart;
      });
    });

    // return PersistentTabView(
    //   context,
    //   onItemSelected: (index) {
    //     setState(() {
    //       _controller.index = index;
    //     });
    //   },
    //   controller: _controller,
    //   screens: _buildScreens(),
    //   items: getNavBarsItems(),
    //   confineInSafeArea: true,
    //   backgroundColor: Colors.white,
    //   handleAndroidBackButtonPress: true,
    //   resizeToAvoidBottomInset: true,
    //   stateManagement: false,
    //   hideNavigationBarWhenKeyboardShows: true,
    //   decoration: NavBarDecoration(
    //     borderRadius: BorderRadius.circular(10.0),
    //     colorBehindNavBar: Colors.white,
    //   ),
    //   popAllScreensOnTapOfSelectedTab: true,
    //   popActionScreens: PopActionScreensType.all,
    //   itemAnimationProperties: const ItemAnimationProperties(
    //     duration: Duration(milliseconds: 200),
    //     curve: Curves.ease,
    //   ),
    //   screenTransitionAnimation: const ScreenTransitionAnimation(
    //     animateTabTransition: true,
    //     curve: Curves.ease,
    //     duration: Duration(milliseconds: 200),
    //   ),
    //   navBarStyle: NavBarStyle.style15,
    // );

    // return Scaffold(
    //     // backgroundColor: themeFlag ? AppColors.mirage : AppColors.creamColor,
    //     body: screens[currentIndex],
    //     // bottomNavigationBar: SalomonBottomBar(
    //     //   backgroundColor: Colors.blueAccent,
    //     //   selectedItemColor:
    //     //       themeFlag ? AppColors.rawSienna : const Color(0xff4B7191),
    //     //   unselectedItemColor: themeFlag ? Colors.white : const Color(0xff777777),
    //     //   currentIndex: currentIndex,
    //     //   onTap: (i) => setState(() => currentIndex = i),
    //     //   items: bottomNavBarIcons,
    //     // ),
    //     bottomNavigationBar: const CustomBottonNavigationBar()

    //     // BottomNavigationBar(
    //     //     selectedIconTheme:
    //     //         const IconThemeData(color: Colors.white, size: 32, opacity: 1),
    //     //     unselectedIconTheme: const IconThemeData(
    //     //         color: Colors.white, size: 32, opacity: 0.2),
    //     //     // iconSize: 40,
    //     //     items: bottomNavBar,
    //     //     backgroundColor: Colors.blueAccent,
    //     //     selectedItemColor: Colors.white,
    //     //     selectedFontSize: 16,
    //     //     unselectedFontSize: 16,
    //     //     unselectedItemColor: Colors.white,
    //     //     currentIndex: currentIndex,
    //     //     onTap: (int i) {
    //     //       setState(() => currentIndex = i);
    //     //       if (i == screens.length - 1) {
    //     //         // ScaffoldMessenger.of(context).showSnackBar(
    //     //         //   SnackUtil.stylishSnackBar(
    //     //         //       text: 'Password Changed , Please Login Again',
    //     //         //       context: context),
    //     //         // );
    //     //         DeleteCache.deleteKey(AppKeys.userData).whenComplete(() {
    //     //           Navigator.of(context)
    //     //               .pushReplacementNamed(AppRouter.loginRoute);
    //     //         });
    //     //       }
    //     //     })
    //     );
  }
}

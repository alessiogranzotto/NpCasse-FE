import 'package:flutter/material.dart';
import 'package:np_casse/app/routes/app_routes.dart';
import 'package:np_casse/core/notifiers/authentication.notifier.dart';
import 'package:np_casse/screens/shopScreen/category.one.shop.screen.dart';
import 'package:provider/provider.dart';

class ShopNavigator extends StatefulWidget {
  const ShopNavigator({super.key});

  @override
  ShopNavigatorState createState() => ShopNavigatorState();
}

GlobalKey<NavigatorState> ShopNavigatorKey = GlobalKey<NavigatorState>();

class ShopNavigatorState extends State<ShopNavigator> {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: ShopNavigatorKey,
      onGenerateRoute: (RouteSettings settings) {
        if (settings.name != "/") {
          return AppRouter.generateRoute(settings);
        }
        return MaterialPageRoute(
          settings: settings,
          builder: (BuildContext context) {
            return const CategoryOneShopScreen();
          },
        );

        // return null;
        // return MaterialPageRoute(
        //   settings: settings,
        //   builder: (BuildContext context) {
        //     if (settings.name == "/detailsProject") {
        //       return const ProjectDetailScreen();
        //     }
        //     return const ProjectScreen();
        //   },
        // );
      },
    );
  }
}

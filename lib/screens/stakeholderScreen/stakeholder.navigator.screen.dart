import 'package:flutter/material.dart';
import 'package:np_casse/app/routes/app_routes.dart';
import 'package:np_casse/core/notifiers/authentication.notifier.dart';
import 'package:np_casse/screens/cartScreen/sh.manage.screen.dart';
import 'package:np_casse/screens/shopScreen/category.one.shop.screen.dart';
import 'package:provider/provider.dart';

class StakeholderNavigator extends StatefulWidget {
  const StakeholderNavigator({super.key});

  @override
  StakeholderNavigatorState createState() => StakeholderNavigatorState();
}

GlobalKey<NavigatorState> StakeholderNavigatorKey = GlobalKey<NavigatorState>();

class StakeholderNavigatorState extends State<StakeholderNavigator> {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: StakeholderNavigatorKey,
      onGenerateRoute: (RouteSettings settings) {
        if (settings.name != "/") {
          return AppRouter.generateRoute(settings);
        }
        return MaterialPageRoute(
          settings: settings,
          builder: (BuildContext context) {
            return const ShManageScreen(
              idCart: 0,
            );
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

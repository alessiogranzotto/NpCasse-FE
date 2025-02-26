import 'package:flutter/material.dart';
import 'package:np_casse/app/routes/app_routes.dart';
import 'package:np_casse/screens/cartScreen/sh.givepro.manage.screen.dart';
import 'package:np_casse/screens/cartScreen/sh.manage.screen.dart';

class StakeholderGiveproNavigator extends StatefulWidget {
  const StakeholderGiveproNavigator({super.key});

  @override
  StakeholderGiveproNavigatorState createState() =>
      StakeholderGiveproNavigatorState();
}

GlobalKey<NavigatorState> StakeholderGiveproNavigatorKey =
    GlobalKey<NavigatorState>();

class StakeholderGiveproNavigatorState
    extends State<StakeholderGiveproNavigator> {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: StakeholderGiveproNavigatorKey,
      onGenerateRoute: (RouteSettings settings) {
        if (settings.name != "/") {
          return AppRouter.generateRoute(settings);
        }
        return MaterialPageRoute(
          settings: settings,
          builder: (BuildContext context) {
            return const ShGiveproManageScreen(
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

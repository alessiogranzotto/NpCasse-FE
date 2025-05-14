import 'package:flutter/material.dart';
import 'package:np_casse/app/routes/app_routes.dart';
import 'package:np_casse/screens/myosotisScreen/myosotis.donation.history.screen.dart';

class MyosotisDonationHistoryNavigator extends StatefulWidget {
  const MyosotisDonationHistoryNavigator({super.key});

  @override
  MyosotisDonationHistoryNavigatorState createState() =>
      MyosotisDonationHistoryNavigatorState();
}

GlobalKey<NavigatorState> MyosotisDonationHistoryNavigatorKey =
    GlobalKey<NavigatorState>();

class MyosotisDonationHistoryNavigatorState
    extends State<MyosotisDonationHistoryNavigator> {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: MyosotisDonationHistoryNavigatorKey,
      onGenerateRoute: (RouteSettings settings) {
        if (settings.name != "/") {
          return AppRouter.generateRoute(settings);
        }
        return MaterialPageRoute(
          settings: settings,
          builder: (BuildContext context) {
            return const MyosotisDonationHistoryScreen();
          },
        );
      },
    );
  }
}

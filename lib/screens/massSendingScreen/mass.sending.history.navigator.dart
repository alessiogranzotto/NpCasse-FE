import 'package:flutter/material.dart';
import 'package:np_casse/app/routes/app_routes.dart';
import 'package:np_casse/screens/reportScreen/cart.history.screen.dart';
import 'package:np_casse/screens/massSendingScreen/mass.sending.history.screen.dart';

class MassSendingHistoryNavigator extends StatefulWidget {
  const MassSendingHistoryNavigator({super.key});

  @override
  MassSendingHistoryNavigatorState createState() =>
      MassSendingHistoryNavigatorState();
}

GlobalKey<NavigatorState> MassSendingHistoryNavigatorKey =
    GlobalKey<NavigatorState>();

class MassSendingHistoryNavigatorState
    extends State<MassSendingHistoryNavigator> {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: MassSendingHistoryNavigatorKey,
      onGenerateRoute: (RouteSettings settings) {
        if (settings.name != "/") {
          return AppRouter.generateRoute(settings);
        }
        return MaterialPageRoute(
          settings: settings,
          builder: (BuildContext context) {
            return const MassSendingHistoryScreen();
          },
        );
      },
    );
  }
}

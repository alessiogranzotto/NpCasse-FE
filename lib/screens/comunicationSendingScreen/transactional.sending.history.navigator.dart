import 'package:flutter/material.dart';
import 'package:np_casse/app/routes/app_routes.dart';
import 'package:np_casse/screens/comunicationSendingScreen/transactional.sending.history.screen.dart';
import 'package:np_casse/screens/reportScreen/cart.history.screen.dart';
import 'package:np_casse/screens/comunicationSendingScreen/mass.sending.history.screen.dart';

class TransactionalSendingHistoryNavigator extends StatefulWidget {
  const TransactionalSendingHistoryNavigator({super.key});

  @override
  TransactionalSendingHistoryNavigatorState createState() =>
      TransactionalSendingHistoryNavigatorState();
}

GlobalKey<NavigatorState> TransactionalSendingHistoryNavigatorKey =
    GlobalKey<NavigatorState>();

class TransactionalSendingHistoryNavigatorState
    extends State<TransactionalSendingHistoryNavigator> {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: TransactionalSendingHistoryNavigatorKey,
      onGenerateRoute: (RouteSettings settings) {
        if (settings.name != "/") {
          return AppRouter.generateRoute(settings);
        }
        return MaterialPageRoute(
          settings: settings,
          builder: (BuildContext context) {
            return const TransactionalSendingHistoryScreen();
          },
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:np_casse/app/routes/app_routes.dart';
import 'package:np_casse/screens/comunicationSendingScreen/transactional.sending.screen.dart';

class TransactionalSendingNavigator extends StatefulWidget {
  const TransactionalSendingNavigator({super.key});

  @override
  TransactionalSendingNavigatorState createState() =>
      TransactionalSendingNavigatorState();
}

GlobalKey<NavigatorState> TransactionalSendingNavigatorKey =
    GlobalKey<NavigatorState>();

class TransactionalSendingNavigatorState
    extends State<TransactionalSendingNavigator> {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: TransactionalSendingNavigatorKey,
      onGenerateRoute: (RouteSettings settings) {
        if (settings.name != "/") {
          return AppRouter.generateRoute(settings);
        }
        return MaterialPageRoute(
          settings: settings,
          builder: (BuildContext context) {
            return const TransactionalSendingScreen();
          },
        );
      },
    );
  }
}

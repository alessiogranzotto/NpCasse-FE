import 'package:flutter/material.dart';
import 'package:np_casse/app/routes/app_routes.dart';
import 'package:np_casse/screens/reportScreen/cart.history.screen.dart';

class CartHistoryNavigator extends StatefulWidget {
  const CartHistoryNavigator({super.key});

  @override
  CartHistoryNavigatorState createState() => CartHistoryNavigatorState();
}

GlobalKey<NavigatorState> CartHistoryNavigatorKey = GlobalKey<NavigatorState>();

class CartHistoryNavigatorState extends State<CartHistoryNavigator> {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: CartHistoryNavigatorKey,
      onGenerateRoute: (RouteSettings settings) {
        if (settings.name != "/") {
          return AppRouter.generateRoute(settings);
        }
        return MaterialPageRoute(
          settings: settings,
          builder: (BuildContext context) {
            return const CartHistoryScreen();
          },
        );
      },
    );
  }
}

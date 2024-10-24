import 'package:flutter/material.dart';
import 'package:np_casse/app/routes/app_routes.dart';
import 'package:np_casse/screens/cartScreen/cart.screen.dart';

class CartNavigator extends StatefulWidget {
  const CartNavigator({super.key});

  @override
  CartNavigatorState createState() => CartNavigatorState();
}

GlobalKey<NavigatorState> CartNavigatorKey = GlobalKey<NavigatorState>();

class CartNavigatorState extends State<CartNavigator> {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: CartNavigatorKey,
      onGenerateRoute: (RouteSettings settings) {
        if (settings.name != "/") {
          return AppRouter.generateRoute(settings);
        }
        return MaterialPageRoute(
          settings: settings,
          builder: (BuildContext context) {
            return const CartScreen();
          },
        );
      },
    );
  }
}

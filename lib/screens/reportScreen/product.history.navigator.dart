import 'package:flutter/material.dart';
import 'package:np_casse/app/routes/app_routes.dart';
import 'package:np_casse/screens/reportScreen/product.history.screen.dart';

class ProductHistoryNavigator extends StatefulWidget {
  const ProductHistoryNavigator({super.key});

  @override
  ProductHistoryNavigatorState createState() => ProductHistoryNavigatorState();
}

GlobalKey<NavigatorState> ProductHistoryNavigatorKey =
    GlobalKey<NavigatorState>();

class ProductHistoryNavigatorState extends State<ProductHistoryNavigator> {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: ProductHistoryNavigatorKey,
      onGenerateRoute: (RouteSettings settings) {
        if (settings.name != "/") {
          return AppRouter.generateRoute(settings);
        }
        return MaterialPageRoute(
          settings: settings,
          builder: (BuildContext context) {
            return const ProductHistoryScreen();
          },
        );
      },
    );
  }
}

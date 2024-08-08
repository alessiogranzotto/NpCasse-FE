import 'package:flutter/material.dart';
import 'package:np_casse/app/routes/app_routes.dart';
import 'package:np_casse/screens/productAttributeScreen/productAttribute.screen.dart';

class ProductAttributeNavigator extends StatefulWidget {
  const ProductAttributeNavigator({super.key});

  @override
  ProductAttributeNavigatorState createState() =>
      ProductAttributeNavigatorState();
}

GlobalKey<NavigatorState> ProductAttributeNavigatorKey =
    GlobalKey<NavigatorState>();

class ProductAttributeNavigatorState extends State<ProductAttributeNavigator> {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: ProductAttributeNavigatorKey,
      onGenerateRoute: (RouteSettings settings) {
        if (settings.name != "/") {
          return AppRouter.generateRoute(settings);
        }
        return MaterialPageRoute(
          settings: settings,
          builder: (BuildContext context) {
            return const ProductAttributeScreen();
          },
        );
      },
    );
  }
}

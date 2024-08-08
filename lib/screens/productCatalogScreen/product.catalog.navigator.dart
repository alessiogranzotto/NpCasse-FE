import 'package:flutter/material.dart';
import 'package:np_casse/app/routes/app_routes.dart';
import 'package:np_casse/screens/productCatalogScreen/product.catalog.screen.dart';

class ProductCatalogNavigator extends StatefulWidget {
  const ProductCatalogNavigator({super.key});

  @override
  ProductCatalogNavigatorState createState() => ProductCatalogNavigatorState();
}

GlobalKey<NavigatorState> ProductCatalogNavigatorKey =
    GlobalKey<NavigatorState>();

class ProductCatalogNavigatorState extends State<ProductCatalogNavigator> {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: ProductCatalogNavigatorKey,
      onGenerateRoute: (RouteSettings settings) {
        if (settings.name != "/") {
          return AppRouter.generateRoute(settings);
        }
        return MaterialPageRoute(
          settings: settings,
          builder: (BuildContext context) {
            return const ProductCatalogScreen();
          },
        );
      },
    );
  }
}

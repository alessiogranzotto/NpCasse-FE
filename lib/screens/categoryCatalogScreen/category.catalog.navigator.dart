import 'package:flutter/material.dart';
import 'package:np_casse/app/routes/app_routes.dart';
import 'package:np_casse/screens/categoryCatalogScreen/category.catalog.screen.dart';

class CategoryCatalogNavigator extends StatefulWidget {
  const CategoryCatalogNavigator({super.key});

  @override
  CategoryCatalogNavigatorState createState() =>
      CategoryCatalogNavigatorState();
}

GlobalKey<NavigatorState> CategoryCatalogNavigatorKey =
    GlobalKey<NavigatorState>();

class CategoryCatalogNavigatorState extends State<CategoryCatalogNavigator> {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: CategoryCatalogNavigatorKey,
      onGenerateRoute: (RouteSettings settings) {
        if (settings.name != "/") {
          return AppRouter.generateRoute(settings);
        }
        return MaterialPageRoute(
          settings: settings,
          builder: (BuildContext context) {
            return const CategoryCatalogScreen();
          },
        );
      },
    );
  }
}

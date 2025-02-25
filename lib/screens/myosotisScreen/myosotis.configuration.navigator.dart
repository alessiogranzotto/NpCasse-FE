import 'package:flutter/material.dart';
import 'package:np_casse/app/routes/app_routes.dart';
import 'package:np_casse/screens/categoryCatalogScreen/category.catalog.screen.dart';
import 'package:np_casse/screens/myosotisScreen/myosotis.configuration.screen.dart';

class MyosotisConfigurationNavigator extends StatefulWidget {
  const MyosotisConfigurationNavigator({super.key});

  @override
  MyosotisConfigurationNavigatorState createState() =>
      MyosotisConfigurationNavigatorState();
}

GlobalKey<NavigatorState> MyosotisConfigurationnavigatorKey =
    GlobalKey<NavigatorState>();

class MyosotisConfigurationNavigatorState
    extends State<MyosotisConfigurationNavigator> {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: MyosotisConfigurationnavigatorKey,
      onGenerateRoute: (RouteSettings settings) {
        if (settings.name != "/") {
          return AppRouter.generateRoute(settings);
        }
        return MaterialPageRoute(
          settings: settings,
          builder: (BuildContext context) {
            return const MyosotisConfigurationScreen();
          },
        );
      },
    );
  }
}

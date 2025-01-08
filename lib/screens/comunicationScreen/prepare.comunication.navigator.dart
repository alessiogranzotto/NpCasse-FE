import 'package:flutter/material.dart';
import 'package:np_casse/app/routes/app_routes.dart';
import 'package:np_casse/screens/categoryCatalogScreen/category.catalog.screen.dart';
import 'package:np_casse/screens/comunicationScreen/prepare.comunication.screen.dart';

class PrepareComunicationNavigator extends StatefulWidget {
  const PrepareComunicationNavigator({super.key});

  @override
  PrepareComunicationNavigatorState createState() =>
      PrepareComunicationNavigatorState();
}

GlobalKey<NavigatorState> PrepareComunicationNavigatorKey =
    GlobalKey<NavigatorState>();

class PrepareComunicationNavigatorState
    extends State<PrepareComunicationNavigator> {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: PrepareComunicationNavigatorKey,
      onGenerateRoute: (RouteSettings settings) {
        if (settings.name != "/") {
          return AppRouter.generateRoute(settings);
        }
        return MaterialPageRoute(
          settings: settings,
          builder: (BuildContext context) {
            return const PrepareComunicationScreen();
          },
        );
      },
    );
  }
}

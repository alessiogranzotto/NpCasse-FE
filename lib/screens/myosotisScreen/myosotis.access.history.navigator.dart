import 'package:flutter/material.dart';
import 'package:np_casse/app/routes/app_routes.dart';
import 'package:np_casse/screens/myosotisScreen/myosotis.access.history.screen.dart';

class MyosotisAccessHistoryNavigator extends StatefulWidget {
  const MyosotisAccessHistoryNavigator({super.key});

  @override
  MyosotisAccessHistoryNavigatorState createState() =>
      MyosotisAccessHistoryNavigatorState();
}

GlobalKey<NavigatorState> MyosotisAccessHistoryNavigatorKey =
    GlobalKey<NavigatorState>();

class MyosotisAccessHistoryNavigatorState
    extends State<MyosotisAccessHistoryNavigator> {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: MyosotisAccessHistoryNavigatorKey,
      onGenerateRoute: (RouteSettings settings) {
        if (settings.name != "/") {
          return AppRouter.generateRoute(settings);
        }
        return MaterialPageRoute(
          settings: settings,
          builder: (BuildContext context) {
            return const MyosotisAccessHistoryScreen();
          },
        );
      },
    );
  }
}

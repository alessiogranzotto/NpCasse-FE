import 'package:flutter/material.dart';
import 'package:np_casse/app/routes/app_routes.dart';
import 'package:np_casse/screens/comunicationSendingScreen/mass.sending.screen.dart';

class MassSendingNavigator extends StatefulWidget {
  const MassSendingNavigator({super.key});

  @override
  MassSendingNavigatorState createState() => MassSendingNavigatorState();
}

GlobalKey<NavigatorState> MassSendingNavigatorKey = GlobalKey<NavigatorState>();

class MassSendingNavigatorState extends State<MassSendingNavigator> {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: MassSendingNavigatorKey,
      onGenerateRoute: (RouteSettings settings) {
        if (settings.name != "/") {
          return AppRouter.generateRoute(settings);
        }
        return MaterialPageRoute(
          settings: settings,
          builder: (BuildContext context) {
            return const MassSendingScreen();
          },
        );
      },
    );
  }
}

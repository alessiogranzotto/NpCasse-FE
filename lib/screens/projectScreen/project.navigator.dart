import 'package:flutter/material.dart';
import 'package:np_casse/app/routes/app_routes.dart';
import 'package:np_casse/screens/projectScreen/project.detail.screen.dart';
import 'package:np_casse/screens/projectScreen/project.screen.dart';

class ProjectNavigator extends StatefulWidget {
  const ProjectNavigator({super.key});

  @override
  ProjectNavigatorState createState() => ProjectNavigatorState();
}

GlobalKey<NavigatorState> projectNavigatorKey = GlobalKey<NavigatorState>();

class ProjectNavigatorState extends State<ProjectNavigator> {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: projectNavigatorKey,
      onGenerateRoute: (RouteSettings settings) {
        if (settings.name != "/") {
          return AppRouter.generateRoute(settings);
        }
        return MaterialPageRoute(
          settings: settings,
          builder: (BuildContext context) {
            return const ProjectScreen();
          },
        );

        // return null;
        // return MaterialPageRoute(
        //   settings: settings,
        //   builder: (BuildContext context) {
        //     if (settings.name == "/detailsProject") {
        //       return const ProjectDetailScreen();
        //     }
        //     return const ProjectScreen();
        //   },
        // );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:np_casse/app/routes/app_routes.dart';
import 'package:np_casse/screens/taskScreen/task.planned.screen.dart';

class TaskPlannedNavigator extends StatefulWidget {
  const TaskPlannedNavigator({super.key});

  @override
  TaskPlannedNavigatorState createState() => TaskPlannedNavigatorState();
}

GlobalKey<NavigatorState> TaskPlannedNavigatorKey = GlobalKey<NavigatorState>();

class TaskPlannedNavigatorState extends State<TaskPlannedNavigator> {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: TaskPlannedNavigatorKey,
      onGenerateRoute: (RouteSettings settings) {
        if (settings.name != "/") {
          return AppRouter.generateRoute(settings);
        }
        return MaterialPageRoute(
          settings: settings,
          builder: (BuildContext context) {
            return const TaskPlannedScreen();
          },
        );
      },
    );
  }
}

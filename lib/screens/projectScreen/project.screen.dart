import 'package:flutter/material.dart';
import 'package:np_casse/app/customized_component/sliver_grid_delegate_fixed_cross_axis_count_and_fixed_height.dart';
import 'package:np_casse/core/models/project.model.dart';
import 'package:np_casse/core/models/user.app.institution.model.dart';
import 'package:np_casse/core/notifiers/authentication.notifier.dart';
import 'package:np_casse/core/notifiers/project.notifier.dart';
import 'package:np_casse/screens/projectScreen/project.detail.screen.dart';
import 'package:np_casse/screens/projectScreen/widget/project.card.dart';
import 'package:np_casse/screens/storeScreen/store.screen.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:provider/provider.dart';

class ProjectScreen extends StatelessWidget {
  const ProjectScreen({super.key});

  final double widgetWitdh = 300;
  final double widgetRatio = 1;
  final double gridMainAxisSpacing = 10;

  @override
  Widget build(BuildContext context) {
    AuthenticationNotifier authenticationNotifier =
        Provider.of<AuthenticationNotifier>(context);

    UserAppInstitutionModel cUserAppInstitutionModel =
        authenticationNotifier.getSelectedUserAppInstitution();

    return SafeArea(
        child: Scaffold(
            backgroundColor: Theme.of(context).colorScheme.background,
            appBar: AppBar(
              title: Text(
                'Progetti ${cUserAppInstitutionModel.idInstitutionNavigation.nameInstitution}',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              actions: <Widget>[
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    PersistentNavBarNavigator.pushNewScreen(context,
                        screen: ProjectDetailScreen(
                          projectModelArgument: ProjectModel(
                              idProject: 0,
                              idUserAppInstitution:
                                  cUserAppInstitutionModel.idUserAppInstitution,
                              nameProject: '',
                              descriptionProject: '',
                              imageProject: ''),
                        ),
                        withNavBar: true,
                        pageTransitionAnimation: PageTransitionAnimation.fade);
                  },
                ),
              ],
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.8,
                  width: MediaQuery.of(context).size.width,
                  child: Consumer<ProjectNotifier>(
                    builder: (context, projectNotifier, _) {
                      return FutureBuilder(
                        future: projectNotifier.getProjects(
                            context: context,
                            token: authenticationNotifier.token,
                            idUserAppInstitution:
                                cUserAppInstitutionModel.idUserAppInstitution),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Center(
                                      child: SizedBox(
                                          width: 100,
                                          height: 100,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 5,
                                            color: Colors.redAccent,
                                          ))),
                                ],
                              ),
                            );
                          } else if (!snapshot.hasData) {
                            return const Center(
                              child: Text(
                                'No data...',
                                style: TextStyle(
                                  color: Colors.redAccent,
                                ),
                              ),
                            );
                          } else {
                            var tSnapshot = snapshot.data as List;
                            return GridView.builder(
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCountAndFixedHeight(
                                  crossAxisCount:
                                      (MediaQuery.of(context).size.width) ~/
                                          widgetWitdh,
                                  crossAxisSpacing: (((MediaQuery.of(context)
                                              .size
                                              .width) -
                                          (widgetWitdh *
                                              ((MediaQuery.of(context)
                                                      .size
                                                      .width) ~/
                                                  widgetWitdh))) /
                                      ((MediaQuery.of(context).size.width) ~/
                                          widgetWitdh)),
                                  mainAxisSpacing: gridMainAxisSpacing,
                                  height: widgetWitdh * widgetRatio,
                                ),
                                physics: const ScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: tSnapshot.length,
                                // scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  ProjectModel project = tSnapshot[index];
                                  return GestureDetector(
                                    onTap: () {
                                      projectNotifier.setProject(project);
                                      PersistentNavBarNavigator.pushNewScreen(
                                        context,
                                        screen: const StoreScreen(),
                                        withNavBar: true,
                                        pageTransitionAnimation:
                                            PageTransitionAnimation.fade,
                                      );
                                    },
                                    child: ProjectCard(
                                      project: project,
                                    ),
                                  );
                                });
                          }
                        },
                      );
                    },
                  ),
                ),
              ),
            )));
  }
}

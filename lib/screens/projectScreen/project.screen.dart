// import 'package:flutter/material.dart';
// import 'package:np_casse/app/customized_component/sliver_grid_delegate_fixed_cross_axis_count_and_fixed_height.dart';
// import 'package:np_casse/app/routes/app_routes.dart';
// import 'package:np_casse/core/models/give.id.flat.structure.model.dart';
// import 'package:np_casse/core/models/project.model.dart';
// import 'package:np_casse/core/models/user.app.institution.model.dart';
// import 'package:np_casse/core/notifiers/authentication.notifier.dart';
// import 'package:np_casse/core/notifiers/project.notifier.dart';
// import 'package:np_casse/screens/projectScreen/widget/project.card.dart';
// import 'package:provider/provider.dart';

// class ProjectScreen extends StatelessWidget {
//   const ProjectScreen({super.key});

//   final double widgetWitdh = 300;
//   final double widgetRatio = 1;
//   final double gridMainAxisSpacing = 10;

//   @override
//   Widget build(BuildContext context) {
//     AuthenticationNotifier authenticationNotifier =
//         Provider.of<AuthenticationNotifier>(context);

//     UserAppInstitutionModel cUserAppInstitutionModel =
//         authenticationNotifier.getSelectedUserAppInstitution();

//     bool canAddProject = authenticationNotifier.canUserAddItem();
//     //canAddProject = true;
//     // // Set the default number of columns to 3.
//     // int columnsCount = 3;
//     // // Define the icon size based on the screen width
//     // double iconSize = 45;

//     // // Use the ResponsiveUtils class to determine the device's screen size.
//     // if (ResponsiveUtils.isMobile(context)) {
//     //   columnsCount = 2;
//     //   iconSize = 30;
//     // } else if (ResponsiveUtils.isDesktop(context)) {
//     //   columnsCount = 4;
//     //   iconSize = 50;
//     // }
//     return Scaffold(
//         backgroundColor: Theme.of(context).colorScheme.background,
//         //drawer: const CustomDrawerWidget(),
//         appBar: AppBar(
//           centerTitle: true,
//           title: Text(
//             'Progetti ${cUserAppInstitutionModel.idInstitutionNavigation.nameInstitution}',
//             style: Theme.of(context).textTheme.headlineMedium,
//           ),
//         ),
//         body: SingleChildScrollView(
//           child: Padding(
//             padding: const EdgeInsets.all(16),
//             child: SizedBox(
//               height: MediaQuery.of(context).size.height * 0.8,
//               width: MediaQuery.of(context).size.width,
//               child: Consumer<ProjectNotifier>(
//                 builder: (context, projectNotifier, _) {
//                   return FutureBuilder(
//                     future: projectNotifier.getProjects(
//                         context: context,
//                         token: authenticationNotifier.token,
//                         idUserAppInstitution:
//                             cUserAppInstitutionModel.idUserAppInstitution),
//                     builder: (context, snapshot) {
//                       if (snapshot.connectionState == ConnectionState.waiting) {
//                         return const Center(
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: [
//                               Center(
//                                   child: SizedBox(
//                                       width: 100,
//                                       height: 100,
//                                       child: CircularProgressIndicator(
//                                         strokeWidth: 5,
//                                         color: Colors.redAccent,
//                                       ))),
//                             ],
//                           ),
//                         );
//                       } else if (!snapshot.hasData) {
//                         return const Center(
//                           child: Text(
//                             'No data...',
//                             style: TextStyle(
//                               color: Colors.redAccent,
//                             ),
//                           ),
//                         );
//                       } else {
//                         var tSnapshot = snapshot.data as List;

//                         return GridView.builder(
//                             gridDelegate:
//                                 SliverGridDelegateWithFixedCrossAxisCountAndFixedHeight(
//                               crossAxisCount:
//                                   (MediaQuery.of(context).size.width) ~/
//                                       widgetWitdh,
//                               crossAxisSpacing: 10,
//                               //     (((MediaQuery.of(context).size.width) -
//                               //             (widgetWitdh *
//                               //                 ((MediaQuery.of(context)
//                               //                         .size
//                               //                         .width) ~/
//                               //                     widgetWitdh))) /
//                               //         ((MediaQuery.of(context).size.width) ~/
//                               //             widgetWitdh)),
//                               mainAxisSpacing: gridMainAxisSpacing,
//                               height: 300,
//                             ),
//                             // gridDelegate:
//                             //     SliverGridDelegateWithFixedCrossAxisCount(
//                             //   // Set the number of columns based on the device's screen size.
//                             //   crossAxisCount: columnsCount,
//                             //   // Set the aspect ratio of each card.
//                             //   childAspectRatio: 3 / 2,
//                             //   crossAxisSpacing: 10,
//                             //   mainAxisSpacing: 10,
//                             // ),
//                             physics: const ScrollPhysics(),
//                             shrinkWrap: true,
//                             itemCount: tSnapshot.length,
//                             // scrollDirection: Axis.horizontal,
//                             itemBuilder: (context, index) {
//                               ProjectModel project = tSnapshot[index];
//                               return GestureDetector(
//                                 onTap: () {
//                                   projectNotifier.setProject(project);
//                                   Navigator.of(context)
//                                       .pushNamed(AppRouter.storeRoute);
//                                   // PersistentNavBarNavigator.pushNewScreen(
//                                   //   context,
//                                   //   screen: const StoreScreen(),
//                                   //   withNavBar: true,
//                                   //   pageTransitionAnimation:
//                                   //       PageTransitionAnimation.fade,
//                                   // );
//                                 },
//                                 child: ProjectCard(
//                                   project: project,
//                                 ),
//                               );
//                             });
//                       }
//                     },
//                   );
//                 },
//               ),
//             ),
//           ),
//         ),
//         floatingActionButton: canAddProject
//             ? Container(
//                 margin: const EdgeInsets.all(10),
//                 child: FloatingActionButton(
//                   shape: const CircleBorder(eccentricity: 0.5),
//                   onPressed: () {
//                     Navigator.of(context).pushNamed(
//                       AppRouter.projectDetailRoute,
//                       arguments: ProjectModel(
//                           idProject: 0,
//                           idUserAppInstitution:
//                               cUserAppInstitutionModel.idUserAppInstitution,
//                           nameProject: '',
//                           descriptionProject: '',
//                           isDeleted: false,
//                           imageProject: '',
//                           giveIdsFlatStructureModel:
//                               GiveIdsFlatStructureModel.empty(),
//                           projectGrantStructure: List.empty()),
//                     );
//                   },
//                   //backgroundColor: Colors.deepOrangeAccent,
//                   child: const Icon(Icons.add),
//                 ),
//               )
//             : const SizedBox.shrink());
//   }
// }

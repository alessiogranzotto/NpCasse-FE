// import 'package:flutter/material.dart';
// import 'package:np_casse/app/routes/app_routes.dart';
// import 'package:np_casse/app/utilities/image_utils.dart';
// import 'package:np_casse/core/models/user.app.institution.model.dart';
// import 'package:np_casse/core/notifiers/authentication.notifier.dart';
// import 'package:provider/provider.dart';
// import 'package:np_casse/core/models/project.model.dart';
// import 'package:np_casse/core/notifiers/project.notifier.dart';

// class ProjectCard extends StatelessWidget {
//   const ProjectCard({
//     Key? key,
//     required this.project,
//   }) : super(key: key);
//   final ProjectModel project;

//   @override
//   Widget build(BuildContext context) {
//     AuthenticationNotifier authenticationNotifier =
//         Provider.of<AuthenticationNotifier>(context);
//     ProjectNotifier projectNotifier = Provider.of<ProjectNotifier>(context);

//     UserAppInstitutionModel cUserAppInstitutionModel =
//         authenticationNotifier.getSelectedUserAppInstitution();

//     return Card(
//       elevation: 8,
//       child: Container(
//         //margin: const EdgeInsets.all(2),
//         decoration: BoxDecoration(
//             boxShadow: [
//               BoxShadow(
//                   color: Theme.of(context).shadowColor.withOpacity(0.6),
//                   offset: const Offset(0.0, 0.0), //(x,y)
//                   blurRadius: 4.0,
//                   blurStyle: BlurStyle.solid)
//             ],
//             //color: Colors.white,
//             color: Theme.of(context).cardColor),

//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Container(
//               margin: const EdgeInsets.symmetric(horizontal: 0),
//               height: 150,
//               decoration: BoxDecoration(
//                 image: DecorationImage(
//                     fit: BoxFit.cover,
//                     image: (ImageUtils.getImageFromStringBase64(
//                             stringImage: project.imageProject)
//                         .image)),
//               ),
//             ),
//             SizedBox(
//               height: 60,
//               child: Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Text(
//                   project.nameProject,
//                   maxLines: 2,
//                   overflow: TextOverflow.ellipsis,
//                   style: Theme.of(context).textTheme.titleSmall,
//                 ),
//               ),
//             ),
//             SizedBox(
//               height: 50,
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                 child: Text(
//                   project.descriptionProject,
//                   maxLines: 3,
//                   overflow: TextOverflow.ellipsis,
//                   style: Theme.of(context).textTheme.bodyMedium,
//                 ),
//               ),
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     SizedBox(
//                       height: 30,
//                       width: 30,
//                       child: IconButton(
//                           onPressed: () {
//                             projectNotifier.setProject(project);
//                             Navigator.of(context).pushNamed(
//                               AppRouter.projectDetailRoute,
//                               arguments: ProjectModel(
//                                   idProject: project.idProject,
//                                   idUserAppInstitution: cUserAppInstitutionModel
//                                       .idUserAppInstitution,
//                                   nameProject: project.nameProject,
//                                   descriptionProject:
//                                       project.descriptionProject,
//                                   isDeleted: project.isDeleted,
//                                   imageProject: project.imageProject,
//                                   giveIdsFlatStructureModel:
//                                       project.giveIdsFlatStructureModel,
//                                   projectGrantStructure:
//                                       project.projectGrantStructure),
//                             );
//                             //   PersistentNavBarNavigator.pushNewScreen(context,
//                             //       screen: ProjectDetailScreen(
//                             //         projectModelArgument: ProjectModel(
//                             //             idProject: project.idProject,
//                             //             idUserAppInstitution:
//                             //                 cUserAppInstitutionModel
//                             //                     .idUserAppInstitution,
//                             //             nameProject: project.nameProject,
//                             //             descriptionProject:
//                             //                 project.descriptionProject,
//                             //             imageProject: project.imageProject,
//                             //             giveIdsFlatStructureModel:
//                             //                 project.giveIdsFlatStructureModel),
//                             //       ),
//                             //       withNavBar: true,
//                             //       pageTransitionAnimation:
//                             //           PageTransitionAnimation.fade);
//                           },
//                           icon: const Icon(
//                             Icons.edit,
//                             size: 20,
//                           )),
//                     ),
//                   ],
//                 )
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:np_casse/app/routes/app_routes.dart';
// import 'package:np_casse/app/utilities/image_utils.dart';
// import 'package:np_casse/core/models/store.model.dart';
// import 'package:np_casse/core/notifiers/store.notifier.dart';
// import 'package:provider/provider.dart';

// class StoreCard extends StatelessWidget {
//   const StoreCard({
//     Key? key,
//     required this.store,
//   }) : super(key: key);
//   final StoreModel store;

//   @override
//   Widget build(BuildContext context) {
//     // UserAppInstitutionNotifier userAppInstitutionNotifier =
//     //     Provider.of<UserAppInstitutionNotifier>(context);

//     // ProjectNotifier projectNotifier = Provider.of<ProjectNotifier>(context);
//     StoreNotifier storeNotifier = Provider.of<StoreNotifier>(context);

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
//               height: 150,
//               decoration: BoxDecoration(
//                 image: DecorationImage(
//                     fit: BoxFit.cover,
//                     image: (ImageUtils.getImageFromStringBase64(
//                             stringImage: store.imageStore)
//                         .image)
//                     // (project.imageProject as ImageProvider)
//                     ),
//               ),
//             ),
//             SizedBox(
//               height: 50,
//               child: Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Text(
//                   store.nameStore,
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
//                   store.descriptionStore,
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
//                             storeNotifier.setStore(store);
//                             Navigator.of(context).pushNamed(
//                               AppRouter.storeDetailRoute,
//                               arguments: StoreModel(
//                                   idStore: store.idStore,
//                                   idProject: store.idProject,
//                                   nameStore: store.nameStore,
//                                   descriptionStore: store.descriptionStore,
//                                   isDeleted: false,
//                                   imageStore: store.imageStore,
//                                   giveIdsFlatStructureModel:
//                                       store.giveIdsFlatStructureModel),
//                             );
//                             // PersistentNavBarNavigator.pushNewScreen(context,
//                             //     screen: StoreDetailScreen(
//                             //       storeModelArgument: StoreModel(
//                             //           idStore: store.idStore,
//                             //           idProject: store.idProject,
//                             //           nameStore: store.nameStore,
//                             //           descriptionStore: store.descriptionStore,
//                             //           imageStore: store.imageStore,
//                             //           giveIdsFlatStructureModel:
//                             //               store.giveIdsFlatStructureModel),
//                             //     ),
//                             //     withNavBar: true,
//                             //     pageTransitionAnimation:
//                             //         PageTransitionAnimation.fade);
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

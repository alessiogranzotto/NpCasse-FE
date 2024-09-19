// import 'package:flutter/material.dart';
// import 'package:np_casse/app/customized_component/sliver_grid_delegate_fixed_cross_axis_count_and_fixed_height.dart';
// import 'package:np_casse/app/routes/app_routes.dart';
// import 'package:np_casse/core/models/give.id.flat.structure.model.dart';
// import 'package:np_casse/core/models/store.model.dart';
// import 'package:np_casse/core/models/user.app.institution.model.dart';
// import 'package:np_casse/core/notifiers/authentication.notifier.dart';
// import 'package:np_casse/core/notifiers/store.notifier.dart';
// import 'package:np_casse/core/notifiers/project.notifier.dart';
// import 'package:np_casse/screens/storeScreen/widget/store.card.dart';
// import 'package:provider/provider.dart';

// class StoreScreen extends StatelessWidget {
//   const StoreScreen({super.key});

//   final double widgetWitdh = 300;
//   final double widgetRatio = 1;
//   final double gridMainAxisSpacing = 10;

//   @override
//   Widget build(BuildContext context) {
//     AuthenticationNotifier authenticationNotifier =
//         Provider.of<AuthenticationNotifier>(context);
//     ProjectNotifier projectNotifier = Provider.of<ProjectNotifier>(context);

//     UserAppInstitutionModel cUserAppInstitutionModel =
//         authenticationNotifier.getSelectedUserAppInstitution();

//     bool canAddStore = authenticationNotifier.canUserAddItem();

//     return SafeArea(
//         child: Scaffold(
//             backgroundColor: Theme.of(context).colorScheme.background,
//             // drawer: const CustomDrawerWidget(),
//             appBar: AppBar(
//               centerTitle: true,
//               title: Text('Negozi di ${projectNotifier.getNameProject}',
//                   style: Theme.of(context).textTheme.headlineLarge),
//               // actions: <Widget>[
//               //   canAddStore
//               //       ? IconButton(
//               //           icon: const Icon(Icons.add),
//               //           onPressed: () {
//               //             Navigator.of(context).pushNamed(
//               //               AppRouter.storeDetailRoute,
//               //               arguments: StoreModel(
//               //                   idStore: 0,
//               //                   idProject: projectNotifier.getIdProject,
//               //                   nameStore: '',
//               //                   descriptionStore: '',
//               //                   imageStore: '',
//               //                   giveIdsFlatStructureModel:
//               //                       GiveIdsFlatStructureModel.empty()),
//               //             );
//               //             // PersistentNavBarNavigator.pushNewScreen(context,
//               //             //     screen: StoreDetailScreen(
//               //             //       storeModelArgument: StoreModel(
//               //             //           idStore: 0,
//               //             //           idProject: projectNotifier.getIdProject,
//               //             //           nameStore: '',
//               //             //           descriptionStore: '',
//               //             //           imageStore: '',
//               //             //           giveIdsFlatStructureModel:
//               //             //               GiveIdsFlatStructureModel.empty()),
//               //             //     ),
//               //             //     withNavBar: true,
//               //             //     pageTransitionAnimation: PageTransitionAnimation.fade);
//               //           },
//               //         )
//               //       : const SizedBox.shrink()
//               // ],
//             ),
//             body: SingleChildScrollView(
//               child: Padding(
//                 padding: const EdgeInsets.all(16),
//                 child: SizedBox(
//                   height: MediaQuery.of(context).size.height * 0.8,
//                   width: MediaQuery.of(context).size.width,
//                   child: Consumer<StoreNotifier>(
//                     builder: (context, storeNotifier, _) {
//                       return FutureBuilder(
//                         future: storeNotifier.getStores(
//                             context: context,
//                             token: authenticationNotifier.token,
//                             idUserAppInstitution:
//                                 cUserAppInstitutionModel.idUserAppInstitution,
//                             idProject: projectNotifier.getIdProject),
//                         builder: (context, snapshot) {
//                           if (snapshot.connectionState ==
//                               ConnectionState.waiting) {
//                             return const Center(
//                               child: Column(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 crossAxisAlignment: CrossAxisAlignment.center,
//                                 children: [
//                                   Center(
//                                       child: SizedBox(
//                                           width: 100,
//                                           height: 100,
//                                           child: CircularProgressIndicator(
//                                             strokeWidth: 5,
//                                             color: Colors.redAccent,
//                                           ))),
//                                 ],
//                               ),
//                             );
//                           } else if (!snapshot.hasData) {
//                             return const Center(
//                               child: Text(
//                                 'No data...',
//                                 style: TextStyle(
//                                   color: Colors.redAccent,
//                                 ),
//                               ),
//                             );
//                           } else {
//                             var tSnapshot = snapshot.data as List;
//                             return GridView.builder(
//                                 gridDelegate:
//                                     SliverGridDelegateWithFixedCrossAxisCountAndFixedHeight(
//                                   crossAxisCount:
//                                       (MediaQuery.of(context).size.width) ~/
//                                           widgetWitdh,
//                                   crossAxisSpacing: 10,
//                                   // (((MediaQuery.of(context)
//                                   //             .size
//                                   //             .width) -
//                                   //         (widgetWitdh *
//                                   //             ((MediaQuery.of(context)
//                                   //                     .size
//                                   //                     .width) ~/
//                                   //                 widgetWitdh))) /
//                                   //     ((MediaQuery.of(context).size.width) ~/
//                                   //         widgetWitdh)),
//                                   mainAxisSpacing: gridMainAxisSpacing,
//                                   height: 300,
//                                 ),
//                                 physics: const ScrollPhysics(),
//                                 shrinkWrap: true,
//                                 itemCount: tSnapshot.length,
//                                 // scrollDirection: Axis.horizontal,
//                                 itemBuilder: (context, index) {
//                                   StoreModel store = tSnapshot[index];
//                                   return GestureDetector(
//                                     onTap: () {
//                                       storeNotifier.setStore(store);
//                                       Navigator.of(context)
//                                           .pushNamed(AppRouter.productRoute);
//                                       // PersistentNavBarNavigator.pushNewScreen(
//                                       //   context,
//                                       //   screen: const ProductScreen(),
//                                       //   withNavBar: true,
//                                       //   pageTransitionAnimation:
//                                       //       PageTransitionAnimation.fade,
//                                       // );
//                                     },
//                                     child: StoreCard(
//                                       store: store,
//                                     ),
//                                   );
//                                 });
//                           }
//                         },
//                       );
//                     },
//                   ),
//                 ),
//               ),
//             ),
//             floatingActionButton: canAddStore
//                 ? Container(
//                     margin: const EdgeInsets.all(10),
//                     child: FloatingActionButton(
//                       shape: const CircleBorder(eccentricity: 0.5),
//                       onPressed: () {
//                         Navigator.of(context).pushNamed(
//                           AppRouter.storeDetailRoute,
//                           arguments: StoreModel(
//                               idStore: 0,
//                               idProject: projectNotifier.getIdProject,
//                               nameStore: '',
//                               descriptionStore: '',
//                               isDeleted: false,
//                               imageStore: '',
//                               giveIdsFlatStructureModel:
//                                   GiveIdsFlatStructureModel.empty()),
//                         );
//                       },
//                       //backgroundColor: Colors.deepOrangeAccent,
//                       child: const Icon(Icons.add),
//                     ),
//                   )
//                 : const SizedBox.shrink()));
//   }
// }

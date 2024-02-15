import 'package:flutter/material.dart';
import 'package:np_casse/app/customized_component/sliver_grid_delegate_fixed_cross_axis_count_and_fixed_height.dart';
import 'package:np_casse/core/models/product.model.dart';
import 'package:np_casse/core/models/user.app.institution.model.dart';
import 'package:np_casse/core/notifiers/authentication.notifier.dart';
import 'package:np_casse/core/notifiers/project.notifier.dart';
import 'package:np_casse/core/notifiers/product.notifier.dart';
// import 'package:np_casse/screens/cartScreen/cart.screen.dart';
import 'package:np_casse/screens/productScreen/product.detail.screen.dart';
import 'package:np_casse/screens/productScreen/widgets/product.card.dart';
// import 'package:np_casse/screens/storeScreen/store.screen.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:provider/provider.dart';
// import 'package:flutter/material.dart';
// import 'package:np_casse/core/models/product.model.dart';
// import 'package:np_casse/core/notifiers/authentication.notifier.dart';
// import 'package:np_casse/core/notifiers/cart.notifier.dart';
// import 'package:np_casse/core/notifiers/product.notifier.dart';
// import 'package:np_casse/core/notifiers/userInstitution.notifier.dart';
// import 'package:np_casse/core/notifiers/product.notifier.dart';
import 'package:np_casse/core/notifiers/store.notifier.dart';
// import 'package:np_casse/core/utils/snackbar.util.dart';
// import 'package:np_casse/screens/cartScreen/add.cart.screen.dart';
// import 'package:np_casse/screens/productScreen/product.detail.screen.dart';
// import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
// import 'package:provider/provider.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});
  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  double widgetWitdh = 300;
  double widgetRatio = 1.1;
  double widgetRatioHalf = 0.65;
  double gridMainAxisSpacing = 10;

  Icon icona = const Icon(Icons.search);
  TextEditingController searchController = TextEditingController();

  // late Future<List<ProductModel>> products;

  // Future<List<ProductModel>> getProduct() async {
  //   AuthenticationNotifier authenticationNotifier =
  //       Provider.of<AuthenticationNotifier>(context);
  //   ProductNotifier productNotifier = Provider.of<ProductNotifier>(context);
  //   UserAppInstitutionModel cUserAppInstitutionModel =
  //       authenticationNotifier.getSelectedUserAppInstitution();
  //   ProjectNotifier projectNotifier = Provider.of<ProjectNotifier>(context);
  //   StoreNotifier storeNotifier = Provider.of<StoreNotifier>(context);
  //   return await productNotifier.getProducts(
  //       context: context,
  //       token: authenticationNotifier.token,
  //       idUserAppInstitution: cUserAppInstitutionModel.idUserAppInstitution,
  //       idProject: projectNotifier.getIdProject,
  //       idStore: storeNotifier.getIdStore,
  //       searchedBy: searchController.text.toLowerCase());
  // }

  @override
  void initState() {
    searchController.text = "";
    // products = getProduct();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AuthenticationNotifier authenticationNotifier =
        Provider.of<AuthenticationNotifier>(context);
    // UserAppInstitutionNotifier userAppInstitutionNotifier =
    //     Provider.of<UserAppInstitutionNotifier>(context);

    ProjectNotifier projectNotifier = Provider.of<ProjectNotifier>(context);
    // ProductNotifier productNotifier = Provider.of<ProductNotifier>(context);
    StoreNotifier storeNotifier = Provider.of<StoreNotifier>(context);
    // CartNotifier cartNotifier = Provider.of<CartNotifier>(context);
    // ProductCardNotifier productCardNotifier =
    //     Provider.of<ProductCardNotifier>(context);
    UserAppInstitutionModel cUserAppInstitutionModel =
        authenticationNotifier.getSelectedUserAppInstitution();

    return SafeArea(
        child: Scaffold(
            backgroundColor: Theme.of(context).colorScheme.background,
            appBar: AppBar(
              title: Text('Prodotti di ${storeNotifier.getNameStore}',
                  style: Theme.of(context).textTheme.headlineLarge),
              actions: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: 200,
                    child: TextField(
                      onChanged: (value) => {
                        if (value.length > 3)
                          {
                            setState(() {
                              icona = const Icon(Icons.cancel);
                            })
                          }
                        else if (value.isEmpty)
                          {icona = const Icon(Icons.search)}
                      },
                      textAlignVertical: TextAlignVertical.bottom,
                      style: Theme.of(context).textTheme.headlineMedium,
                      controller: searchController,
                      decoration: InputDecoration(
                        labelText: "Ricerca prodotto",
                        labelStyle: Theme.of(context)
                            .textTheme
                            .labelLarge!
                            .copyWith(color: Colors.white),
                        hintText: "Ricerca prodotto",
                        hintStyle: Theme.of(context)
                            .textTheme
                            .labelLarge!
                            .copyWith(color: Colors.white.withOpacity(0.3)),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        enabledBorder: OutlineInputBorder(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10.0)),
                          borderSide: BorderSide(
                              color: Colors.white.withOpacity(0.3), width: 2.0),
                        ),
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide:
                              BorderSide(color: Colors.white, width: 2.0),
                        ),
                        suffixIcon: IconButton(
                          icon: icona,
                          onPressed: () {
                            setState(() {
                              if (icona.icon == Icons.search) {
                                icona = const Icon(Icons.cancel);
                              } else {
                                icona = const Icon(Icons.search);
                                searchController.text = "";
                              }
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    PersistentNavBarNavigator.pushNewScreen(context,
                        screen: ProductDetailScreen(
                          productModelArgument: ProductModel(
                              idProduct: 0,
                              idStore: storeNotifier.getIdStore,
                              nameProduct: '',
                              descriptionProduct: '',
                              priceProduct: 0,
                              imageProduct: '',
                              isWishlisted: ValueNotifier<bool>(false),
                              isFreePriceProduct: false),
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
                child: Consumer<ProductNotifier>(
                  builder: (context, productNotifier, _) {
                    return SizedBox(
                      height: MediaQuery.of(context).size.height * 0.8,
                      width: MediaQuery.of(context).size.width,
                      child: FutureBuilder(
                        future: productNotifier.getProducts(
                            context: context,
                            token: authenticationNotifier.token,
                            idUserAppInstitution:
                                cUserAppInstitutionModel.idUserAppInstitution,
                            idProject: projectNotifier.getIdProject,
                            idStore: storeNotifier.getIdStore,
                            searchedBy: searchController.text.toLowerCase()),
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
                            var tSnapshot = snapshot.data as List<ProductModel>;
                            var t = tSnapshot.any(
                                (element) => element.imageProduct.isNotEmpty);
                            bool areAllWithNoImage = !t;
                            double cWidgetRatio = 0;
                            if (areAllWithNoImage) {
                              cWidgetRatio = widgetRatioHalf;
                            } else {
                              cWidgetRatio = widgetRatio;
                            }
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
                                  height: widgetWitdh * cWidgetRatio,
                                ),
                                physics: const ScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: tSnapshot.length,
                                // scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  ProductModel product = tSnapshot[index];
                                  return ProductCard(
                                    product: product,
                                    areAllWithNoImage: areAllWithNoImage,
                                    comeFromWishList: false,
                                  );
                                });
                          }
                        },
                      ),
                    );
                  },
                ),
              ),
            )));
  }
}






// class ProductScreen extends StatelessWidget {
//   const ProductScreen({super.key});

//   final double widgetWitdh = 300;
//   final double widgetRatio = 1.1;
//   final double gridMainAxisSpacing = 10;

//   @override
//   Widget build(BuildContext context) {
//     AuthenticationNotifier authenticationNotifier =
//         Provider.of<AuthenticationNotifier>(context);
//     // UserAppInstitutionNotifier userAppInstitutionNotifier =
//     //     Provider.of<UserAppInstitutionNotifier>(context);

//     ProjectNotifier projectNotifier = Provider.of<ProjectNotifier>(context);
//     // ProductNotifier productNotifier = Provider.of<ProductNotifier>(context);
//     StoreNotifier storeNotifier = Provider.of<StoreNotifier>(context);
//     // CartNotifier cartNotifier = Provider.of<CartNotifier>(context);
//     ProductCardNotifier productCardNotifier =
//         Provider.of<ProductCardNotifier>(context);
//     UserAppInstitutionModel cUserAppInstitutionModel =
//         authenticationNotifier.getSelectedUserAppInstitution();

//     return SafeArea(
//         child: WillPopScope(
//       onWillPop: () {
//         //trigger leaving and use own data
//         Navigator.pop(context, false);
//         productCardNotifier.resetInitialQuantity();

//         return Future.value(false);
//       },
//       child: Scaffold(
//           backgroundColor: Theme.of(context).colorScheme.background,
//           appBar: AppBar(
//             title: Text('Prodotti di ${storeNotifier.getNameStore}',
//                 style: Theme.of(context).textTheme.headlineLarge),
//             actions: <Widget>[
//               IconButton(
//                 icon: const Icon(Icons.add),
//                 onPressed: () {
//                   PersistentNavBarNavigator.pushNewScreen(context,
//                       screen: ProductDetailScreen(
//                         productModelArgument: ProductModel(
//                             idProduct: 0,
//                             idStore: storeNotifier.getIdStore,
//                             nameProduct: '',
//                             descriptionProduct: '',
//                             priceProduct: 0,
//                             imageProduct: ''),
//                       ),
//                       withNavBar: true,
//                       pageTransitionAnimation: PageTransitionAnimation.fade);
//                 },
//               ),
//             ],
//           ),
//           body: SingleChildScrollView(
//             child: Padding(
//               padding: const EdgeInsets.all(16),
//               child: Consumer<ProductNotifier>(
//                 builder: (context, productNotifier, _) {
//                   return SizedBox(
//                     height: MediaQuery.of(context).size.height * 0.8,
//                     width: MediaQuery.of(context).size.width,
//                     child: FutureBuilder(
//                       future: productNotifier.getProducts(
//                           context: context,
//                           token: authenticationNotifier.token,
//                           idUserAppInstitution:
//                               cUserAppInstitutionModel.idUserAppInstitution,
//                           idProject: projectNotifier.getIdProject,
//                           idStore: storeNotifier.getIdStore),
//                       builder: (context, snapshot) {
//                         if (snapshot.connectionState ==
//                             ConnectionState.waiting) {
//                           return const Center(
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               crossAxisAlignment: CrossAxisAlignment.center,
//                               children: [
//                                 Center(
//                                     child: SizedBox(
//                                         width: 100,
//                                         height: 100,
//                                         child: CircularProgressIndicator(
//                                           strokeWidth: 5,
//                                           color: Colors.redAccent,
//                                         ))),
//                               ],
//                             ),
//                           );
//                         } else if (!snapshot.hasData) {
//                           return const Center(
//                             child: Text(
//                               'No data...',
//                               style: TextStyle(
//                                 color: Colors.redAccent,
//                               ),
//                             ),
//                           );
//                         } else {
//                           var tSnapshot = snapshot.data as List;
//                           return GridView.builder(
//                               gridDelegate:
//                                   SliverGridDelegateWithFixedCrossAxisCountAndFixedHeight(
//                                 crossAxisCount:
//                                     (MediaQuery.of(context).size.width) ~/
//                                         widgetWitdh,
//                                 crossAxisSpacing:
//                                     (((MediaQuery.of(context).size.width) -
//                                             (widgetWitdh *
//                                                 ((MediaQuery.of(context)
//                                                         .size
//                                                         .width) ~/
//                                                     widgetWitdh))) /
//                                         ((MediaQuery.of(context).size.width) ~/
//                                             widgetWitdh)),
//                                 mainAxisSpacing: gridMainAxisSpacing,
//                                 height: widgetWitdh * widgetRatio,
//                               ),
//                               physics: const ScrollPhysics(),
//                               shrinkWrap: true,
//                               itemCount: tSnapshot.length,
//                               // scrollDirection: Axis.horizontal,
//                               itemBuilder: (context, index) {
//                                 ProductModel product = tSnapshot[index];
//                                 return ProductCard(
//                                   product: product,
//                                 );
//                               });
//                         }
//                       },
//                     ),
//                   );
//                 },
//               ),
//             ),
//           )),
//     ));
//   }
// }

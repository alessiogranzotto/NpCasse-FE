import 'dart:async';

import 'package:flutter/material.dart';
import 'package:np_casse/app/customized_component/sliver_grid_delegate_fixed_cross_axis_count_and_fixed_height.dart';
import 'package:np_casse/app/routes/app_routes.dart';
import 'package:np_casse/core/models/give.id.flat.structure.model.dart';
import 'package:np_casse/core/models/product.model.dart';
import 'package:np_casse/core/models/user.app.institution.model.dart';
import 'package:np_casse/core/notifiers/authentication.notifier.dart';
import 'package:np_casse/core/notifiers/project.notifier.dart';
import 'package:np_casse/core/notifiers/product.notifier.dart';
import 'package:np_casse/screens/productScreen/widgets/product.card.dart';
import 'package:provider/provider.dart';
import 'package:np_casse/core/notifiers/store.notifier.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});
  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  double widgetWitdh = 320;
  double widgetHeight = 350;
  double widgetHeightHalf = 200;
  // double widgetRatio = 1.1;
  // double widgetRatioHalf = 0.65;
  double gridMainAxisSpacing = 10;

  Timer? _timer;
  Icon icona = const Icon(Icons.search);
  TextEditingController searchController = TextEditingController();
  bool viewOutOfAssortment = false;

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
    viewOutOfAssortment = false;
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
    bool canAddProduct = authenticationNotifier.canUserAddItem();

    return SafeArea(
        child: Scaffold(
            backgroundColor: Theme.of(context).colorScheme.background,
            // drawer: const CustomDrawerWidget(),
            appBar: AppBar(
              centerTitle: true,
              title: Text('Prodotti di ${storeNotifier.getNameStore}',
                  style: Theme.of(context).textTheme.headlineLarge),
              actions: <Widget>[
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: 250,
                      child: CheckboxListTile(
                          title: SizedBox(
                              width: 200,
                              child: Text("Visualizza fuori assortimento",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall)),
                          value: viewOutOfAssortment,
                          onChanged: (bool? value) {
                            setState(() {
                              viewOutOfAssortment = value ?? false;
                            });
                          },
                          controlAffinity: ListTileControlAffinity.leading),
                    )),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: 250,
                    child: TextField(
                      onChanged: (String value) {
                        if (_timer?.isActive ?? false) {
                          _timer!.cancel();
                        }
                        _timer = Timer(const Duration(milliseconds: 1000), () {
                          setState(() {
                            icona = const Icon(Icons.cancel);
                            if (value.isEmpty) {
                              icona = const Icon(Icons.search);
                            }
                          });
                        });
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
                            searchedBy: searchController.text.toLowerCase(),
                            viewOutOfAssortment: viewOutOfAssortment),
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
                            double cHeight = 0;
                            if (areAllWithNoImage) {
                              cHeight = widgetHeightHalf;
                            } else {
                              cHeight = widgetHeight;
                            }
                            return GridView.builder(
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCountAndFixedHeight(
                                  crossAxisCount:
                                      (MediaQuery.of(context).size.width) ~/
                                          widgetWitdh,
                                  crossAxisSpacing: 10,
                                  //  (((MediaQuery.of(context)
                                  //             .size
                                  //             .width) -
                                  //         (widgetWitdh *
                                  //             ((MediaQuery.of(context)
                                  //                     .size
                                  //                     .width) ~/
                                  //                 widgetWitdh))) /
                                  //     ((MediaQuery.of(context).size.width) ~/
                                  //         widgetWitdh)),
                                  mainAxisSpacing: gridMainAxisSpacing,
                                  height: cHeight,
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
            ),
            floatingActionButton: canAddProduct
                ? Container(
                    margin: const EdgeInsets.all(10),
                    child: FloatingActionButton(
                      shape: const CircleBorder(eccentricity: 0.5),
                      onPressed: () {
                        Navigator.of(context).pushNamed(
                          AppRouter.productDetailRoute,
                          arguments: ProductModel(
                              idProduct: 0,
                              idStore: storeNotifier.getIdStore,
                              nameProduct: '',
                              descriptionProduct: '',
                              priceProduct: 0,
                              imageProduct: '',
                              isWishlisted: ValueNotifier<bool>(false),
                              isFreePriceProduct: false,
                              isDeleted: false,
                              isOutOfAssortment: false,
                              giveIdsFlatStructureModel:
                                  GiveIdsFlatStructureModel.empty()),
                        );
                      },
                      //backgroundColor: Colors.deepOrangeAccent,
                      child: const Icon(Icons.add),
                    ),
                  )
                : const SizedBox.shrink()));
  }
}

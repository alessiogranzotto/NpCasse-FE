import 'dart:async';

import 'package:flutter/material.dart';
import 'package:np_casse/app/customized_component/sliver_grid_delegate_fixed_cross_axis_count_and_fixed_height.dart';
import 'package:np_casse/app/routes/app_routes.dart';
import 'package:np_casse/componenents/custom.drop.down.button.form.field.field.dart';
import 'package:np_casse/core/models/give.id.flat.structure.model.dart';
import 'package:np_casse/core/models/user.app.institution.model.dart';
import 'package:np_casse/core/models/product.catalog.model.dart';
import 'package:np_casse/core/notifiers/authentication.notifier.dart';
import 'package:np_casse/core/notifiers/product.catalog.notifier.dart';
import 'package:np_casse/screens/productCatalogScreen/product.catalog.card.dart';
import 'package:provider/provider.dart';

class ProductCatalogScreen extends StatefulWidget {
  const ProductCatalogScreen({super.key});

  @override
  State<ProductCatalogScreen> createState() => _ProductCatalogScreenState();
}

class _ProductCatalogScreenState extends State<ProductCatalogScreen> {
  final double widgetWitdh = 300;
  final double widgetRatio = 1;
  final double gridMainAxisSpacing = 10;
  final double widgetHeight = 350;
  final double widgetHeightHalf = 200;
  Timer? _timer;

  TextEditingController nameDescSearchController = TextEditingController();
  bool readImageData = false;
  bool readAlsoDeleted = false;
  int selectedCategory = 0;
  List<DropdownMenuItem<String>> availableCategory = [];

  String numberResult = '25';
  List<DropdownMenuItem<String>> availableNumberResult = [
    DropdownMenuItem(child: Text("Tutti"), value: "All"),
    DropdownMenuItem(child: Text("10"), value: "10"),
    DropdownMenuItem(child: Text("25"), value: "25"),
    DropdownMenuItem(child: Text("50"), value: "50"),
  ];

  String orderBy = 'NameProduct';
  List<DropdownMenuItem<String>> availableOrderBy = [
    DropdownMenuItem(child: Text("Nome"), value: "NameProduct"),
    DropdownMenuItem(child: Text("Descrizione"), value: "DescriptionProduct"),
    DropdownMenuItem(
        child: Text("Ordine di visualizzazione"), value: "DisplayOrder"),
  ];
  Icon iconaNameDescSearch = const Icon(Icons.search);

  void onChangeCategory(value) {
    setState(() {
      selectedCategory = value!;
    });
  }

  void onChangeNumberResult(value) {
    setState(() {
      numberResult = value!;
    });
  }

  void onChangeOrderBy(value) {
    setState(() {
      orderBy = value!;
    });
  }

  // Future<void> getAvailableCategories() async {
  //   AuthenticationNotifier authenticationNotifier =
  //       Provider.of<AuthenticationNotifier>(context, listen: false);
  //   UserAppInstitutionModel cUserAppInstitutionModel =
  //       authenticationNotifier.getSelectedUserAppInstitution();

  //   CategoryCatalogNotifier categoryCatalogNotifier =
  //       Provider.of<CategoryCatalogNotifier>(context, listen: false);

  //   List<DropdownMenuItem<String>> tAvailableLevelCategory = [];
  //   tAvailableLevelCategory.add(DropdownMenuItem(
  //       child: Text('Categoria di primo livello'), value: '0'));
  //   await categoryCatalogNotifier
  //       .getCategories(
  //           context: context,
  //           token: authenticationNotifier.token,
  //           idUserAppInstitution: cUserAppInstitutionModel.idUserAppInstitution,
  //           idCategory: selectedCategory,
  //           levelCategory: 'All',
  //           readAlsoDeleted: false,
  //           numberResult: 'All',
  //           nameDescSearch: '',
  //           readImageData: false,
  //           orderBy: '')
  //       .then((value) {
  //     for (int i = 0; i < value.length; i++) {
  //       tAvailableLevelCategory.add(
  //         DropdownMenuItem(
  //             child: Text(value[i].nameCategory),
  //             value: value[i].idCategory.toString()),
  //       );
  //     }
  //     setState(() {
  //       availableCategory = tAvailableLevelCategory;
  //     });
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    AuthenticationNotifier authenticationNotifier =
        Provider.of<AuthenticationNotifier>(context);

    UserAppInstitutionModel cUserAppInstitutionModel =
        authenticationNotifier.getSelectedUserAppInstitution();

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Prodotti ${cUserAppInstitutionModel.idInstitutionNavigation.nameInstitution}',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                // Expanded(
                //     flex: 2,
                //     child: CustomDropDownButtonFormField(
                //       actualValue: selectedCategory.toString(),
                //       labelText: 'Categoria',
                //       listOfValue: availableCategory,
                //       onItemChanged: (String value) {
                //         onChangeCategory(value);
                //       },
                //     )),
                Expanded(
                    flex: 1,
                    child: CustomDropDownButtonFormField(
                      actualValue: numberResult,
                      labelText: 'Mostra numero risultati',
                      listOfValue: availableNumberResult,
                      onItemChanged: (String value) {
                        onChangeNumberResult(value);
                      },
                    )),
                Expanded(
                    flex: 2,
                    child: CustomDropDownButtonFormField(
                      actualValue: orderBy,
                      labelText: 'Ordinamento',
                      listOfValue: availableOrderBy,
                      onItemChanged: (String value) {
                        onChangeOrderBy(value);
                      },
                    )),
                Expanded(
                  flex: 1,
                  child: CheckboxListTile(
                    side: const BorderSide(color: Colors.blueGrey),
                    checkColor: Colors.blueAccent,
                    checkboxShape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    activeColor: Colors.blueAccent,

                    controlAffinity: ListTileControlAffinity.leading,
                    value: readAlsoDeleted,
                    onChanged: (bool? value) {
                      setState(() {
                        readAlsoDeleted = value!;
                      });
                    },
                    title: Text(
                      'Mostra anche cancellati',
                      style: Theme.of(context)
                          .textTheme
                          .labelMedium!
                          .copyWith(color: Colors.blueGrey),
                    ),
                    // subtitle: const Text(""),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: CheckboxListTile(
                    side: const BorderSide(color: Colors.blueGrey),
                    checkColor: Colors.blueAccent,
                    checkboxShape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    activeColor: Colors.blueAccent,

                    controlAffinity: ListTileControlAffinity.leading,
                    value: readImageData,
                    onChanged: (bool? value) {
                      setState(() {
                        readImageData = value!;
                      });
                    },
                    title: Text(
                      'Visualizza immagine',
                      style: Theme.of(context)
                          .textTheme
                          .labelMedium!
                          .copyWith(color: Colors.blueGrey),
                    ),
                    // subtitle: const Text(""),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    style: Theme.of(context)
                        .textTheme
                        .labelLarge!
                        .copyWith(color: Colors.blueGrey),
                    onChanged: (String value) {
                      if (_timer?.isActive ?? false) {
                        _timer!.cancel();
                      }
                      _timer = Timer(const Duration(milliseconds: 1000), () {
                        setState(() {
                          iconaNameDescSearch = const Icon(Icons.cancel);
                          if (value.isEmpty) {
                            iconaNameDescSearch = const Icon(Icons.search);
                          }
                        });
                      });
                    },
                    controller: nameDescSearchController,
                    decoration: InputDecoration(
                      labelText: "Ricerca per nome, descrizione o barcode",
                      labelStyle: Theme.of(context)
                          .textTheme
                          .labelMedium!
                          .copyWith(color: Colors.blueGrey),
                      hintText: "Ricerca per nome, descrizione o barcode",
                      hintStyle: Theme.of(context)
                          .textTheme
                          .labelLarge!
                          .copyWith(
                              color:
                                  Theme.of(context).hintColor.withOpacity(0.3)),
                      suffixIcon: IconButton(
                        icon: iconaNameDescSearch,
                        onPressed: () {
                          setState(() {
                            if (iconaNameDescSearch.icon == Icons.search) {
                              iconaNameDescSearch = const Icon(Icons.cancel);
                            } else {
                              iconaNameDescSearch = const Icon(Icons.search);
                              nameDescSearchController.text = "";
                            }
                          });
                        },
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide(color: Colors.grey, width: 1.0),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide(color: Colors.grey, width: 1.0),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide(color: Colors.blue, width: 1.0),
                      ),
                      errorBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide(color: Colors.red, width: 1.0),
                      ),
                      focusedErrorBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide(
                            color: Colors.deepOrangeAccent, width: 1.0),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Consumer<ProductCatalogNotifier>(
                builder: (context, ProductCatalogNotifier, _) {
                  return FutureBuilder(
                    future: ProductCatalogNotifier.getProducts(
                        context: context,
                        token: authenticationNotifier.token,
                        idUserAppInstitution:
                            cUserAppInstitutionModel.idUserAppInstitution,
                        idCategory: 0,
                        readAlsoDeleted: readAlsoDeleted,
                        numberResult: numberResult,
                        nameDescSearch: nameDescSearchController.text,
                        readImageData: readImageData,
                        orderBy: orderBy,
                        shoWVariant: false),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
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
                        var tSnapshot =
                            snapshot.data as List<ProductCatalogModel>;

                        double cHeight = 0;
                        if (readImageData) {
                          cHeight = widgetHeight;
                        } else {
                          cHeight = widgetHeightHalf;
                        }

                        return SingleChildScrollView(
                          child: Column(
                            children: [
                              GridView.builder(
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCountAndFixedHeight(
                                    crossAxisCount:
                                        (MediaQuery.of(context).size.width) ~/
                                            widgetWitdh,
                                    crossAxisSpacing: 10,
                                    mainAxisSpacing: gridMainAxisSpacing,
                                    height: cHeight,
                                  ),
                                  physics: const ScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: tSnapshot.length,
                                  // scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    ProductCatalogModel product =
                                        tSnapshot[index];
                                    return ProductCatalogCard(
                                      product: product,
                                      readImageData: readImageData,
                                    );
                                  }),
                            ],
                          ),
                        );
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Wrap(
        direction: Axis.vertical,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.all(10),
            child: FloatingActionButton(
              shape: const CircleBorder(eccentricity: 0.5),
              onPressed: () {
                Navigator.of(context).pushNamed(
                  AppRouter.productCatalogDetailDataRoute,
                  arguments: ProductCatalogModel(
                      idProduct: 0,
                      idCategory: 0,
                      nameProduct: '',
                      displayOrder: 0,
                      descriptionProduct: '',
                      priceProduct: 0,
                      freePriceProduct: false,
                      outOfAssortment: false,
                      isWishlisted: ValueNotifier<bool>(false),
                      barcode: '',
                      deleted: false,
                      idUserAppInstitution:
                          cUserAppInstitutionModel.idUserAppInstitution,
                      imageData: '',
                      categoryName: '',
                      giveIdsFlatStructureModel:
                          GiveIdsFlatStructureModel.empty(),
                      productAttributeCombination: List.empty(),
                      smartProductAttributeJson: List.empty()),
                );
              },
              //backgroundColor: Colors.deepOrangeAccent,
              child: const Icon(Icons.add),
            ),
          ),
        ],
      ),
    );
  }
}

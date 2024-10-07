import 'dart:async';

import 'package:flutter/material.dart';
import 'package:np_casse/app/customized_component/sliver_grid_delegate_fixed_cross_axis_count_and_fixed_height.dart';
import 'package:np_casse/app/routes/app_routes.dart';
import 'package:np_casse/componenents/custom.drop.down.button.form.field.field.dart';
import 'package:np_casse/core/models/category.catalog.model.dart';
import 'package:np_casse/core/models/give.id.flat.structure.model.dart';
import 'package:np_casse/core/models/user.app.institution.model.dart';
import 'package:np_casse/core/models/product.catalog.model.dart';
import 'package:np_casse/core/notifiers/authentication.notifier.dart';
import 'package:np_casse/core/notifiers/category.catalog.notifier.dart';
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
  String? selectedIdCategory = null;
  String? selectedIdSubCategory = null;
  List<DropdownMenuItem<String>> availableCategory = [];

  String numberResult = '10';
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

  void onChangeSelectedIdCategory(value) {
    setState(() {
      print(value);
      selectedIdCategory = value;
      selectedIdSubCategory = null;
    });
  }

  void onChangeSelectedIdSubCategory(value) {
    setState(() {
      selectedIdSubCategory = value;
    });
  }

  @override
  void initState() {
    super.initState();
  }

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
                Expanded(
                  flex: 2,
                  child: Consumer<CategoryCatalogNotifier>(
                    builder: (context, categoryCatalogNotifier, _) {
                      return FutureBuilder(
                        future: categoryCatalogNotifier.getCategories(
                            context: context,
                            token: authenticationNotifier.token,
                            idUserAppInstitution:
                                cUserAppInstitutionModel.idUserAppInstitution,
                            idCategory: 0,
                            levelCategory: 'FirstLevelCategory',
                            readAlsoDeleted: false,
                            numberResult: 'All',
                            nameDescSearch: '',
                            readImageData: false,
                            orderBy: 'NameCategory'),
                        builder: (context, snapshot) {
                          List<DropdownMenuItem<String>> tAvailableCategory =
                              [];
                          if (snapshot.data != null) {
                            var tSnapshot =
                                snapshot.data as List<CategoryCatalogModel>;

                            for (int i = 0; i < tSnapshot.length; i++) {
                              tAvailableCategory.add(
                                DropdownMenuItem(
                                    child: Text(tSnapshot[i].nameCategory),
                                    value: tSnapshot[i].idCategory.toString()),
                              );
                            }
                          }

                          return CustomDropDownButtonFormField(
                              enabled: true,
                              actualValue: selectedIdCategory,
                              labelText: 'Categoria',
                              listOfValue: tAvailableCategory,
                              onItemChanged: (value) {
                                onChangeSelectedIdCategory(value);
                              });
                        },
                      );
                    },
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Consumer<CategoryCatalogNotifier>(
                    builder: (context, categoryCatalogNotifier, _) {
                      return FutureBuilder(
                        future: categoryCatalogNotifier.getCategories(
                            context: context,
                            token: authenticationNotifier.token,
                            idUserAppInstitution:
                                cUserAppInstitutionModel.idUserAppInstitution,
                            idCategory: int.parse(selectedIdCategory ?? '0'),
                            levelCategory: 'SubCategory',
                            readAlsoDeleted: false,
                            numberResult: 'All',
                            nameDescSearch: '',
                            readImageData: false,
                            orderBy: 'NameCategory'),
                        builder: (context, snapshot) {
                          List<DropdownMenuItem<String>> tAvailableCategory =
                              [];
                          if (snapshot.data != null) {
                            var tSnapshot =
                                snapshot.data as List<CategoryCatalogModel>;

                            for (int i = 0; i < tSnapshot.length; i++) {
                              tAvailableCategory.add(
                                DropdownMenuItem(
                                    child: Text(tSnapshot[i].nameCategory),
                                    value: tSnapshot[i].idCategory.toString()),
                              );
                            }
                          }

                          return CustomDropDownButtonFormField(
                              enabled: true,
                              actualValue: selectedIdSubCategory,
                              labelText: 'Sottocategoria',
                              listOfValue: tAvailableCategory,
                              onItemChanged: (value) {
                                onChangeSelectedIdSubCategory(value);
                              });
                        },
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 32.0),
                  child: Tooltip(
                    message: 'Azzera filtri categoria',
                    child: CircleAvatar(
                      radius: 16,
                      backgroundColor: Colors.black,
                      child: IconButton(
                          icon: const Icon(Icons.clear_rounded, size: 16.0),
                          color: Colors.white,
                          onPressed: () => setState(() {
                                selectedIdCategory = null;
                                selectedIdSubCategory = null;
                              })),
                    ),
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
                Expanded(
                    flex: 1,
                    child: CustomDropDownButtonFormField(
                      enabled: selectedIdCategory != null,
                      actualValue: numberResult,
                      labelText: 'Mostra risultati',
                      listOfValue: availableNumberResult,
                      onItemChanged: (value) {
                        onChangeNumberResult(value);
                      },
                    )),
                Expanded(
                    flex: 2,
                    child: CustomDropDownButtonFormField(
                      enabled: true,
                      actualValue: orderBy,
                      labelText: 'Ordinamento',
                      listOfValue: availableOrderBy,
                      onItemChanged: (value) {
                        onChangeOrderBy(value);
                      },
                    )),
                Expanded(
                  flex: 2,
                  child: Column(
                    // crossAxisAlignment: CrossAxisAlignment.stretch,
                    // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CheckboxListTile(
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
                      CheckboxListTile(
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
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Consumer<ProductCatalogNotifier>(
                builder: (context, productCatalogNotifier, _) {
                  return FutureBuilder(
                    future: productCatalogNotifier.getProducts(
                        context: context,
                        token: authenticationNotifier.token,
                        idUserAppInstitution:
                            cUserAppInstitutionModel.idUserAppInstitution,
                        idCategory: selectedIdSubCategory == null
                            ? int.parse(selectedIdCategory ?? '0')
                            : int.parse(selectedIdSubCategory ?? '0'),
                        readAlsoDeleted: readAlsoDeleted,
                        numberResult: numberResult,
                        nameDescSearch: nameDescSearchController.text,
                        readImageData: readImageData,
                        orderBy: orderBy,
                        shoWVariant: false,
                        viewOutOfAssortment: true),
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

                        var t = tSnapshot
                            .any((element) => element.imageData.isNotEmpty);
                        bool areAllWithNoImage = !t;
                        double cHeight = 0;

                        if (readImageData) {
                          cHeight = widgetHeight;
                        } else {
                          cHeight = widgetHeightHalf;
                        }
                        if (areAllWithNoImage) {
                          cHeight = widgetHeightHalf;
                        } else {
                          cHeight = widgetHeight;
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
                                      areAllWithNoImage: areAllWithNoImage,
                                      comeFromWishList: false,
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
                      wishlisted: false,
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

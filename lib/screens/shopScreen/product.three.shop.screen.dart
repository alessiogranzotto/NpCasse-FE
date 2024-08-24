import 'dart:async';

import 'package:flutter/material.dart';
import 'package:np_casse/app/customized_component/sliver_grid_delegate_fixed_cross_axis_count_and_fixed_height.dart';
import 'package:np_casse/componenents/custom.drop.down.button.form.field.field.dart';
import 'package:np_casse/core/models/category.catalog.model.dart';
import 'package:np_casse/core/models/product.catalog.model.dart';
import 'package:np_casse/core/models/user.app.institution.model.dart';
import 'package:np_casse/core/notifiers/authentication.notifier.dart';
import 'package:np_casse/core/notifiers/product.catalog.notifier.dart';
import 'package:np_casse/core/notifiers/project.notifier.dart';
import 'package:np_casse/screens/shopScreen/widget/product.card.dart';
import 'package:provider/provider.dart';
import 'package:np_casse/core/notifiers/store.notifier.dart';

class ProductThreeShopScreen extends StatefulWidget {
  const ProductThreeShopScreen({
    Key? key,
    required this.childCategoryCatalogModel,
  }) : super(key: key);
  final CategoryCatalogModel childCategoryCatalogModel;

  State<ProductThreeShopScreen> createState() =>
      __ProductThreeShopScreenState();
}

class __ProductThreeShopScreenState extends State<ProductThreeShopScreen> {
  double widgetWitdh = 320;
  double widgetHeight = 650;
  double widgetHeightHalf = 300;
  double gridMainAxisSpacing = 10;

  Timer? _timer;
  Icon icona = const Icon(Icons.search);
  TextEditingController nameDescSearchController = TextEditingController();
  bool viewOutOfAssortment = false;
  bool readImageData = false;
  bool readAlsoDeleted = false;
  int selectedCategory = 0;
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

  @override
  void initState() {
    nameDescSearchController.text = "";
    viewOutOfAssortment = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AuthenticationNotifier authenticationNotifier =
        Provider.of<AuthenticationNotifier>(context);

    ProjectNotifier projectNotifier = Provider.of<ProjectNotifier>(context);
    StoreNotifier storeNotifier = Provider.of<StoreNotifier>(context);
    UserAppInstitutionModel cUserAppInstitutionModel =
        authenticationNotifier.getSelectedUserAppInstitution();
    bool canAddProduct = authenticationNotifier.canUserAddItem();

    return SafeArea(
        child: Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      // drawer: const CustomDrawerWidget(),
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.childCategoryCatalogModel.nameCategory,
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
                            style: Theme.of(context).textTheme.headlineSmall)),
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
                controller: nameDescSearchController,
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
                    borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(
                        color: Colors.white.withOpacity(0.3), width: 2.0),
                  ),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: Colors.white, width: 2.0),
                  ),
                  suffixIcon: IconButton(
                    icon: icona,
                    onPressed: () {
                      setState(() {
                        if (icona.icon == Icons.search) {
                          icona = const Icon(Icons.cancel);
                        } else {
                          icona = const Icon(Icons.search);
                          nameDescSearchController.text = "";
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
                builder: (context, productCatalogNotifier, _) {
                  return SizedBox(
                    height: MediaQuery.of(context).size.height * 0.8,
                    width: MediaQuery.of(context).size.width,
                    child: FutureBuilder(
                      future: productCatalogNotifier.getProducts(
                          context: context,
                          token: authenticationNotifier.token,
                          idUserAppInstitution:
                              cUserAppInstitutionModel.idUserAppInstitution,
                          idCategory:
                              widget.childCategoryCatalogModel.idCategory,
                          readAlsoDeleted: false,
                          numberResult: "All",
                          nameDescSearch:
                              nameDescSearchController.text.toLowerCase(),
                          orderBy: "NameProduct",
                          readImageData: true,
                          shoWVariant: true),
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
                          var tSnapshot =
                              snapshot.data as List<ProductCatalogModel>;
                          var t = tSnapshot
                              .any((element) => element.imageData.isNotEmpty);
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
                                mainAxisSpacing: gridMainAxisSpacing,
                                height: cHeight,
                              ),
                              physics: const ScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: tSnapshot.length,
                              // scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                ProductCatalogModel productCatalog =
                                    tSnapshot[index];
                                return ProductCard(
                                  productCatalog: productCatalog,
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
          ],
        ),
      ),
    ));
  }
}
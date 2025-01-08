import 'dart:async';

import 'package:flutter/material.dart';
import 'package:np_casse/app/constants/colors.dart';
import 'package:np_casse/app/customized_component/sliver_grid_delegate_fixed_cross_axis_count_and_fixed_height.dart';
import 'package:np_casse/componenents/custom.drop.down.button.form.field.field.dart';
import 'package:np_casse/core/models/category.catalog.model.dart';
import 'package:np_casse/core/models/product.catalog.model.dart';
import 'package:np_casse/core/models/user.app.institution.model.dart';
import 'package:np_casse/core/notifiers/authentication.notifier.dart';
import 'package:np_casse/core/notifiers/category.catalog.notifier.dart';
import 'package:np_casse/core/notifiers/product.catalog.notifier.dart';
import 'package:np_casse/core/notifiers/shop.search.notifier.dart';
import 'package:np_casse/screens/shopScreen/widget/product.card.dart';
import 'package:provider/provider.dart';

class ProductSearchScreen extends StatefulWidget {
  const ProductSearchScreen({
    Key? key,
  }) : super(key: key);

  State<ProductSearchScreen> createState() => __ProductSearchScreenState();
}

class __ProductSearchScreenState extends State<ProductSearchScreen> {
  double widgetWitdh = 325;
  double widgetHeight = 580;
  double widgetHeightHalf = 430;
  double gridMainAxisSpacing = 10;

  Timer? _timer;
  Icon icona = const Icon(Icons.search);
  TextEditingController nameDescSearchController = TextEditingController();
  bool viewOutOfAssortment = false;
  bool readImageData = true;
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

  Widget _buildCheckboxTile({
    required bool value,
    required ValueChanged<bool?> onChanged,
    required String title,
    required BuildContext context,
  }) {
    return CheckboxListTile(
      side: const BorderSide(color: Colors.blueGrey),
      checkColor: Colors.blueAccent,
      checkboxShape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      activeColor: Colors.blueAccent,
      controlAffinity: ListTileControlAffinity.leading,
      value: value,
      onChanged: onChanged,
      title: Text(
        title,
        style: Theme.of(context)
            .textTheme
            .labelMedium!
            .copyWith(color: Colors.blueGrey),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    AuthenticationNotifier authenticationNotifier =
        Provider.of<AuthenticationNotifier>(context);
    UserAppInstitutionModel cUserAppInstitutionModel =
        authenticationNotifier.getSelectedUserAppInstitution();
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      // drawer: const CustomDrawerWidget(),
      appBar: AppBar(
        backgroundColor: CustomColors.darkBlue,
        centerTitle: true,
        title: Text(
          'Ricerca shop ${cUserAppInstitutionModel.idInstitutionNavigation.nameInstitution}',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                    flex: 1,
                    child: CustomDropDownButtonFormField(
                      enabled: true,
                      actualValue: numberResult,
                      labelText: 'Mostra numero risultati',
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
                if (screenWidth > 1002) ...[
                  Expanded(
                      flex: 1,
                      child: _buildCheckboxTile(
                        value: viewOutOfAssortment,
                        onChanged: (bool? value) {
                          setState(() {
                            viewOutOfAssortment = value!;
                          });
                        },
                        title: 'Visualizza fuori assortimento',
                        context: context,
                      )),
                  Expanded(
                      flex: 1,
                      child: _buildCheckboxTile(
                        value: readImageData,
                        onChanged: (bool? value) {
                          setState(() {
                            readImageData = value!;
                          });
                        },
                        title: 'Visualizza immagine',
                        context: context,
                      )),
                ],
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
            // Second row of checkboxes for small screens
            if (screenWidth <= 1002) ...[
              Row(
                children: [
                  Expanded(
                      flex: 1,
                      child: _buildCheckboxTile(
                        value: viewOutOfAssortment,
                        onChanged: (bool? value) {
                          setState(() {
                            viewOutOfAssortment = value!;
                          });
                        },
                        title: 'Visualizza fuori assortimento',
                        context: context,
                      )),
                  Expanded(
                      flex: 1,
                      child: _buildCheckboxTile(
                        value: readImageData,
                        onChanged: (bool? value) {
                          setState(() {
                            readImageData = value!;
                          });
                        },
                        title: 'Visualizza immagine',
                        context: context,
                      )),
                ],
              ),
            ],
            SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Consumer<ShopSearchNotifier>(
                builder: (context, shopSearchNotifier, _) {
                  return SizedBox(
                    height: MediaQuery.of(context).size.height * 0.8,
                    width: MediaQuery.of(context).size.width,
                    child: FutureBuilder(
                      future: shopSearchNotifier.getProducts(
                          context: context,
                          token: authenticationNotifier.token,
                          idUserAppInstitution:
                              cUserAppInstitutionModel.idUserAppInstitution,
                          idCategory: 0,
                          readAlsoDeleted: false,
                          numberResult: numberResult,
                          nameDescSearch: nameDescSearchController.text,
                          orderBy: orderBy,
                          readImageData: readImageData,
                          shoWVariant: true,
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
                                  comeFrom: "Search",
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
    );
  }
}

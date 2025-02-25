import 'dart:async';

import 'package:flutter/material.dart';
import 'package:np_casse/app/constants/colors.dart';
import 'package:np_casse/app/customized_component/sliver_grid_delegate_fixed_cross_axis_count_and_fixed_height.dart';
import 'package:np_casse/app/routes/app_routes.dart';
import 'package:np_casse/componenents/custom.drop.down.button.form.field.field.dart';
import 'package:np_casse/core/models/category.catalog.model.dart';
import 'package:np_casse/core/models/give.id.flat.structure.model.dart';
import 'package:np_casse/core/models/user.app.institution.model.dart';
import 'package:np_casse/core/notifiers/authentication.notifier.dart';
import 'package:np_casse/core/notifiers/category.catalog.notifier.dart';
import 'package:np_casse/screens/categoryCatalogScreen/category.catalog.card.dart';
import 'package:provider/provider.dart';

class CategoryCatalogScreen extends StatefulWidget {
  const CategoryCatalogScreen({super.key});

  @override
  State<CategoryCatalogScreen> createState() => _CategoryCatalogScreenState();
}

class _CategoryCatalogScreenState extends State<CategoryCatalogScreen> {
  final double widgetWitdh = 300;
  final double widgetRatio = 1;
  final double gridMainAxisSpacing = 10;
  final double widgetHeight = 350;
  final double widgetHeightHalf = 200;
  Timer? _timer;

  TextEditingController nameDescSearchController = TextEditingController();
  bool readImageData = false;
  bool readAlsoDeleted = false;

  String levelCategory = 'AllCategory';
  List<DropdownMenuItem<String>> availableLevelCategory = [
    DropdownMenuItem(
        child: Text("Mostra tutte le categorie"), value: "AllCategory"),
    DropdownMenuItem(
        child: Text("Mostra solo categorie di primo livello"),
        value: "FirstLevelCategory"),
    DropdownMenuItem(
        child: Text("Mostra solo categorie di secondo livello"),
        value: "SecondLevelCategory"),
  ];

  String numberResult = '10';
  List<DropdownMenuItem<String>> availableNumberResult = [
    DropdownMenuItem(child: Text("Tutti"), value: "All"),
    DropdownMenuItem(child: Text("10"), value: "10"),
    DropdownMenuItem(child: Text("25"), value: "25"),
    DropdownMenuItem(child: Text("50"), value: "50"),
  ];

  String orderBy = 'NameCategory';
  List<DropdownMenuItem<String>> availableOrderBy = [
    DropdownMenuItem(child: Text("Nome"), value: "NameCategory"),
    DropdownMenuItem(child: Text("Descrizione"), value: "DescriptionCategory"),
    DropdownMenuItem(
        child: Text("Ordine di visualizzazione"), value: "DisplayOrder"),
  ];
  Icon iconaNameDescSearch = const Icon(Icons.search);

  void onChangeLevelCategory(value) {
    setState(() {
      levelCategory = value!;
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
      appBar: AppBar(
        backgroundColor: CustomColors.darkBlue,
        centerTitle: true,
        title: Text(
          'Categorie ${cUserAppInstitutionModel.idInstitutionNavigation.nameInstitution}',
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
                    child: CustomDropDownButtonFormField(
                      enabled: true,
                      actualValue: levelCategory,
                      labelText: 'Mostra livelli categorie',
                      listOfValue: availableLevelCategory,
                      onItemChanged: (value) {
                        onChangeLevelCategory(value);
                      },
                    )),
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
                        value: readAlsoDeleted,
                        onChanged: (bool? value) {
                          setState(() {
                            readAlsoDeleted = value!;
                          });
                        },
                        title: 'Mostra anche cancellate',
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
                  flex: 1,
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
                      labelText: "Ricerca per nome o descrizione",
                      labelStyle: Theme.of(context)
                          .textTheme
                          .labelMedium!
                          .copyWith(color: Colors.blueGrey),
                      hintText: "Ricerca per nome o descrizione",
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
                        value: readAlsoDeleted,
                        onChanged: (bool? value) {
                          setState(() {
                            readAlsoDeleted = value!;
                          });
                        },
                        title: 'Mostra anche cancellate',
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
              child: Consumer<CategoryCatalogNotifier>(
                builder: (context, categoryCatalogNotifier, _) {
                  return FutureBuilder(
                    future: categoryCatalogNotifier.getCategories(
                        context: context,
                        token: authenticationNotifier.token,
                        idUserAppInstitution:
                            cUserAppInstitutionModel.idUserAppInstitution,
                        idCategory: 0,
                        levelCategory: levelCategory,
                        readAlsoDeleted: readAlsoDeleted,
                        numberResult: numberResult,
                        nameDescSearch: nameDescSearchController.text,
                        readImageData: readImageData,
                        orderBy: orderBy),
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
                            snapshot.data as List<CategoryCatalogModel>;

                        double cHeight = 0;
                        if (readImageData) {
                          cHeight = widgetHeight;
                        } else {
                          cHeight = widgetHeightHalf;
                        }

                        return Column(
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
                                  CategoryCatalogModel category =
                                      tSnapshot[index];
                                  return CategoryCatalogCard(
                                    category: category,
                                    readImageData: readImageData,
                                  );
                                }),
                          ],
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
                  AppRouter.categoryCatalogDetailRoute,
                  arguments: CategoryCatalogModel(
                      idCategory: 0,
                      nameCategory: '',
                      descriptionCategory: '',
                      parentIdCategory: 0,
                      displayOrder: 0,
                      deleted: false,
                      idUserAppInstitution:
                          cUserAppInstitutionModel.idUserAppInstitution,
                      imageData: '',
                      parentCategoryName: '',
                      giveIdsFlatStructureModel:
                          GiveIdsFlatStructureModel.empty()),
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

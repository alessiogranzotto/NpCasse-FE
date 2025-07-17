import 'dart:async';

import 'package:flutter/material.dart';
import 'package:np_casse/app/constants/colors.dart';
import 'package:np_casse/app/customized_component/sliver_grid_delegate_fixed_cross_axis_count_and_fixed_height.dart';
import 'package:np_casse/app/routes/app_routes.dart';
import 'package:np_casse/componenents/custom.drop.down.button.form.field.field.dart';
import 'package:np_casse/core/models/category.catalog.model.dart';
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
  bool filtersExpanded = true;
  final double widgetWitdh = 300;
  final double widgetRatio = 1;
  final double gridMainAxisSpacing = 10;
  final double widgetHeight = 350;
  final double widgetHeightHalf = 200;
  Timer? _timer;
  final ValueNotifier<bool> isDownloading = ValueNotifier(false);
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

  void handleDownloadProductCatalog(BuildContext context) async {
    isDownloading.value = true;
    try {
      final productCatalogNotifier =
          Provider.of<ProductCatalogNotifier>(context, listen: false);
      var authenticationNotifier =
          Provider.of<AuthenticationNotifier>(context, listen: false);
      UserAppInstitutionModel cUserAppInstitutionModel =
          authenticationNotifier.getSelectedUserAppInstitution();

      await productCatalogNotifier.downloadProductCatalog(
        context: context,
        token: authenticationNotifier.token,
        idUserAppInstitution: cUserAppInstitutionModel.idUserAppInstitution,
        idCategory: selectedIdSubCategory == null
            ? int.parse(selectedIdCategory ?? '0')
            : int.parse(selectedIdSubCategory ?? '0'),
        readAlsoDeleted: readAlsoDeleted,
        numberResult: numberResult,
        nameDescSearch: nameDescSearchController.text,
        readImageData: false,
        orderBy: orderBy,
        showVariant: true,
        viewOutOfAssortment: true,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Errore durante l\'esportazione: $e')),
      );
    } finally {
      isDownloading.value = false;
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    nameDescSearchController.dispose();
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
        overflow: TextOverflow.ellipsis,
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
          'Catalogo prodotti ${cUserAppInstitutionModel.idInstitutionNavigation.nameInstitution}',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      body: Column(
        children: [
          ExpansionTile(
            backgroundColor: Colors.white,
            collapsedBackgroundColor: Colors.grey.shade200,
            leading: const Icon(Icons.filter_alt, color: Colors.blueGrey),
            collapsedIconColor: Colors.blueGrey,
            iconColor: Colors.blue,
            expansionAnimationStyle: AnimationStyle(
              duration: Duration(milliseconds: 1000),
              curve: Curves.easeInOut,
              reverseCurve: Curves.easeInOut,
            ),
            title: const Text(
              'Ricerche catalogo prodotti',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            children: [
              _buildFiltersRow(
                screenWidth: screenWidth,
                authenticationNotifier: authenticationNotifier,
                cUserAppInstitutionModel: cUserAppInstitutionModel,
              ),
            ],
          ),
          Expanded(
            // height: MediaQuery.of(context).size.height,
            // width: MediaQuery.of(context).size.width,
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
                      showVariant: false,
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
                            SizedBox(height: 10),
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
                                // gridDelegate:
                                //     SliverGridDelegateWithMaxCrossAxisExtent(
                                //   maxCrossAxisExtent: widgetWitdh,
                                //   mainAxisSpacing: gridMainAxisSpacing,
                                //   crossAxisSpacing: 10,
                                //   childAspectRatio: widgetWitdh / cHeight,
                                // ),
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
                      nameProduct: '',
                      displayOrder: 0,
                      descriptionProduct: '',
                      priceProduct: 0,
                      freePriceProduct: false,
                      outOfAssortment: false,
                      wishlisted: false,
                      barcode: '',
                      sku: '',
                      valueVat: '',
                      deleted: false,
                      idUserAppInstitution:
                          cUserAppInstitutionModel.idUserAppInstitution,
                      imageData: '',
                      // categoryName: '',
                      giveIdsFlatStructureModel:
                          GiveIdsFlatStructureModel.empty(),
                      productCategoryMappingModel: List.empty(),
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

  Widget _buildFiltersRow({
    required double screenWidth,
    required AuthenticationNotifier authenticationNotifier,
    required UserAppInstitutionModel cUserAppInstitutionModel,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isLargeScreen = constraints.maxWidth > 1024;

        if (isLargeScreen) {
          // Layout a due righe per schermi grandi
          return Column(
            children: [
              Row(
                children: [
                  _buildCategoriaDropdown(
                      authenticationNotifier, cUserAppInstitutionModel),
                  _buildSubCategoriaDropdown(
                      authenticationNotifier, cUserAppInstitutionModel),
                  _buildResetFilterButton(),
                  _buildOrderByDropdown(),
                  _buildNumberResultDropdown(),
                  const SizedBox(width: 8),
                ],
              ),
              Row(
                children: [
                  const SizedBox(width: 8),
                  _buildSearchField(context),
                  _buildCheckboxDeleted(context),
                  _buildCheckboxImage(context),
                  _buildExportButton(context),
                  const SizedBox(width: 8),
                ],
              ),
              SizedBox(
                height: 8,
              )
            ],
          );
        } else {
          // Layout a tre righe per schermi piccoli
          return Column(
            children: [
              Row(
                children: [
                  _buildCategoriaDropdown(
                      authenticationNotifier, cUserAppInstitutionModel),
                  _buildSubCategoriaDropdown(
                      authenticationNotifier, cUserAppInstitutionModel),
                  _buildNumberResultDropdown(),
                ],
              ),
              Row(
                children: [
                  const SizedBox(width: 8),
                  _buildSearchField(context),
                  const SizedBox(width: 8),
                  _buildResetFilterButton(),
                  const SizedBox(width: 8),
                  _buildOrderByDropdown(),
                ],
              ),
              Row(
                children: [
                  _buildOrderByDropdown(),
                  _buildCheckboxDeleted(context),
                  _buildCheckboxImage(context),
                  _buildExportButton(context),
                  const SizedBox(width: 8),
                ],
              ),
            ],
          );
        }
      },
    );
  }

  Widget _buildCategoriaDropdown(
      AuthenticationNotifier auth, UserAppInstitutionModel user) {
    return Expanded(
      flex: 2,
      child: Consumer<ProductCatalogNotifier>(
        builder: (context, notifier, _) {
          return FutureBuilder(
            future: notifier.getCategories(
              context: context,
              token: auth.token,
              idUserAppInstitution: user.idUserAppInstitution,
              idCategory: 0,
              levelCategory: 'FirstLevelCategory',
              readAlsoDeleted: false,
              numberResult: 'All',
              nameDescSearch: '',
              readImageData: false,
              orderBy: 'NameCategory',
            ),
            builder: (context, snapshot) {
              List<DropdownMenuItem<String>> items = [];
              if (snapshot.data != null) {
                var categories = snapshot.data as List<CategoryCatalogModel>;
                items = categories
                    .map((cat) => DropdownMenuItem(
                          child: Text(cat.nameCategory),
                          value: cat.idCategory.toString(),
                        ))
                    .toList();
              }
              return CustomDropDownButtonFormField(
                enabled: true,
                actualValue: selectedIdCategory,
                labelText: 'Categoria',
                listOfValue: items,
                onItemChanged: (value) => onChangeSelectedIdCategory(value),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildSubCategoriaDropdown(
      AuthenticationNotifier auth, UserAppInstitutionModel user) {
    return Expanded(
      flex: 2,
      child: Consumer<ProductCatalogNotifier>(
        builder: (context, notifier, _) {
          return FutureBuilder(
            future: notifier.getCategories(
              context: context,
              token: auth.token,
              idUserAppInstitution: user.idUserAppInstitution,
              idCategory: int.parse(selectedIdCategory ?? '0'),
              levelCategory: 'SubCategory',
              readAlsoDeleted: false,
              numberResult: 'All',
              nameDescSearch: '',
              readImageData: false,
              orderBy: 'NameCategory',
            ),
            builder: (context, snapshot) {
              List<DropdownMenuItem<String>> items = [];
              if (snapshot.data != null) {
                var categories = snapshot.data as List<CategoryCatalogModel>;
                items = categories
                    .map((cat) => DropdownMenuItem(
                          child: Text(cat.nameCategory),
                          value: cat.idCategory.toString(),
                        ))
                    .toList();
              }
              return CustomDropDownButtonFormField(
                enabled: true,
                actualValue: selectedIdSubCategory,
                labelText: 'Sottocategoria',
                listOfValue: items,
                onItemChanged: (value) => onChangeSelectedIdSubCategory(value),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildResetFilterButton() {
    return Padding(
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
            }),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchField(BuildContext context) {
    return Expanded(
      flex: 2,
      child: TextFormField(
        controller: nameDescSearchController,
        style: Theme.of(context)
            .textTheme
            .labelLarge!
            .copyWith(color: Colors.blueGrey),
        onChanged: (value) {
          if (_timer?.isActive ?? false) _timer!.cancel();
          _timer = Timer(const Duration(milliseconds: 1000), () {
            setState(() {
              iconaNameDescSearch = value.isEmpty
                  ? const Icon(Icons.search)
                  : const Icon(Icons.cancel);
            });
          });
        },
        decoration: InputDecoration(
          labelText: "Ricerca per nome, descrizione o barcode",
          hintText: "Ricerca per nome, descrizione o barcode",
          labelStyle: Theme.of(context)
              .textTheme
              .labelMedium!
              .copyWith(color: Colors.blueGrey),
          hintStyle: Theme.of(context)
              .textTheme
              .labelLarge!
              .copyWith(color: Theme.of(context).hintColor.withOpacity(0.3)),
          suffixIcon: IconButton(
            icon: iconaNameDescSearch,
            onPressed: () {
              setState(() {
                if (iconaNameDescSearch.icon == Icons.search) {
                  iconaNameDescSearch = const Icon(Icons.cancel);
                } else {
                  iconaNameDescSearch = const Icon(Icons.search);
                  nameDescSearchController.clear();
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
            borderSide: BorderSide(color: Colors.deepOrangeAccent, width: 1.0),
          ),
        ),
      ),
    );
  }

  Widget _buildOrderByDropdown() {
    return Expanded(
      flex: 1,
      child: CustomDropDownButtonFormField(
        enabled: true,
        actualValue: orderBy,
        labelText: 'Ordinamento',
        listOfValue: availableOrderBy,
        onItemChanged: (value) => onChangeOrderBy(value),
      ),
    );
  }

  Widget _buildNumberResultDropdown() {
    return Expanded(
      flex: 1,
      child: CustomDropDownButtonFormField(
        enabled: true,
        actualValue: numberResult,
        labelText: 'Mostra risultati',
        listOfValue: availableNumberResult,
        onItemChanged: (value) => onChangeNumberResult(value),
      ),
    );
  }

  Widget _buildCheckboxDeleted(BuildContext context) {
    return Expanded(
      flex: 1,
      child: _buildCheckboxTile(
        value: readAlsoDeleted,
        onChanged: (val) => setState(() => readAlsoDeleted = val!),
        title: 'Mostra anche cancellati',
        context: context,
      ),
    );
  }

  Widget _buildCheckboxImage(BuildContext context) {
    return Expanded(
      flex: 1,
      child: _buildCheckboxTile(
        value: readImageData,
        onChanged: (val) => setState(() => readImageData = val!),
        title: 'Visualizza immagine',
        context: context,
      ),
    );
  }

  Widget _buildExportButton(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: isDownloading,
      builder: (context, downloading, _) {
        return ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            fixedSize: const Size(170, 48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed:
              downloading ? null : () => handleDownloadProductCatalog(context),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              downloading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Icon(Icons.file_download_outlined),
              const SizedBox(width: 8),
              SizedBox(
                height: 20,
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    downloading ? ' Esportazione...' : 'Export Excel',
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

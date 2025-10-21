import 'package:currency_textfield/currency_textfield.dart';
import 'package:flutter/material.dart';

import 'package:np_casse/componenents/custom.multi.select.drop.down/src/multi_dropdown.dart';
import 'package:np_casse/componenents/custom.text.form.field.dart';
import 'package:np_casse/core/models/product.attribute.combination.model.dart';
import 'package:np_casse/core/models/product.attribute.mapping.model.dart';
import 'package:np_casse/core/models/product.attribute.value.model.dart';
import 'package:np_casse/core/models/product.catalog.model.dart';
import 'package:np_casse/core/models/user.app.institution.model.dart';
import 'package:np_casse/core/notifiers/authentication.notifier.dart';
import 'package:np_casse/core/notifiers/product.attribute.combination.notifier.dart';
import 'package:np_casse/core/notifiers/product.attribute.mapping.notifier.dart';
import 'package:np_casse/core/notifiers/product.catalog.notifier.dart';
import 'package:np_casse/core/notifiers/wishlist.product.notifier.dart';
import 'package:np_casse/core/themes/app.theme.dart';
import 'package:np_casse/core/utils/snackbar.util.dart';
import 'package:provider/provider.dart';

class ProductAttributeValueEditableListTile extends StatefulWidget {
  final ProductAttributeCombinationModel model;
  final Function(ProductAttributeCombinationModel listModel) onChanged;
  final Function(ProductAttributeCombinationModel listModel) onRemove;

  const ProductAttributeValueEditableListTile({
    super.key,
    required this.model,
    required this.onChanged,
    required this.onRemove,
  });

  @override
  _ProductAttributeValueEditableListTile createState() =>
      _ProductAttributeValueEditableListTile();
}

class _ProductAttributeValueEditableListTile
    extends State<ProductAttributeValueEditableListTile> {
  late ProductAttributeCombinationModel model;

  late bool isEditingMode;

  late TextEditingController barcodeEditingController, skuEditingController;
  CurrencyTextFieldController overriddenPriceEditingController =
      CurrencyTextFieldController();

  // List<String> customStringInserted = [];
  List<ProductAttributeJson> customProductAttributeJson = [];

  @override
  void initState() {
    super.initState();
    this.model = widget.model;
    this.isEditingMode = false;
    // customStringInserted = List.generate(
    //     model.productAttributeMappingModelList.length, (index) => '');

    customProductAttributeJson = List.generate(
        model.productAttributeMappingModelList.length,
        (index) => ProductAttributeJson(
            idProductAttribute: model
                .productAttributeMappingModelList[index].idProductAttribute,
            value: model.productAttributeJson
                    .where((element) =>
                        element.idProductAttribute ==
                        model.productAttributeMappingModelList[index]
                            .idProductAttribute)
                    .firstOrNull
                    ?.value ??
                ''));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: ListTile(
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.black, width: 1),
            borderRadius: BorderRadius.circular(8),
          ),
          trailing: Wrap(
            spacing: 12,
            children: <Widget>[
              tralingButtonEditConfirm,
              tralingButtonDelete,
            ],
          ),
          title: ListView(
            padding: const EdgeInsets.all(5),
            children: <Widget>[
              Container(
                height: 80,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.all(8),
                  itemCount: model.productAttributeMappingModelList.length,
                  itemBuilder: (BuildContext context, int i) {
                    var cSelectedProductAttributeModel =
                        model.productAttributeMappingModelList[i];

                    return Container(
                        width: 250,
                        height: 300,
                        margin: const EdgeInsets.all(3.0),
                        padding: const EdgeInsets.all(3.0),
                        // decoration:
                        //     BoxDecoration(border: Border.all(color: Colors.red)),
                        child: LayoutBuilder(builder: (context, constraints) {
                          var initialValueItem = model.productAttributeJson
                              .where((element) =>
                                  element.idProductAttribute ==
                                  cSelectedProductAttributeModel
                                      .idProductAttribute)
                              .firstOrNull;
                          String initialValueString =
                              initialValueItem?.value ?? '';
                          return RawAutocomplete<ProductAttributeValueModel>(
                            initialValue:
                                TextEditingValue(text: initialValueString),
                            optionsBuilder:
                                (TextEditingValue textEditingValue) {
                              if (textEditingValue.text == '') {
                                return cSelectedProductAttributeModel
                                    .productAttributeValueModelList;
                              }
                              return cSelectedProductAttributeModel
                                  .productAttributeValueModelList
                                  .where((ProductAttributeValueModel option) {
                                return option.name.toUpperCase().contains(
                                    textEditingValue.text.toUpperCase());
                              });
                            },
                            onSelected: (ProductAttributeValueModel selection) {
                              customProductAttributeJson[i].value =
                                  selection.name;
                            },
                            displayStringForOption: (option) {
                              return option.name;
                            },
                            fieldViewBuilder: (
                              BuildContext context,
                              TextEditingController textEditingController,
                              FocusNode focusNode,
                              VoidCallback onFieldSubmitted,
                            ) {
                              return CustomTextFormField(
                                onChanged: (String value) {
                                  customProductAttributeJson[i].value = value;
                                },
                                controller: textEditingController,
                                enabled: isEditingMode,
                                // validator: (value) =>
                                //     value!.toString().isEmpty
                                //         ? "Inserisci il comune"
                                //         : null,
                                focusNode: focusNode,
                                // onChanged: widget.onChanged,

                                labelText: cSelectedProductAttributeModel
                                    .productAttributeModel.name,
                                hintText: cSelectedProductAttributeModel
                                    .productAttributeModel.name,
                              );
                            },
                            optionsViewBuilder: (BuildContext context,
                                AutocompleteOnSelected<
                                        ProductAttributeValueModel>
                                    onSelected,
                                Iterable<ProductAttributeValueModel> options) {
                              return Align(
                                alignment: Alignment.topLeft,
                                child: Material(
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .inversePrimary),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10.0)),
                                  ),
                                  child: SizedBox(
                                    // height: 52.0 * options.length,
                                    height: 52.0 * options.length > 250
                                        ? 250
                                        : 52.0 * options.length,
                                    width: constraints
                                        .biggest.width, // <-- Right here !
                                    child: ListView.builder(
                                      padding: EdgeInsets.zero,
                                      itemCount: options.length,
                                      shrinkWrap: false,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        final ProductAttributeValueModel
                                            option = options.elementAt(index);
                                        return InkWell(
                                          onTap: () => onSelected(option),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                const Icon(Icons.store),
                                                Text(option.name)
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        }));
                    // Text(selectedProductAttributeModel[i]
                    //     .productAttributeModel
                    //     .name);
                  },
                ),
              ),
              Container(
                height: 70,
                child: Row(
                  children: [
                    Expanded(flex: 3, child: barcodeWidget),
                    Expanded(flex: 3, child: skuWidget),
                    Expanded(flex: 1, child: overriddePriceWidget),

                    //         Expanded(flex: 1, child: overriddePriceWidget),
                  ],
                ),
              ),
            ],
          )),
    );
  }

  Widget get barcodeWidget {
    barcodeEditingController = TextEditingController(text: model.barcode);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Tooltip(
        message: 'Barcode, se diverso dal barcode del prodotto',
        child: CustomTextFormField(
          enabled: isEditingMode,
          labelText: 'Barcode',
          controller: barcodeEditingController,
        ),
      ),
    );
  }

  Widget get skuWidget {
    skuEditingController = TextEditingController(text: model.sku);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Tooltip(
        message: 'Stock-keeping unit',
        child: CustomTextFormField(
          enabled: isEditingMode,
          labelText: 'Sku',
          controller: skuEditingController,
        ),
      ),
    );
  }

  Widget get overriddePriceWidget {
    overriddenPriceEditingController = CurrencyTextFieldController(
        decimalSymbol: ',',
        thousandSymbol: '',
        currencySeparator: '',
        currencySymbol: '',
        enableNegative: true,
        numberOfDecimals: 2,
        maxDigits: 8,
        initDoubleValue: model.overriddenPrice);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Tooltip(
        message: 'Prezzo se diverso dal prezzo del prodotto',
        child: CustomTextFormField(
          enabled: isEditingMode,
          // maxLength: 2,
          labelText: 'Prezzo',
          controller: overriddenPriceEditingController,
          suffixIcon: Icon(Icons.euro),
        ),
      ),
    );
  }

  Widget get tralingButtonEditConfirm {
    if (isEditingMode) {
      return IconButton(
        icon: Icon(Icons.check),
        onPressed: saveChange,
      );
    } else
      return IconButton(
        icon: Icon(Icons.edit),
        onPressed: _toggleMode,
      );
  }

  Widget get tralingButtonDelete {
    return IconButton(
      icon: Icon(Icons.remove_circle),
      onPressed: isEditingMode ? null : removeItem,
    );
  }

  void _toggleMode() {
    setState(() {
      isEditingMode = !isEditingMode;
    });
  }

  void saveChange() {
    this.model.barcode = barcodeEditingController.text;
    this.model.sku = skuEditingController.text;
    if (overriddenPriceEditingController.text.isNotEmpty) {
      this.model.overriddenPrice = double.tryParse(
              overriddenPriceEditingController.text.replaceAll(',', '.')) ??
          0;
    } else {
      this.model.overriddenPrice = null;
    }

    // this.model.customStringInserted = customStringInserted;
    this.model.productAttributeJson = customProductAttributeJson;
    _toggleMode();
    widget.onChanged(this.model);
  }

  void removeItem() {
    widget.onRemove(this.model);
  }

  onChangeParentCategory() {}
}

class ProductCatalogDetailAttributeScreen extends StatefulWidget {
  final ProductCatalogModel product;
  final List<ProductAttributeMappingModel> productAttributeMappingModel;
  const ProductCatalogDetailAttributeScreen({
    super.key,
    required this.product,
    required this.productAttributeMappingModel,
  });

  @override
  State<ProductCatalogDetailAttributeScreen> createState() =>
      _ProductAttributeDetailState();
}

class _ProductAttributeDetailState
    extends State<ProductCatalogDetailAttributeScreen> {
  int idProduct = 0;
  bool isEdit = false;
  int idProductAttribute = 0;
  final _formKey = GlobalKey<FormState>();
  final controller = MultiSelectController<ProductAttributeMappingModel>();
  List<ProductAttributeMappingModel> cProductAttributeMappingModel = [];
  List<DropdownItem<ProductAttributeMappingModel>> availableProductAttributes =
      [];
  List<ProductAttributeMappingModel> selectedProductAttributeModel = [];
  List<ProductAttributeCombinationModel>
      tempProductAttributeCombinationListModel = [];
  late bool buttonCreateVariantEnabled;

  var insertedVariant;

  void showNewVariant() {
    setState(() {
      tempProductAttributeCombinationListModel
          .add(ProductAttributeCombinationModel(
              productAttributeMappingModelList: selectedProductAttributeModel,
              idProductAttributeCombination: 0,
              barcode: '',
              sku: '',
              idProduct: idProduct,
              overriddenPrice: null,
              // customStringInserted: List.empty(),
              productAttributeJson: List.empty()));
    });
  }

  @override
  void initState() {
    super.initState();
    idProduct = widget.product.idProduct;
    isEdit = idProduct != 0;
    cProductAttributeMappingModel = widget.productAttributeMappingModel;
    selectedProductAttributeModel = cProductAttributeMappingModel
        .where((element) => element.idProductAttributeMapping != 0)
        .toList();

    availableProductAttributes.clear();
    int lenghtProductAttributeMappingModel =
        cProductAttributeMappingModel.length;
    for (int i = 0; i < lenghtProductAttributeMappingModel; i++) {
      var isPresent =
          cProductAttributeMappingModel[i].idProductAttributeMapping != 0;

      availableProductAttributes.add(DropdownItem(
          selected: isPresent,
          label: cProductAttributeMappingModel[i].productAttributeModel.name,
          value: cProductAttributeMappingModel[i]));
    }
    buttonCreateVariantEnabled = availableProductAttributes.isNotEmpty;
    tempProductAttributeCombinationListModel =
        widget.product.productAttributeCombination;
  }

  @override
  Widget build(BuildContext context) {
    AuthenticationNotifier authenticationNotifier =
        Provider.of<AuthenticationNotifier>(context);

    UserAppInstitutionModel? cUserAppInstitutionModel =
        authenticationNotifier.getSelectedUserAppInstitution();

    ProductCatalogNotifier productCatalogNotifier =
        Provider.of<ProductCatalogNotifier>(context);
    ProductAttributeMappingNotifier productAttributeMappingNotifier =
        Provider.of<ProductAttributeMappingNotifier>(context);

    ProductAttributeCombinationNotifier productAttributeCombinationNotifier =
        Provider.of<ProductAttributeCombinationNotifier>(context);

    WishlistProductNotifier wishlistProductNotifier =
        Provider.of<WishlistProductNotifier>(context);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: CustomColors.darkBlue,
        centerTitle: true,
        title: Text(
          '',
          // 'Dettaglio attributo prodotto: ${widget.productAttributeModelArgument.name}',
          style: Theme.of(context).textTheme.headlineLarge,
        ),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: MultiDropdown<ProductAttributeMappingModel>(
                    items: availableProductAttributes,
                    controller: controller,
                    enabled: true,
                    searchEnabled: true,
                    chipDecoration: ChipDecoration(
                      labelStyle:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      border: Border.all(width: 1.5),
                      backgroundColor: Colors.transparent,
                      wrap: true,
                      runSpacing: 2,
                      spacing: 10,
                    ),
                    fieldDecoration: FieldDecoration(
                      hintText: 'Selezionare gli attributi...',
                      hintStyle: Theme.of(context)
                          .textTheme
                          .labelMedium!
                          .copyWith(
                              color:
                                  Theme.of(context).hintColor.withOpacity(0.3)),
                      prefixIcon: const Icon(Icons.article_outlined),
                      showClearIcon: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Colors.black,
                        ),
                      ),
                    ),
                    // dropdownDecoration: const DropdownDecoration(
                    //   marginTop: 2,
                    //   maxHeight: 500,
                    //   header: Padding(
                    //     padding: EdgeInsets.all(8),
                    //     child: Text(
                    //       'Selezionare gli attributi dalla lista...',
                    //       textAlign: TextAlign.start,
                    //       style: TextStyle(
                    //         fontSize: 16,
                    //         fontWeight: FontWeight.bold,
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    dropdownItemDecoration: DropdownItemDecoration(
                      selectedIcon: const Icon(Icons.check_box,
                          color: CustomColors.darkBlue),
                      disabledIcon:
                          Icon(Icons.lock, color: Colors.grey.shade300),
                    ),
                    validator: (value) {
                      // if (value == null || value.isEmpty) {
                      //   return 'Please select a country';
                      // }
                      return null;
                    },
                    onSelectionChange: (selectedItems) {
                      setState(() {
                        selectedProductAttributeModel = selectedItems;
                        buttonCreateVariantEnabled = false;
                        tempProductAttributeCombinationListModel = [];
                      });
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Wrap(
                    spacing: 8,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).colorScheme.inversePrimary,
                            textStyle: const TextStyle(
                                fontSize: 12, fontWeight: FontWeight.bold)),
                        onPressed: () {
                          if (_formKey.currentState?.validate() ?? false) {
                            tempProductAttributeCombinationListModel = [];
                            List<ProductAttributeMappingModel>
                                productAttributeModelList = [];
                            for (int i = 0;
                                i < controller.selectedItems.length;
                                i++) {
                              productAttributeModelList
                                  .add(controller.selectedItems[i].value);
                            }
                            productAttributeMappingNotifier
                                .updateProductAttributeMapping(
                                    context: context,
                                    token: authenticationNotifier.token,
                                    idProduct: idProduct,
                                    idUserAppInstitution:
                                        cUserAppInstitutionModel
                                            .idUserAppInstitution,
                                    productAttributeMappingModelList:
                                        productAttributeModelList)
                                .then((value) {
                              if (value != null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackUtil.stylishSnackBar(
                                        title: "Gestione attributi",
                                        message:
                                            "Attributi correttamente creati",
                                        contentType: "success"));
                                //Navigator.of(context).pop();
                                // productAttributeMappingNotifier.refresh();

                                setState(() {
                                  cProductAttributeMappingModel = value;
                                  for (int i = 0;
                                      i < selectedProductAttributeModel.length;
                                      i++) {
                                    if (selectedProductAttributeModel[i]
                                        .productAttributeValueModelList
                                        .isEmpty) {
                                      var t = cProductAttributeMappingModel
                                          .singleWhere((element) =>
                                              element.idProductAttribute ==
                                              selectedProductAttributeModel[i]
                                                  .idProductAttribute)
                                          .productAttributeValueModelList;
                                      selectedProductAttributeModel[i]
                                          .productAttributeValueModelList
                                          .addAll(t);
                                    }
                                  }
                                  buttonCreateVariantEnabled =
                                      selectedProductAttributeModel.isNotEmpty;
                                });
                                // var t = availableProductAttributes;
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackUtil.stylishSnackBar(
                                        title: "Gestione attributi",
                                        message: "Errore di connessione",
                                        contentType: "failure"));
                                //Navigator.of(context).pop();
                              }
                            });
                          }
                        },
                        child: const Text('Genera attributi'),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).colorScheme.inversePrimary,
                            textStyle: const TextStyle(
                                fontSize: 12, fontWeight: FontWeight.bold)),
                        onPressed:
                            buttonCreateVariantEnabled ? showNewVariant : null,
                        child: const Text('Aggiungi variante'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  height: MediaQuery.of(context).size.height,
                  child: tempProductAttributeCombinationListModel.length > 0
                      ? ListView.builder(
                          itemCount:
                              tempProductAttributeCombinationListModel.length,
                          // // gridDelegate:
                          // //     new SliverGridDelegateWithFixedCrossAxisCount(
                          // //   crossAxisCount: 1,
                          // //   childAspectRatio: 15.0 / 1.0,
                          // //   mainAxisSpacing: 10.0,
                          // //   crossAxisSpacing: 10.0,
                          // ),
                          itemBuilder: (BuildContext context, int index) {
                            final item =
                                tempProductAttributeCombinationListModel[index];
                            item.productAttributeMappingModelList =
                                selectedProductAttributeModel;

                            return Container(
                              height: 180,
                              child: ProductAttributeValueEditableListTile(
                                key: ObjectKey(item),
                                model: tempProductAttributeCombinationListModel[
                                    index],
                                onChanged: (ProductAttributeCombinationModel
                                    updatedModel) {
                                  tempProductAttributeCombinationListModel[
                                      index] = updatedModel;
                                  //                                listPredefinedAttributeListModel[index] = updatedModel;
                                },
                                onRemove: (ProductAttributeCombinationModel
                                    removedModel) {
                                  tempProductAttributeCombinationListModel
                                      .remove(removedModel);
                                  setState(() {});
                                },
                              ),
                            );
                          },
                        )
                      : Text('Nessun valore predefinito inserito'),
                )
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(eccentricity: 0.5),
        onPressed: () {
          List<ProductAttributeMappingModel> productAttributeModelList = [];
          for (int i = 0; i < controller.selectedItems.length; i++) {
            productAttributeModelList.add(controller.selectedItems[i].value);
          }
          productAttributeCombinationNotifier
              .updateProductAttributeCombination(
                  context: context,
                  token: authenticationNotifier.token,
                  idProduct: idProduct,
                  idUserAppInstitution:
                      cUserAppInstitutionModel.idUserAppInstitution,
                  productAttributeCombinationModelList:
                      tempProductAttributeCombinationListModel)
              .then((value) {
            if (value) {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackUtil.stylishSnackBar(
                      title: "Gestione varianti",
                      message: "Informazioni aggiornate",
                      contentType: "success"));
              Navigator.of(context).pop();
              // productAttributeCombinationNotifier.refresh();
              productCatalogNotifier.refresh();
              // wishlistProductNotifier.refresh();
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackUtil.stylishSnackBar(
                      title: "Gestione varianti",
                      message: "Errore di connessione",
                      contentType: "failure"));
              //Navigator.of(context).pop();
            }
          });
        },
        //backgroundColor: Colors.deepOrangeAccent,
        child: const Icon(Icons.check),
      ),
    );
  }
}

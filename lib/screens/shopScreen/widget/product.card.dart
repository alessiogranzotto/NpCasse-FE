import 'package:currency_textfield/currency_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:np_casse/app/utilities/image_utils.dart';
import 'package:np_casse/componenents/custom.drop.down.button.form.field.field.dart';
import 'package:np_casse/core/models/cart.product.model.dart';
import 'package:np_casse/core/models/product.attribute.combination.model.dart';
import 'package:np_casse/core/models/product.catalog.model.dart';
import 'package:np_casse/core/models/product.category.mapping.model.dart';
import 'package:np_casse/core/models/user.app.institution.model.dart';
import 'package:np_casse/core/notifiers/authentication.notifier.dart';
import 'package:np_casse/core/notifiers/cart.notifier.dart';
import 'package:np_casse/core/notifiers/category.catalog.notifier.dart';
import 'package:np_casse/core/notifiers/product.catalog.notifier.dart';
import 'package:np_casse/core/notifiers/wishlist.product.notifier.dart';
import 'package:np_casse/core/utils/disable.focus.node.dart';
import 'package:np_casse/core/utils/snackbar.util.dart';
import 'package:provider/provider.dart';
import 'package:uiblock/uiblock.dart';

class ProductCard extends StatefulWidget {
  const ProductCard(
      {super.key,
      required this.productCatalog,
      required this.areAllWithNoImage,
      required this.comeFrom});
  final ProductCatalogModel productCatalog;
  final bool areAllWithNoImage;
  final String comeFrom;

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  ProductCatalogModel productCatalog = ProductCatalogModel.empty();
  List<String?> selectedValueVariant = [];
  List<DropdownMenuItem<ProductCategoryMappingModel>>
      tAvailableProductCategory = List.empty();
  ValueNotifier<double> priceNotifier = ValueNotifier<double>(0);
  // ValueNotifier<int> quantityForProductNotifier = ValueNotifier<int>(1);
  ValueNotifier<double> freePriceProductNotifier = ValueNotifier<double>(0);
  ValueNotifier<bool> wishListedNotifier = ValueNotifier<bool>(false);
  bool enableQuantity = false;
  bool enableVariants = false;
  bool enablePrice = false;
  ValueNotifier<bool> addToCartButtonEnabled = ValueNotifier<bool>(false);

  CurrencyTextFieldController textEditingControllerFreePriceProduct =
      CurrencyTextFieldController();

  TextEditingController textEditingControllerNoteProduct =
      TextEditingController();
  TextEditingController textEditingControllerQuantityForProduct =
      TextEditingController();
  int idCategory = 0;
  bool showCategoryProduct = false;
  bool _isCartButtonDisabled = false;
  bool checkEnableButton() {
    return enableQuantity && enablePrice && enableVariants;
  }

  void freePriceOnChange() {
    bool enablePrice = false;
    //final text = textEditingControllerFreePriceProduct.text;
    var value = double.tryParse(
        textEditingControllerFreePriceProduct.text.replaceAll(',', '.'));
    //var value = double.tryParse(text);
    if (value != null) {
      freePriceProductNotifier.value = value;
    } else {
      freePriceProductNotifier.value = 0;
    }
    if (freePriceProductNotifier.value > 0) {
      enablePrice = true;
    } else {
      enablePrice = false;
    }
    addToCartButtonEnabled.value = enablePrice && enableVariants;
  }

  void variantChanged(int index, String? value) {
    // Update the selected value for the variant at the specified index
    selectedValueVariant[index] = value;

    // Determine if all required variants are selected to enable further actions
    enableVariants = selectedValueVariant
        .every((value) => value != null && value.isNotEmpty);

    // Update the state of the Add to Cart button
    addToCartButtonEnabled.value = checkEnableButton();

    // Get the updated product price based on the current selections
    getProductPrice();
  }

  List<DropdownMenuItem<String>> getSelectableItems(int index) {
    return productCatalog.smartProductAttributeJson[index].value
        .where((element) {
          // Ensure that the current element can be selected based on the existing selections
          return productCatalog.productAttributeCombination.any((combination) {
            // Check if the combination matches the selected variants
            return selectedValueVariant.asMap().entries.every((entry) {
                  int i = entry.key; // Get the index of the variant
                  String? selectedValue =
                      entry.value; // Get the selected value for this index

                  // Skip the current index since we are evaluating options for it
                  if (i == index) return true;

                  // If a value is selected for this index, ensure it matches the combination
                  if (selectedValue != null && selectedValue.isNotEmpty) {
                    return combination.productAttributeJson.any((attr) =>
                        attr.value == selectedValue &&
                        attr.idProductAttribute ==
                            productCatalog.smartProductAttributeJson[i]
                                .idProductAttribute);
                  }

                  return true; // If no value is selected for this index, consider it compatible
                }) &&
                // Check if the current element can fit into this combination
                combination.productAttributeJson.any((attr) =>
                    attr.value == element.value &&
                    attr.idProductAttribute ==
                        productCatalog.smartProductAttributeJson[index]
                            .idProductAttribute);
          });
        })
        .map<String>((SmartProductAttributeJsonValue e) => e.value ?? '')
        .toSet() // Convert to Set to remove duplicates
        .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(value: value, child: Text(value));
        })
        .toList();
  }

  getProductPrice() {
    double result = priceNotifier.value;
    bool guard = selectedValueVariant.any((element) => element != null);
    if (guard) {
      List<String> parameters = [];
      for (int i = 0;
          i < productCatalog.smartProductAttributeJson.length;
          i++) {
        String p =
            (productCatalog.smartProductAttributeJson[i].nameProductAttribute) +
                '*=*' +
                (selectedValueVariant[i] ?? '');
        parameters.add(p);
      }
      AuthenticationNotifier authenticationNotifier =
          Provider.of<AuthenticationNotifier>(context, listen: false);
      UserAppInstitutionModel cUserAppInstitutionModel =
          authenticationNotifier.getSelectedUserAppInstitution();

      ProductCatalogNotifier productCatalogNotifier =
          Provider.of<ProductCatalogNotifier>(context, listen: false);

      productCatalogNotifier
          .getProductPrice(
              context: context,
              token: authenticationNotifier.token,
              idUserAppInstitution:
                  cUserAppInstitutionModel.idUserAppInstitution,
              idProduct: productCatalog.idProduct,
              parameters: parameters)
          .then((value) {
        result = value;
        priceNotifier.value = result;
        textEditingControllerFreePriceProduct.text = result.toStringAsFixed(2);
      });
    }
  }

  void quantityChange() {
    var q = int.tryParse(textEditingControllerQuantityForProduct.text);
    if (q != null && q > 0) {
      enableQuantity = true;
    } else {
      enableQuantity = false;
    }
    addToCartButtonEnabled.value = checkEnableButton();
  }

  @override
  void initState() {
    super.initState();
    _isCartButtonDisabled = false;
    productCatalog = widget.productCatalog;
    wishListedNotifier = ValueNotifier<bool>(productCatalog.wishlisted);
    priceNotifier = ValueNotifier<double>(productCatalog.priceProduct);

    if (widget.productCatalog.freePriceProduct) {
      freePriceProductNotifier = ValueNotifier(productCatalog.priceProduct);
    }
    textEditingControllerQuantityForProduct.text = "1";
    textEditingControllerQuantityForProduct.addListener(quantityChange);
    textEditingControllerFreePriceProduct = CurrencyTextFieldController(
        decimalSymbol: ',',
        thousandSymbol: '',
        currencySeparator: '',
        currencySymbol: '',
        enableNegative: false,
        numberOfDecimals: 2,
        initDoubleValue: productCatalog.priceProduct,
        maxDigits: 8);

    textEditingControllerFreePriceProduct.addListener(freePriceOnChange);
    selectedValueVariant = List.generate(
        productCatalog.smartProductAttributeJson.length, (index) => null);
    for (int i = 0; i < selectedValueVariant.length; i++) {
      var itemSelectedFromBarcode = productCatalog
          .smartProductAttributeJson[i].value
          .where((element) => element.selectedFromBarcode == true);
      if (itemSelectedFromBarcode.length > 0) {
        selectedValueVariant[i] = itemSelectedFromBarcode.first.value;
      }
    }

    enableQuantity = true;
    enablePrice =
        (productCatalog.priceProduct > 0 && productCatalog.freePriceProduct) ||
            (!productCatalog.freePriceProduct);
    enableVariants = selectedValueVariant.length == 0;
    if (selectedValueVariant.length > 0) {
      enableVariants = true;
      for (int i = 0; i < selectedValueVariant.length; i++) {
        if (selectedValueVariant[i]?.isEmpty ?? true) {
          enableVariants = false;
        }
      }
    }
    if (productCatalog.productCategoryMappingModel.length > 1) {
      tAvailableProductCategory = productCatalog.productCategoryMappingModel
          .map<DropdownMenuItem<ProductCategoryMappingModel>>(
              (ProductCategoryMappingModel item) {
        return DropdownMenuItem<ProductCategoryMappingModel>(
            value: item, child: Text(item.categoryModel.nameCategory));
      }).toList();
    }

    if (widget.comeFrom == "Wishlist") {
      idCategory = productCatalog.productCategoryMappingModel.first.idCategory;
      showCategoryProduct = true;
    } else if (widget.comeFrom == "Navigate") {
      CategoryCatalogNotifier categoryCatalogNotifier =
          Provider.of<CategoryCatalogNotifier>(context, listen: false);
      idCategory =
          categoryCatalogNotifier.getCurrentCategoryCatalog().idCategory;
      showCategoryProduct = false;
    } else if (widget.comeFrom == "Search") {
      idCategory = productCatalog.productCategoryMappingModel.isNotEmpty
          ? productCatalog.productCategoryMappingModel.first.idCategory
          : 0;
      showCategoryProduct = true;
    }
    addToCartButtonEnabled = ValueNotifier(checkEnableButton());
  }

  @override
  void dispose() {
    textEditingControllerQuantityForProduct.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AuthenticationNotifier authenticationNotifier =
        Provider.of<AuthenticationNotifier>(context);
    CartNotifier cartNotifier = Provider.of<CartNotifier>(context);
    WishlistProductNotifier wishlistProductNotifier =
        Provider.of<WishlistProductNotifier>(context);

    UserAppInstitutionModel? cUserAppInstitutionModel =
        authenticationNotifier.getSelectedUserAppInstitution();

    return Card(
      elevation: 8,
      child: Container(
        //margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  color: Theme.of(context).shadowColor.withOpacity(0.6),
                  offset: const Offset(0.0, 0.0), //(x,y)
                  blurRadius: 4.0,
                  blurStyle: BlurStyle.solid)
            ],
            //color: Colors.white,
            color: Theme.of(context).cardColor),

        child: Column(
          children: [
            widget.areAllWithNoImage
                ? const SizedBox.shrink()
                : Stack(children: <Widget>[
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 0),
                      height: widget.areAllWithNoImage ? 0 : 150,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: (ImageUtils.getImageFromStringBase64(
                                    stringImage: productCatalog.imageData)
                                .image)
                            // (project.imageProject as ImageProvider)
                            ),
                      ),
                    ),
                    productCatalog.outOfAssortment
                        ? Align(
                            alignment: Alignment.topRight,
                            child: CircleAvatar(
                              radius: 24,
                              backgroundColor:
                                  Theme.of(context).colorScheme.errorContainer,
                              child: Text("OUT",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium),
                            ),
                          )
                        : const SizedBox.shrink()
                  ]),
            SizedBox(
              height: 40,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  productCatalog.nameProduct,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
            ),
            // SizedBox(
            //   height: 30,
            //   child: Padding(
            //     padding: const EdgeInsets.symmetric(horizontal: 8.0),
            //     child: Text(
            //       productCatalog.descriptionProduct,
            //       maxLines: 1,
            //       overflow: TextOverflow.ellipsis,
            //       style: Theme.of(context).textTheme.bodyMedium,
            //     ),
            //   ),
            // ),

            productCatalog.productCategoryMappingModel.length > 1 &&
                    showCategoryProduct
                ? Container(
                    height: 60,
                    child: CustomDropDownButtonFormField(
                        actualValue: widget
                            .productCatalog.productCategoryMappingModel
                            .where(
                                (element) => element.idCategory == idCategory)
                            .first,
                        enabled: true,
                        onItemChanged: (value) {
                          var item = value as ProductCategoryMappingModel;
                          idCategory = item.idCategory;
                        },
                        listOfValue: tAvailableProductCategory))
                : Container(
                    height: 60,
                  ),

            Container(
              height: 140,
              child: GridView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: productCatalog.smartProductAttributeJson.length,
                gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  childAspectRatio: 4,
                  mainAxisSpacing: 2.0,
                  crossAxisSpacing: 2.0,
                ),
                itemBuilder: (BuildContext context, int index) {
                  var cSmartProductAttributeJson =
                      productCatalog.smartProductAttributeJson[index];

                  return SizedBox(
                    width: 100,
                    child: GestureDetector(
                      onTap: () {
                        // Clear the current selected value for the variant
                        selectedValueVariant[index] = null;
                        setState(() {}); // Refresh the UI
                      },
                      child: DropdownButtonFormField<String>(
                        focusNode: AlwaysDisabledFocusNode(),
                        style: Theme.of(context)
                            .textTheme
                            .labelMedium!
                            .copyWith(color: Colors.blueGrey),
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.shop),
                          labelText:
                              cSmartProductAttributeJson.nameProductAttribute,
                          labelStyle: Theme.of(context)
                              .textTheme
                              .labelMedium!
                              .copyWith(color: Colors.blueGrey),
                          hintText:
                              cSmartProductAttributeJson.nameProductAttribute,
                          hintStyle: Theme.of(context)
                              .textTheme
                              .labelLarge!
                              .copyWith(
                                  color: Theme.of(context)
                                      .hintColor
                                      .withOpacity(0.3)),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          border: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                            borderSide:
                                BorderSide(color: Colors.grey, width: 1.0),
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                            borderSide:
                                BorderSide(color: Colors.grey, width: 1.0),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                            borderSide:
                                BorderSide(color: Colors.blue, width: 1.0),
                          ),
                          errorBorder: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                            borderSide:
                                BorderSide(color: Colors.red, width: 1.0),
                          ),
                          focusedErrorBorder: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                            borderSide: BorderSide(
                                color: Colors.deepOrangeAccent, width: 1.0),
                          ),
                        ),
                        // hint: Text(
                        //   widget.hintText,
                        // ),
                        isExpanded: true,

                        validator: (value) =>
                            value == null ? 'field required' : null,

                        value: selectedValueVariant[index],

                        onChanged: (String? value) {
                          variantChanged(index, value);

                          setState(() {});
                        },
                        items: getSelectableItems(index),
                      ),
                    ),
                  );
                  // Text(selectedProductAttributeModel[i]
                  //     .productAttributeModel
                  //     .name);
                },
              ),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
              Row(
                children: [
                  productCatalog.freePriceProduct
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  width: 160,
                                  height: 40,
                                  child: ValueListenableBuilder<double>(
                                    builder: (BuildContext context,
                                        double value, Widget? child) {
                                      return TextFormField(
                                        maxLines: 1,
                                        textAlign: TextAlign.center,
                                        controller:
                                            textEditingControllerFreePriceProduct,
                                        keyboardType: const TextInputType
                                            .numberWithOptions(
                                            decimal: true, signed: false),
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium!
                                            .copyWith(
                                                fontWeight: FontWeight.w900),
                                        decoration: const InputDecoration(
                                          contentPadding: EdgeInsets.zero,
                                          suffixIcon: Icon(Icons.euro),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10.0)),
                                            borderSide: BorderSide(
                                                color: Colors.black,
                                                width: 0.2),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10.0)),
                                            borderSide: BorderSide(
                                                color: Colors.red, width: 0.2),
                                          ),
                                        ),
                                      );
                                    },
                                    valueListenable: freePriceProductNotifier,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: ValueListenableBuilder<double>(
                                builder: (BuildContext context, double value,
                                    Widget? child) {
                                  return CircleAvatar(
                                    radius: 32,
                                    backgroundColor: Theme.of(context)
                                        .colorScheme
                                        .secondaryContainer,
                                    child: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Text(
                                          "${priceNotifier.value.toStringAsFixed(2).replaceAll('.', ',')}€",
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineMedium),
                                    ),
                                  );
                                },
                                valueListenable: priceNotifier,
                              ),
                            ),
                            // Padding(
                            //   padding: const EdgeInsets.all(8.0),
                            //   child: Container(
                            //     decoration: BoxDecoration(
                            //       border: Border.all(
                            //         color:
                            //             Theme.of(context).colorScheme.onSurface,
                            //       ),
                            //       borderRadius: BorderRadius.circular(10),
                            //     ),
                            //     child: Row(
                            //       mainAxisAlignment: MainAxisAlignment.end,
                            //       mainAxisSize: MainAxisSize.min,
                            //       children: [
                            //         SizedBox(
                            //           child: IconButton(
                            //               onPressed: () {
                            //                 if (quantityForProductNotifier
                            //                         .value >
                            //                     0) {
                            //                   quantityForProductNotifier
                            //                       .value--;
                            //                 }
                            //                 if (quantityForProductNotifier
                            //                         .value >
                            //                     0) {
                            //                   enableQuantity = true;
                            //                 } else {
                            //                   enableQuantity = false;
                            //                 }
                            //                 addToCartButtonEnabled.value =
                            //                     checkEnableButton();
                            //               },
                            //               icon: const Icon(
                            //                   size: 20, Icons.remove)),
                            //         ),
                            //         SizedBox(
                            //           child: ValueListenableBuilder<int>(
                            //             builder: (BuildContext context,
                            //                 int value, Widget? child) {
                            //               return Text('$value',
                            //                   style: Theme.of(context)
                            //                       .textTheme
                            //                       .titleMedium!
                            //                       .copyWith(
                            //                           fontWeight:
                            //                               FontWeight.w900));
                            //             },
                            //             valueListenable:
                            //                 quantityForProductNotifier,
                            //           ),
                            //         ),
                            //         SizedBox(
                            //           child: IconButton(
                            //               onPressed: () {
                            //                 quantityForProductNotifier.value++;
                            //                 if (quantityForProductNotifier
                            //                         .value >
                            //                     0) {
                            //                   enableQuantity = true;
                            //                 } else {
                            //                   enableQuantity = false;
                            //                 }
                            //                 addToCartButtonEnabled.value =
                            //                     checkEnableButton();
                            //               },
                            //               icon:
                            //                   const Icon(size: 20, Icons.add)),
                            //         ),
                            //       ],
                            //     ),
                            //   ),
                            // ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SizedBox(
                                      child: IconButton(
                                          onPressed: () {
                                            var q = int.tryParse(
                                                textEditingControllerQuantityForProduct
                                                    .text);
                                            if (q == null) {
                                              textEditingControllerQuantityForProduct
                                                  .text = "1";
                                            } else {
                                              if (q >= 2) {
                                                q--;
                                                textEditingControllerQuantityForProduct
                                                    .text = q.toString();
                                              }
                                            }
                                          },
                                          icon: const Icon(
                                              size: 20, Icons.remove)),
                                    ),
                                    SizedBox(
                                      width: 40,
                                      child: TextFormField(
                                          textAlign: TextAlign.center,
                                          controller:
                                              textEditingControllerQuantityForProduct,
                                          keyboardType: TextInputType.number,
                                          inputFormatters: <TextInputFormatter>[
                                            FilteringTextInputFormatter
                                                .digitsOnly
                                          ],
                                          decoration: new InputDecoration(
                                            contentPadding: EdgeInsets.zero,
                                            border: InputBorder.none,
                                            focusedBorder: InputBorder.none,
                                            enabledBorder: InputBorder.none,
                                            errorBorder: InputBorder.none,
                                            disabledBorder: InputBorder.none,
                                          ),
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium!
                                              .copyWith(
                                                  fontWeight: FontWeight.w900)),
                                    ),
                                    SizedBox(
                                      child: IconButton(
                                          onPressed: () {
                                            var q = int.tryParse(
                                                textEditingControllerQuantityForProduct
                                                    .text);
                                            if (q == null) {
                                              textEditingControllerQuantityForProduct
                                                  .text = "1";
                                            } else {
                                              q++;
                                              textEditingControllerQuantityForProduct
                                                  .text = q.toString();
                                            }
                                          },
                                          icon:
                                              const Icon(size: 20, Icons.add)),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )
                ],
              ),
              Row(
                children: [
                  SizedBox(
                    height: 30,
                    width: 30,
                    child: ValueListenableBuilder<bool>(
                      builder:
                          (BuildContext context, bool value, Widget? child) {
                        return IconButton(
                          onPressed: () async {
                            productCatalog.wishlisted =
                                !productCatalog.wishlisted;
                            wishlistProductNotifier
                                .updateWishlistedProductState(
                                    context: context,
                                    token: authenticationNotifier.token,
                                    idUserAppInstitution:
                                        cUserAppInstitutionModel
                                            .idUserAppInstitution,
                                    idProduct: productCatalog.idProduct,
                                    state: productCatalog.wishlisted)
                                .then((value) {
                              if (value) {
                                if (!productCatalog.wishlisted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackUtil.stylishSnackBar(
                                          title: "Prodotti",
                                          message:
                                              '${productCatalog.nameProduct} rimosso dai preferiti',
                                          contentType: "success"));
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackUtil.stylishSnackBar(
                                          title: "Prodotti",
                                          message:
                                              '${productCatalog.nameProduct} aggiunto ai preferiti',
                                          contentType: "success"));
                                }
                                wishListedNotifier.value =
                                    productCatalog.wishlisted;
                                //wishlistProductNotifier.refresh();
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackUtil.stylishSnackBar(
                                        title: "Prodotti",
                                        message: "Errore di connessione",
                                        contentType: "success"));
                              }
                            });
                          },
                          icon: productCatalog.wishlisted
                              ? const Icon(
                                  Icons.favorite,
                                  color: Colors.red,
                                  size: 20,
                                )
                              : const Icon(
                                  Icons.favorite_border,
                                  size: 20,
                                ),
                        );
                      },
                      valueListenable: wishListedNotifier,
                    ),
                  ),
                  SizedBox(
                    height: 30,
                    width: 30,
                    child: ValueListenableBuilder<bool>(
                      builder:
                          (BuildContext context, bool value, Widget? child) {
                        return IconButton(
                          color: addToCartButtonEnabled.value
                              ? Colors.black
                              : Colors.grey,
                          onPressed: () {
                            if (!addToCartButtonEnabled.value) {
                              return;
                            } else {
                              UIBlock.block(context);
                              addToCartButtonEnabled.value = false;
                              int quantity = 0;
                              var q = int.tryParse(
                                  textEditingControllerQuantityForProduct.text);
                              if (q != null) {
                                quantity = q;
                              }
                              if (productCatalog.freePriceProduct) {
                                quantity = 1;
                              }
                              List<CartProductVariants> cartProductVariants =
                                  [];
                              for (int i = 0;
                                  i <
                                      productCatalog
                                          .smartProductAttributeJson.length;
                                  i++) {
                                CartProductVariants v = CartProductVariants(
                                    idProductAttribute: productCatalog
                                        .smartProductAttributeJson[i]
                                        .idProductAttribute,
                                    nameProductAttribute: productCatalog
                                        .smartProductAttributeJson[i]
                                        .nameProductAttribute,
                                    valueVariant:
                                        selectedValueVariant[i] ?? '');

                                cartProductVariants.add(v);
                              }
                              cartNotifier
                                  .addToCart(
                                      context: context,
                                      token: authenticationNotifier.token,
                                      idUserAppInstitution:
                                          cUserAppInstitutionModel
                                              .idUserAppInstitution,
                                      idProduct: productCatalog.idProduct,
                                      idCategory: idCategory,
                                      quantity: quantity,
                                      price: productCatalog.freePriceProduct
                                          ? freePriceProductNotifier.value
                                          : priceNotifier.value,
                                      cartProductVariants: cartProductVariants,
                                      notes:
                                          textEditingControllerNoteProduct.text)
                                  .then((value) {
                                addToCartButtonEnabled.value = true;
                                UIBlock.unblock(context);
                                if (value) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackUtil.stylishSnackBar(
                                          title: "Prodotti",
                                          message:
                                              '$quantity x ${productCatalog.nameProduct} aggiunti al carrello',
                                          contentType: "success"));
                                  textEditingControllerNoteProduct.clear();
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackUtil.stylishSnackBar(
                                          title: "Prodotti",
                                          message: "Errore di connessione",
                                          contentType: "failure"));
                                }
                              });
                            }
                          },
                          icon: const Icon(Icons.shopping_cart),
                        );
                      },
                      valueListenable: addToCartButtonEnabled,
                    ),
                  ),
                ],
              ),
            ]),
            Padding(
              padding: const EdgeInsets.only(
                  top: 16.0, bottom: 0.0, left: 4.0, right: 4.0),
              child: SizedBox(
                height: 100,
                child: Column(
                  children: [
                    Tooltip(
                      message: 'Note prodotto',
                      child: Card(
                        color: Theme.of(context).cardColor,
                        elevation: 4,
                        child: ListTile(
                          title: Text(
                            'Note prodotto',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          subtitle: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: textEditingControllerNoteProduct,
                                  minLines: 1,
                                  maxLines: 2,
                                  onTapOutside: (event) {
                                    FocusManager.instance.primaryFocus
                                        ?.unfocus();
                                  },
                                ),
                              ),
                            ],
                          ),
                          // trailing: const Icon(Icons.edit),
                          onTap: () {},
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

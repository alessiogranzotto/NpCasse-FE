import 'package:currency_textfield/currency_textfield.dart';
import 'package:flutter/material.dart';
import 'package:np_casse/app/utilities/image_utils.dart';
import 'package:np_casse/componenents/custom.drop.down.button.form.field.field.dart';
import 'package:np_casse/core/models/category.catalog.model.dart';
import 'package:np_casse/core/models/product.attribute.combination.model.dart';
import 'package:np_casse/core/models/product.catalog.model.dart';
import 'package:np_casse/core/models/product.model.dart';
import 'package:np_casse/core/models/user.app.institution.model.dart';
import 'package:np_casse/core/notifiers/authentication.notifier.dart';
import 'package:np_casse/core/notifiers/cart.notifier.dart';
import 'package:np_casse/core/notifiers/category.catalog.notifier.dart';
import 'package:np_casse/core/notifiers/product.catalog.notifier.dart';
import 'package:np_casse/core/notifiers/product.notifier.dart';
import 'package:np_casse/core/notifiers/wishlist.product.notifier.dart';
import 'package:np_casse/core/utils/disable.focus.node.dart';
import 'package:np_casse/core/utils/snackbar.util.dart';
import 'package:provider/provider.dart';

class ProductCard extends StatefulWidget {
  const ProductCard({
    super.key,
    required this.productCatalog,
    required this.areAllWithNoImage,
    required this.comeFromWishList,
  });
  final ProductCatalogModel productCatalog;
  final bool areAllWithNoImage;
  final bool comeFromWishList;

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  ProductCatalogModel productCatalog = ProductCatalogModel.empty();
  List<String?> selectedValueVariant = [];

  void variantChanged(int index, String? value) {
    int totalNrVariant = productCatalog.smartProductAttributeJson.length;
    selectedValueVariant[index] = value!;

//DELLA COMBO SELEZIONATA RECUPERO GLI INDICI CHE SI ABBINANO
    List<int> machingInt = [];
    for (int i = 0;
        i < productCatalog.smartProductAttributeJson[index].value.length;
        i++) {
      if (productCatalog.smartProductAttributeJson[index].value[i].value ==
          value) {
        print(i);
        machingInt.add(i);
      }
    }
    print(machingInt);
    for (int i = 0; i < productCatalog.smartProductAttributeJson.length; i++) {
      if (i != index) {
        for (int j = 0;
            j < productCatalog.smartProductAttributeJson[i].value.length;
            j++) {
          if (machingInt.contains(j)) {
            productCatalog.smartProductAttributeJson[i].value[j].selectable =
                true;
          } else {
            productCatalog.smartProductAttributeJson[i].value[j].selectable =
                false;
          }
        }
      }
    }
  }

  Future<String> getProductPrice() async {
    String result = productCatalog.priceProduct.toString();

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

      List<DropdownMenuItem<String>> tAvailableLevelCategory = [];

      await productCatalogNotifier
          .getProductPrice(
              context: context,
              token: authenticationNotifier.token,
              idUserAppInstitution:
                  cUserAppInstitutionModel.idUserAppInstitution,
              idProduct: productCatalog.idProduct,
              parameters: parameters)
          .then((value) {
        var t = value as List<CategoryCatalogModel>;
        result = t.first.nameCategory;
        tAvailableLevelCategory.add(
          DropdownMenuItem(child: Text('Selezionare la categoria'), value: '0'),
        );
        for (int i = 0; i < value.length; i++) {
          tAvailableLevelCategory.add(
            DropdownMenuItem(
                child: Text(value[i].nameCategory),
                value: value[i].idCategory.toString()),
          );
        }
      });
    }

    return result;
  }

  @override
  void initState() {
    super.initState();
    productCatalog = widget.productCatalog;
    selectedValueVariant = List.generate(
        productCatalog.smartProductAttributeJson.length, (index) => null);
    // selectedProductAttributeJson =
    //     List<List<ProductAttributeJson>>.empty(growable: true);
    // for (int i = 0;
    //     i < productCatalog.productAttributeCombination.length;
    //     i++) {
    //   for (int j = 0;
    //       i <
    //           productCatalog
    //               .productAttributeCombination[i].productAttributeJson.length;
    //       j++) {
    //     ProductAttributeJson cProductAttributeJson = ProductAttributeJson(
    //         idProductAttribute: productCatalog.productAttributeCombination[i]
    //             .productAttributeJson[j].idProductAttribute,
    //         value: productCatalog
    //             .productAttributeCombination[i].productAttributeJson[j].value);

    //     selectedProductAttributeJson[j].add(cProductAttributeJson);
    //   }
    // }
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

    ValueNotifier<int> quantityForProduct = ValueNotifier(1);

    ValueNotifier<double> freePriceProduct = ValueNotifier(0);
    if (widget.productCatalog.freePriceProduct) {
      freePriceProduct = ValueNotifier(productCatalog.priceProduct);
    }
    ValueNotifier<bool> addToCartButtonEnabled = ValueNotifier(
        (productCatalog.priceProduct > 0 && productCatalog.freePriceProduct) ||
            (!productCatalog.freePriceProduct && quantityForProduct.value > 0));

    CurrencyTextFieldController textEditingControllerFreePriceProduct =
        CurrencyTextFieldController(
            decimalSymbol: ',',
            thousandSymbol: '',
            currencySeparator: '',
            currencySymbol: '',
            enableNegative: false,
            numberOfDecimals: 2,
            initDoubleValue: productCatalog.priceProduct,
            maxDigits: 8);

    void freePriceOnChange() {
      //final text = textEditingControllerFreePriceProduct.text;
      var value = double.tryParse(
          textEditingControllerFreePriceProduct.text.replaceAll(',', '.'));
      //var value = double.tryParse(text);
      if (value != null) {
        freePriceProduct.value = value;
      } else {
        freePriceProduct.value = 0;
      }
      if (freePriceProduct.value > 0) {
        addToCartButtonEnabled.value = true;
      } else {
        addToCartButtonEnabled.value = false;
        // if (textEditingControllerFreePriceProduct.text == "") {
        //   textEditingControllerFreePriceProduct.text = "0";
        // }
      }
    }

    textEditingControllerFreePriceProduct.addListener(freePriceOnChange);

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
              height: 60,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  productCatalog.nameProduct,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
            ),
            SizedBox(
              height: 50,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  productCatalog.descriptionProduct,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ),
            Container(
              color: Colors.amber[600],
              height: 200,
              child: GridView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: productCatalog.smartProductAttributeJson.length,
                gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  childAspectRatio: 4,
                  mainAxisSpacing: 2.0,
                  crossAxisSpacing: 5.0,
                ),
                itemBuilder: (BuildContext context, int index) {
                  var cSmartProductAttributeJson =
                      productCatalog.smartProductAttributeJson[index];

                  return SizedBox(
                    width: 100,
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
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide:
                              BorderSide(color: Colors.grey, width: 1.0),
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide:
                              BorderSide(color: Colors.grey, width: 1.0),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide:
                              BorderSide(color: Colors.blue, width: 1.0),
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
                      items: cSmartProductAttributeJson.value
                          .where((element) => element.selectable)
                          .toSet()
                          .map<DropdownMenuItem<String>>(
                              (SmartProductAttributeJsonValue value) {
                        var text =
                            (value.value ?? '') + (value.descPrice ?? '');
                        return DropdownMenuItem<String>(
                            value: value.value, child: Text(text));
                      }).toList(),
                    ),
                  );
                  // Text(selectedProductAttributeModel[i]
                  //     .productAttributeModel
                  //     .name);
                },
              ),
            ),
            FutureBuilder<String>(
              future: getProductPrice(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return CircleAvatar(
                    radius: 32,
                    backgroundColor:
                        Theme.of(context).colorScheme.secondaryContainer,
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text("${snapshot.data!.toString()}€",
                          style: Theme.of(context).textTheme.headlineMedium),
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }

                // By default, show a loading spinner.
                return const CircularProgressIndicator();
              },
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
                                color:
                                    Theme.of(context).colorScheme.onBackground,
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
                                        textAlignVertical:
                                            TextAlignVertical.top,
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
                                    valueListenable: freePriceProduct,
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
                              child: CircleAvatar(
                                radius: 32,
                                backgroundColor: Theme.of(context)
                                    .colorScheme
                                    .secondaryContainer,
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Text(
                                      "${productCatalog.priceProduct.toStringAsFixed(2)}€",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineMedium),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onBackground,
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
                                            if (quantityForProduct.value > 0) {
                                              quantityForProduct.value--;
                                            }
                                            if (quantityForProduct.value > 0) {
                                              addToCartButtonEnabled.value =
                                                  true;
                                            } else {
                                              addToCartButtonEnabled.value =
                                                  false;
                                            }
                                          },
                                          icon: const Icon(
                                              size: 20, Icons.remove)),
                                    ),
                                    SizedBox(
                                      child: ValueListenableBuilder<int>(
                                        builder: (BuildContext context,
                                            int value, Widget? child) {
                                          return Text('$value',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleMedium!
                                                  .copyWith(
                                                      fontWeight:
                                                          FontWeight.w900));
                                        },
                                        valueListenable: quantityForProduct,
                                      ),
                                    ),
                                    SizedBox(
                                      child: IconButton(
                                          onPressed: () {
                                            quantityForProduct.value++;
                                            if (quantityForProduct.value > 0) {
                                              addToCartButtonEnabled.value =
                                                  true;
                                            } else {
                                              addToCartButtonEnabled.value =
                                                  false;
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
                            wishlistProductNotifier
                                .updateWishlistedProductState(
                                    context: context,
                                    token: authenticationNotifier.token,
                                    idUserAppInstitution:
                                        cUserAppInstitutionModel
                                            .idUserAppInstitution,
                                    idProduct: productCatalog.idProduct,
                                    state: !productCatalog.isWishlisted.value)
                                .then((value) {
                              if (value) {
                                if (productCatalog.isWishlisted.value) {
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
                                productCatalog.isWishlisted.value =
                                    !productCatalog.isWishlisted.value;
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackUtil.stylishSnackBar(
                                        title: "Prodotti",
                                        message: "Errore di connessione",
                                        contentType: "success"));
                              }
                            });
                          },
                          icon: productCatalog.isWishlisted.value
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
                      valueListenable: productCatalog.isWishlisted,
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
                            int quantity = 0;
                            quantity = quantityForProduct.value;
                            if (addToCartButtonEnabled.value) {
                              if (productCatalog.freePriceProduct) {
                                quantity = 1;
                              }
                              cartNotifier
                                  .addToCart(
                                      context: context,
                                      token: authenticationNotifier.token,
                                      idUserAppInstitution:
                                          cUserAppInstitutionModel
                                              .idUserAppInstitution,
                                      idProduct: productCatalog.idProduct,
                                      quantity: quantity,
                                      freePrice: freePriceProduct.value)
                                  .then((value) {
                                if (value) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackUtil.stylishSnackBar(
                                          title: "Prodotti",
                                          message:
                                              '$quantity x ${productCatalog.nameProduct} aggiunti al carrello',
                                          contentType: "success"));

                                  // Navigator.of(context)
                                  //     .pushNamed(AppRouter.homeRoute);
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackUtil.stylishSnackBar(
                                          title: "Prodotti",
                                          message: "Errore di connessione",
                                          contentType: "success"));
                                }
                              });
                            } else {
                              null;
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
          ],
        ),
      ),
    );
  }
}

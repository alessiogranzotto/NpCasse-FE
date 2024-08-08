// import 'package:flutter/material.dart';
// import 'package:np_casse/app/routes/app_routes.dart';
// import 'package:np_casse/app/utilities/image_utils.dart';
// import 'package:np_casse/core/models/user.app.institution.model.dart';
// import 'package:np_casse/core/notifiers/authentication.notifier.dart';
// import 'package:np_casse/core/notifiers/cart.notifier.dart';
// import 'package:np_casse/core/notifiers/product.card.notifier.dart';
// import 'package:np_casse/core/notifiers/userAppInstitution.notifier.dart';
// import 'package:np_casse/core/utils/snackbar.util.dart';
// import 'package:np_casse/screens/productScreen/product.detail.screen.dart';
// import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
// import 'package:provider/provider.dart';
// import 'package:np_casse/core/models/product.model.dart';
// import 'package:np_casse/core/notifiers/product.notifier.dart';

// class ProductCard extends StatefulWidget {
//   const ProductCard({Key? key, required this.product}) : super(key: key);
//   final ProductModel product;

//   @override
//   State<ProductCard> createState() => _ProductCardState();
// }

// class _ProductCardState extends State<ProductCard> {
//   @override
//   Widget build(BuildContext context) {
//     // UserAppInstitutionNotifier userAppInstitutionNotifier =
//     //     Provider.of<UserAppInstitutionNotifier>(context);
//     AuthenticationNotifier authenticationNotifier =
//         Provider.of<AuthenticationNotifier>(context);
//     ProductNotifier productNotifier = Provider.of<ProductNotifier>(context);
//     CartNotifier cartNotifier = Provider.of<CartNotifier>(context);
//     ProductCardNotifier productCardNotifier =
//         Provider.of<ProductCardNotifier>(context);

//     UserAppInstitutionModel cUserAppInstitutionModel =
//         authenticationNotifier.getSelectedUserAppInstitution();

//     productCardNotifier.setInitialQuantity(widget.product.idProduct);

//     return StatefulBuilder(
//       builder: (BuildContext context, StateSetter setState) {
//         return Card(
//           elevation: 8,
//           child: Container(
//             //margin: const EdgeInsets.all(2),
//             decoration: BoxDecoration(
//                 boxShadow: [
//                   BoxShadow(
//                       color: Theme.of(context).shadowColor.withOpacity(0.6),
//                       offset: const Offset(0.0, 0.0), //(x,y)
//                       blurRadius: 4.0,
//                       blurStyle: BlurStyle.solid)
//                 ],
//                 //color: Colors.white,
//                 color: Theme.of(context).cardColor),

//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Container(
//                   height: 150,
//                   decoration: BoxDecoration(
//                     image: DecorationImage(
//                         fit: BoxFit.fitHeight,
//                         image: (ImageUtils.getImageFromString(
//                                 stringImage: widget.product.imageProduct)
//                             .image)
//                         // (product.imageProduct as ImageProvider)
//                         ),
//                   ),
//                 ),
//                 Row(
//                   children: [
//                     Column(
//                       children: [
//                         Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Text(
//                             widget.product.nameProduct, //
//                             maxLines: 2,
//                             overflow: TextOverflow.ellipsis,
//                             style: Theme.of(context).textTheme.titleSmall,
//                           ),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                           child: Text(
//                             widget.product.descriptionProduct,
//                             maxLines: 3,
//                             overflow: TextOverflow.ellipsis,
//                             style: Theme.of(context).textTheme.bodyMedium,
//                           ),
//                         ),
//                       ],
//                     ),
//                     Expanded(
//                       child: Container(
//                         alignment: Alignment.topRight,
//                         child: Padding(
//                           padding: const EdgeInsets.all(20.0),
//                           child: Text(
//                             '€ ${widget.product.priceProduct.toString()}',
//                             style: Theme.of(context).textTheme.titleMedium,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(
//                   height: 10,
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: [
//                     Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         SizedBox(
//                           height: 30,
//                           width: 130,
//                           child: Row(
//                             children: [
//                               IconButton(
//                                   onPressed: () {
//                                     setState(() =>
//                                         productCardNotifier.subtractQuantity(
//                                             widget.product.idProduct));
//                                   },
//                                   icon: const Icon(Icons.remove)),
//                               Text(
//                                 productCardNotifier
//                                     .getQuantity(widget.product.idProduct),
//                                 style: Theme.of(context).textTheme.titleMedium,
//                               ),
//                               IconButton(
//                                   onPressed: () {
//                                     setState(() => productCardNotifier
//                                         .addQuantity(widget.product.idProduct));
//                                   },
//                                   icon: const Icon(Icons.add)),
//                             ],
//                           ),
//                         ),
//                         const SizedBox(
//                           width: 1,
//                         ),
//                         SizedBox(
//                           height: 30,
//                           width: 110,
//                           child: ElevatedButton(
//                             style: ButtonStyle(
//                                 foregroundColor:
//                                     MaterialStateProperty.all<Color>(
//                                         Colors.white),
//                                 backgroundColor:
//                                     MaterialStateProperty.all<Color>(
//                                         Colors.red),
//                                 shape: MaterialStateProperty.all<
//                                         RoundedRectangleBorder>(
//                                     RoundedRectangleBorder(
//                                         borderRadius:
//                                             BorderRadius.circular(18.0),
//                                         side: const BorderSide(
//                                             color: Colors.red)))),
//                             child: const Icon(Icons.shopping_cart),
//                             onPressed: () {
//                               cartNotifier
//                                   .addToCart(
//                                       context: context,
//                                       token: authenticationNotifier.token,
//                                       idUserAppInstitution:
//                                           cUserAppInstitutionModel
//                                               .idUserAppInstitution,
//                                       idProduct: widget.product.idProduct,
//                                       quantity: int.tryParse(
//                                               productCardNotifier.getQuantity(
//                                                   widget.product.idProduct)) ??
//                                           1)
//                                   .then((value) {
//                                 if (value) {
//                                   ScaffoldMessenger.of(context).showSnackBar(
//                                     SnackUtil.stylishSnackBar(
//                                       text: 'Added To Cart',
//                                       context: context,
//                                     ),
//                                   );
//                                   Navigator.of(context)
//                                       .pushNamed(AppRouter.homeRoute);
//                                 } else {
//                                   ScaffoldMessenger.of(context).showSnackBar(
//                                     SnackUtil.stylishSnackBar(
//                                       text: 'Oops Something Went Wrong',
//                                       context: context,
//                                     ),
//                                   );
//                                 }
//                               });
//                             },
//                           ),
//                         ),
//                       ],
//                     )
//                   ],
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Row(
//                         mainAxisSize: MainAxisSize.max,
//                         children: [
//                           SizedBox(
//                             height: 30,
//                             width: 30,
//                             child: IconButton(
//                                 onPressed: () {
//                                   // projectNotifier.wishlistingProject(
//                                   //     context: context,
//                                   //     token: authenticationNotifier.token,
//                                   //     idUserAppInstitution:
//                                   //         UserAppInstitutionNotifier.getidUserAppInstitution,
//                                   //     projectModel: project);
//                                 },
//                                 icon: const Icon(
//                                   Icons.favorite_border,
//                                   size: 20,
//                                 )),
//                           ),
//                           SizedBox(
//                             height: 30,
//                             width: 30,
//                             child: IconButton(
//                                 onPressed: () async {
//                                   productNotifier.setProduct(widget.product);
//                                   PersistentNavBarNavigator.pushNewScreen(
//                                       context,
//                                       screen: ProductDetailScreen(
//                                         productModelArgument: ProductModel(
//                                             idProduct: widget.product.idProduct,
//                                             idStore: widget.product.idStore,
//                                             nameProduct:
//                                                 widget.product.nameProduct,
//                                             descriptionProduct: widget
//                                                 .product.descriptionProduct,
//                                             priceProduct:
//                                                 widget.product.priceProduct,
//                                             imageProduct:
//                                                 widget.product.imageProduct),
//                                       ),
//                                       withNavBar: true,
//                                       pageTransitionAnimation:
//                                           PageTransitionAnimation.fade);
//                                 },
//                                 icon: const Icon(
//                                   Icons.edit,
//                                   size: 20,
//                                 )),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

import 'package:currency_textfield/currency_textfield.dart';
import 'package:flutter/material.dart';
import 'package:np_casse/app/utilities/image_utils.dart';
import 'package:np_casse/core/models/product.model.dart';
import 'package:np_casse/core/models/user.app.institution.model.dart';
import 'package:np_casse/core/notifiers/authentication.notifier.dart';
import 'package:np_casse/core/notifiers/cart.notifier.dart';
import 'package:np_casse/core/notifiers/product.notifier.dart';
import 'package:np_casse/core/notifiers/wishlist.product.notifier.dart';
import 'package:np_casse/core/utils/snackbar.util.dart';
import 'package:np_casse/screens/productScreen/product.detail.screen.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:provider/provider.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.product,
    required this.areAllWithNoImage,
    required this.comeFromWishList,
  });
  final ProductModel product;
  final bool areAllWithNoImage;
  final bool comeFromWishList;

  @override
  Widget build(BuildContext context) {
    AuthenticationNotifier authenticationNotifier =
        Provider.of<AuthenticationNotifier>(context);
    ProductNotifier productNotifier = Provider.of<ProductNotifier>(context);
    CartNotifier cartNotifier = Provider.of<CartNotifier>(context);
    WishlistProductNotifier wishlistProductNotifier =
        Provider.of<WishlistProductNotifier>(context);

    UserAppInstitutionModel? cUserAppInstitutionModel =
        authenticationNotifier.getSelectedUserAppInstitution();

    ValueNotifier<int> quantityForProduct = ValueNotifier(1);

    ValueNotifier<double> freePriceProduct = ValueNotifier(0);
    if (product.isFreePriceProduct) {
      freePriceProduct = ValueNotifier(product.priceProduct);
    }
    ValueNotifier<bool> addToCartButtonEnabled = ValueNotifier(
        (product.priceProduct > 0 && product.isFreePriceProduct) ||
            (!product.isFreePriceProduct && quantityForProduct.value > 0));

    CurrencyTextFieldController textEditingControllerFreePriceProduct =
        CurrencyTextFieldController(
            decimalSymbol: ',',
            thousandSymbol: '',
            currencySeparator: '',
            currencySymbol: '',
            enableNegative: false,
            numberOfDecimals: 2,
            initDoubleValue: product.priceProduct,
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
            areAllWithNoImage
                ? const SizedBox.shrink()
                : Stack(children: <Widget>[
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 0),
                      height: areAllWithNoImage ? 0 : 150,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: (ImageUtils.getImageFromStringBase64(
                                    stringImage: product.imageProduct)
                                .image)
                            // (project.imageProject as ImageProvider)
                            ),
                      ),
                    ),
                    product.isOutOfAssortment
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
                  product.nameProduct,
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
                  product.descriptionProduct,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
              Row(
                children: [
                  product.isFreePriceProduct
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
                                      "${product.priceProduct.toStringAsFixed(2)}€",
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
                                    idProduct: product.idProduct,
                                    state: !product.isWishlisted.value)
                                .then((value) {
                              if (value) {
                                if (product.isWishlisted.value) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackUtil.stylishSnackBar(
                                          title: "Prodotti",
                                          message:
                                              '${product.nameProduct} rimosso dai preferiti',
                                          contentType: "success"));
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackUtil.stylishSnackBar(
                                          title: "Prodotti",
                                          message:
                                              '${product.nameProduct} aggiunto ai preferiti',
                                          contentType: "success"));
                                }
                                product.isWishlisted.value =
                                    !product.isWishlisted.value;
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackUtil.stylishSnackBar(
                                        title: "Prodotti",
                                        message: "Errore di connessione",
                                        contentType: "success"));
                              }
                            });
                          },
                          icon: product.isWishlisted.value
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
                      valueListenable: product.isWishlisted,
                    ),
                  ),
                  comeFromWishList
                      ? const Divider(height: 0)
                      : SizedBox(
                          height: 30,
                          width: 30,
                          child: IconButton(
                              onPressed: () {
                                productNotifier.setProduct(product);
                                PersistentNavBarNavigator.pushNewScreen(context,
                                    screen: ProductDetailScreen(
                                      productModelArgument: ProductModel(
                                          idProduct: product.idProduct,
                                          idStore: product.idStore,
                                          nameProduct: product.nameProduct,
                                          descriptionProduct:
                                              product.descriptionProduct,
                                          priceProduct: product.priceProduct,
                                          imageProduct: product.imageProduct,
                                          isWishlisted:
                                              ValueNotifier<bool>(false),
                                          isDeleted: product.isDeleted,
                                          isOutOfAssortment:
                                              product.isOutOfAssortment,
                                          isFreePriceProduct:
                                              product.isFreePriceProduct,
                                          giveIdsFlatStructureModel: product
                                              .giveIdsFlatStructureModel),
                                    ),
                                    withNavBar: true,
                                    pageTransitionAnimation:
                                        PageTransitionAnimation.fade);
                              },
                              icon: const Icon(
                                Icons.edit,
                                size: 20,
                              )),
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
                              if (product.isFreePriceProduct) {
                                quantity = 1;
                              }
                              cartNotifier
                                  .addToCart(
                                      context: context,
                                      token: authenticationNotifier.token,
                                      idUserAppInstitution:
                                          cUserAppInstitutionModel
                                              .idUserAppInstitution,
                                      idProduct: product.idProduct,
                                      quantity: quantity,
                                      freePrice: freePriceProduct.value)
                                  .then((value) {
                                if (value) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackUtil.stylishSnackBar(
                                          title: "Prodotti",
                                          message:
                                              '$quantity x ${product.nameProduct} aggiunti al carrello',
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

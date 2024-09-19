// import 'package:currency_textfield/currency_textfield.dart';
// import 'package:flutter/material.dart';
// import 'package:np_casse/app/utilities/image_utils.dart';
// import 'package:np_casse/core/models/product.model.dart';
// import 'package:np_casse/core/models/user.app.institution.model.dart';
// import 'package:np_casse/core/notifiers/authentication.notifier.dart';
// import 'package:np_casse/core/notifiers/product.notifier.dart';
// import 'package:np_casse/core/notifiers/wishlist.product.notifier.dart';
// import 'package:np_casse/core/utils/snackbar.util.dart';
// import 'package:provider/provider.dart';

// class ProductCard extends StatelessWidget {
//   const ProductCard({
//     super.key,
//     required this.product,
//     required this.areAllWithNoImage,
//     required this.comeFromWishList,
//   });
//   final ProductModel product;
//   final bool areAllWithNoImage;
//   final bool comeFromWishList;

//   @override
//   Widget build(BuildContext context) {
//     AuthenticationNotifier authenticationNotifier =
//         Provider.of<AuthenticationNotifier>(context);
//     ProductNotifier productNotifier = Provider.of<ProductNotifier>(context);
//     WishlistProductNotifier wishlistProductNotifier =
//         Provider.of<WishlistProductNotifier>(context);

//     UserAppInstitutionModel? cUserAppInstitutionModel =
//         authenticationNotifier.getSelectedUserAppInstitution();

//     ValueNotifier<int> quantityForProduct = ValueNotifier(1);

//     ValueNotifier<double> freePriceProduct = ValueNotifier(0);
//     if (product.isFreePriceProduct) {
//       freePriceProduct = ValueNotifier(product.priceProduct);
//     }
//     ValueNotifier<bool> addToCartButtonEnabled = ValueNotifier(
//         (product.priceProduct > 0 && product.isFreePriceProduct) ||
//             (!product.isFreePriceProduct && quantityForProduct.value > 0));

//     CurrencyTextFieldController textEditingControllerFreePriceProduct =
//         CurrencyTextFieldController(
//             decimalSymbol: ',',
//             thousandSymbol: '',
//             currencySeparator: '',
//             currencySymbol: '',
//             enableNegative: false,
//             numberOfDecimals: 2,
//             initDoubleValue: product.priceProduct,
//             maxDigits: 8);

//     void freePriceOnChange() {
//       //final text = textEditingControllerFreePriceProduct.text;
//       var value = double.tryParse(
//           textEditingControllerFreePriceProduct.text.replaceAll(',', '.'));
//       //var value = double.tryParse(text);
//       if (value != null) {
//         freePriceProduct.value = value;
//       } else {
//         freePriceProduct.value = 0;
//       }
//       if (freePriceProduct.value > 0) {
//         addToCartButtonEnabled.value = true;
//       } else {
//         addToCartButtonEnabled.value = false;
//         // if (textEditingControllerFreePriceProduct.text == "") {
//         //   textEditingControllerFreePriceProduct.text = "0";
//         // }
//       }
//     }

//     textEditingControllerFreePriceProduct.addListener(freePriceOnChange);

//     return Card(
//       elevation: 8,
//       child: Container(
//         //margin: const EdgeInsets.all(2),
//         decoration: BoxDecoration(
//             boxShadow: [
//               BoxShadow(
//                   color: Theme.of(context).shadowColor.withOpacity(0.6),
//                   offset: const Offset(0.0, 0.0), //(x,y)
//                   blurRadius: 4.0,
//                   blurStyle: BlurStyle.solid)
//             ],
//             //color: Colors.white,
//             color: Theme.of(context).cardColor),

//         child: Column(
//           children: [
//             areAllWithNoImage
//                 ? const SizedBox.shrink()
//                 : Stack(children: <Widget>[
//                     Container(
//                       margin: const EdgeInsets.symmetric(horizontal: 0),
//                       height: areAllWithNoImage ? 0 : 150,
//                       decoration: BoxDecoration(
//                         image: DecorationImage(
//                             fit: BoxFit.cover,
//                             image: (ImageUtils.getImageFromStringBase64(
//                                     stringImage: product.imageProduct)
//                                 .image)
//                             // (project.imageProject as ImageProvider)
//                             ),
//                       ),
//                     ),
//                     product.isOutOfAssortment
//                         ? Align(
//                             alignment: Alignment.topRight,
//                             child: CircleAvatar(
//                               radius: 24,
//                               backgroundColor:
//                                   Theme.of(context).colorScheme.errorContainer,
//                               child: Text("OUT",
//                                   style: Theme.of(context)
//                                       .textTheme
//                                       .headlineMedium),
//                             ),
//                           )
//                         : const SizedBox.shrink()
//                   ]),
//             SizedBox(
//               height: 60,
//               child: Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Text(
//                   product.nameProduct,
//                   maxLines: 2,
//                   overflow: TextOverflow.ellipsis,
//                   style: Theme.of(context).textTheme.titleSmall,
//                 ),
//               ),
//             ),
//             SizedBox(
//               height: 50,
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                 child: Text(
//                   product.descriptionProduct,
//                   maxLines: 3,
//                   overflow: TextOverflow.ellipsis,
//                   style: Theme.of(context).textTheme.bodyMedium,
//                 ),
//               ),
//             ),
//             Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
//               Row(
//                 children: [
//                   product.isFreePriceProduct
//                       ? Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Container(
//                             decoration: BoxDecoration(
//                               border: Border.all(
//                                 color:
//                                     Theme.of(context).colorScheme.onBackground,
//                               ),
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.end,
//                               mainAxisSize: MainAxisSize.min,
//                               children: [
//                                 SizedBox(
//                                   width: 160,
//                                   height: 40,
//                                   child: ValueListenableBuilder<double>(
//                                     builder: (BuildContext context,
//                                         double value, Widget? child) {
//                                       return TextFormField(
//                                         maxLines: 1,
//                                         textAlignVertical:
//                                             TextAlignVertical.top,
//                                         controller:
//                                             textEditingControllerFreePriceProduct,
//                                         keyboardType: const TextInputType
//                                             .numberWithOptions(
//                                             decimal: true, signed: false),
//                                         style: Theme.of(context)
//                                             .textTheme
//                                             .titleMedium!
//                                             .copyWith(
//                                                 fontWeight: FontWeight.w900),
//                                         decoration: const InputDecoration(
//                                           suffixIcon: Icon(Icons.euro),
//                                           enabledBorder: OutlineInputBorder(
//                                             borderRadius: BorderRadius.all(
//                                                 Radius.circular(10.0)),
//                                             borderSide: BorderSide(
//                                                 color: Colors.black,
//                                                 width: 0.2),
//                                           ),
//                                           focusedBorder: OutlineInputBorder(
//                                             borderRadius: BorderRadius.all(
//                                                 Radius.circular(10.0)),
//                                             borderSide: BorderSide(
//                                                 color: Colors.red, width: 0.2),
//                                           ),
//                                         ),
//                                       );
//                                     },
//                                     valueListenable: freePriceProduct,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         )
//                       : Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             Padding(
//                               padding: const EdgeInsets.only(right: 8.0),
//                               child: CircleAvatar(
//                                 radius: 32,
//                                 backgroundColor: Theme.of(context)
//                                     .colorScheme
//                                     .secondaryContainer,
//                                 child: Padding(
//                                   padding: const EdgeInsets.all(4.0),
//                                   child: Text(
//                                       "${product.priceProduct.toStringAsFixed(2)}€",
//                                       style: Theme.of(context)
//                                           .textTheme
//                                           .headlineMedium),
//                                 ),
//                               ),
//                             ),
//                             Padding(
//                               padding: const EdgeInsets.all(8.0),
//                               child: Container(
//                                 decoration: BoxDecoration(
//                                   border: Border.all(
//                                     color: Theme.of(context)
//                                         .colorScheme
//                                         .onBackground,
//                                   ),
//                                   borderRadius: BorderRadius.circular(10),
//                                 ),
//                                 child: Row(
//                                   mainAxisAlignment: MainAxisAlignment.end,
//                                   mainAxisSize: MainAxisSize.min,
//                                   children: [
//                                     SizedBox(
//                                       child: IconButton(
//                                           onPressed: () {
//                                             if (quantityForProduct.value > 0) {
//                                               quantityForProduct.value--;
//                                             }
//                                             if (quantityForProduct.value > 0) {
//                                               addToCartButtonEnabled.value =
//                                                   true;
//                                             } else {
//                                               addToCartButtonEnabled.value =
//                                                   false;
//                                             }
//                                           },
//                                           icon: const Icon(
//                                               size: 20, Icons.remove)),
//                                     ),
//                                     SizedBox(
//                                       child: ValueListenableBuilder<int>(
//                                         builder: (BuildContext context,
//                                             int value, Widget? child) {
//                                           return Text('$value',
//                                               style: Theme.of(context)
//                                                   .textTheme
//                                                   .titleMedium!
//                                                   .copyWith(
//                                                       fontWeight:
//                                                           FontWeight.w900));
//                                         },
//                                         valueListenable: quantityForProduct,
//                                       ),
//                                     ),
//                                     SizedBox(
//                                       child: IconButton(
//                                           onPressed: () {
//                                             quantityForProduct.value++;
//                                             if (quantityForProduct.value > 0) {
//                                               addToCartButtonEnabled.value =
//                                                   true;
//                                             } else {
//                                               addToCartButtonEnabled.value =
//                                                   false;
//                                             }
//                                           },
//                                           icon:
//                                               const Icon(size: 20, Icons.add)),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ],
//                         )
//                 ],
//               ),
//               Row(
//                 children: [
//                   SizedBox(
//                     height: 30,
//                     width: 30,
//                     child: ValueListenableBuilder<bool>(
//                       builder:
//                           (BuildContext context, bool value, Widget? child) {
//                         return IconButton(
//                           onPressed: () async {
//                             wishlistProductNotifier
//                                 .updateWishlistedProductState(
//                                     context: context,
//                                     token: authenticationNotifier.token,
//                                     idUserAppInstitution:
//                                         cUserAppInstitutionModel
//                                             .idUserAppInstitution,
//                                     idProduct: product.idProduct,
//                                     state: !product.isWishlisted.value)
//                                 .then((value) {
//                               if (value) {
//                                 if (product.isWishlisted.value) {
//                                   ScaffoldMessenger.of(context).showSnackBar(
//                                       SnackUtil.stylishSnackBar(
//                                           title: "Prodotti",
//                                           message:
//                                               '${product.nameProduct} rimosso dai preferiti',
//                                           contentType: "success"));
//                                 } else {
//                                   ScaffoldMessenger.of(context).showSnackBar(
//                                       SnackUtil.stylishSnackBar(
//                                           title: "Prodotti",
//                                           message:
//                                               '${product.nameProduct} aggiunto ai preferiti',
//                                           contentType: "success"));
//                                 }
//                                 product.isWishlisted.value =
//                                     !product.isWishlisted.value;
//                               } else {
//                                 ScaffoldMessenger.of(context).showSnackBar(
//                                     SnackUtil.stylishSnackBar(
//                                         title: "Prodotti",
//                                         message: "Errore di connessione",
//                                         contentType: "failure"));
//                               }
//                             });
//                           },
//                           icon: product.isWishlisted.value
//                               ? const Icon(
//                                   Icons.favorite,
//                                   color: Colors.red,
//                                   size: 20,
//                                 )
//                               : const Icon(
//                                   Icons.favorite_border,
//                                   size: 20,
//                                 ),
//                         );
//                       },
//                       valueListenable: product.isWishlisted,
//                     ),
//                   ),
//                   comeFromWishList
//                       ? const Divider(height: 0)
//                       : SizedBox(
//                           height: 30,
//                           width: 30,
//                           child: IconButton(
//                               onPressed: () {
//                                 productNotifier.setProduct(product);
//                               },
//                               icon: const Icon(
//                                 Icons.edit,
//                                 size: 20,
//                               )),
//                         ),
//                   SizedBox(
//                     height: 30,
//                     width: 30,
//                     child: ValueListenableBuilder<bool>(
//                       builder:
//                           (BuildContext context, bool value, Widget? child) {
//                         return IconButton(
//                           color: addToCartButtonEnabled.value
//                               ? Colors.black
//                               : Colors.grey,
//                           onPressed: () {
//                             int quantity = 0;
//                             quantity = quantityForProduct.value;
//                             if (addToCartButtonEnabled.value) {
//                               if (product.isFreePriceProduct) {
//                                 quantity = 1;
//                               }
//                               //   cartNotifier
//                               //       .addToCart(
//                               //           context: context,
//                               //           token: authenticationNotifier.token,
//                               //           idUserAppInstitution:
//                               //               cUserAppInstitutionModel
//                               //                   .idUserAppInstitution,
//                               //           idProduct: product.idProduct,
//                               //           quantity: quantity,
//                               //           price: product.isFreePriceProduct
//                               //               ? freePriceProductNotifien.value
//                               //               : pricen,
//                               //           cartProductVariants: List.empty())
//                               //       .then((value) {
//                               //     if (value) {
//                               //       ScaffoldMessenger.of(context).showSnackBar(
//                               //           SnackUtil.stylishSnackBar(
//                               //               title: "Prodotti",
//                               //               message:
//                               //                   '$quantity x ${product.nameProduct} aggiunti al carrello',
//                               //               contentType: "success"));

//                               //       // Navigator.of(context)
//                               //       //     .pushNamed(AppRouter.homeRoute);
//                               //     } else {
//                               //       ScaffoldMessenger.of(context).showSnackBar(
//                               //           SnackUtil.stylishSnackBar(
//                               //               title: "Prodotti",
//                               //               message: "Errore di connessione",
//                               //               contentType: "success"));
//                               //     }
//                               //   });
//                               // } else {
//                               //   null;
//                             }
//                           },
//                           icon: const Icon(Icons.shopping_cart),
//                         );
//                       },
//                       valueListenable: addToCartButtonEnabled,
//                     ),
//                   ),
//                 ],
//               ),
//             ]),
//           ],
//         ),
//       ),
//     );
//   }
// }

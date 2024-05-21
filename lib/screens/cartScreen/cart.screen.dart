import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:np_casse/app/utilities/image_utils.dart';
import 'package:np_casse/core/models/cart.model.dart';
import 'package:np_casse/core/models/cart.product.model.dart';
import 'package:np_casse/core/models/user.app.institution.model.dart';
import 'package:np_casse/core/notifiers/authentication.notifier.dart';
import 'package:np_casse/core/notifiers/cart.notifier.dart';
import 'package:np_casse/core/utils/snackbar.util.dart';
import 'package:np_casse/screens/cartScreen/widgets/cart.checkout.dart';
import 'package:np_casse/screens/homeScreen/custom.drawer.dart';
import 'package:provider/provider.dart';

class RefreshCartController {
  void Function()? refreshMoneyCartFromParent;
}

class CartScreen extends StatefulWidget {
  const CartScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  // final ValueNotifier<double> totalPrice = ValueNotifier(0);
  bool _isButtonDisabled = false;
  bool cartHasData = true;
  bool visible = true;

  final RefreshCartController refreshCartController = RefreshCartController();

  @override
  void initState() {
    _isButtonDisabled = false;
    cartHasData = true;
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    AuthenticationNotifier authenticationNotifier =
        Provider.of<AuthenticationNotifier>(context);
    UserAppInstitutionModel cUserAppInstitutionModel =
        authenticationNotifier.getSelectedUserAppInstitution();

  CartNotifier cartNotifier = Provider.of<CartNotifier>(context);
  CartModel cCart = cartNotifier.getCart();
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      drawer: const CustomDrawerWidget(),
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(50),
              child: 
            Text(
              'Il mio carrello',
              style: Theme.of(context).textTheme.headlineLarge,
            ),),
            CircleAvatar(
              radius: 20,
              backgroundColor:
                  Theme.of(context).colorScheme.secondaryContainer,
              child: Text(cCart.idCart.toString(),
                  style: Theme.of(context).textTheme.headlineLarge),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Consumer<CartNotifier>(
              builder: (context, cartNotifier, _) {
                return FutureBuilder(
                  future: cartNotifier.findCart(
                      context: context,
                      token: authenticationNotifier.token,
                      idUserAppInstitution:
                          cUserAppInstitutionModel.idUserAppInstitution,
                      cartStateEnum: 1),
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
                      return Center(
                        child: Text(
                          'Il tuo carrello non contiene prodotti',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      );
                    } else {
                      var tSnapshot =
                          snapshot.data.cartProducts as List<CartProductModel>;

                      return Column(children: [
                        Expanded(
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: tSnapshot.length,
                            itemBuilder: (context, index) {
                              CartProductModel cartProductModel =
                                  tSnapshot[index];
                              return Container(width: double.infinity,
                                margin: const EdgeInsets.all(10),
                                padding: const EdgeInsets.all(10), 
                                decoration: BoxDecoration(
                                  color:Color.fromARGB(255, 237, 208, 171),
                                  borderRadius: BorderRadius.circular(20),),
                                child: Row(
                                 mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children:[
                                    Stack(children: [
                                      Container(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 0),
                                        height: 80,
                                        width: 80,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: (ImageUtils
                                                      .getImageFromString(
                                                          stringImage:
                                                              cartProductModel
                                                                  .productModel
                                                                  .imageProduct)
                                                  .image)
                                              // (project.imageProject as ImageProvider)
                                              ),
                                        ),
                                      ),
                                    ]),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: SizedBox(
                                        width: 130,
                                        child: Column(
                                          crossAxisAlignment:CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                                cartProductModel
                                                    .productModel.nameProduct,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleSmall),
                                            const SizedBox(height: 5),
                                            Text(
                                                cartProductModel.productModel
                                                    .descriptionProduct,
                                                maxLines: 2,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall),
                                            const SizedBox(height: 5),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Column(
                                      children: [
                                        cartProductModel.freePriceCartProduct
                                                    .value >
                                                0
                                            ? Container(
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .onBackground,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:MainAxisAlignment.end,
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    SizedBox(
                                                      width: 50,
                                                      height: 40,
                                                      child:
                                                          ValueListenableBuilder<
                                                              double>(
                                                        builder: (BuildContext
                                                                context,
                                                            double value,
                                                            Widget? child) {
                                                          return Row(
                                                            mainAxisAlignment:MainAxisAlignment.end,
                                                            children: <Widget>[
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(
                                                                        2.0),
                                                                child: Text(
                                                                    '$value €',
                                                                    style: Theme.of(
                                                                            context)
                                                                        .textTheme
                                                                        .titleSmall),
                                                              )
                                                            ],
                                                          );
                                                        },
                                                        valueListenable:
                                                            cartProductModel
                                                                .freePriceCartProduct,
                                                      ),
                                                    ),
                                                    IconButton(
                                                        onPressed: () {
                                                          if (_isButtonDisabled) {
                                                            return;
                                                          } else {
                                                            _isButtonDisabled =
                                                                true;
                                                            int zero = 0;
                                                            cartNotifier
                                                                .updateItemQuantity(
                                                                    context:
                                                                        context,
                                                                    token: authenticationNotifier
                                                                        .token,
                                                                    idUserAppInstitution:
                                                                        cUserAppInstitutionModel
                                                                            .idUserAppInstitution,
                                                                    idCart: cartProductModel
                                                                        .idCart,
                                                                    idCartProduct:
                                                                        cartProductModel
                                                                            .idCartProduct,
                                                                    quantityCartProduct:
                                                                        zero)
                                                                .then((value) {
                                                              if (value) {
                                                                cartProductModel
                                                                    .quantityCartProduct
                                                                    .value = 0;
                                                                tSnapshot.remove(
                                                                    cartProductModel);
                                                                refreshCartController
                                                                    .refreshMoneyCartFromParent!();
                                                                ScaffoldMessenger
                                                                        .of(
                                                                            context)
                                                                    .showSnackBar(SnackUtil.stylishSnackBar(
                                                                        title:
                                                                            "Carrello",
                                                                        message:
                                                                            'Informazioni aggiornate. Prodotto ${cartProductModel.productModel.nameProduct} rimosso',
                                                                        contentType:
                                                                            "success"));

                                                                _isButtonDisabled =
                                                                    false;
                                                                // totalPrice.value =
                                                                //     cartNotifier.totalPrice;
                                                                // Navigator.of(context).pop();
                                                                // productNotifier.refresh();
                                                              } else {
                                                                ScaffoldMessenger
                                                                        .of(
                                                                            context)
                                                                    .showSnackBar(SnackUtil.stylishSnackBar(
                                                                        title:
                                                                            "Anagrafiche",
                                                                        message:
                                                                            "Errore di connessione",
                                                                        contentType:
                                                                            "error"));
                                                                // Navigator.of(context).pop();
                                                              }
                                                            });
                                                          }
                                                        },
                                                        icon: const Icon(
                                                            size: 30,
                                                            Icons
                                                            .delete_outline)),
                                                  ],
                                                ),
                                              )
                                            : Container(
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .onBackground,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:MainAxisAlignment.end,
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    IconButton(
                                                        onPressed: () {
                                                          if (_isButtonDisabled ||
                                                              cartProductModel
                                                                      .quantityCartProduct
                                                                      .value <
                                                                  1) {
                                                            return;
                                                          } else {
                                                            _isButtonDisabled =
                                                                true;
                                                            int tDecrease =
                                                                cartProductModel
                                                                        .quantityCartProduct
                                                                        .value -
                                                                    1;
                                                            cartNotifier
                                                                .updateItemQuantity(
                                                                    context:
                                                                        context,
                                                                    token: authenticationNotifier
                                                                        .token,
                                                                    idUserAppInstitution:
                                                                        cUserAppInstitutionModel
                                                                            .idUserAppInstitution,
                                                                    idCart: cartProductModel
                                                                        .idCart,
                                                                    idCartProduct:
                                                                        cartProductModel
                                                                            .idCartProduct,
                                                                    quantityCartProduct:
                                                                        tDecrease)
                                                                .then((value) {
                                                              if (value) {
                                                                cartProductModel
                                                                    .quantityCartProduct
                                                                    .value -= 1;
                                                                refreshCartController
                                                                    .refreshMoneyCartFromParent!();
                                                                ScaffoldMessenger
                                                                        .of(
                                                                            context)
                                                                    .showSnackBar(SnackUtil.stylishSnackBar(
                                                                        title:
                                                                            "Carrello",
                                                                        message:
                                                                            'Informazioni aggiornate. ${cartProductModel.quantityCartProduct.value.toString()} x ${cartProductModel.productModel.nameProduct} presenti',
                                                                        contentType:
                                                                            "success"));
                                                                _isButtonDisabled =
                                                                    false;
                                                                // totalPrice.value =
                                                                //     cartNotifier.totalPrice;
                                                              } else {
                                                                ScaffoldMessenger
                                                                        .of(
                                                                            context)
                                                                    .showSnackBar(SnackUtil.stylishSnackBar(
                                                                        title:
                                                                            "Carrello",
                                                                        message:
                                                                            "Errore di connessione",
                                                                        contentType:
                                                                            "error"));
                                                                // Navigator.of(context).pop();
                                                              }
                                                            });
                                                          }
                                                        },
                                                        icon: const Icon(
                                                            size: 24,
                                                            Icons.remove)),
                                                    SizedBox(
                                                      width: 30,
                                                      height: 50,
                                                      child:
                                                          ValueListenableBuilder<
                                                              int>(
                                                        builder: (BuildContext
                                                                context,
                                                            int value,
                                                            Widget? child) {
                                                          return Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                            children: <Widget>[
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(
                                                                        2.0),
                                                                child: Text(
                                                                    '$value',
                                                                    style: Theme.of(
                                                                            context)
                                                                        .textTheme
                                                                        .titleSmall),
                                                              )
                                                            ],
                                                          );
                                                        },
                                                        valueListenable:
                                                            cartProductModel
                                                                .quantityCartProduct,
                                                      ),
                                                    ),
                                                    IconButton(
                                                        onPressed: () {
                                                          if (_isButtonDisabled) {
                                                            return;
                                                          } else {
                                                            _isButtonDisabled =
                                                                true;
                                                            int tIncrease =
                                                                cartProductModel
                                                                        .quantityCartProduct
                                                                        .value +
                                                                    1;
                                                            cartNotifier
                                                                .updateItemQuantity(
                                                                    context:
                                                                        context,
                                                                    token: authenticationNotifier
                                                                        .token,
                                                                    idUserAppInstitution:
                                                                        cUserAppInstitutionModel
                                                                            .idUserAppInstitution,
                                                                    idCart: cartProductModel
                                                                        .idCart,
                                                                    idCartProduct:
                                                                        cartProductModel
                                                                            .idCartProduct,
                                                                    quantityCartProduct:
                                                                        tIncrease)
                                                                .then((value) {
                                                              if (value) {
                                                                cartProductModel
                                                                    .quantityCartProduct
                                                                    .value += 1;
                                                                refreshCartController
                                                                    .refreshMoneyCartFromParent!();
                                                                ScaffoldMessenger
                                                                        .of(
                                                                            context)
                                                                    .showSnackBar(SnackUtil.stylishSnackBar(
                                                                        title:
                                                                            "Carrello",
                                                                        message:
                                                                            'Informazioni aggiornate. ${cartProductModel.quantityCartProduct.value.toString()} x ${cartProductModel.productModel.nameProduct} presenti',
                                                                        contentType:
                                                                            "success"));

                                                                _isButtonDisabled =
                                                                    false;
                                                                // totalPrice.value =
                                                                //     cartNotifier.totalPrice;
                                                                // Navigator.of(context).pop();
                                                                // productNotifier.refresh();
                                                              } else {
                                                                ScaffoldMessenger
                                                                        .of(
                                                                            context)
                                                                    .showSnackBar(SnackUtil.stylishSnackBar(
                                                                        title:
                                                                            "Carrello",
                                                                        message:
                                                                            "Errore di connessione",
                                                                        contentType:
                                                                            "error"));
                                                                // Navigator.of(context).pop();
                                                              }
                                                            });
                                                          }
                                                        },
                                                        icon: const Icon(
                                                            size: 20,
                                                            Icons.add)),
                                                    IconButton(
                                                        onPressed: () {
                                                          if (_isButtonDisabled) {
                                                            return;
                                                          } else {
                                                            _isButtonDisabled =
                                                                true;
                                                            int zero = 0;
                                                            cartNotifier
                                                                .updateItemQuantity(
                                                                    context:
                                                                        context,
                                                                    token: authenticationNotifier
                                                                        .token,
                                                                    idUserAppInstitution:
                                                                        cUserAppInstitutionModel
                                                                            .idUserAppInstitution,
                                                                    idCart: cartProductModel
                                                                        .idCart,
                                                                    idCartProduct:
                                                                        cartProductModel
                                                                            .idCartProduct,
                                                                    quantityCartProduct:
                                                                        zero)
                                                                .then((value) {
                                                              if (value) {
                                                                cartProductModel
                                                                    .quantityCartProduct
                                                                    .value = 0;
                                                                tSnapshot.remove(
                                                                    cartProductModel);
                                                                ScaffoldMessenger
                                                                        .of(
                                                                            context)
                                                                    .showSnackBar(SnackUtil.stylishSnackBar(
                                                                        title:
                                                                            "Carrello",
                                                                        message:
                                                                            'Informazioni aggiornate. Prodotto ${cartProductModel.productModel.nameProduct} rimosso',
                                                                        contentType:
                                                                            "success"));

                                                                _isButtonDisabled =
                                                                    false;
                                                                // totalPrice.value =
                                                                //     cartNotifier.totalPrice;
                                                                // Navigator.of(context).pop();
                                                                // productNotifier.refresh();
                                                              } else {
                                                                ScaffoldMessenger
                                                                        .of(
                                                                            context)
                                                                    .showSnackBar(SnackUtil.stylishSnackBar(
                                                                        title:
                                                                            "Carrello",
                                                                        message:
                                                                            "Errore di connessione",
                                                                        contentType:
                                                                            "error"));
                                                                // Navigator.of(context).pop();
                                                              }
                                                            });
                                                          }
                                                        },
                                                        icon: const Icon(
                                                            size: 20,
                                                            Icons
                                                                .delete_outline)),
                                                  ],
                                                ),
                                              ),
                                  ]),
                                  Column(
                                      children: [ Container(
                                        margin: const EdgeInsets.all(10),
                                        padding: const EdgeInsets.all(15),
                                        decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8,),
                                        border:Border.all(color: Colors.black)),
                                        child: Row(
                                        children: [
                                        Text(
                                        '${cartProductModel.productModel.priceProduct}€',
                                        style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium),],//prezzo
                                      ),
                                  ),
                                  ],),
                                ]
                              )
                              );
                            },
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Visibility(
                              visible: cartHasData,
                              child: CheckoutCart(
                              controller: refreshCartController)),
                        ),
                      ]);
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
      // bottomNavigationBar: Visibility(
      //     visible: cartHasData,
      //     child: CheckoutCart(controller: refreshCartController)),
    );

    // return Scaffold(
    //   backgroundColor: Theme.of(context).colorScheme.background,
    //   appBar: AppBar(
    //     centerTitle: true,
    //     title: Text(
    //       'My Shopping Cart',
    //       style: Theme.of(context).textTheme.headlineLarge,
    //     ),
    //   ),
    //   body: Column(
    //     children: [
    //       Expanded(
    //         child: Consumer<CartNotifier>(
    //           builder: (context, cartNotifier, _) {
    //             return FutureBuilder(
    //               future: cartNotifier.findCart(
    //                   context: context,
    //                   token: authenticationNotifier.token,
    //                   idUserAppInstitution:
    //                       cUserAppInstitutionModel.idUserAppInstitution,
    //                   cartStateEnum: 1),
    //               builder: (context, snapshot) {
    //                 if (snapshot.connectionState == ConnectionState.waiting) {
    //                   return const Center(
    //                     child: Column(
    //                       mainAxisAlignment: MainAxisAlignment.center,
    //                       crossAxisAlignment: CrossAxisAlignment.center,
    //                       children: [
    //                         Center(
    //                             child: SizedBox(
    //                                 width: 100,
    //                                 height: 100,
    //                                 child: CircularProgressIndicator(
    //                                   strokeWidth: 5,
    //                                   color: Colors.redAccent,
    //                                 ))),
    //                       ],
    //                     ),
    //                   );
    //                 } else if (!snapshot.hasData) {
    //                   return Center(
    //                     child: Text(
    //                       'Il tuo carrello non contiene prodotti',
    //                       style: Theme.of(context).textTheme.titleMedium,
    //                     ),
    //                   );
    //                 } else {
    //                   var tSnapshot =
    //                       snapshot.data.cartProducts as List<CartProductModel>;

    //                   return SingleChildScrollView(
    //                       child: ListView.builder(
    //                           shrinkWrap: true,
    //                           itemCount: tSnapshot.length,
    //                           itemBuilder: (context, index) {
    //                             CartProductModel cartProductModel =
    //                                 tSnapshot[index];
    //                             return Container(
    //                               width: double.infinity,
    //                               margin: const EdgeInsets.all(15),
    //                               padding: const EdgeInsets.all(15),
    //                               decoration: BoxDecoration(
    //                                 color: Colors.grey[200]?.withOpacity(0.6),
    //                                 borderRadius: BorderRadius.circular(10),
    //                               ),
    //                               child: Wrap(
    //                                 spacing: 10,
    //                                 runSpacing: 10,
    //                                 crossAxisAlignment:
    //                                     WrapCrossAlignment.center,
    //                                 alignment: WrapAlignment.spaceEvenly,
    //                                 children: [
    //                                   Container(
    //                                     padding: const EdgeInsets.all(5),
    //                                     decoration: BoxDecoration(
    //                                       borderRadius:
    //                                           BorderRadius.circular(10),
    //                                       color: Colors.amber,
    //                                     ),
    //                                     child: ClipRRect(
    //                                       borderRadius: const BorderRadius.all(
    //                                           Radius.circular(20)),
    //                                       child: ClipRRect(
    //                                         borderRadius:
    //                                             BorderRadius.circular(10),
    //                                         child: Padding(
    //                                           padding: const EdgeInsets.all(5),
    //                                           child: Image(
    //                                             image: ImageUtils
    //                                                     .getImageFromString(
    //                                                         stringImage:
    //                                                             cartProductModel
    //                                                                 .productModel
    //                                                                 .imageProduct)
    //                                                 .image,
    //                                             width: 100,
    //                                             height: 90,
    //                                           ),
    //                                         ),
    //                                       ),
    //                                     ),
    //                                   ),
    //                                   Column(
    //                                     crossAxisAlignment:
    //                                         CrossAxisAlignment.start,
    //                                     children: [
    //                                       const Text(
    //                                         "product.name.nextLine",
    //                                         maxLines: 2,
    //                                         overflow: TextOverflow.ellipsis,
    //                                         style: TextStyle(
    //                                           fontWeight: FontWeight.w600,
    //                                           fontSize: 15,
    //                                         ),
    //                                       ),
    //                                       const SizedBox(height: 5),
    //                                       Text(
    //                                         "controller.getCurrentSize(product)",
    //                                         style: TextStyle(
    //                                           color:
    //                                               Colors.black.withOpacity(0.5),
    //                                           fontWeight: FontWeight.w400,
    //                                         ),
    //                                       ),
    //                                       const SizedBox(height: 5),
    //                                       const Text(
    //                                         "controller.isPriceOff(product)",
    //                                         style: TextStyle(
    //                                           fontWeight: FontWeight.w900,
    //                                           fontSize: 23,
    //                                         ),
    //                                       ),
    //                                     ],
    //                                   ),
    //                                   Container(
    //                                     decoration: BoxDecoration(
    //                                       color: Colors.white,
    //                                       borderRadius:
    //                                           BorderRadius.circular(10),
    //                                     ),
    //                                     child: Row(
    //                                       mainAxisAlignment:
    //                                           MainAxisAlignment.end,
    //                                       mainAxisSize: MainAxisSize.min,
    //                                       children: [
    //                                         IconButton(
    //                                           splashRadius: 10.0,
    //                                           onPressed: () => {},
    //                                           icon: const Icon(
    //                                             Icons.remove,
    //                                             color: Color(0xFFEC6813),
    //                                           ),
    //                                         ),
    //                                         IconButton(
    //                                           splashRadius: 10.0,
    //                                           onPressed: () => {},
    //                                           icon: const Icon(Icons.add,
    //                                               color: Color(0xFFEC6813)),
    //                                         ),
    //                                       ],
    //                                     ),
    //                                   )
    //                                 ],
    //                               ),
    //                             );
    //                           }));
    //                 }
    //               },
    //             );
    //           },
    //         ),
    //       ),
    //     ],
    //   ),
    // );
  }
}

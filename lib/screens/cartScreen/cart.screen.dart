import 'package:flutter/material.dart';
import 'package:np_casse/app/utilities/image_utils.dart';
import 'package:np_casse/core/models/cart.product.model.dart';
import 'package:np_casse/core/models/user.app.institution.model.dart';
import 'package:np_casse/core/notifiers/authentication.notifier.dart';
import 'package:np_casse/core/notifiers/cart.notifier.dart';
import 'package:np_casse/core/utils/snackbar.util.dart';
import 'package:np_casse/screens/cartScreen/payment.screen.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:provider/provider.dart';

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

  @override
  void initState() {
    _isButtonDisabled = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    CartNotifier cartNotifier = Provider.of<CartNotifier>(context);
    AuthenticationNotifier authenticationNotifier =
        Provider.of<AuthenticationNotifier>(context);
    UserAppInstitutionModel cUserAppInstitutionModel =
        authenticationNotifier.getSelectedUserAppInstitution();

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'My Shopping Cart',
          style: Theme.of(context).textTheme.headlineLarge,
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
                      return Stack(children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.75,
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: tSnapshot.length,
                            itemBuilder: (context, index) {
                              CartProductModel cartProductModel =
                                  tSnapshot[index];
                              return Container(
                                width: double.infinity,
                                margin: const EdgeInsets.all(15),
                                padding: const EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onBackground
                                            .withAlpha(150),
                                        offset: const Offset(0.0, 1.0), //(x,y)
                                        blurRadius: 4.0,
                                        blurStyle: BlurStyle.outer)
                                  ],
                                  color: Theme.of(context).cardColor,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Wrap(
                                  spacing: 10,
                                  runSpacing: 10,
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  alignment: WrapAlignment.spaceEvenly,
                                  children: [
                                    CircleAvatar(
                                        radius: 80,
                                        backgroundImage:
                                            ImageUtils.getImageFromString(
                                                    stringImage:
                                                        cartProductModel
                                                            .productModel
                                                            .imageProduct)
                                                .image),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                            cartProductModel
                                                .productModel.nameProduct,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium!
                                                .copyWith(
                                                    fontWeight:
                                                        FontWeight.w600)),
                                        const SizedBox(height: 5),
                                        Text(
                                            cartProductModel.productModel
                                                .descriptionProduct,
                                            maxLines: 2,
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium!
                                                .copyWith(
                                                    fontWeight:
                                                        FontWeight.w400)),
                                        const SizedBox(height: 5),
                                        Text(
                                            '${cartProductModel.productModel.priceProduct}€',
                                            maxLines: 2,
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium!
                                                .copyWith(
                                                    fontWeight:
                                                        FontWeight.w400)),
                                        const SizedBox(height: 5),
                                        Text('Qui ci potrei inserire le note',
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium!
                                                .copyWith(
                                                    fontWeight:
                                                        FontWeight.w900)),
                                      ],
                                    ),
                                    cartProductModel
                                                .freePriceCartProduct.value >
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
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                SizedBox(
                                                  width: 140,
                                                  height: 60,
                                                  child: ValueListenableBuilder<
                                                      double>(
                                                    builder:
                                                        (BuildContext context,
                                                            double value,
                                                            Widget? child) {
                                                      return Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                        children: <Widget>[
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(16.0),
                                                            child: Text(
                                                                '$value €',
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .titleMedium!
                                                                    .copyWith(
                                                                        fontWeight:
                                                                            FontWeight.w900)),
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
                                                                token:
                                                                    authenticationNotifier
                                                                        .token,
                                                                idUserAppInstitution:
                                                                    cUserAppInstitutionModel
                                                                        .idUserAppInstitution,
                                                                idCart:
                                                                    cartProductModel
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
                                                                    .of(context)
                                                                .showSnackBar(
                                                              SnackUtil
                                                                  .stylishSnackBar(
                                                                text:
                                                                    'Info Updated cart product: ${cartProductModel.quantityCartProduct.value}',
                                                                context:
                                                                    context,
                                                              ),
                                                            );
                                                            _isButtonDisabled =
                                                                false;
                                                            // totalPrice.value =
                                                            //     cartNotifier.totalPrice;
                                                            // Navigator.of(context).pop();
                                                            // productNotifier.refresh();
                                                          } else {
                                                            ScaffoldMessenger
                                                                    .of(context)
                                                                .showSnackBar(
                                                              SnackUtil
                                                                  .stylishSnackBar(
                                                                text:
                                                                    'Error Please Try Again , After a While',
                                                                context:
                                                                    context,
                                                              ),
                                                            );
                                                            // Navigator.of(context).pop();
                                                          }
                                                        });
                                                      }
                                                    },
                                                    icon: const Icon(
                                                        size: 30,
                                                        Icons.delete_outline)),
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
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              mainAxisSize: MainAxisSize.min,
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
                                                                token:
                                                                    authenticationNotifier
                                                                        .token,
                                                                idUserAppInstitution:
                                                                    cUserAppInstitutionModel
                                                                        .idUserAppInstitution,
                                                                idCart:
                                                                    cartProductModel
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
                                                            // totalPrice.value =
                                                            //     tDecrease.toDouble();
                                                            ScaffoldMessenger
                                                                    .of(context)
                                                                .showSnackBar(
                                                              SnackUtil
                                                                  .stylishSnackBar(
                                                                text:
                                                                    'Info Updated cart product: ${cartProductModel.quantityCartProduct.value}',
                                                                context:
                                                                    context,
                                                              ),
                                                            );
                                                            _isButtonDisabled =
                                                                false;
                                                            // totalPrice.value =
                                                            //     cartNotifier.totalPrice;
                                                          } else {
                                                            ScaffoldMessenger
                                                                    .of(context)
                                                                .showSnackBar(
                                                              SnackUtil
                                                                  .stylishSnackBar(
                                                                text:
                                                                    'Error Please Try Again , After a While',
                                                                context:
                                                                    context,
                                                              ),
                                                            );
                                                            // Navigator.of(context).pop();
                                                          }
                                                        });
                                                      }
                                                    },
                                                    icon: const Icon(
                                                        size: 30,
                                                        Icons.remove)),
                                                ValueListenableBuilder<int>(
                                                  builder:
                                                      (BuildContext context,
                                                          int value,
                                                          Widget? child) {
                                                    return Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      children: <Widget>[
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(16.0),
                                                          child: Text('$value',
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .titleMedium!
                                                                  .copyWith(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w900)),
                                                        )
                                                      ],
                                                    );
                                                  },
                                                  valueListenable:
                                                      cartProductModel
                                                          .quantityCartProduct,
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
                                                                token:
                                                                    authenticationNotifier
                                                                        .token,
                                                                idUserAppInstitution:
                                                                    cUserAppInstitutionModel
                                                                        .idUserAppInstitution,
                                                                idCart:
                                                                    cartProductModel
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
                                                            ScaffoldMessenger
                                                                    .of(context)
                                                                .showSnackBar(
                                                              SnackUtil
                                                                  .stylishSnackBar(
                                                                text:
                                                                    'Info Updated cart product: ${cartProductModel.quantityCartProduct.value.toString()}',
                                                                context:
                                                                    context,
                                                              ),
                                                            );
                                                            _isButtonDisabled =
                                                                false;
                                                            // totalPrice.value =
                                                            //     cartNotifier.totalPrice;
                                                            // Navigator.of(context).pop();
                                                            // productNotifier.refresh();
                                                          } else {
                                                            ScaffoldMessenger
                                                                    .of(context)
                                                                .showSnackBar(
                                                              SnackUtil
                                                                  .stylishSnackBar(
                                                                text:
                                                                    'Error Please Try Again , After a While',
                                                                context:
                                                                    context,
                                                              ),
                                                            );
                                                            // Navigator.of(context).pop();
                                                          }
                                                        });
                                                      }
                                                    },
                                                    icon: const Icon(
                                                        size: 30, Icons.add)),
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
                                                                token:
                                                                    authenticationNotifier
                                                                        .token,
                                                                idUserAppInstitution:
                                                                    cUserAppInstitutionModel
                                                                        .idUserAppInstitution,
                                                                idCart:
                                                                    cartProductModel
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
                                                                    .of(context)
                                                                .showSnackBar(
                                                              SnackUtil
                                                                  .stylishSnackBar(
                                                                text:
                                                                    'Info Updated cart product: ${cartProductModel.quantityCartProduct.value}',
                                                                context:
                                                                    context,
                                                              ),
                                                            );
                                                            _isButtonDisabled =
                                                                false;
                                                            // totalPrice.value =
                                                            //     cartNotifier.totalPrice;
                                                            // Navigator.of(context).pop();
                                                            // productNotifier.refresh();
                                                          } else {
                                                            ScaffoldMessenger
                                                                    .of(context)
                                                                .showSnackBar(
                                                              SnackUtil
                                                                  .stylishSnackBar(
                                                                text:
                                                                    'Error Please Try Again , After a While',
                                                                context:
                                                                    context,
                                                              ),
                                                            );
                                                            // Navigator.of(context).pop();
                                                          }
                                                        });
                                                      }
                                                    },
                                                    icon: const Icon(
                                                        size: 30,
                                                        Icons.delete_outline)),
                                              ],
                                            ),
                                          )
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                        Align(
                          child: ValueListenableBuilder<double>(
                            builder: (BuildContext context, double value,
                                Widget? child) {
                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        bottom: 32, top: 16),
                                    child: Align(
                                      alignment: Alignment.bottomCenter,
                                      child: MaterialButton(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.05,
                                        minWidth:
                                            MediaQuery.of(context).size.width *
                                                0.25,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        onPressed: () async {
                                          PersistentNavBarNavigator
                                              .pushNewScreen(
                                            context,
                                            screen: PaymentScreen(),
                                            withNavBar: true,
                                            pageTransitionAnimation:
                                                PageTransitionAnimation.fade,
                                          );
                                        },
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondaryContainer,
                                        child: Text(
                                            'Totale da pagare: $value €',
                                            style: Theme.of(context)
                                                .textTheme
                                                .headlineMedium),
                                      ),
                                    ),
                                  )
                                ],
                              );
                            },
                            valueListenable: cartNotifier.totalCartMoney,
                            // The child parameter is most helpful if the child is
                            // expensive to build and does not depend on the value from
                            // the notifier.
                          ),
                        )
                      ]);
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
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

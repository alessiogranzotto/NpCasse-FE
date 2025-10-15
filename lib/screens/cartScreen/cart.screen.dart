import 'package:currency_textfield/currency_textfield.dart';
import 'package:flutter/material.dart';

import 'package:np_casse/app/utilities/image.utils.dart';
import 'package:np_casse/app/utilities/money_formatter.dart';
import 'package:np_casse/componenents/empty.data.widget.dart';
import 'package:np_casse/core/models/cart.product.model.dart';
import 'package:np_casse/core/models/user.app.institution.model.dart';
import 'package:np_casse/core/notifiers/authentication.notifier.dart';
import 'package:np_casse/core/notifiers/cart.notifier.dart';
import 'package:np_casse/core/themes/app.theme.dart';
import 'package:np_casse/core/utils/snackbar.util.dart';
import 'package:np_casse/screens/cartScreen/widgets/cart.detail.dart';
import 'package:provider/provider.dart';
import 'package:uiblock/uiblock.dart';

class CustomTextStyle {
  static var textFormFieldRegular = TextStyle(
      fontSize: 16,
      fontFamily: "Helvetica",
      color: Colors.black,
      fontWeight: FontWeight.w400);

  static var textFormFieldLight =
      textFormFieldRegular.copyWith(fontWeight: FontWeight.w200);

  static var textFormFieldMedium =
      textFormFieldRegular.copyWith(fontWeight: FontWeight.w500);

  static var textFormFieldSemiBold =
      textFormFieldRegular.copyWith(fontWeight: FontWeight.w600);

  static var textFormFieldBold =
      textFormFieldRegular.copyWith(fontWeight: FontWeight.w700);

  static var textFormFieldBlack =
      textFormFieldRegular.copyWith(fontWeight: FontWeight.w900);
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
  int idCart = 0;
  bool disabledFinalizeButton = true;
  int indexPayment = 0;
  late double toBeReturnedCalculation;
  late String _toBeReturned = '---';
  late bool _isNumericPadVisible = true;

  final List<bool> _selectedPayment = <bool>[true, false, false, false];
  CurrencyTextFieldController textEditingControllerCashInserted =
      CurrencyTextFieldController(
          decimalSymbol: ',',
          thousandSymbol: '',
          currencySeparator: '',
          currencySymbol: '',
          enableNegative: false,
          numberOfDecimals: 2,
          initDoubleValue: 0,
          maxDigits: 8);
  @override
  void initState() {
    _isButtonDisabled = false;
    cartHasData = true;
    textEditingControllerCashInserted.addListener(cashInsertedOnChange);
    toBeReturnedCalculation = 0;
    _toBeReturned = '---';
    _isNumericPadVisible = true;
    super.initState();
  }

  void cashInsertedOnChange() {
    CartNotifier cartNotifier =
        Provider.of<CartNotifier>(context, listen: false);
    var value = double.tryParse(
        textEditingControllerCashInserted.text.replaceAll(',', '.'));

    if (value != null) {
      if (value > 0) {
        toBeReturnedCalculation = value - cartNotifier.subTotalCartMoney.value;
        setState(() {
          if (toBeReturnedCalculation >= 0 &&
              cartNotifier.subTotalCartMoney.value > 0) {
            _toBeReturned = '${toBeReturnedCalculation.toStringAsFixed(2)} €';
            disabledFinalizeButton = false;
          } else {
            _toBeReturned = '---';
            disabledFinalizeButton = true;
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    AuthenticationNotifier authenticationNotifier =
        Provider.of<AuthenticationNotifier>(context);
    UserAppInstitutionModel cUserAppInstitutionModel =
        authenticationNotifier.getSelectedUserAppInstitution();

    //CartNotifier cartNotifier = Provider.of<CartNotifier>(context);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: CustomColors.darkBlue,
        centerTitle: true,
        title: Text(
          'Carrello ${cUserAppInstitutionModel.idInstitutionNavigation.nameInstitution}',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      body: Row(
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
                    // Waiting state - Show loading indicator
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: SizedBox(
                          width: 100,
                          height: 100,
                          child: CircularProgressIndicator(
                            strokeWidth: 5,
                            color: Colors.redAccent,
                          ),
                        ),
                      );
                    }

                    // Error handling
                    else if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          'Errore nel recuperare il carrello: ${snapshot.error}',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      );
                    }

                    // No data or null data handling
                    else if (!snapshot.hasData || snapshot.data == null) {
                      return Center(
                          child: EmptyDataWidget(
                        title: "Il tuo carrello non contiene prodotti",
                        message: "Non ci sono elementi da mostrare al momento.",
                      ));
                    } else {
                      var tSnapshot =
                          snapshot.data.cartProducts as List<CartProductModel>;
                      idCart =
                          tSnapshot.isNotEmpty ? tSnapshot.first.idCart : 0;

                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 2,

                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: tSnapshot.length,
                              itemBuilder: (context, index) {
                                CartProductModel cartProductModel =
                                    tSnapshot[index];
                                return Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Card(
                                        elevation: 8,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(4)),
                                        ),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(4)),
                                              border: Border.all(
                                                  color: Colors.grey.shade200)),
                                          padding: EdgeInsets.only(
                                              left: 12,
                                              top: 8,
                                              right: 12,
                                              bottom: 8),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              SizedBox(height: 4),
                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 0, vertical: 3),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: <Widget>[
                                                    Text(
                                                      cartProductModel
                                                                  .valueVat !=
                                                              null
                                                          ? (cartProductModel
                                                                  .nameProduct +
                                                              ' (IVA: ' +
                                                              cartProductModel
                                                                  .valueVat! +
                                                              ')')
                                                          : cartProductModel
                                                              .nameProduct,
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: CustomTextStyle
                                                          .textFormFieldMedium
                                                          .copyWith(
                                                              fontSize: 12,
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                    ),
                                                    Row(
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
                                                              UIBlock.block(
                                                                  context);
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
                                                                  .then(
                                                                      (value) {
                                                                _isButtonDisabled =
                                                                    false;
                                                                UIBlock.unblock(
                                                                    context);
                                                                if (value) {
                                                                  cartProductModel
                                                                      .quantityCartProduct
                                                                      .value -= 1;
                                                                  ScaffoldMessenger.of(context).showSnackBar(SnackUtil.stylishSnackBar(
                                                                      title:
                                                                          "Carrello",
                                                                      message:
                                                                          'Informazioni aggiornate. ${cartProductModel.quantityCartProduct.value.toString()} x ${cartProductModel.nameProduct} presenti',
                                                                      contentType:
                                                                          "success"));
                                                                } else {
                                                                  ScaffoldMessenger.of(context).showSnackBar(SnackUtil.stylishSnackBar(
                                                                      title:
                                                                          "Carrello",
                                                                      message:
                                                                          "Errore di connessione",
                                                                      contentType:
                                                                          "error"));
                                                                }
                                                              });
                                                            }
                                                          },
                                                          icon: const Icon(
                                                              size: 20,
                                                              Icons
                                                                  .remove_circle_sharp),
                                                        ),
                                                        IconButton(
                                                            onPressed: () {
                                                              if (_isButtonDisabled) {
                                                                return;
                                                              } else {
                                                                _isButtonDisabled =
                                                                    true;
                                                                UIBlock.block(
                                                                    context);
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
                                                                    .then(
                                                                        (value) {
                                                                  _isButtonDisabled =
                                                                      false;
                                                                  UIBlock.unblock(
                                                                      context);
                                                                  if (value) {
                                                                    cartProductModel
                                                                        .quantityCartProduct
                                                                        .value += 1;
                                                                    // refreshCartController
                                                                    //     .refreshMoneyCartFromParent!();
                                                                    ScaffoldMessenger.of(context).showSnackBar(SnackUtil.stylishSnackBar(
                                                                        title:
                                                                            "Carrello",
                                                                        message:
                                                                            'Informazioni aggiornate. ${cartProductModel.quantityCartProduct.value.toString()} x ${cartProductModel.nameProduct} presenti',
                                                                        contentType:
                                                                            "success"));

                                                                    // totalPrice.value =
                                                                    //     cartNotifier.totalPrice;
                                                                    // Navigator.of(context).pop();
                                                                    // productNotifier.refresh();
                                                                  } else {
                                                                    ScaffoldMessenger.of(context).showSnackBar(SnackUtil.stylishSnackBar(
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
                                                                    .add_circle_sharp)),
                                                        IconButton(
                                                            onPressed: () {
                                                              if (_isButtonDisabled) {
                                                                return;
                                                              } else {
                                                                _isButtonDisabled =
                                                                    true;
                                                                UIBlock.block(
                                                                    context);
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
                                                                    .then(
                                                                        (value) {
                                                                  _isButtonDisabled =
                                                                      false;
                                                                  UIBlock.unblock(
                                                                      context);
                                                                  if (value) {
                                                                    cartProductModel
                                                                        .quantityCartProduct
                                                                        .value = 0;
                                                                    tSnapshot
                                                                        .remove(
                                                                            cartProductModel);

                                                                    ScaffoldMessenger.of(context).showSnackBar(SnackUtil.stylishSnackBar(
                                                                        title:
                                                                            "Carrello",
                                                                        message:
                                                                            'Informazioni aggiornate. Prodotto ${cartProductModel.nameProduct} rimosso',
                                                                        contentType:
                                                                            "success"));

                                                                    // totalPrice.value =
                                                                    //     cartNotifier.totalPrice;
                                                                    // Navigator.of(context).pop();
                                                                    // productNotifier.refresh();
                                                                  } else {
                                                                    ScaffoldMessenger.of(context).showSnackBar(SnackUtil.stylishSnackBar(
                                                                        title:
                                                                            "Carrello",
                                                                        message:
                                                                            "Errore di connessione",
                                                                        contentType:
                                                                            "failure"));
                                                                    // Navigator.of(context).pop();
                                                                  }
                                                                });
                                                              }
                                                            },
                                                            icon: const Icon(
                                                                size: 20,
                                                                Icons
                                                                    .delete_sharp)),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                width: double.infinity,
                                                height: 0.5,
                                                margin: EdgeInsets.symmetric(
                                                    vertical: 4),
                                                color: Colors.grey.shade400,
                                              ),
                                              SizedBox(
                                                height: 8,
                                              ),
                                              Row(
                                                children: [
                                                  Column(
                                                    children: [
                                                      Container(
                                                        decoration: BoxDecoration(
                                                            image: DecorationImage(
                                                                fit: BoxFit
                                                                    .cover,
                                                                image: (ImageUtils.getImageFromStringBase64(
                                                                        stringImage:
                                                                            cartProductModel
                                                                                .imageData)
                                                                    .image)),
                                                            borderRadius:
                                                                BorderRadius.all(
                                                                    Radius.circular(
                                                                        4)),
                                                            border: Border.all(
                                                                color: Colors
                                                                    .grey
                                                                    .shade200)),
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 12,
                                                                top: 8,
                                                                right: 12,
                                                                bottom: 8),
                                                        margin: const EdgeInsets
                                                            .symmetric(
                                                            horizontal: 0),
                                                        height: 120,
                                                        width: 120,
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    width: 28,
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Container(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 0,
                                                                vertical: 3),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: <Widget>[
                                                            Text(
                                                              'Quantità prodotto: ',
                                                              style: CustomTextStyle
                                                                  .textFormFieldMedium
                                                                  .copyWith(
                                                                      color: Colors
                                                                          .grey
                                                                          .shade700,
                                                                      fontSize:
                                                                          12),
                                                            ),
                                                            ValueListenableBuilder<
                                                                int>(
                                                              builder: (BuildContext
                                                                      context,
                                                                  int value,
                                                                  Widget?
                                                                      child) {
                                                                return Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceAround,
                                                                  children: <Widget>[
                                                                    Padding(
                                                                      padding: const EdgeInsets
                                                                          .all(
                                                                          2.0),
                                                                      child: Text(
                                                                          '$value',
                                                                          style: CustomTextStyle.textFormFieldMedium.copyWith(
                                                                              color: Colors.grey.shade700,
                                                                              fontSize: 12)),
                                                                    )
                                                                  ],
                                                                );
                                                              },
                                                              valueListenable:
                                                                  cartProductModel
                                                                      .quantityCartProduct,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 8,
                                                      ),
                                                      Container(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 0,
                                                                vertical: 3),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: <Widget>[
                                                            Text(
                                                              'Prezzo prodotto: ',
                                                              style: CustomTextStyle
                                                                  .textFormFieldMedium
                                                                  .copyWith(
                                                                      color: Colors
                                                                          .grey
                                                                          .shade700,
                                                                      fontSize:
                                                                          12),
                                                            ),
                                                            Text(
                                                              MoneyUtils
                                                                  .getFormattedCurrency(
                                                                cartProductModel
                                                                    .priceCartProduct,
                                                              ),
                                                              style: CustomTextStyle
                                                                  .textFormFieldMedium
                                                                  .copyWith(
                                                                      color: Colors
                                                                          .grey
                                                                          .shade700,
                                                                      fontSize:
                                                                          12),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 8,
                                                      ),
                                                      Container(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 0,
                                                                vertical: 3),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: <Widget>[
                                                            Text(
                                                              'Variante prodotto: ',
                                                              style: CustomTextStyle
                                                                  .textFormFieldMedium
                                                                  .copyWith(
                                                                      color: Colors
                                                                          .grey
                                                                          .shade700,
                                                                      fontSize:
                                                                          12),
                                                            ),
                                                            Text(
                                                              cartProductModel
                                                                  .productAttributeExplicit,
                                                              maxLines: 1,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: CustomTextStyle
                                                                  .textFormFieldMedium
                                                                  .copyWith(
                                                                      color: Colors
                                                                          .grey
                                                                          .shade700,
                                                                      fontSize:
                                                                          12),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 8,
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 8,
                                              ),
                                              Container(
                                                width: double.infinity,
                                                height: 0.5,
                                                margin: EdgeInsets.symmetric(
                                                    vertical: 4),
                                                color: Colors.grey.shade400,
                                              ),
                                              SizedBox(
                                                height: 8,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Text('Note: ',
                                                      style: CustomTextStyle
                                                          .textFormFieldMedium
                                                          .copyWith(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 12)),
                                                  Flexible(
                                                    child: Text(
                                                      cartProductModel
                                                          .notesCartProduct,
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: CustomTextStyle
                                                          .textFormFieldMedium
                                                          .copyWith(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 12),
                                                    ),
                                                  )
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                            // ),
                          ),
                          CartDetailScreen(idCart: idCart) // Expanded(
                          //   child:
                          //       CheckoutCart(controller: refreshCartController),
                          // )
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
    );
  }
}

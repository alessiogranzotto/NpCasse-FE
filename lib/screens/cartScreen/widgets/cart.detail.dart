import 'package:currency_textfield/currency_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:np_casse/app/routes/app_routes.dart';
import 'package:np_casse/app/utilities/money_formatter.dart';
import 'package:np_casse/core/models/cart.model.dart';
import 'package:np_casse/core/models/user.app.institution.model.dart';
import 'package:np_casse/core/notifiers/authentication.notifier.dart';
import 'package:np_casse/core/notifiers/cart.notifier.dart';
import 'package:np_casse/core/utils/snackbar.util.dart';
import 'package:np_casse/screens/cartScreen/cart.screen.dart';
import 'package:provider/provider.dart';

enum PaymentType { contanti, bancomat, cartaCredito, assegni }

class CartDetailScreen extends StatefulWidget {
  const CartDetailScreen({super.key});

  @override
  State<CartDetailScreen> createState() => _CartDetailScreenState();
}

class _CartDetailScreenState extends State<CartDetailScreen> {
  bool _isButtonDisabled = false;
  bool cartHasData = true;
  bool visible = true;

  bool disabledFinalizeButton = true;
  int indexPayment = 0;
  late double toBeReturnedCalculation;
  late String _toBeReturned = '---';
  late bool _isSelectedPaymentVisible = true;
  var rateDiscounted = 0.0;
  var totalDiscount = 0.0;

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

  TextEditingController rateDiscoutTextEditingController =
      TextEditingController();
  void adjustPrice() {
    CartNotifier cartNotifier =
        Provider.of<CartNotifier>(context, listen: false);
    rateDiscounted =
        double.tryParse(rateDiscoutTextEditingController.text) ?? 0;
    if (rateDiscounted > 100) {
      rateDiscoutTextEditingController.text = '';
      rateDiscounted = 0;
    }
    totalDiscount =
        (rateDiscounted / 100) * cartNotifier.totalCartProductNoDonation;

    setState(() {
      cartNotifier.totalCartMoney.value =
          cartNotifier.subTotalCartMoney.value - totalDiscount;
    });
  }

  void cashInsertedOnChange() {
    CartNotifier cartNotifier =
        Provider.of<CartNotifier>(context, listen: false);
    var value = double.tryParse(
        textEditingControllerCashInserted.text.replaceAll(',', '.'));

    if (value != null) {
      if (value > 0) {
        toBeReturnedCalculation = value - cartNotifier.totalCartMoney.value;
        setState(() {
          if (toBeReturnedCalculation >= 0 &&
              cartNotifier.totalCartMoney.value > 0) {
            _toBeReturned =
                MoneyUtils.getFormattedCurrency(toBeReturnedCalculation);
            disabledFinalizeButton = false;
          } else {
            _toBeReturned = '---';
            disabledFinalizeButton = true;
          }
        });
      }
    }
  }

  void checkImport(int index) {
    CartNotifier cartNotifier =
        Provider.of<CartNotifier>(context, listen: false);
    setState(() {
      indexPayment = index;
      disabledFinalizeButton = true;
      if (index > 0 && cartNotifier.subTotalCartMoney.value > 0) {
        disabledFinalizeButton = false;
        textEditingControllerCashInserted.text = '';
      }
    });
  }

  void finalizeFunctionKnown() {
    CartNotifier cartNotifier =
        Provider.of<CartNotifier>(context, listen: false);

    AuthenticationNotifier authenticationNotifier =
        Provider.of<AuthenticationNotifier>(context, listen: false);
    UserAppInstitutionModel cUserAppInstitutionModel =
        authenticationNotifier.getSelectedUserAppInstitution();

    CartModel cCart = cartNotifier.getCurrentCart();

    var strTypePayment = PaymentType.values[indexPayment].toString();
    cartNotifier
        .setCartCheckout(
            context: context,
            token: authenticationNotifier.token,
            idCart: cCart.idCart,
            idUserAppInstitution: cUserAppInstitutionModel.idUserAppInstitution,
            totalPriceCart: cartNotifier.totalCartMoney.value,
            typePayment: strTypePayment)
        .then((value) {
      if (value > 0) {
        // if (context.mounted) {
        //   ScaffoldMessenger.of(context).showSnackBar(SnackUtil.stylishSnackBar(
        //       title: "Carrello",
        //       message: "Carrello chiuso correttamente",
        //       contentType: "success"));
        // }
        // homeNotifier.setHomeIndex(0);
        Navigator.of(context).pushNamed(AppRouter.shManage);
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackUtil.stylishSnackBar(
              title: "Carrello",
              message: "Errore di connessione",
              contentType: "failure"));
        }
      }
    });
  }

  void finalizeFunctionUnknown() {
    CartNotifier cartNotifier =
        Provider.of<CartNotifier>(context, listen: false);

    AuthenticationNotifier authenticationNotifier =
        Provider.of<AuthenticationNotifier>(context, listen: false);
    UserAppInstitutionModel cUserAppInstitutionModel =
        authenticationNotifier.getSelectedUserAppInstitution();

    CartModel cCart = cartNotifier.getCurrentCart();
    var strTypePayment = PaymentType.values[indexPayment].toString();
    cartNotifier
        .setCartCheckout(
            context: context,
            token: authenticationNotifier.token,
            idCart: cCart.idCart,
            idUserAppInstitution: cUserAppInstitutionModel.idUserAppInstitution,
            totalPriceCart: cartNotifier.totalCartMoney.value,
            typePayment: strTypePayment)
        .then((value) {
      if (value > 0) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackUtil.stylishSnackBar(
              title: "Carrello",
              message: "Carrello chiuso correttamente",
              contentType: "success"));
        }
        // homeNotifier.setHomeIndex(0);
        Navigator.of(context).popUntil((route) => route.isFirst);
        cartNotifier.refresh();
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackUtil.stylishSnackBar(
              title: "Carrello",
              message: "Errore di connessione",
              contentType: "failure"));
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    rateDiscoutTextEditingController.addListener(adjustPrice);
    textEditingControllerCashInserted.addListener(cashInsertedOnChange);
    toBeReturnedCalculation = 0;
    _toBeReturned = '---';
    _isSelectedPaymentVisible = true;
  }

  @override
  void dispose() {
    textEditingControllerCashInserted.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    CartNotifier cartNotifier = Provider.of<CartNotifier>(context);

    return Expanded(
      flex: 2,
      child: Container(
        margin: EdgeInsets.all(4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(4)),
        ),
        child: Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(4))),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(4)),
                border: Border.all(color: Colors.grey.shade200)),
            padding: EdgeInsets.only(left: 12, top: 8, right: 12, bottom: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 4,
                ),
                Text(
                  "Dettaglio carrello",
                  style: CustomTextStyle.textFormFieldMedium.copyWith(
                      fontSize: 12,
                      color: Colors.black,
                      fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: 4,
                ),
                Container(
                  width: double.infinity,
                  height: 0.5,
                  margin: EdgeInsets.symmetric(vertical: 4),
                  color: Colors.grey.shade400,
                ),
                SizedBox(
                  height: 4,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 0, vertical: 3),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Prodotti: ',
                        style: CustomTextStyle.textFormFieldMedium.copyWith(
                            color: Colors.grey.shade700, fontSize: 12),
                      ),
                      ValueListenableBuilder<int>(
                        builder:
                            (BuildContext context, int value, Widget? child) {
                          return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                value.toString(),
                                style: CustomTextStyle.textFormFieldMedium
                                    .copyWith(
                                        color: Colors.black, fontSize: 12),
                              ));
                        },
                        valueListenable: cartNotifier.totalCartProductType,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 4,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 0, vertical: 3),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Quantità: ',
                        style: CustomTextStyle.textFormFieldMedium.copyWith(
                            color: Colors.grey.shade700, fontSize: 12),
                      ),
                      ValueListenableBuilder<int>(
                        builder:
                            (BuildContext context, int value, Widget? child) {
                          return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                value.toString(),
                                style: CustomTextStyle.textFormFieldMedium
                                    .copyWith(
                                        color: Colors.black, fontSize: 12),
                              ));
                        },
                        valueListenable: cartNotifier.totalCartProduct,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 4,
                ),
                Container(
                  width: double.infinity,
                  height: 0.5,
                  margin: EdgeInsets.symmetric(vertical: 4),
                  color: Colors.grey.shade400,
                ),
                SizedBox(
                  height: 4,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 0, vertical: 3),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Sub Totale: ',
                        style: CustomTextStyle.textFormFieldMedium.copyWith(
                            color: Colors.grey.shade700, fontSize: 12),
                      ),
                      ValueListenableBuilder<double>(
                        builder: (BuildContext context, double value,
                            Widget? child) {
                          return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                MoneyUtils.getFormattedCurrency(value),
                                style: CustomTextStyle.textFormFieldMedium
                                    .copyWith(
                                        color: Colors.black, fontSize: 12),
                              ));
                        },
                        valueListenable: cartNotifier.subTotalCartMoney,
                      ),
                    ],
                  ),
                ),

                SizedBox(
                  height: 4,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 0, vertical: 3),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Sconto ' +
                            rateDiscounted.toStringAsFixed(2) +
                            " %" +
                            " equivalente a " +
                            MoneyUtils.getFormattedCurrency(totalDiscount),
                        style: CustomTextStyle.textFormFieldMedium.copyWith(
                            color: Colors.grey.shade700, fontSize: 12),
                      ),
                      SizedBox(
                        width: 100,
                        child: TextFormField(
                          maxLines: 1,
                          textAlignVertical: TextAlignVertical.top,
                          controller: rateDiscoutTextEditingController,
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true, signed: false),
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly
                          ], // Only numbers can be entered
                          style: Theme.of(context).textTheme.titleSmall,
                          decoration: const InputDecoration(
                            suffixIcon: Icon(Icons.percent),
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                              borderSide:
                                  BorderSide(color: Colors.black, width: 0.2),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                              borderSide:
                                  BorderSide(color: Colors.red, width: 0.2),
                            ),
                          ),
                        ),
                      ),
                      // Slider(
                      //   label: rateDiscounted.toStringAsFixed(2) + " %",
                      //   divisions: 100,
                      //   min: 0.0,
                      //   max: 100.0,
                      //   activeColor: Colors.lightBlue,
                      //   inactiveColor: Colors.purple.shade100,
                      //   value: rateDiscounted,
                      //   onChanged: (double value) {
                      //     adjustPrice(value);
                      //   },
                      // ),
                    ],
                  ),
                ),

                // createPriceItem("Bag discount", '5197', Colors.teal.shade300),
                // createPriceItem("Tax", '96', Colors.grey.shade700),
                // createPriceItem("Order Total", '2013', Colors.grey.shade700),
                // createPriceItem(
                //     "Delievery Charges", "FREE", Colors.teal.shade300),
                SizedBox(
                  height: 4,
                ),
                Container(
                  width: double.infinity,
                  height: 0.5,
                  margin: EdgeInsets.symmetric(vertical: 4),
                  color: Colors.grey.shade400,
                ),
                SizedBox(
                  height: 4,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 0, vertical: 3),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "Totale",
                        style: CustomTextStyle.textFormFieldBold
                            .copyWith(color: Colors.black, fontSize: 14),
                      ),
                      ValueListenableBuilder<double>(
                        builder: (BuildContext context, double value,
                            Widget? child) {
                          return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                MoneyUtils.getFormattedCurrency(value),
                                style: CustomTextStyle.textFormFieldBold
                                    .copyWith(
                                        color: Colors.black, fontSize: 14),
                              ));
                        },
                        valueListenable: cartNotifier.totalCartMoney,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 4,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 0, vertical: 3),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Metodo di pagamento ',
                        style: CustomTextStyle.textFormFieldMedium.copyWith(
                            color: Colors.grey.shade700, fontSize: 12),
                      ),
                      ToggleButtons(
                          direction: Axis.horizontal,
                          onPressed: (int index) {
                            setState(() {
                              // The button that is tapped is set to true, and the others to false.
                              for (int i = 0;
                                  i < _selectedPayment.length;
                                  i++) {
                                _selectedPayment[i] = i == index;
                              }
                              if (index == 0) {
                                _isSelectedPaymentVisible = true;
                              } else {
                                _isSelectedPaymentVisible = false;
                              }
                              checkImport(index);
                            });
                          },
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8)),
                          selectedColor:
                              Theme.of(context).colorScheme.secondaryContainer,
                          isSelected: _selectedPayment,
                          children: const [
                            Tooltip(
                              message: 'Contanti',
                              child: SizedBox(
                                height: 24,
                                width: 24,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.euro,
                                      size: 20,
                                    ),
                                    // Text('Contanti',
                                    //     style:
                                    //         Theme.of(context).textTheme.bodyMedium),
                                  ],
                                ),
                              ),
                            ),
                            Tooltip(
                              message: 'Bancomat',
                              child: SizedBox(
                                height: 24,
                                width: 24,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.card_giftcard,
                                      size: 20,
                                    ),
                                    // Text('Bancomat',
                                    //     style:
                                    //         Theme.of(context).textTheme.bodyMedium),
                                  ],
                                ),
                              ),
                            ),
                            Tooltip(
                              message: 'Carte di credito',
                              child: SizedBox(
                                height: 24,
                                width: 24,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.credit_card,
                                      size: 20,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Tooltip(
                              message: 'Assegni',
                              child: SizedBox(
                                height: 24,
                                width: 24,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.fact_check,
                                      size: 20,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ]),
                    ],
                  ),
                ),
                SizedBox(
                  height: 4,
                ),

                Visibility(
                  maintainSize: false,
                  maintainAnimation: true,
                  maintainState: true,
                  visible: _isSelectedPaymentVisible,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 0, vertical: 3),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Importo ricevuto ',
                          style: CustomTextStyle.textFormFieldMedium.copyWith(
                              color: Colors.grey.shade700, fontSize: 12),
                        ),
                        SizedBox(
                          width: 196,
                          child: TextFormField(
                            maxLines: 1,
                            textAlignVertical: TextAlignVertical.top,
                            controller: textEditingControllerCashInserted,
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true, signed: false),
                            style: Theme.of(context).textTheme.titleSmall,
                            decoration: const InputDecoration(
                              suffixIcon: Icon(Icons.euro),
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                                borderSide:
                                    BorderSide(color: Colors.black, width: 0.2),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                                borderSide:
                                    BorderSide(color: Colors.red, width: 0.2),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Visibility(
                  maintainSize: false,
                  maintainAnimation: true,
                  maintainState: true,
                  visible: _isSelectedPaymentVisible,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 0, vertical: 3),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Resto da consegnare',
                          style: CustomTextStyle.textFormFieldBold
                              .copyWith(color: Colors.black, fontSize: 14),
                        ),
                        Text(
                          _toBeReturned,
                          style: CustomTextStyle.textFormFieldBold
                              .copyWith(color: Colors.black, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 4,
                ),
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context)
                                    .colorScheme
                                    .inversePrimary,
                                textStyle: const TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.bold)),
                            onPressed: disabledFinalizeButton
                                ? null
                                : finalizeFunctionUnknown,
                            child: const Column(
                              children: [
                                Text("Check Out"),
                                Text("(donazione anonima)"),
                              ],
                            )),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context)
                                    .colorScheme
                                    .inversePrimary,
                                textStyle: const TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.bold)),
                            onPressed: disabledFinalizeButton
                                ? null
                                : finalizeFunctionKnown,
                            child: const Text("Check Out (richiedi ricevuta)")),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

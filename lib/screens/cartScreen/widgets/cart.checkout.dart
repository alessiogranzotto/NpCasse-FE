import 'package:currency_textfield/currency_textfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:np_casse/core/models/cart.model.dart';
import 'package:np_casse/core/models/user.app.institution.model.dart';
import 'package:np_casse/core/notifiers/authentication.notifier.dart';
import 'package:np_casse/core/notifiers/cart.notifier.dart';
import 'package:np_casse/core/notifiers/home.notifier.dart';
import 'package:np_casse/core/utils/snackbar.util.dart';
import 'package:np_casse/screens/cartScreen/cart.screen.dart';
import 'package:np_casse/screens/cartScreen/sh.manage.screen.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:provider/provider.dart';

enum PaymentType { contanti, bancomat, cartaCredito, assegni }

class CheckoutCart extends StatefulWidget {
  const CheckoutCart({Key? key, required this.controller}) : super(key: key);
  final RefreshCartController controller;
  @override
  // ignore: no_logic_in_create_state
  State<CheckoutCart> createState() => _CheckoutCartState(controller);
}

class _CheckoutCartState extends State<CheckoutCart> {
  _CheckoutCartState(RefreshCartController refreshController) {
    refreshController.refreshMoneyCartFromParent = refreshMoneyCartFromParent;
  }
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
    super.initState();
    textEditingControllerCashInserted.addListener(cashInsertedOnChange);
    toBeReturnedCalculation = 0;
    _toBeReturned = '---';
    _isNumericPadVisible = true;
  }

  @override
  void dispose() {
    textEditingControllerCashInserted.dispose();
    super.dispose();
  }

  void refreshMoneyCartFromParent() {
    cashInsertedOnChange();
  }

  void refreshSummaryCart() {}

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

  void checkImport(int index) {
    CartNotifier cartNotifier =
        Provider.of<CartNotifier>(context, listen: false);
    setState(() {
      indexPayment = index;
      disabledFinalizeButton = true;
      if (index > 0 && cartNotifier.totalCartMoney.value > 0) {
        disabledFinalizeButton = false;
        textEditingControllerCashInserted.text = '';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    AuthenticationNotifier authenticationNotifier =
        Provider.of<AuthenticationNotifier>(context);
    CartNotifier cartNotifier = Provider.of<CartNotifier>(context);
    HomeNotifier homeNotifier = Provider.of<HomeNotifier>(context);
    UserAppInstitutionModel cUserAppInstitutionModel =
        authenticationNotifier.getSelectedUserAppInstitution();

    CartModel cCart = cartNotifier.getCart();

    void finalizeFunctionKnown() {
      var strTypePayment = PaymentType.values[indexPayment].toString();
      cartNotifier
          .setCartPayment(
              context: context,
              token: authenticationNotifier.token,
              idCart: cCart.idCart,
              idUserAppInstitution:
                  cUserAppInstitutionModel.idUserAppInstitution,
              typePayment: strTypePayment)
          .then((value) {
        if (value > 0) {
          Navigator.pop(context);
          PersistentNavBarNavigator.pushNewScreen(
            context,
            screen: const ShManageScreen(),
            withNavBar: true,
            pageTransitionAnimation: PageTransitionAnimation.fade,
          );
        } else {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackUtil.stylishSnackBar(
                    title: "Pagamento",
                    message: "Errore di connessione",
                    contentType: "failure"));
          }
        }
      });
    }

    void finalizeFunctionUnknown() {
      var strTypePayment = PaymentType.values[indexPayment].toString();
      cartNotifier
          .setCartPayment(
              context: context,
              token: authenticationNotifier.token,
              idCart: cCart.idCart,
              idUserAppInstitution:
                  cUserAppInstitutionModel.idUserAppInstitution,
              typePayment: strTypePayment)
          .then((value) {
        if (value > 0) {
          Navigator.of(context).popUntil((route) => route.isFirst);
          homeNotifier.setHomeIndex(0);
        } else {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackUtil.stylishSnackBar(
                    title: "Pagamento",
                    message: "Errore di connessione",
                    contentType: "failure"));
          }
        }
      });
    }

    return Container(
      child: Column(
        children: [
          Container(
                width: double.infinity,
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color:Color.fromARGB(255, 237, 208, 171),
                  borderRadius: BorderRadius.circular(20),),
            child:Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('Totale:',
                        style: Theme.of(context).textTheme.titleSmall),
                  ValueListenableBuilder<double>(
                    builder:
                        (BuildContext context, double value, Widget? child) {
                      return Chip(
                        label: Text(
                          '${value.toStringAsFixed(2)} €',
                        ),
                        backgroundColor: Theme.of(context).primaryColor,
                      );
                    },
                    valueListenable: cartNotifier.totalCartMoney,
                  ),
                  //Padding(padding: EdgeInsets.only(left:700)),
                  ToggleButtons(
                    direction: Axis.horizontal,
                    onPressed: (int index) {
                      setState(() {
                        // The button that is tapped is set to true, and the others to false.
                        for (int i = 0; i < _selectedPayment.length; i++) {
                          _selectedPayment[i] = i == index;
                        }
                        if (index == 0) {
                          _isNumericPadVisible = true;
                        } else {
                          _isNumericPadVisible = false;
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
                      SizedBox(
                        height: 24,
                        width: 24,
                        child: Column(
                          //mainAxisAlignment: MainAxisAlignment.center,
                          //crossAxisAlignment: CrossAxisAlignment.center,
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
                      SizedBox(
                        height: 24,
                        width: 24,
                        child: Column(
                          //mainAxisAlignment: MainAxisAlignment.end,
                          //crossAxisAlignment: CrossAxisAlignment.center,
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
                      SizedBox(
                        height: 24,
                        width: 24,
                        child: Column(
                          //mainAxisAlignment: MainAxisAlignment.center,
                          //crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.credit_card,
                              size: 20,
                            ),
                            // Text('Carta di credito',
                            //     style:
                            //         Theme.of(context).textTheme.bodyMedium),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 24,
                        width: 24,
                        child: Column(
                          //mainAxisAlignment: MainAxisAlignment.center,
                          //crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.fact_check,
                              size: 20,
                            ),
                            // Text('Assegni',
                            //     style:
                            //         Theme.of(context).textTheme.bodyMedium),
                          ],
                    ),
                  ),
              ])],
          ),),
      Container(
        width: double.infinity,
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color:Color.fromARGB(255, 237, 208, 171),
            borderRadius: BorderRadius.circular(20),),
        child: Visibility(
        maintainSize: true,
        maintainAnimation: true,
        maintainState: true,
        visible: _isNumericPadVisible,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
           children:[Text('Importo ricevuto:',
                  style: Theme.of(context).textTheme.titleSmall),
             SizedBox(
                width: 100,
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
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide:
                          BorderSide(color: Colors.black, width: 0.2),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(color: Colors.red, width: 0.2),
                    ),
                  ),
                ),
           ),
              Text('Resto:',
                  style: Theme.of(context).textTheme.titleSmall),
             Chip(
                  label: Text(
                _toBeReturned,
              )),
          ],
        ),
      ),),
      Container(
        width: double.infinity,
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color:Color.fromARGB(255, 237, 208, 171),
          borderRadius: BorderRadius.circular(20),),
        child:Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
             padding: const EdgeInsets.only(left: 30, right: 320),
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Theme.of(context).colorScheme.inversePrimary,
                    textStyle: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.bold)),
                onPressed:
                    disabledFinalizeButton ? null : finalizeFunctionUnknown,
                child: const Column(
                  children: [
                    Text("Check Out"),
                    Text("(donazione anonima)"),
                  ],
                )),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 320,right: 30),
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Theme.of(context).colorScheme.inversePrimary,
                    textStyle: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.bold)),
                onPressed:
                    disabledFinalizeButton ? null : finalizeFunctionKnown,
                child: const Text("Check Out (richiedi ricevuta)")),
          ),
        ],
      ),
      ),
    ],
  ),
);}
}

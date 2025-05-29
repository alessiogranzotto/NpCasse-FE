import 'package:currency_textfield/currency_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jumping_dot/jumping_dot.dart';
import 'package:np_casse/app/constants/colors.dart';
import 'package:np_casse/app/routes/api_routes.dart';
import 'package:np_casse/app/routes/app_routes.dart';
import 'package:np_casse/app/utilities/money_formatter.dart';
import 'package:np_casse/componenents/custom.drop.down.button.form.field.field.dart';
import 'package:np_casse/core/models/institution.model.dart';
import 'package:np_casse/core/models/user.app.institution.model.dart';
import 'package:np_casse/core/notifiers/authentication.notifier.dart';
import 'package:np_casse/core/notifiers/cart.notifier.dart';
import 'package:np_casse/core/notifiers/institution.attribute.notifier.dart';
import 'package:np_casse/core/utils/snackbar.util.dart';
import 'package:np_casse/screens/cartScreen/cart.screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

enum PaymentType { contanti, bancomat, cartaCredito, assegni }

class CartDetailScreen extends StatefulWidget {
  const CartDetailScreen({Key? key, required this.idCart}) : super(key: key);
  final int idCart;
  @override
  State<CartDetailScreen> createState() => _CartDetailScreenState();
}

class _CartDetailScreenState extends State<CartDetailScreen> {
  // bool _isButtonDisabled = false;
  bool cartHasData = true;
  bool visible = true;

  bool disabledFinalizeButton = true;
  int indexPayment = 0;
  late double toBeReturnedCalculation;
  late String _toBeReturned = '---';
  late bool _isSelectedPaymentVisible = true;
  late bool _isStripePayment = false;
  var rateDiscounted = 0.0;
  var totalDiscount = 0.0;
  var totalCartMoney = 0;

  static const platform = MethodChannel('com.example.npcasse/stripe');
  String resultText = '';
  String _stripeStatus = 'Terminal is not initialized yet.';
  bool isTerminalInitialized = false;
  bool isReaderDiscovered =
      false; // This will track if the reader has already been discovered.
  bool isReaderConnected = false;

  final List<bool> _selectedPayment = <bool>[true, false, false, false];
  String selectedFiscalization = "0";
  bool fiscalizationVisible = false;
  bool posAuthorization = false;
  bool isLoadingFiscalization = true;
  List<DropdownMenuItem<String>> availableFiscalization = [
    DropdownMenuItem(child: Text("Nessuna fiscalizzazione"), value: "0"),
    DropdownMenuItem(child: Text("Emissione scontrino"), value: "1"),
    DropdownMenuItem(child: Text("Emissione fattura"), value: "2"),
  ];
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
      if (index == 3 && cartNotifier.subTotalCartMoney.value > 0) {
        disabledFinalizeButton = false;
        textEditingControllerCashInserted.text = '';
      } else if (index == 1 || index == 2) {
        posAuthorization
            ? disabledFinalizeButton = true
            : disabledFinalizeButton = false;
      }
    });
  }

  void finalizeStripePayment() {
    CartNotifier cartNotifier =
        Provider.of<CartNotifier>(context, listen: false);

    AuthenticationNotifier authenticationNotifier =
        Provider.of<AuthenticationNotifier>(context, listen: false);
    UserAppInstitutionModel cUserAppInstitutionModel =
        authenticationNotifier.getSelectedUserAppInstitution();

    var strTypePayment = PaymentType.values[indexPayment].toString();
    cartNotifier
        .setCartCheckout(
            context: context,
            token: authenticationNotifier.token,
            idCart: widget.idCart,
            idUserAppInstitution: cUserAppInstitutionModel.idUserAppInstitution,
            totalPriceCart: cartNotifier.totalCartMoney.value,
            percDiscount:
                double.tryParse(rateDiscoutTextEditingController.text) ?? 0,
            typePayment: strTypePayment,
            fiscalization: int.parse(selectedFiscalization),
            modeCartCheckout: 0)
        .then((value) {
      if (value > 0) {
        setState(() {
          disabledFinalizeButton = false;
        });
        // if (context.mounted) {
        //   ScaffoldMessenger.of(context).showSnackBar(SnackUtil.stylishSnackBar(
        //       title: "Carrello",
        //       message: "Carrello chiuso correttamente",
        //       contentType: "success"));
        // }
        //cartNotifier.refresh();
      } else {
        showCartErrorSnackbar();
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

    var strTypePayment = PaymentType.values[indexPayment].toString();
    cartNotifier
        .setCartCheckout(
            context: context,
            token: authenticationNotifier.token,
            idCart: widget.idCart,
            idUserAppInstitution: cUserAppInstitutionModel.idUserAppInstitution,
            totalPriceCart: cartNotifier.totalCartMoney.value,
            percDiscount:
                double.tryParse(rateDiscoutTextEditingController.text) ?? 0,
            typePayment: strTypePayment,
            fiscalization: int.parse(selectedFiscalization),
            modeCartCheckout: 2)
        .then((value) {
      if (value > 0) {
        // if (context.mounted) {
        //   ScaffoldMessenger.of(context).showSnackBar(SnackUtil.stylishSnackBar(
        //       title: "Carrello",
        //       message: "Carrello chiuso correttamente",
        //       contentType: "success"));
        // }
        // homeNotifier.setHomeIndex(0);
        Navigator.of(context)
            .pushNamed(AppRouter.shManage, arguments: widget.idCart);
      } else {
        showCartErrorSnackbar();
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

    int tFiscalization = int.parse(selectedFiscalization);
    if (tFiscalization == 2) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackUtil.stylishSnackBar(
            title: "Carrello",
            message: "Impossibile emettere fattura se il carrello è anonimo",
            contentType: "warning"));
      }
    } else {
      var strTypePayment = PaymentType.values[indexPayment].toString();
      cartNotifier
          .setCartCheckout(
              context: context,
              token: authenticationNotifier.token,
              idCart: widget.idCart,
              idUserAppInstitution:
                  cUserAppInstitutionModel.idUserAppInstitution,
              totalPriceCart: cartNotifier.totalCartMoney.value,
              percDiscount:
                  double.tryParse(rateDiscoutTextEditingController.text) ?? 0,
              typePayment: strTypePayment,
              fiscalization: int.parse(selectedFiscalization),
              modeCartCheckout: 1)
          .then((value) {
        if (value > 0) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackUtil.stylishSnackBar(
                    title: "Carrello",
                    message: "Carrello chiuso correttamente",
                    contentType: "success"));
          }
          // homeNotifier.setHomeIndex(0);
          Navigator.of(context).popUntil((route) => route.isFirst);
          cartNotifier.refresh();
        } else {
          showCartErrorSnackbar();
        }
      });
    }
  }

  void showCartErrorSnackbar() {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackUtil.stylishSnackBar(
          title: "Carrello",
          message: "Errore di connessione",
          contentType: "failure"));
    }
  }

  // Method to initialize Stripe terminal
  Future<void> initializeStripe(int idUserAppInstitution, String? token) async {
    try {
      // Send the idUserAppInstitution to the native side when calling 'initializeStripe'
      final result = await platform.invokeMethod('initializeStripe', {
        'idUserAppInstitution':
            idUserAppInstitution, // Pass the idUserAppInstitution
        'token': token, // Pass token as part of the method arguments
        'casseURL': ApiRoutes.casseURL
      });

      // On success, mark the terminal as initialized
      setState(() {
        isTerminalInitialized = true;
      });

      // Optionally print the result from the native side
      print(result);
    } on PlatformException catch (e) {
      // On error, handle initialization failure
      setState(() {
        _stripeStatus = '${e.message}';
        isTerminalInitialized = false;
      });
    }
  }

  Future<void> _discoverReaders(int idUserAppInstitution, String? token) async {
    if (!isTerminalInitialized) {
      return;
    }

    // Check if readers are already discovered
    if (isReaderDiscovered) {
      return; // Skip discovering if readers are already discovered
    }

    // Check if the terminal is already connected to a reader
    if (await platform.invokeMethod('isReaderConnected')) {
      isReaderDiscovered = true;
      getConnectedReaderInfo();
      return;
    }

    try {
      // Now, attempt to discover readers
      final result = await platform.invokeMethod('discoverReaders', {
        'idUserAppInstitution':
            idUserAppInstitution, // Pass the idUserAppInstitution
        'token': token, // Pass token as part of the method arguments
      });

      if (result != null) {
        // Delay calling getConnectedReaderInfo by 1 second
        await Future.delayed(Duration(seconds: 2));
        // Mark the reader as discovered to avoid discovering again
        setState(() {
          isReaderDiscovered = true;
        });

        // Call getConnectedReaderInfo method after the delay
        getConnectedReaderInfo();
      } else {
        setState(() {
          _stripeStatus = 'No readers found.';
          isReaderDiscovered = false;
        });
      }
    } on PlatformException catch (e) {
      setState(() {
        _stripeStatus = '${e.message}';
      });
    }
  }

  Future<void> getConnectedReaderInfo() async {
    try {
      // Fetch connected device info
      final connectedDevice =
          await platform.invokeMethod('getConnectedDeviceInfo');

      if (connectedDevice != null && connectedDevice is Map) {
        // Safely cast map values to String and handle potential null values
        final serialNumber = connectedDevice["serialNumber"] ?? "Unknown";

        setState(() {
          _stripeStatus = 'Connected to $serialNumber';
          isReaderConnected = true;
        });
      } else {
        setState(() {
          _stripeStatus = 'No connected device information available';
          isReaderConnected = false;
        });
      }
    } on PlatformException catch (e) {
      setState(() {
        _stripeStatus = '${e.message}';
        isReaderConnected = false;
      });
    }
  }

  Future<void> _makePayment() async {
    int amount = totalCartMoney; // Example: 100 cents = $1.00
    String currency = 'EUR';

    if (!isTerminalInitialized) {
      setState(() {
        _stripeStatus = 'Terminal or Reader is not connected.';
      });
      return;
    }

    try {
      final paymentResult = await platform.invokeMethod('processPayment', {
        'amount': amount,
        'currency': currency,
      });
      setState(() {
        _stripeStatus = paymentResult;
        disabledFinalizeButton = false;
        textEditingControllerCashInserted.text = '';
      });
      disconnectReader();
      finalizeStripePayment();
    } on PlatformException catch (e) {
      setState(() {
        _stripeStatus = '${e.message}';
      });
    }
  }

  Future<void> disconnectReader() async {
    try {
      final String result = await platform.invokeMethod('disconnectReader');
      setState(() {
        isReaderConnected = false;
      });
      print(result); // This will print the success message from the native code
    } on PlatformException catch (e) {
      print("$e");
    }
  }

  Future<void> uninitializeStripe() async {
    try {
      final String result = await platform.invokeMethod('uninitializeStripe');
      print(result); // This will print the success message from the native code
    } on PlatformException catch (e) {
      print("Error uninitializing terminal: ${e.message}");
    }
  }

  onFiscalizationChanged(value) {
    selectedFiscalization = value;
  }

  Future<void> getInstitutionAttribute() async {
    setState(() {
      isLoadingFiscalization = true;
    });
    AuthenticationNotifier authenticationNotifier =
        Provider.of<AuthenticationNotifier>(context, listen: false);
    UserAppInstitutionModel cUserAppInstitutionModel =
        authenticationNotifier.getSelectedUserAppInstitution();

    InstitutionAttributeNotifier institutionAttributeNotifier =
        Provider.of<InstitutionAttributeNotifier>(context, listen: false);

    await institutionAttributeNotifier
        .getInstitutionAttribute(
            context: context,
            token: authenticationNotifier.token,
            idUserAppInstitution: cUserAppInstitutionModel.idUserAppInstitution,
            idInstitution:
                cUserAppInstitutionModel.idInstitutionNavigation.idInstitution,
            isDelayed: true)
        .then((value) {
      var snapshot = value as List<InstitutionAttributeModel>;
      var itemInstitutionFiscalized = snapshot
          .where((element) => element.attributeName == 'Institution.Fiscalized')
          .firstOrNull;
      if (itemInstitutionFiscalized != null &&
          itemInstitutionFiscalized.attributeValue == "true") {
        selectedFiscalization = "1";
        setState(() {
          fiscalizationVisible = true;
        });
      } else {
        setState(() {
          fiscalizationVisible = false;
        });
      }
      var itemPosAuthorization = snapshot
          .where((element) =>
              element.attributeName == 'Institution.PosAuthorization')
          .firstOrNull;
      if (itemPosAuthorization != null &&
          itemPosAuthorization.attributeValue == "true") {
        setState(() {
          posAuthorization = true;
        });
      } else {
        setState(() {
          posAuthorization = false;
        });
      }
      setState(() {
        isLoadingFiscalization = false;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getInstitutionAttribute();
    rateDiscoutTextEditingController.addListener(adjustPrice);
    textEditingControllerCashInserted.addListener(cashInsertedOnChange);
    toBeReturnedCalculation = 0;
    _toBeReturned = '---';
    _isSelectedPaymentVisible = true;
    _isStripePayment = false;
  }

  @override
  void dispose() {
    super.dispose();
    textEditingControllerCashInserted.dispose();
    rateDiscoutTextEditingController.dispose();
    if (!kIsWeb) {
      uninitializeStripe();
    }
  }

  @override
  Widget build(BuildContext context) {
    CartNotifier cartNotifier = Provider.of<CartNotifier>(context);
    AuthenticationNotifier authenticationNotifier =
        Provider.of<AuthenticationNotifier>(context);
    UserAppInstitutionModel? cUserAppInstitutionModel =
        authenticationNotifier.getSelectedUserAppInstitution();

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
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 2,
                  ),
                  Text(
                    "Dettaglio carrello: " + widget.idCart.toString(),
                    style: CustomTextStyle.textFormFieldMedium.copyWith(
                        fontSize: 12,
                        color: Colors.black,
                        fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  Container(
                    width: double.infinity,
                    height: 0.5,
                    margin: EdgeInsets.symmetric(vertical: 4),
                    color: Colors.grey.shade400,
                  ),
                  SizedBox(
                    height: 2,
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
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 4.0),
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
                    height: 2,
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
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 4.0),
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
                    height: 2,
                  ),
                  Container(
                    width: double.infinity,
                    height: 0.5,
                    margin: EdgeInsets.symmetric(vertical: 4),
                    color: Colors.grey.shade400,
                  ),
                  SizedBox(
                    height: 2,
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
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 4.0),
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
                    height: 2,
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
                            enabled: !_isStripePayment,
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
                    height: 2,
                  ),
                  Container(
                    width: double.infinity,
                    height: 0.5,
                    margin: EdgeInsets.symmetric(vertical: 4),
                    color: Colors.grey.shade400,
                  ),
                  SizedBox(
                    height: 2,
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
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 4.0),
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
                    height: 2,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 0, vertical: 3),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Metodo di pagamento ',
                              style: CustomTextStyle.textFormFieldMedium
                                  .copyWith(
                                      color: Colors.grey.shade700,
                                      fontSize: 12),
                            ),
                          ],
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
                                  _isStripePayment = false;
                                } else if (index == 1 || index == 2) {
                                  posAuthorization
                                      ? disabledFinalizeButton = true
                                      : disabledFinalizeButton = false;
                                  _isSelectedPaymentVisible = false;
                                  _isStripePayment = true;
                                  totalCartMoney =
                                      (cartNotifier.totalCartMoney.value * 100)
                                          .toInt();
                                  if (!isTerminalInitialized) {
                                    initializeStripe(
                                        cUserAppInstitutionModel
                                            .idUserAppInstitution,
                                        authenticationNotifier.token);
                                  }
                                  if (!isReaderDiscovered) {
                                    Future.delayed(Duration(seconds: 2), () {
                                      // This callback is executed after the delay
                                      _discoverReaders(
                                          cUserAppInstitutionModel
                                              .idUserAppInstitution,
                                          authenticationNotifier.token);
                                    });
                                  } else {
                                    getConnectedReaderInfo();
                                  }
                                } else {
                                  _isSelectedPaymentVisible = false;
                                  _isStripePayment = false;
                                }
                                checkImport(index);
                              });
                            },
                            borderRadius:
                                const BorderRadius.all(Radius.circular(8)),
                            selectedColor: Theme.of(context)
                                .colorScheme
                                .secondaryContainer,
                            isSelected: _selectedPayment,
                            children: const [
                              Tooltip(
                                message: 'Contanti',
                                child: SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
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
                    height: 2,
                  ),

                  Visibility(
                    maintainSize: true,
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
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      decimal: true, signed: false),
                              style: Theme.of(context).textTheme.titleSmall,
                              decoration: const InputDecoration(
                                suffixIcon: Icon(Icons.euro),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                  borderSide: BorderSide(
                                      color: Colors.black, width: 0.2),
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
                    height: 2,
                  ),
                  Visibility(
                    maintainSize: true,
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
                    height: 2,
                  ),
                  Visibility(
                    maintainSize: true,
                    maintainAnimation: true,
                    maintainState: true,
                    visible: _isStripePayment,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 0, vertical: 2),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 300, // Set the desired width limit
                            child: Text(
                              _stripeStatus,
                              style: CustomTextStyle.textFormFieldBold.copyWith(
                                color: Colors.black,
                                fontSize: 14,
                              ),
                              maxLines: 3, // Set the max number of lines
                              overflow: TextOverflow
                                  .ellipsis, // Optional: To handle overflow with ellipsis
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 0),
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Theme.of(context)
                                        .colorScheme
                                        .inversePrimary,
                                    textStyle: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold)),
                                onPressed: isReaderConnected && _isStripePayment
                                    ? _makePayment
                                    : null,
                                child: const Column(
                                  children: [
                                    Text("Invia Pagamento"),
                                  ],
                                )),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  isLoadingFiscalization
                      ? SizedBox(
                          height: 60,
                          child: JumpingDots(
                            color: CustomColors.darkBlue,
                            radius: 10,
                            numberOfDots: 5,
                          ))
                      : (fiscalizationVisible
                          ? CustomDropDownButtonFormField(
                              enabled: true,
                              actualValue: selectedFiscalization,
                              labelText: 'Fiscalizzazione',
                              listOfValue: availableFiscalization,
                              onItemChanged: (value) {
                                onFiscalizationChanged(value);
                              })
                          : SizedBox(
                              height: 60,
                            )),

                  Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        width: double.infinity,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0, vertical: 2.0),
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Theme.of(context)
                                              .colorScheme
                                              .inversePrimary,
                                          textStyle: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold)),
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
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0, vertical: 4.0),
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Theme.of(context)
                                              .colorScheme
                                              .inversePrimary,
                                          textStyle: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold)),
                                      onPressed: disabledFinalizeButton
                                          ? null
                                          : finalizeFunctionKnown,
                                      child: const Text(
                                          "Check Out (richiedi ricevuta)")),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

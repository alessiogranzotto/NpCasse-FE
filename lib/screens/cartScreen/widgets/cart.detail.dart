import 'package:collection/collection.dart';
import 'package:currency_textfield/currency_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jumping_dot/jumping_dot.dart';
import 'package:np_casse/app/constants/functional.dart';
import 'package:np_casse/app/routes/api_routes.dart';
import 'package:np_casse/app/routes/app_routes.dart';
import 'package:np_casse/app/utilities/money_formatter.dart';
import 'package:np_casse/componenents/custom.drop.down.button.form.field.field.dart';
import 'package:np_casse/core/models/cart.product.model.dart';
import 'package:np_casse/core/models/institution.model.dart';
import 'package:np_casse/core/models/product.catalog.model.dart';
import 'package:np_casse/core/models/product.category.mapping.model.dart';
import 'package:np_casse/core/models/user.app.institution.model.dart';
import 'package:np_casse/core/notifiers/authentication.notifier.dart';
import 'package:np_casse/core/notifiers/cart.notifier.dart';
import 'package:np_casse/core/notifiers/institution.attribute.notifier.dart';
import 'package:np_casse/core/themes/app.theme.dart';
import 'package:np_casse/core/utils/snackbar.util.dart';
import 'package:np_casse/screens/cartScreen/cart.screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:uiblock/uiblock.dart';

class CartDetailScreen extends StatefulWidget {
  const CartDetailScreen({Key? key, required this.idCart}) : super(key: key);
  final int idCart;
  @override
  State<CartDetailScreen> createState() => _CartDetailScreenState();
}

class _CartDetailScreenState extends State<CartDetailScreen> {
  late CartNotifier cartNotifier;

  bool cartHasData = true;
  bool visible = true;

  bool disabledFinalizeButton = true;
  PaymentType? currentPaymentType = null;
  late double toBeReturnedCalculation;
  late String _toBeReturned = '---';
  late bool _isSelectedPaymentVisible = false;
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

  List<bool> _selectedPaymentDynamic = <bool>[];
  List<PaymentType> _availablePaymentsDynamic = [];

  String selectedFiscalization = "0";
  bool fiscalizationVisible = false;
  bool posAuthorization = false;
  bool isLoadingAttribute = true;
  final ValueNotifier<bool> showPredefinedProduct = ValueNotifier(false);
  final ValueNotifier<bool> addPredefinedProductEnabled = ValueNotifier(false);

  int idPredefinedProduct = 0;
  ProductCatalogModel? predefinedProduct;
  ProductCategoryMappingModel? productCategoryPredefinedProduct;
  double valuePredefinedProduct = 0;

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
  CurrencyTextFieldController textEditingControllerPredefinedProduct =
      CurrencyTextFieldController(
          decimalSymbol: ',',
          thousandSymbol: '',
          currencySeparator: '',
          currencySymbol: '',
          enableNegative: false,
          numberOfDecimals: 2,
          initDoubleValue: 0,
          maxDigits: 8);

  TextEditingController rateDiscountTextEditingController =
      TextEditingController();
  final ScrollController _scrollController = ScrollController();

  void adjustPrice() {
    // CartNotifier cartNotifier =
    //     Provider.of<CartNotifier>(context, listen: false);
    rateDiscounted =
        double.tryParse(rateDiscountTextEditingController.text) ?? 0;
    if (rateDiscounted > 100) {
      rateDiscountTextEditingController.text = '';
      rateDiscounted = 0;
    }
    totalDiscount =
        (rateDiscounted / 100) * cartNotifier.totalCartProductNoDonation;

    cartNotifier.totalCartMoney.value =
        cartNotifier.subTotalCartMoney.value - totalDiscount;
    setState(() {});
    pricePredefinedProductOnChange();
  }

  void pricePredefinedProductOnChange() {
    // CartNotifier cartNotifier =
    //     Provider.of<CartNotifier>(context, listen: false);
    if (predefinedProduct != null && predefinedProduct!.freePriceProduct) {
      var value = double.tryParse(textEditingControllerPredefinedProduct.text
              .replaceAll(',', '.')) ??
          0.0;
      if (value > cartNotifier.totalCartMoney.value) {
        addPredefinedProductEnabled.value = true;
      } else {
        addPredefinedProductEnabled.value = false;
      }
    } else {
      addPredefinedProductEnabled.value = true;
    }
  }

  void _scrollLeft() {
    _scrollController.animateTo(
      _scrollController.offset - 100,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _scrollRight() {
    _scrollController.animateTo(
      _scrollController.offset + 100,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void cashInsertedOnChange() {
    var value = double.tryParse(
        textEditingControllerCashInserted.text.replaceAll(',', '.'));

    if (value != null && value > 0) {
      toBeReturnedCalculation = value - cartNotifier.totalCartMoney.value;
      setState(() {
        if (toBeReturnedCalculation >= 0 &&
            cartNotifier.totalCartMoney.value > 0) {
          _toBeReturned =
              MoneyUtils.getFormattedCurrency(toBeReturnedCalculation);
          disabledFinalizeButton = false;
        }
      });
    } else {
      setState(() {
        _toBeReturned = '---';
        disabledFinalizeButton = true;
      });
    }
  }

  void checkImport(PaymentType pt) {
    // CartNotifier cartNotifier =
    //     Provider.of<CartNotifier>(context, listen: false);
    setState(() {
      currentPaymentType = pt;
      disabledFinalizeButton = true;
      if (pt == PaymentType.Assegni &&
          cartNotifier.subTotalCartMoney.value > 0) {
        disabledFinalizeButton = false;
        textEditingControllerCashInserted.text = '';
      } else if (pt == PaymentType.Bancomat || pt == PaymentType.CartaCredito) {
        posAuthorization
            ? disabledFinalizeButton = true
            : disabledFinalizeButton = false;
      } else if (pt == PaymentType.Contanti) {
        disabledFinalizeButton = true;
        textEditingControllerCashInserted.text = '';
        cashInsertedOnChange();
      } else {
        disabledFinalizeButton = false;
      }
    });
  }

  void finalizeStripePayment(String paymentIntendId, String paymentStatus) {
    // CartNotifier cartNotifier =
    //     Provider.of<CartNotifier>(context, listen: false);

    AuthenticationNotifier authenticationNotifier =
        Provider.of<AuthenticationNotifier>(context, listen: false);
    UserAppInstitutionModel cUserAppInstitutionModel =
        authenticationNotifier.getSelectedUserAppInstitution();
    var strTypePayment = currentPaymentType.toString();
    cartNotifier
        .setCartCheckout(
            context: context,
            token: authenticationNotifier.token,
            idCart: widget.idCart,
            idUserAppInstitution: cUserAppInstitutionModel.idUserAppInstitution,
            totalPriceCart: cartNotifier.totalCartMoney.value,
            percDiscount:
                double.tryParse(rateDiscountTextEditingController.text) ?? 0,
            typePayment: strTypePayment,
            fiscalization: int.parse(selectedFiscalization),
            modeCartCheckout: 0,
            paymentIntendId: paymentIntendId,
            paymentStatus: paymentStatus)
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
    // CartNotifier cartNotifier =
    //     Provider.of<CartNotifier>(context, listen: false);

    AuthenticationNotifier authenticationNotifier =
        Provider.of<AuthenticationNotifier>(context, listen: false);
    UserAppInstitutionModel cUserAppInstitutionModel =
        authenticationNotifier.getSelectedUserAppInstitution();

    var strTypePayment = currentPaymentType.toString();
    cartNotifier
        .setCartCheckout(
            context: context,
            token: authenticationNotifier.token,
            idCart: widget.idCart,
            idUserAppInstitution: cUserAppInstitutionModel.idUserAppInstitution,
            totalPriceCart: cartNotifier.totalCartMoney.value,
            percDiscount:
                double.tryParse(rateDiscountTextEditingController.text) ?? 0,
            typePayment: strTypePayment,
            fiscalization: int.parse(selectedFiscalization),
            modeCartCheckout: 2,
            paymentIntendId: '',
            paymentStatus: '')
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
    // CartNotifier cartNotifier =
    //     Provider.of<CartNotifier>(context, listen: false);

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
      var strTypePayment = currentPaymentType.toString();
      cartNotifier
          .setCartCheckout(
              context: context,
              token: authenticationNotifier.token,
              idCart: widget.idCart,
              idUserAppInstitution:
                  cUserAppInstitutionModel.idUserAppInstitution,
              totalPriceCart: cartNotifier.totalCartMoney.value,
              percDiscount:
                  double.tryParse(rateDiscountTextEditingController.text) ?? 0,
              typePayment: strTypePayment,
              fiscalization: int.parse(selectedFiscalization),
              modeCartCheckout: 1,
              paymentIntendId: '',
              paymentStatus: '')
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
      final transactionId = paymentResult?['transactionId'] ?? '';
      final paymentStatus = paymentResult?['status'] ?? 'Unknown';
      finalizeStripePayment(transactionId, paymentStatus);

      setState(() {
        _stripeStatus = paymentResult;
        textEditingControllerCashInserted.text = '';
      });
      disconnectReader();
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
    } on PlatformException catch (e) {
      print("$e");
    }
  }

  Future<void> uninitializeStripe() async {
    try {
      final String result = await platform.invokeMethod('uninitializeStripe');
    } on PlatformException catch (e) {
      print("Error uninitializing terminal: ${e.message}");
    }
  }

  onFiscalizationChanged(value) {
    selectedFiscalization = value;
  }

  Future<void> getInstitutionAttribute() async {
    setState(() {
      isLoadingAttribute = true;
    });
    AuthenticationNotifier authenticationNotifier =
        Provider.of<AuthenticationNotifier>(context, listen: false);
    UserAppInstitutionModel cUserAppInstitutionModel =
        authenticationNotifier.getSelectedUserAppInstitution();

    InstitutionAttributeNotifier institutionAttributeNotifier =
        Provider.of<InstitutionAttributeNotifier>(context, listen: false);

    final snapshot = await institutionAttributeNotifier.getInstitutionAttribute(
      context: context,
      token: authenticationNotifier.token,
      idUserAppInstitution: cUserAppInstitutionModel.idUserAppInstitution,
      idInstitution:
          cUserAppInstitutionModel.idInstitutionNavigation.idInstitution,
      isDelayed: true,
    ) as List<InstitutionAttributeModel>;

    final itemInstitutionFiscalized = snapshot.firstWhereOrNull(
      (e) => e.attributeName == 'Institution.Fiscalized',
    );
    final itemPosAuthorization = snapshot.firstWhereOrNull(
      (e) => e.attributeName == 'Institution.PosAuthorization',
    );

    final itemGiveIdPaymentTypeVisibility = snapshot.firstWhereOrNull(
      (e) => e.attributeName == 'Give.IdPaymentType.Visibility',
    );

    final visibilityPaymentSplit = itemGiveIdPaymentTypeVisibility
        ?.attributeValue
        .split(";")
        .map((e) => e.trim());

    if (visibilityPaymentSplit != null) {
      _availablePaymentsDynamic = visibilityPaymentSplit
          .map(mapDbValueToPaymentType)
          .where((e) => e != null)
          .cast<PaymentType>()
          .toList();
      _selectedPaymentDynamic =
          List<bool>.filled(_availablePaymentsDynamic.length, false);
    }

    final itemPredefinedProduct = snapshot.firstWhereOrNull(
      (e) => e.attributeName == 'Parameter.PredefinedProduct',
    );

    if (itemPredefinedProduct != null) {
      List<String> predefinedProductSplit =
          itemPredefinedProduct.attributeValue.split("*;*");
      idPredefinedProduct = (predefinedProductSplit.length > 1)
          ? int.tryParse(predefinedProductSplit[0]) ?? 0
          : 0;
    }
    if (idPredefinedProduct > 0) {
      await getProduct(
        idPredefinedProduct,
      );
      productCategoryPredefinedProduct =
          predefinedProduct!.productCategoryMappingModel.first;
    }

    // Fiscalization
    if (itemInstitutionFiscalized?.attributeValue == "true") {
      selectedFiscalization = "1";
      fiscalizationVisible = true;
    } else {
      fiscalizationVisible = false;
    }
    posAuthorization = itemPosAuthorization?.attributeValue == "true";

    setState(() {
      isLoadingAttribute = false;
    });
  }

  Future<void> getProduct(int idProduct) async {
    setState(() {
      isLoadingAttribute = true;
    });
    AuthenticationNotifier authenticationNotifier =
        Provider.of<AuthenticationNotifier>(context, listen: false);
    UserAppInstitutionModel cUserAppInstitutionModel =
        authenticationNotifier.getSelectedUserAppInstitution();

    // CartNotifier cartNotifier =
    //     Provider.of<CartNotifier>(context, listen: false);

    final snapshot = await cartNotifier.getProduct(
        context: context,
        token: authenticationNotifier.token,
        idUserAppInstitution: cUserAppInstitutionModel.idUserAppInstitution,
        idProduct: idProduct) as ProductCatalogModel;

    predefinedProduct = snapshot;
  }

  @override
  void initState() {
    super.initState();
    getInstitutionAttribute();
    rateDiscountTextEditingController.addListener(adjustPrice);
    textEditingControllerCashInserted.addListener(cashInsertedOnChange);
    textEditingControllerPredefinedProduct
        .addListener(pricePredefinedProductOnChange);
    toBeReturnedCalculation = 0;
    _toBeReturned = '---';
    _isSelectedPaymentVisible = false;
    _isStripePayment = false;
    cartNotifier = Provider.of<CartNotifier>(context, listen: false);
  }

  @override
  void dispose() {
    super.dispose();
    rateDiscountTextEditingController.dispose();
    textEditingControllerCashInserted.dispose();
    textEditingControllerPredefinedProduct.dispose();
    if (!kIsWeb) {
      uninitializeStripe();
    }
  }

  @override
  Widget build(BuildContext context) {
    // CartNotifier cartNotifier = Provider.of<CartNotifier>(context);
    AuthenticationNotifier authenticationNotifier =
        Provider.of<AuthenticationNotifier>(context);
    UserAppInstitutionModel? cUserAppInstitutionModel =
        authenticationNotifier.getSelectedUserAppInstitution();

    return Expanded(
      flex: 2,
      child: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(4)),
          ),
          child: Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(4))),
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(4)),
              ),
              child: Container(
                height: 640,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                    border: Border.all(color: Colors.grey.shade200)),
                padding:
                    EdgeInsets.only(left: 12, top: 8, right: 12, bottom: 8),
                child: isLoadingAttribute
                    ? Center(
                        child: JumpingDots(
                          color: CustomColors.darkBlue,
                          radius: 10,
                          numberOfDots: 5,
                        ),
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            height: 2,
                          ),
                          Text(
                            "Dettaglio carrello: " + widget.idCart.toString(),
                            style: Theme.of(context).textTheme.titleSmall,
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
                            padding: EdgeInsets.symmetric(
                                horizontal: 0, vertical: 3),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        'Prodotti: ',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium,
                                      ),
                                      ValueListenableBuilder<int>(
                                        builder: (BuildContext context,
                                            int value, Widget? child) {
                                          return Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8.0,
                                                      vertical: 4.0),
                                              child: Text(
                                                value.toString(),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium,
                                              ));
                                        },
                                        valueListenable:
                                            cartNotifier.totalCartProductType,
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        'Quantità: ',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium,
                                      ),
                                      ValueListenableBuilder<int>(
                                        builder: (BuildContext context,
                                            int value, Widget? child) {
                                          return Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8.0,
                                                      vertical: 4.0),
                                              child: Text(
                                                value.toString(),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium,
                                              ));
                                        },
                                        valueListenable:
                                            cartNotifier.totalCartProduct,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
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
                            padding: EdgeInsets.symmetric(
                                horizontal: 0, vertical: 3),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  'Sub Totale: ',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                ValueListenableBuilder<double>(
                                  builder: (BuildContext context, double value,
                                      Widget? child) {
                                    return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0, vertical: 4.0),
                                        child: Text(
                                          MoneyUtils.getFormattedCurrency(
                                              value),
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium,
                                        ));
                                  },
                                  valueListenable:
                                      cartNotifier.subTotalCartMoney,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 2,
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 0, vertical: 3),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  'Sconto ' +
                                      rateDiscounted.toStringAsFixed(2) +
                                      " %" +
                                      " equivalente a " +
                                      MoneyUtils.getFormattedCurrency(
                                          totalDiscount),
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                SizedBox(
                                  width: 120,
                                  child: TextFormField(
                                    maxLines: 1,
                                    textAlignVertical: TextAlignVertical.top,
                                    controller:
                                        rateDiscountTextEditingController,
                                    keyboardType:
                                        const TextInputType.numberWithOptions(
                                            decimal: true, signed: false),
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter.digitsOnly
                                    ], // Only numbers can be entered
                                    style:
                                        Theme.of(context).textTheme.titleSmall,
                                    decoration: const InputDecoration(
                                      suffixIcon: Icon(Icons.percent),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10.0)),
                                        borderSide: BorderSide(
                                            color: Colors.black, width: 0.2),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10.0)),
                                        borderSide: BorderSide(
                                            color: Colors.red, width: 0.2),
                                      ),
                                    ),
                                    enabled: !_isStripePayment,
                                  ),
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
                            padding: EdgeInsets.symmetric(
                                horizontal: 0, vertical: 3),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  "Totale:",
                                  style: Theme.of(context).textTheme.titleSmall,
                                ),
                                ValueListenableBuilder<double>(
                                  builder: (BuildContext context, double value,
                                      Widget? child) {
                                    return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0, vertical: 4.0),
                                        child: Text(
                                          MoneyUtils.getFormattedCurrency(
                                              value),
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleSmall,
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
                          predefinedProduct != null && idPredefinedProduct > 0
                              ? SizedBox(
                                  height: 100,
                                  child: Builder(
                                    builder: (context) {
                                      final product = predefinedProduct!;
                                      bool isFreePrice =
                                          product.freePriceProduct;
                                      String strPriceProduct = product
                                          .priceProduct
                                          .toStringAsFixed(2);

                                      if (!isFreePrice) {
                                        textEditingControllerPredefinedProduct
                                            .text = strPriceProduct;
                                      }

                                      return Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            child: Container(
                                              padding: const EdgeInsets.all(4),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                boxShadow: const [
                                                  BoxShadow(
                                                    color: Colors.black12,
                                                    blurRadius: 4,
                                                    offset: Offset(0, 2),
                                                  ),
                                                ],
                                              ),
                                              child: Row(
                                                children: [
                                                  Flexible(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  left: 10),
                                                          child: Text(
                                                            product.nameProduct,
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .titleSmall,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                            height: 4),
                                                        Row(
                                                          children: [
                                                            Expanded(
                                                              child: product
                                                                          .productCategoryMappingModel
                                                                          .length >
                                                                      1
                                                                  ? CustomDropDownButtonFormField(
                                                                      actualValue:
                                                                          productCategoryPredefinedProduct,
                                                                      enabled:
                                                                          true,
                                                                      onItemChanged:
                                                                          (value) {
                                                                        ProductCategoryMappingModel
                                                                            item =
                                                                            value
                                                                                as ProductCategoryMappingModel;
                                                                        productCategoryPredefinedProduct =
                                                                            item;
                                                                      },
                                                                      listOfValue: product
                                                                          .productCategoryMappingModel
                                                                          .map((item) =>
                                                                              DropdownMenuItem<ProductCategoryMappingModel>(
                                                                                value: item,
                                                                                child: Text(item.categoryModel.nameCategory),
                                                                              ))
                                                                          .toList(),
                                                                    )
                                                                  : Padding(
                                                                      padding: const EdgeInsets
                                                                          .only(
                                                                          left:
                                                                              10.0),
                                                                      child:
                                                                          Text(
                                                                        product
                                                                            .productCategoryMappingModel
                                                                            .first
                                                                            .categoryModel
                                                                            .nameCategory,
                                                                        style: Theme.of(context)
                                                                            .textTheme
                                                                            .titleSmall,
                                                                      ),
                                                                    ),
                                                            ),
                                                            const SizedBox(
                                                                width: 8),
                                                            if (isFreePrice)
                                                              Row(
                                                                children: [
                                                                  Tooltip(
                                                                    message:
                                                                        'Aggiungi una donazione per arrivare a:',
                                                                    preferBelow:
                                                                        false,
                                                                    verticalOffset:
                                                                        12,
                                                                    margin:
                                                                        const EdgeInsets
                                                                            .all(
                                                                            16),
                                                                    child:
                                                                        SizedBox(
                                                                      width:
                                                                          100,
                                                                      child:
                                                                          TextFormField(
                                                                        controller:
                                                                            textEditingControllerPredefinedProduct,
                                                                        keyboardType: const TextInputType
                                                                            .numberWithOptions(
                                                                            decimal:
                                                                                true,
                                                                            signed:
                                                                                false),
                                                                        style: Theme.of(context)
                                                                            .textTheme
                                                                            .titleSmall,
                                                                        decoration:
                                                                            const InputDecoration(
                                                                          suffixIcon:
                                                                              Icon(Icons.euro),
                                                                          enabledBorder:
                                                                              OutlineInputBorder(
                                                                            borderRadius:
                                                                                BorderRadius.all(Radius.circular(10.0)),
                                                                            borderSide:
                                                                                BorderSide(color: Colors.black, width: 0.2),
                                                                          ),
                                                                          focusedBorder:
                                                                              OutlineInputBorder(
                                                                            borderRadius:
                                                                                BorderRadius.all(Radius.circular(10.0)),
                                                                            borderSide:
                                                                                BorderSide(color: Colors.red, width: 1),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  const SizedBox(
                                                                      width: 8),
                                                                ],
                                                              )
                                                            else
                                                              Text(
                                                                MoneyUtils
                                                                    .getFormattedCurrency(
                                                                        product
                                                                            .priceProduct),
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .titleSmall,
                                                              ),
                                                            const SizedBox(
                                                                width: 8),
                                                            ValueListenableBuilder<
                                                                bool>(
                                                              valueListenable:
                                                                  addPredefinedProductEnabled,
                                                              builder: (context,
                                                                  enabled, _) {
                                                                return Container(
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: enabled
                                                                        ? Colors
                                                                            .blueAccent
                                                                        : Colors
                                                                            .grey,
                                                                    shape: BoxShape
                                                                        .circle,
                                                                  ),
                                                                  child:
                                                                      IconButton(
                                                                    onPressed: enabled
                                                                        ? () {
                                                                            if (!addPredefinedProductEnabled.value) {
                                                                              return;
                                                                            } else {
                                                                              UIBlock.block(context);
                                                                              double tempDiscount = rateDiscounted;
                                                                              addPredefinedProductEnabled.value = false;

                                                                              int quantity = 1;

                                                                              List<CartProductVariants> cartProductVariants = [];
                                                                              if (predefinedProduct!.freePriceProduct) {
                                                                                valuePredefinedProduct = (double.tryParse(textEditingControllerPredefinedProduct.text.replaceAll(',', '.')) ?? 0.0) - cartNotifier.totalCartMoney.value;
                                                                              } else {
                                                                                valuePredefinedProduct = predefinedProduct!.priceProduct;
                                                                              }

                                                                              cartNotifier.addToCart(context: context, token: authenticationNotifier.token, idUserAppInstitution: cUserAppInstitutionModel.idUserAppInstitution, idProduct: predefinedProduct!.idProduct, idCategory: productCategoryPredefinedProduct!.idCategory, quantity: quantity, price: valuePredefinedProduct, cartProductVariants: cartProductVariants, notes: '').then((value) {
                                                                                addPredefinedProductEnabled.value = true;
                                                                                cartNotifier.refresh();
                                                                                UIBlock.unblock(context);
                                                                                if (value) {
                                                                                  ScaffoldMessenger.of(context).showSnackBar(SnackUtil.stylishSnackBar(title: "Prodotti", message: '$quantity x ${predefinedProduct!.nameProduct} aggiunti al carrello', contentType: "success"));
                                                                                } else {
                                                                                  ScaffoldMessenger.of(context).showSnackBar(SnackUtil.stylishSnackBar(title: "Prodotti", message: "Errore di connessione", contentType: "failure"));
                                                                                }
                                                                              });
                                                                            }
                                                                          }
                                                                        : null, // disabilitato se non valido
                                                                    icon: const Icon(
                                                                        Icons
                                                                            .add,
                                                                        color: Colors
                                                                            .white),
                                                                    tooltip: '',
                                                                  ),
                                                                );
                                                              },
                                                            )
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                )
                              : const SizedBox.shrink(),
                          SizedBox(
                            height: 8,
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 0, vertical: 3),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'Metodo di pagamento:',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                    ),
                                  ],
                                ),
                                Container(
                                  height: 40,
                                  child: Row(
                                    children: [
                                      // IconButton(
                                      //   icon: Icon(Icons.arrow_left),
                                      //   onPressed: _scrollLeft,
                                      // ),
                                      SizedBox(
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          controller: _scrollController,
                                          child: ToggleButtons(
                                            direction: Axis.horizontal,
                                            constraints: BoxConstraints(
                                              minWidth: 42,
                                              minHeight: 42,
                                            ),
                                            onPressed: (int index) {
                                              final selected =
                                                  _availablePaymentsDynamic[
                                                      index];
                                              setState(() {
                                                for (int i = 0;
                                                    i <
                                                        _selectedPaymentDynamic
                                                            .length;
                                                    i++) {
                                                  _selectedPaymentDynamic[i] =
                                                      i == index;
                                                }

                                                // Logica in base al tipo di pagamento selezionato
                                                switch (selected) {
                                                  case PaymentType.Nessuno:
                                                    throw UnimplementedError();
                                                  case PaymentType.Contanti:
                                                    _isSelectedPaymentVisible =
                                                        true;
                                                    _isStripePayment = false;
                                                    break;
                                                  case PaymentType.Bancomat:
                                                  case PaymentType.CartaCredito:
                                                    disabledFinalizeButton =
                                                        posAuthorization;
                                                    _isSelectedPaymentVisible =
                                                        false;
                                                    _isStripePayment = true;
                                                    totalCartMoney = (cartNotifier
                                                                .totalCartMoney
                                                                .value *
                                                            100)
                                                        .toInt();

                                                    if (!isTerminalInitialized) {
                                                      initializeStripe(
                                                          cUserAppInstitutionModel
                                                              .idUserAppInstitution,
                                                          authenticationNotifier
                                                              .token);
                                                    }

                                                    if (!isReaderDiscovered) {
                                                      Future.delayed(
                                                          const Duration(
                                                              seconds: 2), () {
                                                        _discoverReaders(
                                                            cUserAppInstitutionModel
                                                                .idUserAppInstitution,
                                                            authenticationNotifier
                                                                .token);
                                                      });
                                                    } else {
                                                      getConnectedReaderInfo();
                                                    }
                                                    break;
                                                  case PaymentType.Assegni:
                                                  case PaymentType.Paypal:
                                                  case PaymentType
                                                        .PagamentoEsterno:
                                                  case PaymentType.Sdd:
                                                  case PaymentType
                                                        .BonificoPromessa:
                                                  case PaymentType
                                                        .BonificoIstantaneo:
                                                  case PaymentType.BonificoLink:
                                                    _isSelectedPaymentVisible =
                                                        false;
                                                    _isStripePayment = false;
                                                    break;
                                                }

                                                checkImport(selected);
                                              });
                                            },
                                            isSelected: _selectedPaymentDynamic,
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(8)),
                                            selectedColor: Theme.of(context)
                                                .colorScheme
                                                .secondaryContainer,
                                            children: _availablePaymentsDynamic
                                                .map((payment) {
                                              final paymentType =
                                                  mapPaymentTypeToDbValue(
                                                      payment);
                                              final key =
                                                  paymentTypeInfo[paymentType];

                                              if (key == null) {
                                                return const Tooltip(
                                                  message:
                                                      'Metodo non supportato',
                                                  child: Icon(
                                                      Icons.help_outline,
                                                      size: 20),
                                                );
                                              }

                                              return Tooltip(
                                                message:
                                                    key['tooltip'] as String,
                                                child: Icon(
                                                    key['icon'] as IconData,
                                                    size: 20),
                                              );
                                            }).toList(),
                                          ),
                                        ),
                                      ),
                                      // IconButton(
                                      //   icon: Icon(Icons.arrow_right),
                                      //   onPressed: _scrollRight,
                                      // ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 2,
                          ),
                          Container(
                            height: 100,
                            child: Column(
                              children: [
                                Visibility(
                                  maintainSize: false,
                                  maintainAnimation: true,
                                  maintainState: true,
                                  visible: _isSelectedPaymentVisible,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 0, vertical: 3),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Importo ricevuto ',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium,
                                            ),
                                            SizedBox(
                                              width: 120,
                                              child: TextFormField(
                                                maxLines: 1,
                                                textAlignVertical:
                                                    TextAlignVertical.top,
                                                controller:
                                                    textEditingControllerCashInserted,
                                                keyboardType:
                                                    const TextInputType
                                                        .numberWithOptions(
                                                        decimal: true,
                                                        signed: false),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleSmall,
                                                decoration:
                                                    const InputDecoration(
                                                  suffixIcon: Icon(Icons.euro),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                10.0)),
                                                    borderSide: BorderSide(
                                                        color: Colors.black,
                                                        width: 0.2),
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                10.0)),
                                                    borderSide: BorderSide(
                                                        color: Colors.red,
                                                        width: 0.2),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 12,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Resto da consegnare',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleSmall,
                                            ),
                                            Text(
                                              _toBeReturned,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleSmall,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Visibility(
                                  maintainSize: false,
                                  maintainAnimation: true,
                                  maintainState: true,
                                  visible: _isStripePayment,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 0, vertical: 2),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          width:
                                              300, // Set the desired width limit
                                          child: Text(
                                            _stripeStatus,
                                            style: CustomTextStyle
                                                .textFormFieldBold
                                                .copyWith(
                                              color: Colors.black,
                                              fontSize: 14,
                                            ),
                                            maxLines:
                                                3, // Set the max number of lines
                                            overflow: TextOverflow
                                                .ellipsis, // Optional: To handle overflow with ellipsis
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0, vertical: 0),
                                          child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      Theme.of(context)
                                                          .colorScheme
                                                          .inversePrimary,
                                                  textStyle: const TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              onPressed: isReaderConnected &&
                                                      _isStripePayment
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
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 2,
                          ),
                          Container(
                            height: 60,
                            child: (fiscalizationVisible
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
                          ),
                          Container(
                            width: double.infinity,
                            child: Row(
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
                                      child: Column(
                                        children: [
                                          const Text("Check Out"),
                                          Text("(richiedi ricevuta)"),
                                        ],
                                      )),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

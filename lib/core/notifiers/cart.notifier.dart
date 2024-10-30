import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:np_casse/app/routes/app_routes.dart';
import 'package:np_casse/app/utilities/initial_context.dart';
import 'package:np_casse/core/api/cart.api.dart';
import 'package:np_casse/core/models/cart.model.dart';
import 'package:np_casse/core/models/cart.product.model.dart';
import 'package:np_casse/core/notifiers/authentication.notifier.dart';
import 'package:np_casse/core/utils/snackbar.util.dart';
import 'package:np_casse/screens/loginScreen/login.view.dart';
import 'package:np_casse/screens/loginScreen/logout.view.dart';
import 'package:provider/provider.dart';

class CartNotifier with ChangeNotifier {
  final CartAPI cartAPI = CartAPI();

  CartModel currentCartModel = CartModel.empty();
  // int _nrProductInCart = 0;
  // int _nrProductTypeInCart = 0;
  // double _totalCartMoney = 0;
  // int get nrProductInCart => _nrProductInCart;
  // int get nrProductTypeInCart => _nrProductTypeInCart;

  late ValueNotifier<double> subTotalCartMoney = ValueNotifier(0);
  late ValueNotifier<double> totalCartMoney = ValueNotifier(0);
  late ValueNotifier<int> totalCartProduct = ValueNotifier(0);
  late double totalCartProductNoDonation = 0;
  late ValueNotifier<int> totalCartProductType = ValueNotifier(0);

  setCurrentCart(CartModel cartModel) {
    int _nrProductInCart = 0;
    int _nrProductTypeInCart = 0;
    double _subTotalCartMoney = 0;
    totalCartProductNoDonation = 0;
    currentCartModel = cartModel;
    _nrProductTypeInCart = cartModel.cartProducts.length;
    for (var element in cartModel.cartProducts) {
      _subTotalCartMoney = _subTotalCartMoney +
          (element.priceCartProduct * element.quantityCartProduct.value);
      _nrProductInCart = _nrProductInCart + element.quantityCartProduct.value;
      if (!element.freePriceProduct) {
        totalCartProductNoDonation = totalCartProductNoDonation +
            (element.priceCartProduct * element.quantityCartProduct.value);
      }
    }

    totalCartProductType.value = _nrProductTypeInCart;
    totalCartProduct.value = _nrProductInCart;
    subTotalCartMoney.value = _subTotalCartMoney;
    totalCartMoney.value = _subTotalCartMoney;
  }

  getCurrentCart() {
    return currentCartModel;
  }

  Future addToCart(
      {required BuildContext context,
      required String? token,
      required int idUserAppInstitution,
      required int idProduct,
      required int quantity,
      double? price,
      required List<CartProductVariants?> cartProductVariants,
      String? notes}) async {
    try {
      bool isOk = false;

      var response = await cartAPI.addToCart(
          token: token,
          idUserAppInstitution: idUserAppInstitution,
          idProduct: idProduct,
          quantity: quantity,
          price: price,
          cartProductVariants: cartProductVariants,
          notes: notes);

      if (response != null) {
        final Map<String, dynamic> parseData = await jsonDecode(response);
        isOk = parseData['isOk'];
        if (!isOk) {
          String errorDescription = parseData['errorDescription'];
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackUtil.stylishSnackBar(
                    title: "Carrello",
                    message: errorDescription,
                    contentType: "failure"));
            // Navigator.pop(context);
          }
        } else {
          // ProjectModel projectDetail =
          //     ProjectModel.fromJson(parseData['okResult']);
          //return projectDetail;
          //notifyListeners();
        }
      }
      return isOk;
    } on SocketException catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackUtil.stylishSnackBar(
            title: "Carrello",
            message: "Errore di connessione",
            contentType: "failure"));
      }
    }
  }

  Future findCart(
      {required BuildContext context,
      required String? token,
      required int idUserAppInstitution,
      required int cartStateEnum}) async {
    try {
      bool isOk = false;
      var response = await cartAPI.findCart(
          token: token,
          idUserAppInstitution: idUserAppInstitution,
          cartStateEnum: cartStateEnum);

      if (response != null) {
        final Map<String, dynamic> parseData = await jsonDecode(response);
        isOk = parseData['isOk'];
        if (!isOk) {
          String errorDescription = parseData['errorDescription'];
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackUtil.stylishSnackBar(
                    title: "Carrello",
                    message: errorDescription,
                    contentType: "failure"));
          }
        } else {
          if (parseData['okResult'] != null) {
            CartModel cartModel = CartModel.fromJson(parseData['okResult']);
            setCurrentCart(cartModel);
            return cartModel;
          } else {
            setCurrentCart(CartModel.empty());
            return null;
          }
        }
      } else {
        AuthenticationNotifier authenticationNotifier =
            Provider.of<AuthenticationNotifier>(context, listen: false);
        authenticationNotifier.exit(context);
      }
    } on SocketException catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackUtil.stylishSnackBar(
            title: "Carrello",
            message: "Errore di connessione",
            contentType: "failure"));
      }
    }
  }

  Future updateItemQuantity(
      {required BuildContext context,
      required String? token,
      required int idUserAppInstitution,
      required int idCart,
      required int idCartProduct,
      required int quantityCartProduct}) async {
    try {
      bool isOk = false;
      var response = await cartAPI.updateCartProduct(
          token: token,
          idUserAppInstitution: idUserAppInstitution,
          idCart: idCart,
          idCartProduct: idCartProduct,
          quantityCartProduct: quantityCartProduct);

      if (response != null) {
        final Map<String, dynamic> parseData = await jsonDecode(response);
        isOk = parseData['isOk'];
        if (!isOk) {
          String errorDescription = parseData['errorDescription'];
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackUtil.stylishSnackBar(
                    title: "Carrello",
                    message: errorDescription,
                    contentType: "failure"));
          }
        } else {
          CartModel cartModel = CartModel.fromJson(parseData['okResult'] ?? '');
          setCurrentCart(cartModel);
          if (quantityCartProduct == 0) {
            notifyListeners();
          }
          // ProjectModel projectDetail =
          //     ProjectModel.fromJson(parseData['okResult']);
          //return projectDetail;
        }
      } else {
        AuthenticationNotifier authenticationNotifier =
            Provider.of<AuthenticationNotifier>(context, listen: false);
        authenticationNotifier.exit(context);
      }
      return isOk;
    } on SocketException catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackUtil.stylishSnackBar(
            title: "Carrello",
            message: "Errore di connessione",
            contentType: "failure"));
      }
    }
  }

  Future setCartCheckout(
      {required BuildContext context,
      required String? token,
      required int idUserAppInstitution,
      required int idCart,
      required String typePayment,
      required double totalPriceCart,
      required double percDiscount}) async {
    try {
      bool isOk = false;
      int savedIdCart = 0;
      var response = await cartAPI.setCartCheckout(
          token: token,
          idCart: idCart,
          idUserAppInstitution: idUserAppInstitution,
          totalPriceCart: totalPriceCart,
          percDiscount: percDiscount,
          typePayment: typePayment);

      if (response != null) {
        final Map<String, dynamic> parseData = await jsonDecode(response);
        isOk = parseData['isOk'];
        if (!isOk) {
          String errorDescription = parseData['errorDescription'];
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackUtil.stylishSnackBar(
                    title: "Autenticazione",
                    message: errorDescription,
                    contentType: "failure"));
          }
        } else {
          CartModel cartModelDetail = CartModel.fromJson(parseData['okResult']);
          savedIdCart = cartModelDetail.idCart;
          // notifyListeners();
        }
      } else {
        AuthenticationNotifier authenticationNotifier =
            Provider.of<AuthenticationNotifier>(context, listen: false);
        authenticationNotifier.exit(context);
      }
      return savedIdCart;
    } on SocketException catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackUtil.stylishSnackBar(
            title: "Carrello",
            message: "Errore di connessione",
            contentType: "failure"));
      }
    }
  }

  Future getInvoiceType(
      {required BuildContext context,
      required String? token,
      required int idUserAppInstitution}) async {
    try {
      List<InvoiceTypeModel> invoiceTypeModel = List<InvoiceTypeModel>.empty();
      bool isOk = false;
      var response = await cartAPI.getInvoiceType(
          token: token, idUserAppInstitution: idUserAppInstitution);

      if (response != null) {
        final Map<String, dynamic> parseData = await jsonDecode(response);
        isOk = parseData['isOk'];
        if (!isOk) {
          String errorDescription = parseData['errorDescription'];
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackUtil.stylishSnackBar(
                    title: "Carrello",
                    message: errorDescription,
                    contentType: "failure"));
          }
        } else {
          if (parseData['okResult'] != null) {
            invoiceTypeModel = List.from(parseData['okResult'])
                .map((e) => InvoiceTypeModel.fromJson(e))
                .toList();
            return invoiceTypeModel;
          }
        }
      } else {
        AuthenticationNotifier authenticationNotifier =
            Provider.of<AuthenticationNotifier>(context, listen: false);
        authenticationNotifier.exit(context);
      }
    } on SocketException catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackUtil.stylishSnackBar(
            title: "Carrello",
            message: "Errore di connessione",
            contentType: "failure"));
      }
      return List<InvoiceTypeModel>.empty();
    }
  }

  Future getInvoice(
      {required BuildContext context,
      required String? token,
      required int idUserAppInstitution,
      required int idCart,
      required String emailName}) async {
    try {
      var response = await cartAPI.getInvoice(
          token: token,
          idUserAppInstitution: idUserAppInstitution,
          idCart: idCart,
          emailName: emailName);

      if (response != null) {
        // var dir = await getTemporaryDirectory();
        // File file = File("${dir.path}/data.pdf");
        // await file.writeAsBytes(response, flush: true);
        return response;
        // return file.path;
      } else {
        AuthenticationNotifier authenticationNotifier =
            Provider.of<AuthenticationNotifier>(context, listen: false);
        authenticationNotifier.exit(context);
      }
    } on SocketException catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackUtil.stylishSnackBar(
            title: "Carrello",
            message: "Errore di connessione",
            contentType: "failure"));
      }
    }
  }

  Future sendInvoice(
      {required BuildContext context,
      required String? token,
      required int idUserAppInstitution,
      required int idCart,
      required String emailName}) async {
    try {
      var response = await cartAPI.sendInvoice(
          token: token,
          idUserAppInstitution: idUserAppInstitution,
          idCart: idCart,
          emailName: emailName);

      if (response != null) {
        final Map<String, dynamic> parseData = await jsonDecode(response);
        bool isOk = parseData['isOk'];
        if (!isOk) {
          String errorDescription = parseData['errorDescription'];
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackUtil.stylishSnackBar(
                    title: "Carrello",
                    message: errorDescription,
                    contentType: "failure"));
          }
        } else {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackUtil.stylishSnackBar(
                    title: "Carrello",
                    message: "Email inviata con successo",
                    contentType: "success"));
          }
          // notifyListeners();
        }
      } else {
        AuthenticationNotifier authenticationNotifier =
            Provider.of<AuthenticationNotifier>(context, listen: false);
        authenticationNotifier.exit(context);
      }
    } on SocketException catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackUtil.stylishSnackBar(
            title: "Carrello",
            message: "Errore di connessione",
            contentType: "failure"));
      }
    }
  }

  Future cartToStakeholder(
      {required BuildContext context,
      required String? token,
      required int idCart,
      required int idUserAppInstitution,
      required int idStakeholder,
      required String denominationStakeholder}) async {
    try {
      bool isOk = false;
      var response = await cartAPI.cartToStakeholder(
          token: token,
          idCart: idCart,
          idUserAppInstitution: idUserAppInstitution,
          idStakeholder: idStakeholder,
          denominationStakeholder: denominationStakeholder);

      if (response != null) {
        final Map<String, dynamic> parseData = await jsonDecode(response);
        isOk = parseData['isOk'];
        if (!isOk) {
          String errorDescription = parseData['errorDescription'];
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackUtil.stylishSnackBar(
                    title: "Carrello",
                    message: errorDescription,
                    contentType: "failure"));
          }
        } else {
          //notifyListeners();
        }
        return isOk;
      } else {
        AuthenticationNotifier authenticationNotifier =
            Provider.of<AuthenticationNotifier>(context, listen: false);
        authenticationNotifier.exit(context);
      }
    } on SocketException catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackUtil.stylishSnackBar(
            title: "Carrello",
            message: "Errore di connessione",
            contentType: "failure"));
      }
    }
  }

  void refresh() {
    notifyListeners();
  }
}

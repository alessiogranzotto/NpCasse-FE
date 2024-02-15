import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:np_casse/core/api/cart.api.dart';
import 'package:np_casse/core/models/cart.model.dart';
import 'package:np_casse/core/utils/snackbar.util.dart';

class CartNotifier with ChangeNotifier {
  final CartAPI cartAPI = CartAPI();

  CartModel currentCartModel = CartModel.empty();
  int _nrProductInCart = 0;
  int _nrProductTypeInCart = 0;
  int get nrProductInCart => _nrProductInCart;
  int get nrProductTypeInCart => _nrProductTypeInCart;

  late ValueNotifier<double> totalCartMoney = ValueNotifier(0);

  setCart(CartModel cartModel) {
    _nrProductInCart = 0;
    _nrProductTypeInCart = 0;
    totalCartMoney.value = 0;
    currentCartModel = cartModel;
    for (var element in cartModel.cartProducts) {
      if (element.freePriceCartProduct.value > 0) {
        totalCartMoney.value =
            totalCartMoney.value + element.freePriceCartProduct.value;
        _nrProductInCart = _nrProductInCart + 1;
      } else {
        totalCartMoney.value = totalCartMoney.value +
            (element.productModel.priceProduct *
                element.quantityCartProduct.value);
        _nrProductInCart = _nrProductInCart + element.quantityCartProduct.value;
      }
    }

    _nrProductTypeInCart = cartModel.cartProducts.length;
  }

  getCart() {
    return currentCartModel;
  }

  Future addToCart(
      {required BuildContext context,
      required String? token,
      required int idUserAppInstitution,
      required int idProduct,
      required int quantity,
      double? freePrice,
      String? notes}) async {
    try {
      bool isOk = false;

      var response = await cartAPI.addToCart(
          token: token,
          idUserAppInstitution: idUserAppInstitution,
          idProduct: idProduct,
          quantity: quantity,
          freePrice: freePrice,
          notes: notes);

      if (response != null) {
        final Map<String, dynamic> parseData = await jsonDecode(response);
        isOk = parseData['isOk'];
        if (!isOk) {
          String errorDescription = parseData['errorDescription'];
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackUtil.stylishSnackBar(
                    text: errorDescription, context: context));
            // Navigator.pop(context);
          }
        } else {
          // ProjectModel projectDetail =
          //     ProjectModel.fromJson(parseData['okResult']);
          //return projectDetail;
          notifyListeners();
        }
      }
      return isOk;
    } on SocketException catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackUtil.stylishSnackBar(
          text: 'Oops No You Need A Good Internet Connection',
          context: context,
        ),
      );
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
                    text: errorDescription, context: context));
            // Navigator.pop(context);
          }
        } else {
          if (parseData['okResult'] != null) {
            CartModel cartModel =
                CartModel.fromJson(parseData['okResult'] ?? '');
            _nrProductInCart = cartModel.cartProducts.length;

            setCart(cartModel);

            return cartModel;
          } else {
            return null;
          }
        }
      }
    } on SocketException catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackUtil.stylishSnackBar(
          text: 'Oops No You Need A Good Internet Connection',
          context: context,
        ),
      );
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
                    text: errorDescription, context: context));
            // Navigator.pop(context);
          }
        } else {
          CartModel cartModel = CartModel.fromJson(parseData['okResult'] ?? '');
          _nrProductInCart = cartModel.cartProducts.length;
          setCart(cartModel);
          if (quantityCartProduct == 0) {
            notifyListeners();
          }
          // ProjectModel projectDetail =
          //     ProjectModel.fromJson(parseData['okResult']);
          //return projectDetail;
        }
      }
      return isOk;
    } on SocketException catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackUtil.stylishSnackBar(
            text: 'Oops No You Need A Good Internet Connection',
            context: context,
          ),
        );
      }
    }
  }

  Future finalizeCart(
      {required BuildContext context,
      required String? token,
      required int idUserAppInstitution,
      required int idCart,
      required String typePayment}) async {
    try {
      bool isOk = false;
      int savedIdCart = 0;
      var response = await cartAPI.finalizeCart(
          token: token,
          idCart: idCart,
          idUserAppInstitution: idUserAppInstitution,
          typePayment: typePayment);

      if (response != null) {
        final Map<String, dynamic> parseData = await jsonDecode(response);
        isOk = parseData['isOk'];
        if (!isOk) {
          String errorDescription = parseData['errorDescription'];
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackUtil.stylishSnackBar(
                    text: errorDescription, context: context));
            Navigator.pop(context);
          }
        } else {
          CartModel cartModelDetail = CartModel.fromJson(parseData['okResult']);
          savedIdCart = cartModelDetail.idCart;
          // notifyListeners();
        }
      }
      return savedIdCart;
    } on SocketException catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackUtil.stylishSnackBar(
            text: 'Oops No You Need A Good Internet Connection',
            context: context,
          ),
        );
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
                    text: errorDescription, context: context));
            // Navigator.pop(context);
          }
        } else {
          if (parseData['okResult'] != null) {
            invoiceTypeModel = List.from(parseData['okResult'])
                .map((e) => InvoiceTypeModel.fromJson(e))
                .toList();
          }
        }
      }

      return invoiceTypeModel;
    } on SocketException catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackUtil.stylishSnackBar(
            text: 'Oops No You Need A Good Internet Connection',
            context: context,
          ),
        );
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
        return null;
      }
    } on SocketException catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackUtil.stylishSnackBar(
            text: 'Oops No You Need A Good Internet Connection',
            context: context,
          ),
        );
      }
    }
  }

  Future cartToStakeholder(
      {required BuildContext context,
      required String? token,
      required int idCart,
      required int idUserAppInstitution,
      required int idStakeholder}) async {
    try {
      bool isOk = false;
      var response = await cartAPI.cartToStakeholder(
          token: token,
          idCart: idCart,
          idUserAppInstitution: idUserAppInstitution,
          idStakeholder: idStakeholder);

      if (response != null) {
        final Map<String, dynamic> parseData = await jsonDecode(response);
        isOk = parseData['isOk'];
        if (!isOk) {
          String errorDescription = parseData['errorDescription'];
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackUtil.stylishSnackBar(
                    text: errorDescription, context: context));
            //Navigator.pop(context);
          }
        } else {
          //notifyListeners();
        }
      }
      return isOk;
    } on SocketException catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackUtil.stylishSnackBar(
            text: 'Oops No You Need A Good Internet Connection',
            context: context,
          ),
        );
      }
    }
  }

  void refresh() {
    notifyListeners();
  }
}

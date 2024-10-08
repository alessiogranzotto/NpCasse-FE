import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:np_casse/core/api/wishlist.product.api.dart';
import 'package:np_casse/core/models/product.catalog.model.dart';
import 'package:np_casse/core/notifiers/authentication.notifier.dart';
import 'package:np_casse/core/utils/snackbar.util.dart';
import 'package:provider/provider.dart';

class WishlistProductNotifier with ChangeNotifier {
  final WishlistProductAPI wishlistProductAPI = WishlistProductAPI();
  // ProductModel currentProductModel = ProductModel.empty();
  // int get getIdProduct => currentProductModel.idProduct;
  // int get getIdStore => currentProductModel.idStore;
  // String get getNameProduct => currentProductModel.nameProduct;
  // double get getPriceProduct => currentProductModel.priceProduct;

  // setProduct(ProductModel productModel) {
  //   currentProductModel = productModel;
  // }

  void refresh() {
    notifyListeners();
  }

  Future findWishlistedProducts(
      {required BuildContext context,
      required String? token,
      required int idUserAppInstitution}) async {
    try {
      var response = await wishlistProductAPI.findWishlistedProducts(
          token: token, idUserAppInstitution: idUserAppInstitution);
      if (response != null) {
        final Map<String, dynamic> parseData = await jsonDecode(response);
        bool isOk = parseData['isOk'];
        if (!isOk) {
          String errorDescription = parseData['errorDescription'];
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackUtil.stylishSnackBar(
                    title: "Lista preferiti",
                    message: errorDescription,
                    contentType: "failure"));
          }
        } else {
          List<ProductCatalogModel> products = List.from(parseData['okResult'])
              .map((e) => ProductCatalogModel.fromJson(e))
              .toList();
          return products;
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
            title: "Lista preferiti",
            message: "Errore di connessione",
            contentType: "failure"));
      }
    }
  }

  Future updateWishlistedProductState(
      {required BuildContext context,
      required String? token,
      required int idUserAppInstitution,
      required int idProduct,
      required bool state}) async {
    try {
      bool isOk = false;
      var response = await wishlistProductAPI.updateWishlistedProductState(
          token: token,
          idUserAppInstitution: idUserAppInstitution,
          idProduct: idProduct,
          state: state);

      if (response != null) {
        final Map<String, dynamic> parseData = await jsonDecode(response);
        isOk = parseData['isOk'];
        if (!isOk) {
          String errorDescription = parseData['errorDescription'];
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackUtil.stylishSnackBar(
                    title: "Lista preferiti",
                    message: errorDescription,
                    contentType: "failure"));
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
            title: "Lista preferiti",
            message: "Errore di connessione",
            contentType: "failure"));
      }
    }
  }
}

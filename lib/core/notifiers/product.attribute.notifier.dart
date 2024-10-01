import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:np_casse/core/api/product.attribute.api.dart';
import 'package:np_casse/core/models/product.attribute.model.dart';
import 'package:np_casse/core/notifiers/authentication.notifier.dart';
import 'package:np_casse/core/utils/snackbar.util.dart';
import 'package:provider/provider.dart';

class ProductAttributeNotifier with ChangeNotifier {
  final ProductAttributeAPI productAttributeAPI = ProductAttributeAPI();

  void refresh() {
    notifyListeners();
  }

  Future getProductAttributes(
      {required BuildContext context,
      required String? token,
      required int idUserAppInstitution,
      required bool readAlsoDeleted,
      required String numberResult,
      required String nameDescSearch,
      required String orderBy}) async {
    try {
      var response = await productAttributeAPI.getProductAttribute(
          token: token,
          idUserAppInstitution: idUserAppInstitution,
          readAlsoDeleted: readAlsoDeleted,
          numberResult: numberResult,
          nameDescSearch: nameDescSearch,
          orderBy: orderBy);
      if (response != null) {
        final Map<String, dynamic> parseData = await jsonDecode(response);
        bool isOk = parseData['isOk'];
        if (!isOk) {
          String errorDescription = parseData['errorDescription'];
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackUtil.stylishSnackBar(
                    title: "Prodotti",
                    message: errorDescription,
                    contentType: "failure"));
          }
        } else {
          List<ProductAttributeModel> productAttributes =
              List.from(parseData['okResult'])
                  .map((e) => ProductAttributeModel.fromJson(e))
                  .toList();
          return productAttributes;
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
            title: "Prodotti",
            message: "Errore di connessione",
            contentType: "failure"));
      }
    }
  }

  Future addOrUpdateProductAttribute(
      {required BuildContext context,
      required String? token,
      required int idUserAppInstitution,
      required ProductAttributeModel productAttributeModel}) async {
    try {
      bool isOk = false;
      var response = await productAttributeAPI.addOrUpdateProductAttribute(
          token: token,
          idUserAppInstitution: idUserAppInstitution,
          productAttributeModel: productAttributeModel);

      if (response != null) {
        final Map<String, dynamic> parseData = await jsonDecode(response);
        isOk = parseData['isOk'];
        if (!isOk) {
          String errorDescription = parseData['errorDescription'];
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackUtil.stylishSnackBar(
                    title: "Attributi prodotto",
                    message: errorDescription,
                    contentType: "failure"));
          }
        } else {}
      }
      return isOk;
    } on SocketException catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackUtil.stylishSnackBar(
            title: "Attributi prodotto",
            message: "Errore di connessione",
            contentType: "failure"));
      }
    }
  }
}

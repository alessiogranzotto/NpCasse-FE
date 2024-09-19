import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:np_casse/core/api/product.attribute.Combination.api.dart';
import 'package:np_casse/core/models/product.attribute.combination.model.dart';
import 'package:np_casse/core/utils/snackbar.util.dart';

class ProductAttributeCombinationNotifier with ChangeNotifier {
  final ProductAttributeCombinationAPI productAttributeCombinationAPI =
      ProductAttributeCombinationAPI();

  void refresh() {
    notifyListeners();
  }

  Future updateProductAttributeCombination(
      {required BuildContext context,
      required String? token,
      required idProduct,
      required idUserAppInstitution,
      required List<ProductAttributeCombinationModel>
          productAttributeCombinationModelList}) async {
    try {
      bool isOk = false;
      var response = await productAttributeCombinationAPI
          .updateProductAttributeCombination(
              token: token,
              idProduct: idProduct,
              idUserAppInstitution: idUserAppInstitution,
              productAttributeCombinationList:
                  productAttributeCombinationModelList);

      if (response != null) {
        final Map<String, dynamic> parseData = await jsonDecode(response);
        isOk = parseData['isOk'];
        if (!isOk) {
          String errorDescription = parseData['errorDescription'];
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackUtil.stylishSnackBar(
                    title: "Gestione varianti",
                    message: errorDescription,
                    contentType: "failure"));
            // Navigator.pop(context);
          }
        } else {}
      }
      return isOk;
    } on SocketException catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackUtil.stylishSnackBar(
            title: "Gestione varianti",
            message: "Errore di connessione",
            contentType: "failure"));
      }
    }
  }
}

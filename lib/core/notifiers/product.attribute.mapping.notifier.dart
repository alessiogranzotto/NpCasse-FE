import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:np_casse/core/api/product.attribute.mapping.api.dart';
import 'package:np_casse/core/models/product.attribute.mapping.model.dart';
import 'package:np_casse/core/utils/snackbar.util.dart';

class ProductAttributeMappingNotifier with ChangeNotifier {
  final ProductAttributeMappingAPI productAttributeMappingAPI =
      ProductAttributeMappingAPI();

  void refresh() {
    notifyListeners();
  }

  Future getProductAttributeMapping(
      {required BuildContext context,
      required String? token,
      required int idUserAppInstitution,
      required int idProduct,
      required bool readAlsoDeleted,
      required String numberResult}) async {
    try {
      var response =
          await productAttributeMappingAPI.getProductAttributeMapping(
              token: token,
              idUserAppInstitution: idUserAppInstitution,
              idProduct: idProduct,
              readAlsoDeleted: readAlsoDeleted,
              numberResult: numberResult);
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
          List<ProductAttributeMappingModel> productAttributeMappingModel =
              List.from(parseData['okResult'])
                  .map((e) => ProductAttributeMappingModel.fromJson(e))
                  .toList();
          return productAttributeMappingModel;
          // notifyListeners();
        }
      }
    } on SocketException catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackUtil.stylishSnackBar(
            title: "Gestione attributi",
            message: "Errore di connessione",
            contentType: "failure"));
      }
    }
  }

  Future updateProductAttributeMapping(
      {required BuildContext context,
      required String? token,
      required idProduct,
      required idUserAppInstitution,
      required List<ProductAttributeMappingModel>
          productAttributeMappingModelList}) async {
    try {
      bool isOk = false;
      //SVUOTO SE IMMAGINE NON IMPOSTATA
      // if (projectModel.imageProject == AppAssets.noImageString) {
      //   projectModel.imageProject = '';
      // }
      var response =
          await productAttributeMappingAPI.updateProductAttributeMapping(
              token: token,
              idProduct: idProduct,
              idUserAppInstitution: idUserAppInstitution,
              productAttributeMappingModelList:
                  productAttributeMappingModelList);

      if (response != null) {
        final Map<String, dynamic> parseData = await jsonDecode(response);
        isOk = parseData['isOk'];
        if (!isOk) {
          String errorDescription = parseData['errorDescription'];
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackUtil.stylishSnackBar(
                    title: "Gestione attributi",
                    message: errorDescription,
                    contentType: "failure"));
            // Navigator.pop(context);
          }
        } else {
          List<ProductAttributeMappingModel> productAttributeMappingModel =
              List.from(parseData['okResult'])
                  .map((e) => ProductAttributeMappingModel.fromJson(e))
                  .toList();
          return productAttributeMappingModel;
        }
      }
      return null;
    } on SocketException catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackUtil.stylishSnackBar(
            title: "Gestione attributi",
            message: "Errore di connessione",
            contentType: "failure"));
      }
    }
  }
}

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:np_casse/core/api/common.api.dart';
import 'package:np_casse/core/models/category.catalog.model.dart';
import 'package:np_casse/core/models/product.catalog.model.dart';
import 'package:np_casse/core/notifiers/authentication.notifier.dart';
import 'package:np_casse/core/utils/snackbar.util.dart';
import 'package:provider/provider.dart';

class ShopSearchNotifier with ChangeNotifier {
  final CommonAPI commonAPI = CommonAPI();

  // Future getCategories(
  //     {required BuildContext context,
  //     required String? token,
  //     required int idUserAppInstitution,
  //     required int idCategory,
  //     required String levelCategory,
  //     required bool readAlsoDeleted,
  //     required String numberResult,
  //     required String nameDescSearch,
  //     required bool readImageData,
  //     required String orderBy}) async {
  //   try {
  //     var response = await commonAPI.getCategories(
  //         token: token,
  //         idUserAppInstitution: idUserAppInstitution,
  //         idCategory: idCategory,
  //         levelCategory: levelCategory,
  //         readAlsoDeleted: readAlsoDeleted,
  //         numberResult: numberResult,
  //         nameDescSearch: nameDescSearch,
  //         readImageData: readImageData,
  //         orderBy: orderBy);
  //     if (response != null) {
  //       final Map<String, dynamic> parseData = await jsonDecode(response);
  //       bool isOk = parseData['isOk'];
  //       if (!isOk) {
  //         String errorDescription = parseData['errorDescription'];
  //         if (context.mounted) {
  //           ScaffoldMessenger.of(context).showSnackBar(
  //               SnackUtil.stylishSnackBar(
  //                   title: "Categorie",
  //                   message: errorDescription,
  //                   contentType: "failure"));
  //         }
  //       } else {
  //         List<CategoryCatalogModel> categories =
  //             List.from(parseData['okResult'])
  //                 .map((e) => CategoryCatalogModel.fromJson(e))
  //                 .toList();
  //         return categories;
  //         // notifyListeners();
  //       }
  //     } else {
  //       AuthenticationNotifier authenticationNotifier =
  //           Provider.of<AuthenticationNotifier>(context, listen: false);
  //       authenticationNotifier.exit(context);
  //     }
  //   } on SocketException catch (_) {
  //     if (context.mounted) {
  //       ScaffoldMessenger.of(context).showSnackBar(SnackUtil.stylishSnackBar(
  //           title: "Categorie",
  //           message: "Errore di connessione",
  //           contentType: "failure"));
  //     }
  //   }
  // }

  Future getProducts(
      {required BuildContext context,
      required String? token,
      required int idUserAppInstitution,
      required int idCategory,
      required bool readAlsoDeleted,
      required String numberResult,
      required String nameDescSearch,
      required bool readImageData,
      required String orderBy,
      required bool shoWVariant,
      required bool viewOutOfAssortment}) async {
    try {
      var response = await commonAPI.getProducts(
          token: token,
          idUserAppInstitution: idUserAppInstitution,
          idCategory: idCategory,
          readAlsoDeleted: readAlsoDeleted,
          numberResult: numberResult,
          nameDescSearch: nameDescSearch,
          readImageData: readImageData,
          orderBy: orderBy,
          showVariant: shoWVariant,
          viewOutOfAssortment: viewOutOfAssortment);
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
            title: "Prodotti",
            message: "Errore di connessione",
            contentType: "failure"));
      }
    }
  }

  void refresh() {
    notifyListeners();
  }
}

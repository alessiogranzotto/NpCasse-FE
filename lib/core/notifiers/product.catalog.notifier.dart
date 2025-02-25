import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:np_casse/core/api/common.api.dart';
import 'package:np_casse/core/api/product.catalog.api.dart';
import 'package:np_casse/core/models/category.catalog.model.dart';
import 'package:np_casse/core/models/product.catalog.model.dart';
import 'package:np_casse/core/models/vat.model.dart';
import 'package:np_casse/core/notifiers/authentication.notifier.dart';
import 'package:np_casse/core/utils/snackbar.util.dart';
import 'package:provider/provider.dart';

class ProductCatalogNotifier with ChangeNotifier {
  final ProductCatalogAPI productCatalogAPI = ProductCatalogAPI();
  final CommonAPI commonAPI = CommonAPI();

  Future getCategories(
      {required BuildContext context,
      required String? token,
      required int idUserAppInstitution,
      required int idCategory,
      required String levelCategory,
      required bool readAlsoDeleted,
      required String numberResult,
      required String nameDescSearch,
      required bool readImageData,
      required String orderBy}) async {
    try {
      var response = await commonAPI.getCategories(
          token: token,
          idUserAppInstitution: idUserAppInstitution,
          idCategory: idCategory,
          levelCategory: levelCategory,
          readAlsoDeleted: readAlsoDeleted,
          numberResult: numberResult,
          nameDescSearch: nameDescSearch,
          readImageData: readImageData,
          orderBy: orderBy);
      if (response != null) {
        final Map<String, dynamic> parseData = await jsonDecode(response);
        bool isOk = parseData['isOk'];
        if (!isOk) {
          String errorDescription = parseData['errorDescription'];
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackUtil.stylishSnackBar(
                    title: "Categorie",
                    message: errorDescription,
                    contentType: "failure"));
          }
        } else {
          List<CategoryCatalogModel> categories =
              List.from(parseData['okResult'])
                  .map((e) => CategoryCatalogModel.fromJson(e))
                  .toList();
          return categories;
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
            title: "Categorie",
            message: "Errore di connessione",
            contentType: "failure"));
      }
    }
  }

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

  Future getVat(
      {required BuildContext context,
      required String? token,
      required int idUserAppInstitution,
      bool? isDelayed}) async {
    try {
      if (isDelayed != null && isDelayed) {
        await Future.delayed(const Duration(seconds: 2));
      }
      var response = await commonAPI.getVat(
        token: token,
        idUserAppInstitution: idUserAppInstitution,
      );
      if (response != null) {
        final Map<String, dynamic> parseData = await jsonDecode(response);
        bool isOk = parseData['isOk'];
        if (!isOk) {
          String errorDescription = parseData['errorDescription'];
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackUtil.stylishSnackBar(
                    title: "vat",
                    message: errorDescription,
                    contentType: "failure"));
          }
        } else {
          VatDataModel vat = VatDataModel.fromJson(parseData['okResult']);
          return vat;
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
            title: "vat",
            message: "Errore di connessione",
            contentType: "failure"));
      }
    }
  }

  Future getProductPrice(
      {required BuildContext context,
      required String? token,
      required int idUserAppInstitution,
      required int idProduct,
      required List<String?> parameters}) async {
    try {
      var response = await productCatalogAPI.getProductPrice(
          token: token,
          idUserAppInstitution: idUserAppInstitution,
          idProduct: idProduct,
          parameters: parameters);
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
          double productPrice = parseData['okResult'];
          return productPrice;
        }
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

  Future addOrUpdateProduct(
      {required BuildContext context,
      required String? token,
      required ProductCatalogModel productCatalogModel}) async {
    try {
      bool isOk = false;
      //SVUOTO SE IMMAGINE NON IMPOSTATA
      // if (projectModel.imageProject == AppAssets.noImageString) {
      //   projectModel.imageProject = '';
      // }
      var response = await productCatalogAPI.addOrUpdateProduct(
          token: token, productCatalogModel: productCatalogModel);

      if (response != null) {
        final Map<String, dynamic> parseData = await jsonDecode(response);
        isOk = parseData['isOk'];
        if (!isOk) {
          String errorDescription = parseData['errorDescription'];
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackUtil.stylishSnackBar(
                    title: "Prodotti",
                    message: errorDescription,
                    contentType: "failure"));
            // Navigator.pop(context);
          }
        } else {
          // ProjectModel projectDetail =
          //     ProjectModel.fromJson(parseData['okResult']);
          //return projectDetail;
          // notifyListeners();
        }
      }
      return isOk;
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

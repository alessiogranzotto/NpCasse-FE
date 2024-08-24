import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:np_casse/core/api/product.catalog.api.dart';
import 'package:np_casse/core/models/product.catalog.model.dart';
import 'package:np_casse/core/models/product.model.dart';
import 'package:np_casse/core/utils/snackbar.util.dart';

class ProductCatalogNotifier with ChangeNotifier {
  final ProductCatalogAPI productCatalogAPI = ProductCatalogAPI();
  ProductModel currentProductModel = ProductModel.empty();
  int get getIdProduct => currentProductModel.idProduct;
  int get getIdStore => currentProductModel.idStore;
  String get getNameProduct => currentProductModel.nameProduct;
  double get getPriceProduct => currentProductModel.priceProduct;

  setProduct(ProductModel productModel) {
    currentProductModel = productModel;
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
      required bool shoWVariant}) async {
    try {
      var response = await productCatalogAPI.getProducts(
          token: token,
          idUserAppInstitution: idUserAppInstitution,
          idCategory: idCategory,
          readAlsoDeleted: readAlsoDeleted,
          numberResult: numberResult,
          nameDescSearch: nameDescSearch,
          readImageData: readImageData,
          orderBy: orderBy,
          showVariant: shoWVariant);
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
          List<ProductCatalogModel> products = List.from(parseData['okResult'])
              .map((e) => ProductCatalogModel.fromJson(e))
              .toList();
          return products;
          // notifyListeners();
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

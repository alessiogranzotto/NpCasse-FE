import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:np_casse/core/api/category.catalog.api.dart';
import 'package:np_casse/core/models/category.catalog.model.dart';
import 'package:np_casse/core/utils/snackbar.util.dart';

class CategoryCatalogNotifier with ChangeNotifier {
  final CategoryCatalogAPI categoryCatalogAPI = CategoryCatalogAPI();
  CategoryCatalogModel currentCategoryCatalogModel =
      CategoryCatalogModel.empty();
  // int get getIdProduct => currentProductModel.idProduct;
  // int get getIdStore => currentProductModel.idStore;
  // String get getNameProduct => currentProductModel.nameProduct;
  // double get getPriceProduct => currentProductModel.priceProduct;

  setCategoryCatalog(CategoryCatalogModel CategoryCatalogModel) {
    currentCategoryCatalogModel = CategoryCatalogModel;
  }

  void refresh() {
    notifyListeners();
  }

  Future getCategories(
      {required BuildContext context,
      required String? token,
      required int idUserAppInstitution,
      required int idCategory,
      required String levelCategory,
      required bool readAlsoDeleted,
      required bool readImageData,
      required int pageSize,
      required int pageNumber}) async {
    try {
      var response = await categoryCatalogAPI.getCategories(
          token: token,
          idUserAppInstitution: idUserAppInstitution,
          idCategory: idCategory,
          levelCategory: levelCategory,
          readAlsoDeleted: readAlsoDeleted,
          readImageData: readImageData,
          pageSize: pageSize,
          pageNumber: pageNumber);
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
          CategoryCatalogDataModel categories =
              CategoryCatalogDataModel.fromJson(parseData['okResult'] ?? '');
          return categories;
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
}

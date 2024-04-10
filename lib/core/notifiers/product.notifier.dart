import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:np_casse/core/api/product.api.dart';
import 'package:np_casse/core/models/product.model.dart';
import 'package:np_casse/core/utils/snackbar.util.dart';

class ProductNotifier with ChangeNotifier {
  final ProductAPI productAPI = ProductAPI();
  ProductModel currentProductModel = ProductModel.empty();
  int get getIdProduct => currentProductModel.idProduct;
  int get getIdStore => currentProductModel.idStore;
  String get getNameProduct => currentProductModel.nameProduct;
  double get getPriceProduct => currentProductModel.priceProduct;

  setProduct(ProductModel productModel) {
    currentProductModel = productModel;
  }

  void refresh() {
    notifyListeners();
  }

  Future getProducts(
      {required BuildContext context,
      required String? token,
      required int idUserAppInstitution,
      required int idProject,
      required int idStore,
      required String searchedBy}) async {
    try {
      var response = await productAPI.getProduct(
          token: token,
          idUserAppInstitution: idUserAppInstitution,
          idProject: idProject,
          idStore: idStore);
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
          List<ProductModel> products = List.from(parseData['okResult'])
              .map((e) => ProductModel.fromJson(e))
              .toList();
          if (searchedBy.isNotEmpty) {
            List<ProductModel> productsFiltered = products
                .where((element) =>
                    element.nameProduct.toLowerCase().contains(searchedBy) ||
                    element.descriptionProduct
                        .toLowerCase()
                        .contains(searchedBy))
                .toList();
            return productsFiltered;
          }
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
      required int idUserAppInstitution,
      required int idProject,
      required int idStore,
      required ProductModel productModel}) async {
    try {
      bool isOk = false;
      var response = await productAPI.addOrUpdateProduct(
          token: token,
          idUserAppInstitution: idUserAppInstitution,
          idProject: idProject,
          idStore: idStore,
          productModel: productModel);

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
            title: "Prodotti",
            message: "Errore di connessione",
            contentType: "failure"));
      }
    }
  }
}

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:np_casse/core/api/report.api.dart';
import 'package:np_casse/core/models/cart.history.model.dart';
import 'package:np_casse/core/models/product.history.model.dart';
import 'package:np_casse/core/notifiers/authentication.notifier.dart';
import 'package:np_casse/core/utils/snackbar.util.dart';
import 'package:provider/provider.dart';

class ReportNotifier with ChangeNotifier {
  final ReportApi reportAPI = ReportApi();

  CartHistoryModel currentCartHistoryModel = CartHistoryModel.empty();

  Future findCartList(
      {required BuildContext context,
      required String? token,
      required int idUserAppInstitution,
      required int pageNumber,
      required int pageSize,
      required List<String> orderBy}) async {
    try {
      bool isOk = false;
      var response = await reportAPI.findCartList(
          token: token,
          idUserAppInstitution: idUserAppInstitution,
          pageNumber: pageNumber,
          pageSize: pageSize,
          orderBy: orderBy);

      if (response != null) {
        final Map<String, dynamic> parseData = await jsonDecode(response);
        isOk = parseData['isOk'];
        if (!isOk) {
          String errorDescription = parseData['errorDescription'];
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackUtil.stylishSnackBar(
                    title: "Carrello Storico",
                    message: errorDescription,
                    contentType: "failure"));
          }
        } else {
          if (parseData['okResult'] != null) {
            CartHistoryModel cartHistoryModel =
                CartHistoryModel.fromJson(parseData['okResult']);
            return cartHistoryModel;
          } else {
            return null;
          }
        }
      } else {
        AuthenticationNotifier authenticationNotifier =
            Provider.of<AuthenticationNotifier>(context, listen: false);
        authenticationNotifier.exit(context);
      }
    } on SocketException catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackUtil.stylishSnackBar(
            title: "Carrello Storico",
            message: "Errore di connessione",
            contentType: "failure"));
      }
    }
  }

  Future findProductList(
      {required BuildContext context,
      required String? token,
      required int idUserAppInstitution,
      required int pageNumber,
      required int pageSize,
      required List<String> orderBy}) async {
    try {
      bool isOk = false;
      var response = await reportAPI.findProductList(
          token: token,
          idUserAppInstitution: idUserAppInstitution,
          pageNumber: pageNumber,
          pageSize: pageSize,
          orderBy: orderBy);

      if (response != null) {
        final Map<String, dynamic> parseData = await jsonDecode(response);
        isOk = parseData['isOk'];
        if (!isOk) {
          String errorDescription = parseData['errorDescription'];
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackUtil.stylishSnackBar(
                    title: "Prodotti Storico",
                    message: errorDescription,
                    contentType: "failure"));
          }
        } else {
          if (parseData['okResult'] != null) {
            ProductHistoryModel productHistoryModel =
                ProductHistoryModel.fromJson(parseData['okResult']);
            return productHistoryModel;
          } else {
            return null;
          }
        }
      } else {
        AuthenticationNotifier authenticationNotifier =
            Provider.of<AuthenticationNotifier>(context, listen: false);
        authenticationNotifier.exit(context);
      }
    } on SocketException catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackUtil.stylishSnackBar(
            title: "Prodotti Storico",
            message: "Errore di connessione",
            contentType: "failure"));
      }
    }
  }

  void refresh() {
    notifyListeners();
  }
}

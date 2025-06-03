import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:np_casse/core/api/category.catalog.api.dart';
import 'package:np_casse/core/api/common.api.dart';
import 'package:np_casse/core/api/report.api.dart';
import 'package:np_casse/core/models/cart.history.model.dart';
import 'package:np_casse/core/models/category.catalog.model.dart';
import 'package:np_casse/core/models/myosotis.donation.history.model.dart';
import 'package:np_casse/core/notifiers/authentication.notifier.dart';
import 'package:np_casse/core/utils/download.file.dart';
import 'package:np_casse/core/utils/snackbar.util.dart';
import 'package:provider/provider.dart';
import 'dart:typed_data';

class ReportMyosotisDonationNotifier with ChangeNotifier {
  final ReportApi reportAPI = ReportApi();
  // final CategoryCatalogAPI categoryCatalogAPI = CategoryCatalogAPI();
  // CategoryCatalogModel currentCategoryCatalogModel =
  //     CategoryCatalogModel.empty();
  // final CommonAPI commonAPI = CommonAPI();

  MyosotisDonationHistoryModel currentMyosotisDonationHistoryModel =
      MyosotisDonationHistoryModel.empty();
  bool _isUpdated = false;
  bool get isUpdated => _isUpdated;

  void setUpdate(bool value) {
    _isUpdated = value;
    notifyListeners();
  }

  Future findMyosotisDonationList(
      {required BuildContext context,
      required String? token,
      required int idUserAppInstitution,
      required int pageNumber,
      required int pageSize,
      required List<String> orderBy,
      required List<String> filter}) async {
    try {
      bool isOk = false;
      var response = await reportAPI.findMyosotisDonationList(
          token: token,
          idUserAppInstitution: idUserAppInstitution,
          pageNumber: pageNumber,
          pageSize: pageSize,
          orderBy: orderBy,
          filter: filter);

      if (response != null) {
        final Map<String, dynamic> parseData = await jsonDecode(response);
        isOk = parseData['isOk'];
        if (!isOk) {
          String errorDescription = parseData['errorDescription'];
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackUtil.stylishSnackBar(
                    title: "Donazioni Myosotis",
                    message: errorDescription,
                    contentType: "failure"));
          }
        } else {
          if (parseData['okResult'] != null) {
            MyosotisDonationHistoryModel myosotisDonationHistoryModel =
                MyosotisDonationHistoryModel.fromJson(parseData['okResult']);
            return myosotisDonationHistoryModel;
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
            title: "Donazioni Myosotis",
            message: "Errore di connessione",
            contentType: "failure"));
      }
    }
  }

  Future<void> downloadCartList(
      {required BuildContext context,
      required String? token,
      required int idUserAppInstitution,
      required int pageNumber,
      required int pageSize,
      required List<String> orderBy,
      required List<String> filter}) async {
    try {
      bool isOk = false;
      var response = await reportAPI.downloadCartList(
          token: token,
          idUserAppInstitution: idUserAppInstitution,
          pageNumber: pageNumber,
          pageSize: pageSize,
          orderBy: orderBy,
          filter: filter);
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
            await DownloadFile.downloadFile(parseData['okResult'], context);
            return null;
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

  void refresh() {
    notifyListeners();
  }
}

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:np_casse/core/api/report.api.dart';
import 'package:np_casse/core/models/product.history.model.dart';
import 'package:np_casse/core/notifiers/authentication.notifier.dart';
import 'package:np_casse/core/utils/snackbar.util.dart';
import 'package:provider/provider.dart';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:np_casse/core/utils/file_web.dart'
    if (dart.library.io) 'package:np_casse/core/utils/file_mobile.dart';

class ReportProductNotifier with ChangeNotifier {
  final ReportApi reportAPI = ReportApi();

  bool _isUpdated = false;
  bool get isUpdated => _isUpdated;

  void setUpdate(bool value) {
    _isUpdated = value;
    notifyListeners();
  }

  Future findProductList(
      {required BuildContext context,
      required String? token,
      required int idUserAppInstitution,
      required int pageNumber,
      required int pageSize,
      required List<String> orderBy,
      required List<String> filter}) async {
    try {
      bool isOk = false;
      var response = await reportAPI.findProductList(
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

  Future<void> downloadProductList(
      {required BuildContext context,
      required String? token,
      required int idUserAppInstitution,
      required int pageNumber,
      required int pageSize,
      required List<String> orderBy,
      required List<String> filter}) async {
    try {
      bool isOk = false;
      var response = await reportAPI.downloadProductList(
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
                    title: "Prodotti Storico",
                    message: errorDescription,
                    contentType: "failure"));
          }
        } else {
          if (parseData['okResult'] != null) {
            await downloadFile(parseData['okResult'], context);
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
            title: "Prodotti Storico",
            message: "Errore di connessione",
            contentType: "failure"));
      }
    }
  }

  Future<void> downloadFile(
      Map<String, dynamic> okResult, BuildContext context) async {
    var fileContents = okResult['fileContents'];

    // Check if fileContents is a base64-encoded string
    Uint8List fileBytes;
    if (fileContents is String) {
      // Decode base64 string to Uint8List
      fileBytes = base64Decode(fileContents);
    } else if (fileContents is Uint8List) {
      // If fileContents is already Uint8List, just use it
      fileBytes = fileContents;
    } else {
      // If it's neither, throw an error or handle accordingly
      throw Exception(
          "File contents is neither a valid base64 string nor a Uint8List");
    }

    // Proceed with platform-specific logic
    if (kIsWeb) {
      // Web-specific logic
      downloadFileWeb(
          fileBytes, okResult['fileDownloadName'], okResult['contentType']);
    } else {
      // Mobile-specific logic
      // await downloadFileMobile(fileBytes, okResult['fileDownloadName'], context);
    }
  }

  void refresh() {
    notifyListeners();
  }
}

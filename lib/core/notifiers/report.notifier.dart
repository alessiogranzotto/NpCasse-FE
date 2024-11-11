import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:np_casse/core/api/report.api.dart';
import 'package:np_casse/core/models/cart.history.model.dart';
import 'package:np_casse/core/models/product.history.model.dart';
import 'package:np_casse/core/notifiers/authentication.notifier.dart';
import 'package:np_casse/core/utils/snackbar.util.dart';
import 'package:provider/provider.dart';
import 'dart:typed_data';
// import 'dart:html' as html;

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

  Future<void> downloadCartList({
    required BuildContext context,
    required String? token,
    required int idUserAppInstitution,
  }) async {
    try {
      bool isOk = false;
      var response = await reportAPI.downloadCartList(
        token: token,
        idUserAppInstitution: idUserAppInstitution,
      );
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
            title: "Carrello Storico",
            message: "Errore di connessione",
            contentType: "failure"));
      }
    }
  }

  Future<void> downloadProductList({
    required BuildContext context,
    required String? token,
    required int idUserAppInstitution,
  }) async {
    try {
      bool isOk = false;
      var response = await reportAPI.downloadProductList(
        token: token,
        idUserAppInstitution: idUserAppInstitution,
      );
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
    print(okResult);
    var fileContents = okResult['fileContents'];

    // Check if fileContents is a base64-encoded string
    Uint8List fileBytes;
    if (fileContents is String) {
      // Decode base64 string to Uint8List
      fileBytes = base64Decode(fileContents);
    } else {
      // If it's not a string, handle appropriately (throw error or log)
      throw Exception("File contents is not a valid base64 string");
    }

    // Create a Blob and download it
    // final blob = html.Blob([fileBytes], okResult['contentType']);
    // final url = html.Url.createObjectUrlFromBlob(blob);
    // html.AnchorElement(href: url)
    //   ..setAttribute('download', okResult['fileDownloadName'])
    //   ..click();

    // Revoke object URL after downloading to free memory
    // html.Url.revokeObjectUrl(url);
  }

  void refresh() {
    notifyListeners();
  }
}

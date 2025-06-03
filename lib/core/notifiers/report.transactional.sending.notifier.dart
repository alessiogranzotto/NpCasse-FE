import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:np_casse/core/api/Transactional.sending.api.dart';
import 'package:np_casse/core/models/transactional.sending.history.model.dart';
import 'package:np_casse/core/notifiers/authentication.notifier.dart';
import 'package:np_casse/core/utils/download.file.dart';
import 'package:np_casse/core/utils/snackbar.util.dart';
import 'package:provider/provider.dart';

class ReportTransactionalSendingNotifier with ChangeNotifier {
  final TransactionalSendingAPI transactionalSendingAPI =
      TransactionalSendingAPI();

  bool _isUpdated = false;
  bool get isUpdated => _isUpdated;

  void setUpdate(bool value) {
    _isUpdated = value;
    notifyListeners();
  }

  Future findTransactionalSendingList(
      {required BuildContext context,
      required String? token,
      required int idUserAppInstitution,
      required int pageNumber,
      required int pageSize,
      required List<String> orderBy,
      required List<String> filter}) async {
    try {
      bool isOk = false;
      var response = await transactionalSendingAPI.findTransactionalSendingList(
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
                    title: "Comunicazioni",
                    message: errorDescription,
                    contentType: "failure"));
          }
        } else {
          if (parseData['okResult'] != null) {
            TransactionalSendingHistoryModel transactionalSendingHistoryModel =
                TransactionalSendingHistoryModel.fromJson(
                    parseData['okResult']);
            return transactionalSendingHistoryModel;
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
            title: "Report invio massivo",
            message: "Errore di connessione",
            contentType: "failure"));
      }
    }
  }

  Future<void> downloadTransactionalSendingList(
      {required BuildContext context,
      required String? token,
      required int idUserAppInstitution,
      required int pageNumber,
      required int pageSize,
      required List<String> orderBy,
      required List<String> filter}) async {
    try {
      bool isOk = false;
      var response =
          await transactionalSendingAPI.downloadTransactionalSendingList(
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
                    title: "Report invio massivo",
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
            title: "Report invio massivo",
            message: "Errore di connessione",
            contentType: "failure"));
      }
    }
  }

  void refresh() {
    notifyListeners();
  }
}

// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:np_casse/core/api/Transactional.sending.api.dart';
import 'package:np_casse/core/api/common.sending.api.dart';
import 'package:np_casse/core/models/comunication.sending.model.dart';
import 'package:np_casse/core/notifiers/authentication.notifier.dart';
import 'package:np_casse/core/utils/download.file.dart';
import 'package:np_casse/core/utils/snackbar.util.dart';
import 'package:provider/provider.dart';

class TransactionalSendingNotifier with ChangeNotifier {
  final TransactionalSendingAPI transactionalSendingAPI =
      TransactionalSendingAPI();
  final CommonSendingAPI commonSendingAPI = CommonSendingAPI();

  Future findTransactionalSendings(
      {required BuildContext context,
      required String? token,
      required int idUserAppInstitution,
      required int idInstitution,
      required bool readAlsoArchived,
      required String numberResult,
      required String nameDescSearch,
      required String orderBy,
      required String type}) async {
    try {
      var response = await transactionalSendingAPI.findTransactionalSendings(
          token: token,
          idUserAppInstitution: idUserAppInstitution,
          idInstitution: idInstitution,
          readAlsoArchived: readAlsoArchived,
          numberResult: numberResult,
          nameDescSearch: nameDescSearch,
          orderBy: orderBy,
          type: type);
      if (response != null) {
        print(response);
        final Map<String, dynamic> parseData = await jsonDecode(response);
        bool isOk = parseData['isOk'];
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
          List<TransactionalSendingModel> TransactionalSending =
              List.from(parseData['okResult'])
                  .map((e) => TransactionalSendingModel.fromJson(e))
                  .toList();
          return TransactionalSending;
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
            title: "Comunicazioni",
            message: "Errore di connessione",
            contentType: "failure"));
      }
    }
  }

  Future getEmailTemplatesFromSmtp2Go({
    required BuildContext context,
    required String? token,
    required int idUserAppInstitution,
    required int idInstitution,
  }) async {
    try {
      bool isOk = false;

      var response = await commonSendingAPI.getEmailTemplatesFromSmtp2Go(
        token: token,
        idUserAppInstitution: idUserAppInstitution,
        idInstitution: idInstitution,
      );

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
            List<TemplateSmtp2GoModel> templateComunicationModel =
                List.from(parseData['okResult'])
                    .map((e) => TemplateSmtp2GoModel.fromJson(e))
                    .toList();
            return templateComunicationModel;
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
            title: "Comunicazioni",
            message: "Errore di connessione",
            contentType: "failure"));
      }
    }
  }

  Future getAvailableAction(
      {required BuildContext context,
      required String? token,
      required int idUserAppInstitution}) async {
    try {
      bool isOk = false;

      var response = await transactionalSendingAPI.getAvailableAction(
          token: token, idUserAppInstitution: idUserAppInstitution);

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
            List<String> availableAction =
                List<String>.from(parseData['okResult']);
            return availableAction;
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
            title: "Comunicazioni",
            message: "Errore di connessione",
            contentType: "failure"));
      }
    }
  }

  Future downloadEmailTemplateDetailFromSmtp2Go({
    required BuildContext context,
    required String? token,
    required int idUserAppInstitution,
    required int idInstitution,
    required String idtemplate,
  }) async {
    try {
      bool isOk = false;

      var response =
          await commonSendingAPI.downloadEmailTemplateDetailFromSmtp2Go(
              token: token,
              idUserAppInstitution: idUserAppInstitution,
              idInstitution: idInstitution,
              idTemplate: idtemplate);

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
            title: "Comunicazioni",
            message: "Errore di connessione",
            contentType: "failure"));
      }
    }
  }

  Future addOrUpdateTransactionalSending(
      {required BuildContext context,
      String? token,
      required TransactionalSendingModel transactionalSendingModel}) async {
    try {
      bool isOk = false;
      var response =
          await transactionalSendingAPI.addOrUpdateTransactionalSending(
              token: token,
              transactionalSendingModel: transactionalSendingModel);

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
        } else {}
      }
      return isOk;
    } on SocketException catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackUtil.stylishSnackBar(
            title: "Comunicazioni",
            message: "Errore di connessione",
            contentType: "failure"));
      }
    }
  }

  Future getTransactionalEmailStatistics(
      {required BuildContext context,
      required String? token,
      required int idUserAppInstitution,
      required int idInstitution,
      required int idTransactionalSending}) async {
    try {
      var response =
          await transactionalSendingAPI.getTransactionalEmailStatistics(
              token: token,
              idUserAppInstitution: idUserAppInstitution,
              idInstitution: idInstitution,
              idTransactionalSending: idTransactionalSending);
      if (response != null) {
        final Map<String, dynamic> parseData = await jsonDecode(response);
        bool isOk = parseData['isOk'];
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
          List<ComunicationStatistics> transactionalEmailStatistics =
              List.from(parseData['okResult'])
                  .map((e) => ComunicationStatistics.fromJson(e))
                  .toList();
          return transactionalEmailStatistics;
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
            title: "Comunicazioni",
            message: "Errore di connessione",
            contentType: "failure"));
      }
    }
  }

  void refresh() {
    notifyListeners();
  }
}

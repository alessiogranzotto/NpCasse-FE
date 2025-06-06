// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:np_casse/core/api/common.sending.api.dart';
import 'package:np_casse/core/api/mass.sending.api.dart';
import 'package:np_casse/core/models/comunication.sending.model.dart';
import 'package:np_casse/core/notifiers/authentication.notifier.dart';
import 'package:np_casse/core/utils/download.file.dart';
import 'package:np_casse/core/utils/snackbar.util.dart';
import 'package:provider/provider.dart';

class MassSendingNotifier with ChangeNotifier {
  final MassSendingAPI massSendingAPI = MassSendingAPI();
  final CommonSendingAPI commonSendingAPI = CommonSendingAPI();

  Future findMassSendings(
      {required BuildContext context,
      required String? token,
      required int idUserAppInstitution,
      required int idInstitution,
      required bool readAlsoArchived,
      required String numberResult,
      required String nameDescSearch,
      required String orderBy}) async {
    try {
      var response = await massSendingAPI.findMassSendings(
          token: token,
          idUserAppInstitution: idUserAppInstitution,
          idInstitution: idInstitution,
          readAlsoArchived: readAlsoArchived,
          numberResult: numberResult,
          nameDescSearch: nameDescSearch,
          orderBy: orderBy);
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
          List<MassSendingModel> massSending = List.from(parseData['okResult'])
              .map((e) => MassSendingModel.fromJson(e))
              .toList();
          return massSending;
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

  Future addOrUpdateMassSending(
      {required BuildContext context,
      String? token,
      required MassSendingModel massSendingModel}) async {
    try {
      bool isOk = false;
      var response = await massSendingAPI.addOrUpdateMassSending(
          token: token, massSendingModel: massSendingModel);

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

  Future getAccumulatorFromGive(
      {required BuildContext context,
      required String? token,
      required int idUserAppInstitution,
      required int idInstitution}) async {
    try {
      var response = await commonSendingAPI.getAccumulatorFromGive(
          token: token,
          idUserAppInstitution: idUserAppInstitution,
          idInstitution: idInstitution);
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
          List<AccumulatorGiveModel> massSending =
              List.from(parseData['okResult'])
                  .map((e) => AccumulatorGiveModel.fromJson(e))
                  .toList();
          return massSending;
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

  Future updateMassSendingGiveAccumulator(
      {required BuildContext context,
      required String? token,
      required int idMassSending,
      required int idUserAppInstitution,
      required List<MassSendingGiveAccumulator>
          massSendingGiveAccumulator}) async {
    try {
      bool isOk = false;
      var response = await massSendingAPI.updateMassSendingGiveAccumulator(
          token: token,
          idMassSending: idMassSending,
          idUserAppInstitution: idUserAppInstitution,
          massSendingGiveAccumulator: massSendingGiveAccumulator);

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

  Future updateMassSendingPlanning(
      {required BuildContext context,
      required String? token,
      required int idMassSending,
      required int idUserAppInstitution,
      required DateTime dateTimePlanMassSending}) async {
    try {
      bool isOk = false;
      var response = await massSendingAPI.updateMassSendingPlanning(
          token: token,
          idMassSending: idMassSending,
          idUserAppInstitution: idUserAppInstitution,
          dateTimePlanMassSending: dateTimePlanMassSending);

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

  Future getMassSendingJobStatistics(
      {required BuildContext context,
      required String? token,
      required int idUserAppInstitution,
      required int idInstitution,
      required int idMassSending}) async {
    try {
      var response = await massSendingAPI.getMassSendingJobStatistics(
          token: token,
          idUserAppInstitution: idUserAppInstitution,
          idInstitution: idInstitution,
          idMassSending: idMassSending);
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
          List<ComunicationStatistics> massSendingJobStatistics =
              List.from(parseData['okResult'])
                  .map((e) => ComunicationStatistics.fromJson(e))
                  .toList();
          return massSendingJobStatistics;
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

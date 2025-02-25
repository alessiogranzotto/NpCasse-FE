import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:np_casse/core/api/myosotis.configuration.api.dart';
import 'package:np_casse/core/models/myosotis.configuration.model.dart';
import 'package:np_casse/core/notifiers/authentication.notifier.dart';
import 'package:np_casse/core/utils/snackbar.util.dart';
import 'package:provider/provider.dart';

class MyosotisConfigurationNotifier with ChangeNotifier {
  final MyosotisConfigurationAPI myosotisConfigurationAPI =
      MyosotisConfigurationAPI();

  Future getMyosotisConfigurationDetailEmpty(
      {required BuildContext context,
      String? token,
      required int idUserAppInstitution,
      required int idInstitution}) async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      var response =
          await myosotisConfigurationAPI.getMyosotisConfigurationDetailEmpty(
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
                    title: "Configurazioni Myosotis",
                    message: errorDescription,
                    contentType: "failure"));
          }
        } else {
          MyosotisConfigurationDetailEmpty myosotisConfigurationDetailEmpty =
              MyosotisConfigurationDetailEmpty.fromJson(parseData['okResult']);
          return myosotisConfigurationDetailEmpty;
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
            title: "Configurazioni Myosotis",
            message: "Errore di connessione",
            contentType: "failure"));
      }
    }
  }

  Future findMyosotisConfigurations(
      {required BuildContext context,
      required String? token,
      required int idUserAppInstitution,
      required int idInstitution,
      required bool readAlsoArchived,
      required String numberResult,
      required String nameDescSearch,
      required String orderBy}) async {
    try {
      var response = await myosotisConfigurationAPI.findMyosotisConfigurations(
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
                    title: "Configurazioni Myosotis",
                    message: errorDescription,
                    contentType: "failure"));
          }
        } else {
          List<MyosotisConfigurationModel> myosotisConfiguration =
              List.from(parseData['okResult'])
                  .map((e) => MyosotisConfigurationModel.fromJson(e))
                  .toList();
          return myosotisConfiguration;
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
            title: "Configurazioni Myosotis",
            message: "Errore di connessione",
            contentType: "failure"));
      }
    }
  }

  void refresh() {
    notifyListeners();
  }

  addOrUpdateMyosotisConfiguration(
      {required BuildContext context,
      String? token,
      required MyosotisConfigurationModel myosotisConfigurationModel}) async {
    try {
      bool isOk = false;
      var response =
          await myosotisConfigurationAPI.addOrUpdateMyosotisConfiguration(
              token: token,
              myosotisConfigurationModel: myosotisConfigurationModel);

      if (response != null) {
        final Map<String, dynamic> parseData = await jsonDecode(response);
        isOk = parseData['isOk'];
        if (!isOk) {
          String errorDescription = parseData['errorDescription'];
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackUtil.stylishSnackBar(
                    title: "Configurazioni Myosotis",
                    message: errorDescription,
                    contentType: "failure"));
          }
        } else {}
      }
      return isOk;
    } on SocketException catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackUtil.stylishSnackBar(
            title: "Configurazioni Myosotis",
            message: "Errore di connessione",
            contentType: "failure"));
      }
    }
  }
}

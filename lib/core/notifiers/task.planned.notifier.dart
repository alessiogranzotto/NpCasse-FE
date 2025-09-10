import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:np_casse/core/api/task.planned.api.dart';
import 'package:np_casse/core/models/task.planned.model.dart';
import 'package:np_casse/core/notifiers/authentication.notifier.dart';
import 'package:np_casse/core/utils/snackbar.util.dart';
import 'package:provider/provider.dart';

class TaskPlannedNotifier with ChangeNotifier {
  final TaskPlannedAPI taskPlannedAPI = TaskPlannedAPI();

  Future getTaskPlanned(
      {required BuildContext context,
      required String? token,
      required int idUserAppInstitution,
      required int idInstitution,
      required bool readAlsoDeleted}) async {
    try {
      var response = await taskPlannedAPI.getTaskPlanned(
          token: token,
          idUserAppInstitution: idUserAppInstitution,
          idInstitution: idInstitution,
          readAlsoDeleted: readAlsoDeleted);
      if (response != null) {
        final Map<String, dynamic> parseData = await jsonDecode(response);
        bool isOk = parseData['isOk'];
        if (!isOk) {
          String errorDescription = parseData['errorDescription'];
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackUtil.stylishSnackBar(
                    title: "Procedure pianificate",
                    message: errorDescription,
                    contentType: "failure"));
          }
        } else {
          List<TaskPlannedModel> taskPlanned = List.from(parseData['okResult'])
              .map((e) => TaskPlannedModel.fromJson(e))
              .toList();
          return taskPlanned;
        }
      } else {
        AuthenticationNotifier authenticationNotifier =
            Provider.of<AuthenticationNotifier>(context, listen: false);
        authenticationNotifier.exit(context);
      }
    } on SocketException catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackUtil.stylishSnackBar(
            title: "Procedure pianificate",
            message: "Errore di connessione",
            contentType: "failure"));
      }
    }
  }

  Future addOrUpdateTaskPlanned(
      {required BuildContext context,
      String? token,
      required TaskPlannedModel taskPlannedModel}) async {
    try {
      bool isOk = false;
      var response = await taskPlannedAPI.addOrUpdateTaskPlanned(
          token: token, taskPlannedModel: taskPlannedModel);

      if (response != null) {
        final Map<String, dynamic> parseData = await jsonDecode(response);
        isOk = parseData['isOk'];
        if (!isOk) {
          String errorDescription = parseData['errorDescription'];
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackUtil.stylishSnackBar(
                    title: "Procedure pianificate",
                    message: errorDescription,
                    contentType: "failure"));
          }
        } else {}
      }
      return isOk;
    } on SocketException catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackUtil.stylishSnackBar(
            title: "Procedure pianificate",
            message: "Errore di connessione",
            contentType: "failure"));
      }
    }
  }

  void refresh() {
    notifyListeners();
  }
}

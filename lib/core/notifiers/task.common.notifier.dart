import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:np_casse/core/api/task.common.api.dart';
import 'package:np_casse/core/models/task.common.model.dart';
import 'package:np_casse/core/notifiers/authentication.notifier.dart';
import 'package:np_casse/core/utils/snackbar.util.dart';
import 'package:provider/provider.dart';

class TaskCommonNotifier with ChangeNotifier {
  final TaskCommonAPI taskCommonAPI = TaskCommonAPI();

  Future getTaskCommon(
      {required BuildContext context,
      required String? token,
      required int idUserAppInstitution,
      required int idInstitution,
      required bool readAlsoDeleted}) async {
    try {
      var response = await taskCommonAPI.getTaskCommon(
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
                    title: "Procedure pianificate",
                    message: errorDescription,
                    contentType: "failure"));
          }
        } else {
          List<TaskCommonModel> taskCommon = List.from(parseData['okResult'])
              .map((e) => TaskCommonModel.fromJson(e))
              .toList();
          return taskCommon;
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

  void refresh() {
    notifyListeners();
  }
}

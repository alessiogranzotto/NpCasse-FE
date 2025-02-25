import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:np_casse/core/utils/download.file.dart';
import 'package:np_casse/core/api/download.app.dart.dart';
import 'package:np_casse/core/utils/snackbar.util.dart';

class DownloadAppNotifier with ChangeNotifier {
  final DownloadAppAPI downloadAppAPI = DownloadAppAPI();

  Future downloadAndroidApp({required BuildContext context}) async {
    try {
      bool isOk = false;

      var response = await downloadAppAPI.downloadAndroidApp();

      if (response != null) {
        final Map<String, dynamic> parseData = await jsonDecode(response);
        isOk = parseData['isOk'];
        if (!isOk) {
          String errorDescription = parseData['errorDescription'];
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackUtil.stylishSnackBar(
                    title: "Download App",
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
        ScaffoldMessenger.of(context).showSnackBar(SnackUtil.stylishSnackBar(
            title: "Download App",
            message: "Errore di connessione",
            contentType: "failure"));
      }
    } on SocketException catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackUtil.stylishSnackBar(
            title: "Download App",
            message: "Errore di connessione",
            contentType: "failure"));
      }
    }
  }
}

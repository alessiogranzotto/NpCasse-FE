import 'package:flutter/material.dart';
import 'package:np_casse/componenents/custom.snackbar/custom.snackbar.content.dart';

class SnackUtil {
  static stylishSnackBar(
      {required String title,
      required String message,
      required String contentType}) {
    return SnackBar(
      /// need to set following properties for best effect of awesome_snackbar_content
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: CustomSnackbarContent(
          title: title,
          message: message,

          /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
          contentType: contentType == "failure"
              ? ContentType.failure
              : (contentType == "help"
                  ? ContentType.help
                  : (contentType == "success"
                      ? ContentType.success
                      : ContentType.warning))),
    );
  }
}

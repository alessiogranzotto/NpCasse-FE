import 'package:flutter/material.dart';

class TaskUtils {
  static getIconByTaskCommonScope(String scopeTaskCommon) {
    if (scopeTaskCommon == "Carrelli") {
      return Icon(Icons.shopping_cart);
    } else if (scopeTaskCommon == "Prodotti") {
      return Icon(Icons.inventory_2);
    } else if (scopeTaskCommon == "Myosotis") {
      return Icon(Icons.app_settings_alt);
    } else {
      return Icon(Icons.circle);
    }
  }

  static getIconByTaskCommonSendMode(String sendMode) {
    if (sendMode == "Ftp") {
      return Icon(Icons.cloud_upload);
    } else if (sendMode == "Email") {
      return Icon(Icons.email);
    } else {
      return Icon(Icons.insert_drive_file);
    }
  }

  static getIconByTaskCommonExportMode(String exportMode) {
    if (exportMode == "*.txt") {
      return Icon(Icons.description);
    } else if (exportMode == "*.xlsx") {
      return Icon(Icons.table_chart);
    } else if (exportMode == "*.html") {
      return Icon(Icons.language);
    } else {
      return Icon(Icons.insert_drive_file);
    }
  }
}

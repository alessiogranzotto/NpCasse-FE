import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:np_casse/core/utils/file_mobile.dart';
import 'package:np_casse/core/utils/file_web.dart';

class DownloadFile {
  DownloadFile._(); // Private constructor to prevent instantiation

  static Future<void> downloadFile(
      Map<String, dynamic> okResult, BuildContext context) async {
    var fileContents = okResult['fileContents'];

    // Check if fileContents is a base64-encoded string
    Uint8List fileBytes;
    if (fileContents is String) {
      // Decode base64 string to Uint8List
      fileBytes = base64Decode(fileContents);
    } else if (fileContents is Uint8List) {
      // If fileContents is already Uint8List, just use it
      fileBytes = fileContents;
    } else {
      // If it's neither, throw an error or handle accordingly
      throw Exception(
          "File contents is neither a valid base64 string nor a Uint8List");
    }

    // Proceed with platform-specific logic
    if (kIsWeb) {
      // Web-specific logic
      downloadFileWeb(
          fileBytes, okResult['fileDownloadName'], okResult['contentType']);
    } else {
      // Mobile-specific logic
      await downloadFileMobile(
          fileBytes, okResult['fileDownloadName'], context);
    }
  }
}

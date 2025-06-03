import 'dart:typed_data';
import 'dart:html' as html;
import 'package:flutter/material.dart';

void downloadFileWeb(Uint8List fileBytes, String fileName, String contentType) {
  final blob = html.Blob([fileBytes], contentType);
  final url = html.Url.createObjectUrlFromBlob(blob);
  final anchor = html.AnchorElement(href: url)
    ..target = 'blank'
    ..download = fileName
    ..click();
  html.Url.revokeObjectUrl(url);
}

Future<void> downloadFileMobile(Uint8List fileBytes, String fileName, BuildContext context) async {
 
}

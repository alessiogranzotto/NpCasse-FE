import 'dart:io' as io;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> downloadFileMobile(Uint8List fileBytes, String fileName, BuildContext context) async {
  try {
    // Request the "Manage External Storage" permission
    PermissionStatus status = await Permission.manageExternalStorage.request();

    if (status.isGranted) {
      // Get the path to the external storage (usually the root of the internal SD card)
      final directory = '/storage/emulated/0/Download'; // Direct path to the public Download folder

      // Sanitize the file name (avoid illegal characters)
      final sanitizedFileName = fileName.replaceAll(RegExp(r'[\/\\:*?"<>|]'), '_');

      // Construct the file path within the Download directory
      final filePath = '$directory/$sanitizedFileName';

      // Write the file to the path
      final file = io.File(filePath);
      await file.writeAsBytes(fileBytes);

      // Show success Snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("File saved successfully"),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      // Show error Snackbar if permission is denied
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Permission denied. Cannot save file."),
          backgroundColor: Colors.red,
        ),
      );
    }
  } catch (e) {
    // Show error Snackbar in case of any exception
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Error saving file: $e"),
        backgroundColor: Colors.red,
      ),
    );
  }
}

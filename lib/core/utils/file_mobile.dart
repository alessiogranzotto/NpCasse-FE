import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io' as io;
import 'package:flutter_media_store/flutter_media_store.dart';

Future<void> downloadFileMobile(Uint8List fileBytes, String fileName, BuildContext context) async {
  try {
    // Check for permission
    PermissionStatus status = await Permission.manageExternalStorage.request();


    // Request permission if not granted
    if (!status.isGranted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Permission denied. Please enable storage access in settings."),
          backgroundColor: Colors.red,
        ),
      );
      openAppSettings();
      return;
    }

    // For Android 10+ with MediaStore, save the file in the Downloads folder
    if (io.Platform.isAndroid) {
      final sanitizedFileName = fileName.replaceAll(RegExp(r'[\/\\:*?"<>|]'), '_');

      // Dynamically determine MIME type based on file extension
      String mimeType = _getMimeType(fileName);

      // Create an instance of FlutterMediaStore
      final mediaStore = FlutterMediaStore();

      // Attempt to save the file with the determined MIME type
      mediaStore.saveFile(
        rootFolderName: "",  // Root folder (public folder)
        folderName: "",       // Folder inside the root folder (e.g., Downloads)
        fileData: fileBytes,          // Provide the file byte data
        fileName: sanitizedFileName,  // Provide the sanitized file name
        mimeType: mimeType,           // Use the determined MIME type
        onSuccess: (path, uri) {
          // Show success Snackbar with path and uri
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("File saved successfully"),
              backgroundColor: Colors.green,
            ),
          );
        },
        onError: (error) {
          // Show error Snackbar
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Error saving file: $error"),
              backgroundColor: Colors.red,
            ),
          );
        },
      );
    } else {
      // For other platforms (iOS or below Android 10)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("This feature is available on Android only."),
          backgroundColor: Colors.red,
        ),
      );
    }
  } catch (e) {
    // Catch any errors during file saving
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Error saving file: $e"),
        backgroundColor: Colors.red,
      ),
    );
  }
}

// Helper function to get MIME type based on file extension
String _getMimeType(String fileName) {
  final fileExtension = fileName.split('.').last.toLowerCase();

  switch (fileExtension) {
    case 'pdf':
      return 'application/pdf';
    case 'jpg':
    case 'jpeg':
      return 'image/jpeg';
    case 'png':
      return 'image/png';
    case 'xlsx':
      return 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet';
    case 'txt':
      return 'text/plain';
    case 'docx':
      return 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
    case 'zip':
      return 'application/zip';
    // Add other cases here as needed
    default:
      return 'application/octet-stream'; // Generic MIME type for unknown files
  }
}

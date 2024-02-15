import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:np_casse/app/constants/assets.dart';

class ImageUtils {
  ImageUtils._(); // Private constructor to prevent instantiation

  static Future<String> getFileFromImage({required ImageSource source}) async {
    //
    XFile? imageXFile;
    final ImagePicker imagePicked = ImagePicker();
    // File? imageFile;
    File? imageFilePicked;
    Uint8List imagebytes = Uint8List(8);
    String? base64Result = '';

    // bool isOk = ImagePicker().supportsImageSource(source);

    if (!kIsWeb) {
      imageXFile = await imagePicked.pickImage(
          source: source,
          maxWidth: 1280,
          maxHeight: 720,
          imageQuality: 50 //0 - 100
          );
      if (imageXFile != null) {
        var selected = File(imageXFile.path);
        imageFilePicked = selected;
        var f = await imageFilePicked.readAsBytes();
        imagebytes = f;
      } else {
        print('no image picked');
      }
    } else if (kIsWeb) {
      imageXFile = await ImagePicker().pickImage(
          source: source,
          maxWidth: 1280,
          maxHeight: 720,
          imageQuality: 50 //0 - 100
          );
      if (imageXFile != null) {
        var f = await imageXFile.readAsBytes();
        imagebytes = f;
        imageFilePicked = File('a');
      } else {
        print('no image picked');
      }
    } else {
      print('something went wrong');
    }

    base64Result = base64.encode(imagebytes);

    return base64Result;
  }

  static Image getImageFromString({required String stringImage}) {
    String strImage = stringImage != '' ? stringImage : setFakeImage();
    return Image.memory(base64Decode(strImage));
  }

  static Future<String> imageSelectorCamera() async {
    var imageFile = await getFileFromImage(source: ImageSource.camera);
    return imageFile;
  }

  static Future<String> imageSelectorFile() async {
    var imageFile = await getFileFromImage(source: ImageSource.gallery);
    return imageFile;
  }

  static String setNoImage() {
    return '';
  }

  static String setFakeImage() {
    return AppAssets.noImageString;
  }
}

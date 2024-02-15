import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:np_casse/core/api/store.api.dart';
import 'package:np_casse/core/models/store.model.dart';
import 'package:np_casse/core/utils/snackbar.util.dart';

class StoreNotifier with ChangeNotifier {
  final StoreAPI storeAPI = StoreAPI();
  StoreModel currentStoreModel = StoreModel.empty();
  int get getIdStore => currentStoreModel.idStore;
  int get getIdProject => currentStoreModel.idProject;
  String get getNameStore => currentStoreModel.nameStore;

  setStore(StoreModel storeModel) {
    currentStoreModel = storeModel;
  }

  void refresh() {
    notifyListeners();
  }

  Future getStores(
      {required BuildContext context,
      required String? token,
      required int idUserAppInstitution,
      required int idProject}) async {
    try {
      var response = await storeAPI.getStore(
          token: token,
          idUserAppInstitution: idUserAppInstitution,
          idProject: idProject);
      if (response != null) {
        final Map<String, dynamic> parseData = await jsonDecode(response);
        bool isOk = parseData['isOk'];
        if (!isOk) {
          String errorDescription = parseData['errorDescription'];
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackUtil.stylishSnackBar(
                    text: errorDescription, context: context));
            // Navigator.pop(context);
          }
        } else {
          List<StoreModel> stores = List.from(parseData['okResult'])
              .map((e) => StoreModel.fromJson(e))
              .toList();
          return stores;
          // notifyListeners();
        }
      }
    } on SocketException catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(SnackUtil.stylishSnackBar(
          text: 'Oops No You Need A Good Internet Connection',
          context: context));
    }
  }

  Future addOrUpdateStore(
      {required BuildContext context,
      required String? token,
      required int idUserAppInstitution,
      required int idProject,
      required StoreModel storeModel}) async {
    try {
      bool isOk = false;
      var response = await storeAPI.addOrUpdateStore(
          token: token,
          idUserAppInstitution: idUserAppInstitution,
          idProject: idProject,
          storeModel: storeModel);

      if (response != null) {
        final Map<String, dynamic> parseData = await jsonDecode(response);
        isOk = parseData['isOk'];
        if (!isOk) {
          String errorDescription = parseData['errorDescription'];
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackUtil.stylishSnackBar(
                    text: errorDescription, context: context));
            // Navigator.pop(context);
          }
        } else {
          // ProjectModel projectDetail =
          //     ProjectModel.fromJson(parseData['okResult']);
          //return projectDetail;
          //notifyListeners();
        }
      }
      return isOk;
    } on SocketException catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackUtil.stylishSnackBar(
            text: 'Oops No You Need A Good Internet Connection',
            context: context),
      );
    }
  }
}

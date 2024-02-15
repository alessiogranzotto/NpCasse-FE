import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:np_casse/core/api/project.api.dart';
import 'package:np_casse/core/models/project.model.dart';
import 'package:np_casse/core/utils/snackbar.util.dart';

class ProjectNotifier with ChangeNotifier {
  final ProjectAPI projectAPI = ProjectAPI();
  ProjectModel currentProjectModel = ProjectModel.empty();
  int get getIdProject => currentProjectModel.idProject;
  // int get getidUserAppInstitution => currentProjectModel.idUserAppInstitution;
  String get getNameProject => currentProjectModel.nameProject;
  String get getImageProject => currentProjectModel.imageProject;
  //bool get getIsWishlisted => currentProjectModel.isWishlisted;

  setProject(ProjectModel projectModel) {
    currentProjectModel = projectModel;
  }

  void refresh() {
    notifyListeners();
  }

  Future getProjects(
      {required BuildContext context,
      required String? token,
      required int idUserAppInstitution}) async {
    try {
      var response = await projectAPI.getProject(
          token: token, idUserAppInstitution: idUserAppInstitution);

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
          List<ProjectModel> projects = List.from(parseData['okResult'])
              .map((e) => ProjectModel.fromJson(e))
              .toList();
          return projects;
          // notifyListeners();
        }
      }
    } on SocketException catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(SnackUtil.stylishSnackBar(
          text: 'Oops No You Need A Good Internet Connection',
          context: context));
    }
  }

  Future addOrUpdateProject(
      {required BuildContext context,
      required String? token,
      required int idUserAppInstitution,
      required ProjectModel projectModel}) async {
    try {
      bool isOk = false;
      //SVUOTO SE IMMAGINE NON IMPOSTATA
      // if (projectModel.imageProject == AppAssets.noImageString) {
      //   projectModel.imageProject = '';
      // }
      var response = await projectAPI.addOrUpdateProject(
          token: token,
          idUserAppInstitution: idUserAppInstitution,
          projectModel: projectModel);

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
          // notifyListeners();
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

  // Future wishlistingProject(
  //     {required BuildContext context,
  //     required String? token,
  //     required int idUserAppInstitution,
  //     required ProjectModel projectModel}) async {
  //   try {
  //     bool isOk = false;

  //     var response = '''id': '1', 'name': 'Bananas''';
  //     isOk = true; // send a wishlisting request to Server

  //     if (response != null) {
  //       // final Map<String, dynamic> parseData = await jsonDecode(response);
  //       // isOk = parseData['isOk'];
  //       if (!isOk) {
  //         String errorDescription = ''; // parseData['errorDescription'];''
  //         if (context.mounted) {
  //           ScaffoldMessenger.of(context).showSnackBar(
  //               SnackUtil.stylishSnackBar(
  //                   text: errorDescription, context: context));
  //           // Navigator.pop(context);
  //         }
  //       } else {
  //         // ProjectModel projectDetail =
  //         //     ProjectModel.fromJson(parseData['okResult']);
  //         //return projectDetail;
  //         // if (!currentProjectModel.isWishlisted) {
  //         //   ScaffoldMessenger.of(context)
  //         //       .showSnackBar(SnackBar(content: Text('Item Wishlisted')));
  //         //   currentProjectModel.isWishlisted = true;
  //         // } else {
  //         //   ScaffoldMessenger.of(context).showSnackBar(
  //         //       SnackBar(content: Text('Item removed from Wishlist')));
  //         //   currentProjectModel.isWishlisted = false;
  //         // }
  //         notifyListeners();
  //       }
  //     }
  //     return isOk;
  //   } on SocketException catch (_) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackUtil.stylishSnackBar(
  //           text: 'Oops No You Need A Good Internet Connection',
  //           context: context),
  //     );
  //   }
  // }
}

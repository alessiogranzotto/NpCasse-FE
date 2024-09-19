// import 'dart:convert';
// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:np_casse/core/api/project.api.dart';
// import 'package:np_casse/core/models/project.model.dart';
// import 'package:np_casse/core/utils/snackbar.util.dart';

// class ProjectNotifier with ChangeNotifier {
//   final ProjectAPI projectAPI = ProjectAPI();
//   ProjectModel currentProjectModel = ProjectModel.empty();
//   int get getIdProject => currentProjectModel.idProject;
//   // int get getidUserAppInstitution => currentProjectModel.idUserAppInstitution;
//   String get getNameProject => currentProjectModel.nameProject;
//   String get getImageProject => currentProjectModel.imageProject;
//   //bool get getIsWishlisted => currentProjectModel.isWishlisted;

//   setProject(ProjectModel projectModel) {
//     currentProjectModel = projectModel;
//   }

//   void refresh() {
//     notifyListeners();
//   }

//   Future getProjects(
//       {required BuildContext context,
//       required String? token,
//       required int idUserAppInstitution}) async {
//     try {
//       var response = await projectAPI.getProject(
//           token: token, idUserAppInstitution: idUserAppInstitution);

//       if (response != null) {
//         final Map<String, dynamic> parseData = await jsonDecode(response);
//         bool isOk = parseData['isOk'];
//         if (!isOk) {
//           String errorDescription = parseData['errorDescription'];
//           if (context.mounted) {
//             ScaffoldMessenger.of(context).showSnackBar(
//                 SnackUtil.stylishSnackBar(
//                     title: "Prodotti",
//                     message: errorDescription,
//                     contentType: "failure"));
//             // Navigator.pop(context);
//           }
//         } else {
//           List<ProjectModel> projects = List.from(parseData['okResult'])
//               .map((e) => ProjectModel.fromJson(e))
//               .toList();
//           return projects;
//           // notifyListeners();
//         }
//       }
//     } on SocketException catch (_) {
//       if (context.mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(SnackUtil.stylishSnackBar(
//             title: "Progetti",
//             message: "Errore di connessione",
//             contentType: "failure"));
//       }
//     }
//   }

//   Future addOrUpdateProject(
//       {required BuildContext context,
//       required String? token,
//       required int idUserAppInstitution,
//       required ProjectModel projectModel}) async {
//     try {
//       bool isOk = false;
//       //SVUOTO SE IMMAGINE NON IMPOSTATA
//       // if (projectModel.imageProject == AppAssets.noImageString) {
//       //   projectModel.imageProject = '';
//       // }
//       var response = await projectAPI.addOrUpdateProject(
//           token: token,
//           idUserAppInstitution: idUserAppInstitution,
//           projectModel: projectModel);

//       if (response != null) {
//         final Map<String, dynamic> parseData = await jsonDecode(response);
//         isOk = parseData['isOk'];
//         if (!isOk) {
//           String errorDescription = parseData['errorDescription'];
//           if (context.mounted) {
//             ScaffoldMessenger.of(context).showSnackBar(
//                 SnackUtil.stylishSnackBar(
//                     title: "Prodotti",
//                     message: errorDescription,
//                     contentType: "failure"));
//             // Navigator.pop(context);
//           }
//         } else {
//           // ProjectModel projectDetail =
//           //     ProjectModel.fromJson(parseData['okResult']);
//           //return projectDetail;
//           // notifyListeners();
//         }
//       }
//       return isOk;
//     } on SocketException catch (_) {
//       if (context.mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(SnackUtil.stylishSnackBar(
//             title: "progetti",
//             message: "Errore di connessione",
//             contentType: "failure"));
//       }
//     }
//   }
// }

// // ignore_for_file: non_constant_identifier_names

// import 'dart:convert';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:np_casse/core/api/comunication.api.dart';
// import 'package:np_casse/core/models/comunication.model.dart';
// import 'package:np_casse/core/notifiers/authentication.notifier.dart';
// import 'package:np_casse/core/utils/download.file.dart';
// import 'package:np_casse/core/utils/snackbar.util.dart';
// import 'package:provider/provider.dart';

// class ComunicationNotifier with ChangeNotifier {
//   final ComunicationAPI comunicationAPI = ComunicationAPI();

//   bool _isUpdated = false;
//   bool get isUpdated => _isUpdated;

//   void setUpdate(bool value) {
//     _isUpdated = value;
//     notifyListeners();
//   }

//   void refresh() {
//     notifyListeners();
//   }

//   Future getEmailTemplates({
//     required BuildContext context,
//     required String? token,
//     required int idUserAppInstitution,
//     required int idInstitution,
//   }) async {
//     try {
//       bool isOk = false;

//       var response = await comunicationAPI.getEmailTemplates(
//         token: token,
//         idUserAppInstitution: idUserAppInstitution,
//         idInstitution: idInstitution,
//       );

//       if (response != null) {
//         final Map<String, dynamic> parseData = await jsonDecode(response);
//         isOk = parseData['isOk'];
//         if (!isOk) {
//           String errorDescription = parseData['errorDescription'];
//           if (context.mounted) {
//             ScaffoldMessenger.of(context).showSnackBar(
//                 SnackUtil.stylishSnackBar(
//                     title: "Comunicazioni",
//                     message: errorDescription,
//                     contentType: "failure"));
//           }
//         } else {
//           if (parseData['okResult'] != null) {
//             List<TemplateComunicationModel> templateComunicationModel =
//                 List.from(parseData['okResult'])
//                     .map((e) => TemplateComunicationModel.fromJson(e))
//                     .toList();
//             return templateComunicationModel;
//           } else {
//             return null;
//           }
//         }
//       } else {
//         AuthenticationNotifier authenticationNotifier =
//             Provider.of<AuthenticationNotifier>(context, listen: false);
//         authenticationNotifier.exit(context);
//       }
//     } on SocketException catch (_) {
//       if (context.mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(SnackUtil.stylishSnackBar(
//             title: "Anagrafiche",
//             message: "Errore di connessione",
//             contentType: "failure"));
//       }
//     }
//   }

//   Future getEmailTemplateDetail({
//     required BuildContext context,
//     required String? token,
//     required int idUserAppInstitution,
//     required int idInstitution,
//     required String idtemplate,
//   }) async {
//     try {
//       bool isOk = false;

//       var response = await comunicationAPI.getEmailTemplateDetail(
//           token: token,
//           idUserAppInstitution: idUserAppInstitution,
//           idInstitution: idInstitution,
//           idTemplate: idtemplate);

//       if (response != null) {
//         final Map<String, dynamic> parseData = await jsonDecode(response);
//         isOk = parseData['isOk'];
//         if (!isOk) {
//           String errorDescription = parseData['errorDescription'];
//           if (context.mounted) {
//             ScaffoldMessenger.of(context).showSnackBar(
//                 SnackUtil.stylishSnackBar(
//                     title: "Comunicazioni",
//                     message: errorDescription,
//                     contentType: "failure"));
//           }
//         } else {
//           if (parseData['okResult'] != null) {
//             TemplateDetailComunicationModel templateDetailComunicationModel =
//                 TemplateDetailComunicationModel.fromJson(parseData['okResult']);
//             return templateDetailComunicationModel;
//           } else {
//             return null;
//           }
//         }
//       } else {
//         AuthenticationNotifier authenticationNotifier =
//             Provider.of<AuthenticationNotifier>(context, listen: false);
//         authenticationNotifier.exit(context);
//       }
//     } on SocketException catch (_) {
//       if (context.mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(SnackUtil.stylishSnackBar(
//             title: "Anagrafiche",
//             message: "Errore di connessione",
//             contentType: "failure"));
//       }
//     }
//   }

//   Future downloadEmailTemplateDetail({
//     required BuildContext context,
//     required String? token,
//     required int idUserAppInstitution,
//     required int idInstitution,
//     required String idtemplate,
//   }) async {
//     try {
//       bool isOk = false;

//       var response = await comunicationAPI.downloadEmailTemplateDetail(
//           token: token,
//           idUserAppInstitution: idUserAppInstitution,
//           idInstitution: idInstitution,
//           idTemplate: idtemplate);

//       if (response != null) {
//         final Map<String, dynamic> parseData = await jsonDecode(response);
//         isOk = parseData['isOk'];
//         if (!isOk) {
//           String errorDescription = parseData['errorDescription'];
//           if (context.mounted) {
//             ScaffoldMessenger.of(context).showSnackBar(
//                 SnackUtil.stylishSnackBar(
//                     title: "Comunicazioni",
//                     message: errorDescription,
//                     contentType: "failure"));
//           }
//         } else {
//           if (parseData['okResult'] != null) {
//             await DownloadFile.downloadFile(parseData['okResult'], context);
//             return null;
//           } else {
//             return null;
//           }
//         }
//       } else {
//         AuthenticationNotifier authenticationNotifier =
//             Provider.of<AuthenticationNotifier>(context, listen: false);
//         authenticationNotifier.exit(context);
//       }
//     } on SocketException catch (_) {
//       if (context.mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(SnackUtil.stylishSnackBar(
//             title: "Anagrafiche",
//             message: "Errore di connessione",
//             contentType: "failure"));
//       }
//     }
//   }

//   Future addComunication({
//     required BuildContext context,
//     String? token,
//     required ComunicationModel comunicationModel,
//   }) async {
//     try {
//       bool isOk = false;

//       var response = await comunicationAPI.addComunication(
//           context: context, token: token, comunicationModel: comunicationModel);

//       if (response != null) {
//         final Map<String, dynamic> parseData = await jsonDecode(response);
//         isOk = parseData['isOk'];
//         if (!isOk) {
//           String errorDescription = parseData['errorDescription'];
//           if (context.mounted) {
//             ScaffoldMessenger.of(context).showSnackBar(
//                 SnackUtil.stylishSnackBar(
//                     title: "Comunicazioni",
//                     message: errorDescription,
//                     contentType: "failure"));
//             // Navigator.pop(context);
//           }
//         } else {}
//       }
//       return isOk;
//     } on SocketException catch (_) {
//       if (context.mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(SnackUtil.stylishSnackBar(
//             title: "Comunicazioni",
//             message: "Errore di connessione",
//             contentType: "failure"));
//       }
//     }
//   }
// }

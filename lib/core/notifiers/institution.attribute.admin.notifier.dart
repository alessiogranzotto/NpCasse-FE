// import 'dart:convert';
// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:np_casse/core/api/institution.attribute.api.dart';
// import 'package:np_casse/core/models/institution.model.dart';
// import 'package:np_casse/core/notifiers/authentication.notifier.dart';
// import 'package:np_casse/core/utils/snackbar.util.dart';
// import 'package:provider/provider.dart';

// class InstitutionAttributeAdminNotifier with ChangeNotifier {
//   final InstitutionAttributeAPI institutionAttributeAPI =
//       InstitutionAttributeAPI();

//   bool _isUpdated = false;
//   bool get isUpdated => _isUpdated;

//   void setUpdate(bool value) {
//     _isUpdated = value;
//     notifyListeners();
//   }

//   void refresh() {
//     notifyListeners();
//   }

//   Future getInstitutionAttribute(
//       {required BuildContext context,
//       required String? token,
//       required int idUserAppInstitution,
//       required int idInstitution}) async {
//     try {
//       var response = await institutionAttributeAPI.getInstitutionAttribute(
//           token: token,
//           idUserAppInstitution: idUserAppInstitution,
//           idInstitution: idInstitution);
//       if (response != null) {
//         final Map<String, dynamic> parseData = await jsonDecode(response);
//         bool isOk = parseData['isOk'];
//         if (!isOk) {
//           String errorDescription = parseData['errorDescription'];
//           if (context.mounted) {
//             ScaffoldMessenger.of(context).showSnackBar(
//                 SnackUtil.stylishSnackBar(
//                     title: "Impostazioni ente",
//                     message: errorDescription,
//                     contentType: "failure"));
//             return null;
//           }
//         } else {
//           List<InstitutionAttributeModel> attribute =
//               List.from(parseData['okResult'])
//                   .map((e) => InstitutionAttributeModel.fromJson(e))
//                   .toList();
//           return attribute;
//           // notifyListeners();
//         }
//       } else {
//         AuthenticationNotifier authenticationNotifier =
//             Provider.of<AuthenticationNotifier>(context, listen: false);
//         authenticationNotifier.exit(context);
//       }
//     } on SocketException catch (_) {
//       if (context.mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(SnackUtil.stylishSnackBar(
//             title: "Impostazioni ente",
//             message: "Errore di connessione",
//             contentType: "failure"));
//       }
//     }
//   }

//   Future updateGiveAttribute(
//       {required BuildContext context,
//       required String? token,
//       required int idUserAppInstitution,
//       required int idInstitution,
//       required String giveNomeLogin,
//       required String giveBaseAddress,
//       required String giveUserName,
//       required String givePassword}) async {
//     try {
//       var response = await institutionAttributeAPI.updateGiveAttribute(
//           token: token,
//           idUserAppInstitution: idUserAppInstitution,
//           idInstitution: idInstitution,
//           giveNomeLogin: giveNomeLogin,
//           giveBaseAddress: giveBaseAddress,
//           giveUserName: giveUserName,
//           givePassword: givePassword);

//       final Map<String, dynamic> parseData = await jsonDecode(response);
//       bool isOk = parseData['isOk'];
//       if (!isOk) {
//         String errorDescription = parseData['errorDescription'];
//         if (context.mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(SnackUtil.stylishSnackBar(
//               title: "Impostazioni ente",
//               message: errorDescription,
//               contentType: "failure"));
//           // _isLoading = false;
//           // notifyListeners();
//         }
//       } else {
//         // notifyListeners();
//       }
//       return isOk;
//     } on SocketException catch (_) {
//       if (context.mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(SnackUtil.stylishSnackBar(
//             title: "Impostazioni ente",
//             message: "Errore di connessione",
//             contentType: "failure"));

//         // _isLoading = false;
//         // notifyListeners();
//       }
//     } catch (e) {
//       if (context.mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(SnackUtil.stylishSnackBar(
//             title: "Impostazioni ente",
//             message: "Errore di connessione",
//             contentType: "failure"));
//         // _isLoading = false;
//         // notifyListeners();
//       }
//     }
//   }

//   Future updateEmailSendAttribute(
//       {required BuildContext context,
//       required String? token,
//       required int idUserAppInstitution,
//       required int idInstitution,
//       required String emailSendAccompaniment,
//       required String emailSendFrom}) async {
//     try {
//       var response = await institutionAttributeAPI.updateEmailSendAttribute(
//           token: token,
//           idUserAppInstitution: idUserAppInstitution,
//           idInstitution: idInstitution,
//           emailSendAccompaniment: emailSendAccompaniment,
//           emailSendFrom: emailSendFrom);

//       final Map<String, dynamic> parseData = await jsonDecode(response);
//       bool isOk = parseData['isOk'];
//       if (!isOk) {
//         String errorDescription = parseData['errorDescription'];
//         if (context.mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(SnackUtil.stylishSnackBar(
//               title: "Impostazioni ente",
//               message: errorDescription,
//               contentType: "failure"));
//           // _isLoading = false;
//           // notifyListeners();
//         }
//       } else {
//         // notifyListeners();
//       }
//       return isOk;
//     } on SocketException catch (_) {
//       if (context.mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(SnackUtil.stylishSnackBar(
//             title: "Impostazioni ente",
//             message: "Errore di connessione",
//             contentType: "failure"));

//         // _isLoading = false;
//         // notifyListeners();
//       }
//     } catch (e) {
//       if (context.mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(SnackUtil.stylishSnackBar(
//             title: "Impostazioni ente",
//             message: "Errore di connessione",
//             contentType: "failure"));
//         // _isLoading = false;
//         // notifyListeners();
//       }
//     }
//   }
// }

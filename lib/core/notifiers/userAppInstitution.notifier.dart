// import 'dart:convert';
// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:np_casse/core/api/institution.api.dart';
// import 'package:np_casse/core/models/user_institution.model.dart';
// import 'package:np_casse/core/utils/snackbar.util.dart';

// class UserAppInstitutionNotifier with ChangeNotifier {
//   final UserInstitutionAPI _institutionAPI = UserInstitutionAPI();
//   UserInstitutionModel? userInstitutionModel;

//   int get getIdInstitution => userInstitutionModel?.idInstitution ?? 0;
//   int get getIdUser => userInstitutionModel?.idUser ?? 0;
//   int get getidUserAppInstitution =>
//       userInstitutionModel?.idUserAppInstitution ?? 0;

//   String get getNameInstitution =>
//       userInstitutionModel?.institution.nameInstitution ?? '';

//   setUserInstitution(UserInstitutionModel? val) {
//     userInstitutionModel = val;
//     // notifyListeners();
//   }

//   // Future getInstitution(
//   //     {required BuildContext context,
//   //     required token,
//   //     required int idUser}) async {
//   //   try {
//   //     var response = await _institutionAPI.getUserInstitution(
//   //         token: token, idUser: idUser);
//   //     if (response != null) {
//   //       final Map<String, dynamic> parseData = await jsonDecode(response);
//   //       bool isOk = parseData['isOk'];
//   //       if (!isOk) {
//   //         String errorDescription = parseData['errorDescription'];
//   //         if (context.mounted) {
//   //           ScaffoldMessenger.of(context).showSnackBar(
//   //               SnackUtil.stylishSnackBar(
//   //                   text: errorDescription, context: context));
//   //           // Navigator.pop(context);
//   //         }
//   //       } else {
//   //         List<UserInstitutionModel> userInstitutions =
//   //             List.from(parseData['okResult'])
//   //                 .map((e) => UserInstitutionModel.fromJson(e))
//   //                 .toList();

//   //         return userInstitutions;
//   //         // notifyListeners();
//   //       }
//   //     }
//   //   } on SocketException catch (_) {
//   //     ScaffoldMessenger.of(context).showSnackBar(
//   //       SnackUtil.stylishSnackBar(
//   //           text: 'Oops No You Need A Good Internet Connection',
//   //           context: context),
//   //     );
//   //   }
//   // }
// }

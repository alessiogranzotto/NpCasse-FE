// // ignore_for_file: non_constant_identifier_names

// import 'dart:convert';

// import 'package:flutter/src/widgets/framework.dart';
// import 'package:http/http.dart' as http;
// import 'package:np_casse/app/routes/api_routes.dart';
// import 'package:np_casse/core/models/comunication.model.dart';

// class ComunicationAPI {
//   final client = http.Client();

//   Future getEmailTemplates(
//       {required String? token,
//       required int idUserAppInstitution,
//       required int idInstitution}) async {
//     final Uri uri = Uri.parse(
//         '${ApiRoutes.comunicationURL}/Get-email-templates?idUserAppInstitution=$idUserAppInstitution&IdInstitution=$idInstitution');
//     final http.Response response = await client.get(
//       uri,
//       headers: {
//         'Content-Type': 'application/json',
//         'Accept': 'application/json',
//         'Access-Control-Allow-Origin': "*",
//         "Authorization": token ?? ''
//       },
//     );
//     if (response.statusCode == 200) {
//       final dynamic body = response.body;
//       return body;
//     } else {
//       // If the server did not return a 200 OK response,
//       // then throw an exception.
//       return null;
//     }
//   }

//   Future getEmailTemplateDetail(
//       {required String? token,
//       required int idUserAppInstitution,
//       required int idInstitution,
//       required String idTemplate}) async {
//     final Uri uri = Uri.parse(
//         '${ApiRoutes.comunicationURL}/Get-email-template-detail?idUserAppInstitution=$idUserAppInstitution&IdInstitution=$idInstitution&Idtemplate=$idTemplate');
//     final http.Response response = await client.get(
//       uri,
//       headers: {
//         'Content-Type': 'application/json',
//         'Accept': 'application/json',
//         'Access-Control-Allow-Origin': "*",
//         "Authorization": token ?? ''
//       },
//     );
//     if (response.statusCode == 200) {
//       final dynamic body = response.body;
//       return body;
//     } else {
//       // If the server did not return a 200 OK response,
//       // then throw an exception.
//       return null;
//     }
//   }

//   Future downloadEmailTemplateDetail(
//       {required String? token,
//       required int idUserAppInstitution,
//       required int idInstitution,
//       required String idTemplate}) async {
//     final Uri uri = Uri.parse(
//         '${ApiRoutes.comunicationURL}/Download-email-template-detail?idUserAppInstitution=$idUserAppInstitution&IdInstitution=$idInstitution&Idtemplate=$idTemplate');
//     final http.Response response = await client.get(
//       uri,
//       headers: {
//         'Content-Type': 'application/json',
//         'Accept': 'application/json',
//         'Access-Control-Allow-Origin': "*",
//         "Authorization": token ?? ''
//       },
//     );
//     if (response.statusCode == 200) {
//       final dynamic body = response.body;
//       return body;
//     } else {
//       // If the server did not return a 200 OK response,
//       // then throw an exception.
//       return null;
//     }
//   }

//   addComunication({
//     required BuildContext context,
//     String? token,
//     required ComunicationModel comunicationModel,
//   }) async {
//     final Uri uri =
//         Uri.parse('${ApiRoutes.comunicationURL}/Prepare-comunication');

//     final http.Response response = await client.post(uri,
//         headers: {
//           'Content-Type': 'application/json',
//           'Accept': 'application/json',
//           'Access-Control-Allow-Origin': "*",
//           "Authorization": token ?? ''
//         },
//         body: jsonEncode(comunicationModel));

//     if (response.statusCode == 200) {
//       final dynamic body = response.body;
//       return body;
//     } else {
//       // If the server did not return a 200 OK response,
//       // then throw an exception.
//       return null;
//     }
//   }
// }

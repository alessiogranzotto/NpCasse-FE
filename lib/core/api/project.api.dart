// import 'dart:convert';

// import 'package:flutter/foundation.dart';
// import 'package:http/http.dart' as http;
// import 'package:np_casse/app/routes/api_routes.dart';
// import 'package:np_casse/core/models/project.model.dart';

// class ProjectAPI {
//   final client = http.Client();

//   Future getProject(
//       {required String? token, required int idUserAppInstitution}) async {
//     final Uri uri = Uri.parse(
//         '${ApiRoutes.baseUserAppInstitutionURL}/$idUserAppInstitution/Project');

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

//   Future addOrUpdateProject(
//       {required String? token,
//       required int idUserAppInstitution,
//       required ProjectModel projectModel}) async {
//     int idProject = projectModel.idProject;
//     String x = jsonEncode(projectModel);
//     String y = jsonEncode(projectModel.giveIdsFlatStructureModel);
//     if (kDebugMode) {
//       print(x);
//       print(y);
//     }
//     final http.Response response;
//     if (idProject == 0) {
//       final Uri uri = Uri.parse(
//           '${ApiRoutes.baseUserAppInstitutionURL}/$idUserAppInstitution/Project');
//       response = await client.post(uri,
//           headers: {
//             'Content-Type': 'application/json',
//             'Accept': 'application/json',
//             'Access-Control-Allow-Origin': "*",
//             "Authorization": token ?? ''
//           },
//           body: jsonEncode(projectModel));
//     } else {
//       final Uri uri = Uri.parse(
//           '${ApiRoutes.baseUserAppInstitutionURL}/$idUserAppInstitution/Project/$idProject');
//       response = await client.put(uri,
//           headers: {
//             'Content-Type': 'application/json',
//             'Accept': 'application/json',
//             'Access-Control-Allow-Origin': "*",
//             "Authorization": token ?? ''
//           },
//           body: jsonEncode(projectModel));
//     }
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

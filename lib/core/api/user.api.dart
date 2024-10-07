import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:np_casse/app/routes/api_routes.dart';

class UserAPI {
  final client = http.Client();

//   Future getUserData({required String token}) async {
//     final Uri uri = Uri.parse(ApiRoutes.userDataURL);
//     final http.Response response = await client.get(
//       uri,
//       headers: {
//         'Content-Type': 'application/json',
//         'Accept': 'application/json',
//         'Access-Control-Allow-Origin': "*",
//         "Authorization": token
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

// Future getUserDetails({required String userEmail}) async {
//   var subUrl = '/info/$userEmail';
//   final Uri uri = Uri.parse(ApiRoutes.userDetailsURL + subUrl);
//   final http.Response response = await client.get(
//     uri,
//     headers: {
//       'Content-Type': 'application/json',
//       'Accept': 'application/json',
//       'Access-Control-Allow-Origin': "*",
//     },
//   );
//   final dynamic body = response.body;
//   return body;
// }

  Future updateUserDetails(
      {required String? token,
      required int idUser,
      required int idUserAppInstitution,
      required String userName,
      required String userSurname,
      required String userEmail,
      required String userPhoneNo}) async {
    final Uri uri = Uri.parse('${ApiRoutes.updateUserDetailsURL}/$idUser');

    final http.Response response = await client.put(uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Access-Control-Allow-Origin': "*",
          "Authorization": token ?? ''
        },
        body: jsonEncode({
          "idUserAppInstitution": idUserAppInstitution,
          "name": userName,
          "surname": userSurname,
          "email": userEmail,
          "phone": userPhoneNo,
        }));

    if (response.statusCode == 200) {
      final dynamic body = response.body;
      return body;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      return null;
    }
  }

  Future changePassword(
      {required String? token,
      required int idUser,
      required String password,
      required String confirmPassword}) async {
    final Uri uri = Uri.parse('${ApiRoutes.changePasswordURL}/$idUser');

    final http.Response response = await client.put(uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Access-Control-Allow-Origin': "*",
          "Authorization": token ?? ''
        },
        body: jsonEncode(
            {"password": password, "confirmPassword": confirmPassword}));
    if (response.statusCode == 200) {
      final dynamic body = response.body;
      return body;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      return null;
    }
  }

  final headers = {
    'Content-Type': 'application/json',
    // 'Accept': 'application/json',
    // 'Access-Control-Allow-Origin': "*",
  };
}

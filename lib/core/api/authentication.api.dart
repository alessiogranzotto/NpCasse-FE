import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:np_casse/app/routes/api_routes.dart';

class AuthenticationAPI {
  final client = http.Client();

  final headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Access-Control-Allow-Origin': "*",
  };
  Future userAuthenticate(
      {required String email,
      required String password,
      String? appName,
      int? idUserAppInstitution}) async {
    // try {
    //   final response = await http.post(
    //     Uri.parse(ApiRoutes.loginURL),
    //     body: json.encode({'email': email, 'password': password}),
    //     headers: {'Content-Type': 'application/json'},
    //   );
    //   if (response.statusCode == 200) {
    //     final responseData = json.decode(response.body);
    //   } else if (response.statusCode == 400) {}
    // } catch (e) {
    //   throw e;
    // }

    final Uri uri = Uri.parse(ApiRoutes.loginURL);
    final http.Response response = await client.post(uri,
        headers: headers,
        body: jsonEncode({
          "email": email,
          "password": password,
          "appName": appName,
          "idUserAppInstitution": idUserAppInstitution,
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

  // Future getUserInstitution(
  //     {required String? token, required int? idUser}) async {
  //   final Uri uri =
  //       Uri.parse('${ApiRoutes.userInstitutionByIdUserURL}/$idUser');
  //   final http.Response response = await client.get(
  //     uri,
  //     headers: {
  //       'Content-Type': 'application/json',
  //       'Accept': 'application/json',
  //       'Access-Control-Allow-Origin': "*",
  //       "Authorization": token ?? ''
  //     },
  //   );
  //   if (response.statusCode == 200) {
  //     final dynamic body = response.body;
  //     return body;
  //   } else {
  //     // If the server did not return a 200 OK response,
  //     // then throw an exception.
  //     return null;
  //   }
  // }

  Future getUserAppInstitution(
      {required String? token,
      required int idUser,
      required String appName}) async {
    final Uri uri = Uri.parse(
        '${ApiRoutes.authUserAppInstitutionURL}?IdUser=$idUser&AppName=$appName');
    final http.Response response = await client.get(uri, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Access-Control-Allow-Origin': "*",
      "Authorization": token ?? ''
    });
    if (response.statusCode == 200) {
      final dynamic body = response.body;
      return body;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      return null;
    }
  }

  Future getUserAppInstitutionGrant(
      {required String? token,
      required int idUser,
      required int idUserAppInstitution}) async {
    final Uri uri = Uri.parse(
        '${ApiRoutes.authUserAppInstitutionGrantURL}?IdUser=$idUser&IdUserAppInstitution=$idUserAppInstitution');
    final http.Response response = await client.get(uri, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Access-Control-Allow-Origin': "*",
      "Authorization": token ?? ''
    });
    if (response.statusCode == 200) {
      final dynamic body = response.body;
      return body;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      return null;
    }
  }

  Future userRegister({required String email, required String password}) async {
    final Uri uri = Uri.parse(ApiRoutes.registerURL);
    final http.Response response = await client.post(uri,
        headers: headers,
        body: jsonEncode({
          "email": email,
          "password": password,
        }));
    final dynamic body = response.body;
    return body;
  }
}

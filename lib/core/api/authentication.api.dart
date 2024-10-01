import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:np_casse/app/routes/api_routes.dart';

class AuthenticationAPI {
  final client = http.Client();

  Future authenticateAccount(
      {required String email, required String password}) async {
    final Uri uri = Uri.parse(ApiRoutes.authenticateURL);
    final http.Response response = await client.post(uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Access-Control-Allow-Origin': "*",
        },
        body: jsonEncode({
          "email": email,
          "password": password,
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

  Future checkOtp(
      {required String? token,
      required String email,
      required String otpCode}) async {
    final Uri uri = Uri.parse(ApiRoutes.checkOtpURL);
    final http.Response response = await client.post(uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Access-Control-Allow-Origin': "*",
          "Authorization": token ?? ''
        },
        body: jsonEncode({
          "email": email,
          "otpCode": otpCode,
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

  // Future userRegister({required String email, required String password}) async {
  //   final Uri uri = Uri.parse(ApiRoutes.registerURL);
  //   final http.Response response = await client.post(uri,
  //       headers: headers,
  //       body: jsonEncode({
  //         "email": email,
  //         "password": password,
  //       }));
  //   final dynamic body = response.body;
  //   return body;
  // }
}

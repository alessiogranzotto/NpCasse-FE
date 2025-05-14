import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:np_casse/app/routes/api_routes.dart';
import 'package:np_casse/core/models/user.model.dart';

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

  Future getGiveToken(
      {required String? token,
      required int idUserAppInstitution,
      required int idInstitution}) async {
    final Uri uri = Uri.parse(
        '${ApiRoutes.giveTemporaryTokenURL}?IdUserAppInstitution=$idUserAppInstitution&IdInstitution=$idInstitution');
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

  Future updateUserDetails(
      {required String? token,
      required int idUser,
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

  Future updateUserSecurityAttribute({
    required String? token,
    required int idUser,
    required String otpMode,
    required int tokenExpiration,
    required int maxInactivity,
  }) async {
    List<UserAttributeModel> cUserAttributeModel = [];
    cUserAttributeModel.add(new UserAttributeModel(
        attributeName: 'User.OtpMode', attributeValue: otpMode));
    cUserAttributeModel.add(new UserAttributeModel(
        attributeName: 'User.TokenExpiration',
        attributeValue: tokenExpiration.toString()));
    cUserAttributeModel.add(new UserAttributeModel(
        attributeName: 'User.MaxInactivity',
        attributeValue: maxInactivity.toString()));

    final Uri uri = Uri.parse('${ApiRoutes.updateUserAttributeURL}/$idUser');
    final http.Response response = await client.put(uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Access-Control-Allow-Origin': "*",
          "Authorization": token ?? ''
        },
        body: jsonEncode({
          "updateUserAttributeRequest": cUserAttributeModel,
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

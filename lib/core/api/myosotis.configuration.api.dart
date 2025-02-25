// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:np_casse/app/routes/api_routes.dart';
import 'package:np_casse/core/models/myosotis.configuration.model.dart';

class MyosotisConfigurationAPI {
  final client = http.Client();

  Future getMyosotisConfigurationDetailEmpty(
      {required String? token,
      required int idUserAppInstitution,
      required int idInstitution}) async {
    final Uri uri = Uri.parse(
        '${ApiRoutes.MyosotisConfigurationURL}/Get-myosotis-configuration-detail-empty?idUserAppInstitution=$idUserAppInstitution&IdInstitution=$idInstitution');
    final http.Response response = await client.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Access-Control-Allow-Origin': "*",
        "Authorization": token ?? ''
      },
    );
    if (response.statusCode == 200) {
      final dynamic body = response.body;
      return body;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      return null;
    }
  }

  Future findMyosotisConfigurations(
      {required String? token,
      required int idUserAppInstitution,
      required int idInstitution,
      required bool readAlsoArchived,
      required String numberResult,
      required String nameDescSearch,
      required String orderBy}) async {
    final Uri uri = Uri.parse(
        '${ApiRoutes.MyosotisConfigurationURL}/Find-myosotis-configurations?idUserAppInstitution=$idUserAppInstitution&IdInstitution=$idInstitution&ReadAlsoArchived=$readAlsoArchived&NumberResult=$numberResult&NameDescSearch=$nameDescSearch&OrderBy=$orderBy');
    final http.Response response = await client.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Access-Control-Allow-Origin': "*",
        "Authorization": token ?? ''
      },
    );
    if (response.statusCode == 200) {
      final dynamic body = response.body;
      return body;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      return null;
    }
  }

  addOrUpdateMyosotisConfiguration(
      {String? token,
      required MyosotisConfigurationModel myosotisConfigurationModel}) async {
    int idMyosotisConfiguration =
        myosotisConfigurationModel.idMyosotisConfiguration;
    var t = jsonEncode(myosotisConfigurationModel);
    print(t);
    final http.Response response;
    if (idMyosotisConfiguration == 0) {
      final Uri uri = Uri.parse('${ApiRoutes.baseMyosotisConfigurationURL}');
      response = await client.post(uri,
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Access-Control-Allow-Origin': "*",
            "Authorization": token ?? ''
          },
          body: jsonEncode(myosotisConfigurationModel));
    } else {
      final Uri uri = Uri.parse(
          '${ApiRoutes.baseMyosotisConfigurationURL}/$idMyosotisConfiguration');
      response = await client.put(uri,
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Access-Control-Allow-Origin': "*",
            "Authorization": token ?? ''
          },
          body: jsonEncode(myosotisConfigurationModel));
    }
    if (response.statusCode == 200) {
      final dynamic body = response.body;
      return body;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      return null;
    }
  }
}

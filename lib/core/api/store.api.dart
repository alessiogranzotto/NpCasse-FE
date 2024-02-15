import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:np_casse/app/routes/api_routes.dart';
import 'package:np_casse/core/models/store.model.dart';

class StoreAPI {
  final client = http.Client();

  Future getStore(
      {required String? token,
      required int idUserAppInstitution,
      required idProject}) async {
    final Uri uri = Uri.parse(
        '${ApiRoutes.baseUserAppInstitutionURL}/$idUserAppInstitution/Project/$idProject/Store');

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

  Future addOrUpdateStore(
      {required String? token,
      required int idUserAppInstitution,
      required int idProject,
      required StoreModel storeModel}) async {
    int idStore = storeModel.idStore;

    final http.Response response;
    if (idStore == 0) {
      final Uri uri = Uri.parse(
          '${ApiRoutes.baseUserAppInstitutionURL}/$idUserAppInstitution/Project/$idProject/Store');

      response = await client.post(uri,
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Access-Control-Allow-Origin': "*",
            "Authorization": token ?? ''
          },
          body: jsonEncode(storeModel));
    } else {
      final Uri uri = Uri.parse(
          '${ApiRoutes.baseUserAppInstitutionURL}/$idUserAppInstitution/Project/$idProject/Store/$idStore');

      response = await client.put(uri,
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Access-Control-Allow-Origin': "*",
            "Authorization": token ?? ''
          },
          body: jsonEncode(storeModel));
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

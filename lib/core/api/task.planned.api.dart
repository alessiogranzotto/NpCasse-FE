import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:np_casse/app/routes/api_routes.dart';
import 'package:np_casse/core/models/task.planned.model.dart';

class TaskPlannedAPI {
  final client = http.Client();

  Future getTaskPlanned(
      {required String? token,
      required int idUserAppInstitution,
      required int idInstitution,
      required bool readAlsoDeleted}) async {
    final Uri uri = Uri.parse(
        '${ApiRoutes.baseTaskURL}/Task-planned?idUserAppInstitution=$idUserAppInstitution&IdInstitution=$idInstitution&ReadAlsoDeleted=$readAlsoDeleted');

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

  Future addOrUpdateTaskPlanned(
      {required String? token,
      required TaskPlannedModel taskPlannedModel}) async {
    int idTaskPlanned = taskPlannedModel.idTaskPlanned;

    final http.Response response;
    if (idTaskPlanned == 0) {
      final Uri uri = Uri.parse('${ApiRoutes.baseTaskURL}/Task-planned/');
      response = await client.post(uri,
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Access-Control-Allow-Origin': "*",
            "Authorization": token ?? ''
          },
          body: jsonEncode(taskPlannedModel));
    } else {
      final Uri uri =
          Uri.parse('${ApiRoutes.baseTaskURL}/Task-planned/$idTaskPlanned');
      response = await client.put(uri,
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Access-Control-Allow-Origin': "*",
            "Authorization": token ?? ''
          },
          body: jsonEncode(taskPlannedModel));
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

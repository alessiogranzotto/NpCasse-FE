import 'package:http/http.dart' as http;
import 'package:np_casse/app/routes/api_routes.dart';

class TaskCommonAPI {
  final client = http.Client();

  Future getTaskCommon(
      {required String? token,
      required int idUserAppInstitution,
      required int idInstitution}) async {
    final Uri uri = Uri.parse(
        '${ApiRoutes.baseTaskURL}/Task-common?idUserAppInstitution=$idUserAppInstitution&IdInstitution=$idInstitution');

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
}

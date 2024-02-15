import 'package:http/http.dart' as http;

class UserInstitutionAPI {
  final client = http.Client();
  final headers = {
    'Content-Type': 'application/json',
    // 'Accept': 'application/json',
    // 'Access-Control-Allow-Origin': "*",
  };

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
}

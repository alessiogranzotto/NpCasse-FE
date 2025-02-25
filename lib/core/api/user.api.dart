import 'package:http/http.dart' as http;

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
}

import 'package:http/http.dart' as http;
import 'package:np_casse/app/routes/api_routes.dart';

class DownloadAppAPI {
  final client = http.Client();

  Future downloadAndroidApp() async {
    final Uri uri = Uri.parse('${ApiRoutes.downloadAppURL}/Apk');
    final http.Response response = await client.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Access-Control-Allow-Origin': "*",
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

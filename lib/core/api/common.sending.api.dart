import 'package:http/http.dart' as http;
import 'package:np_casse/app/routes/api_routes.dart';

class CommonSendingAPI {
  final client = http.Client();

  Future getEmailTemplatesFromSmtp2Go(
      {required String? token,
      required int idUserAppInstitution,
      required int idInstitution}) async {
    final Uri uri = Uri.parse(
        '${ApiRoutes.baseComunicationSendingURL}/Common-sending/Get-email-templates-from-smtp2go?idUserAppInstitution=$idUserAppInstitution&IdInstitution=$idInstitution');
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

  Future downloadEmailTemplateDetailFromSmtp2Go(
      {required String? token,
      required int idUserAppInstitution,
      required int idInstitution,
      required String idTemplate}) async {
    final Uri uri = Uri.parse(
        '${ApiRoutes.baseComunicationSendingURL}/Common-sending/Download-email-template-detail-from-smtp2go?idUserAppInstitution=$idUserAppInstitution&IdInstitution=$idInstitution&Idtemplate=$idTemplate');
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

  Future getAccumulatorFromGive(
      {required String? token,
      required int idUserAppInstitution,
      required int idInstitution}) async {
    final Uri uri = Uri.parse(
        '${ApiRoutes.baseComunicationSendingURL}/Common-sending/Search-accumulator-from-give?idUserAppInstitution=$idUserAppInstitution&IdInstitution=$idInstitution');
    final http.Response response = await http.Client().get(
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

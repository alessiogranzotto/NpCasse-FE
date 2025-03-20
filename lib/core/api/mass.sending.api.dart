import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:np_casse/app/routes/api_routes.dart';
import 'package:np_casse/core/models/mass.sending.model.dart';

class MassSendingAPI {
  final client = http.Client();

  Future findMassSendings(
      {required String? token,
      required int idUserAppInstitution,
      required int idInstitution,
      required bool readAlsoArchived,
      required String numberResult,
      required String nameDescSearch,
      required String orderBy}) async {
    final Uri uri = Uri.parse(
        '${ApiRoutes.baseMassSendingURL}/Find-mass-sending?idUserAppInstitution=$idUserAppInstitution&IdInstitution=$idInstitution&ReadAlsoArchived=$readAlsoArchived&NumberResult=$numberResult&NameDescSearch=$nameDescSearch&OrderBy=$orderBy');
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

  Future getEmailTemplatesFromSmtp2Go(
      {required String? token,
      required int idUserAppInstitution,
      required int idInstitution}) async {
    final Uri uri = Uri.parse(
        '${ApiRoutes.baseMassSendingURL}/Get-email-templates-from-smtp2go?idUserAppInstitution=$idUserAppInstitution&IdInstitution=$idInstitution');
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
        '${ApiRoutes.baseMassSendingURL}/Download-email-template-detail-from-smtp2go?idUserAppInstitution=$idUserAppInstitution&IdInstitution=$idInstitution&Idtemplate=$idTemplate');
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

  Future addOrUpdateMassSending(
      {String? token, required MassSendingModel massSendingModel}) async {
    int idMassSending = massSendingModel.idMassSending;
    var t = jsonEncode(massSendingModel);
    print(t);
    final http.Response response;
    if (idMassSending == 0) {
      final Uri uri = Uri.parse('${ApiRoutes.baseMassSendingURL}');
      response = await client.post(uri,
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Access-Control-Allow-Origin': "*",
            "Authorization": token ?? ''
          },
          body: jsonEncode(massSendingModel));
    } else {
      final Uri uri =
          Uri.parse('${ApiRoutes.baseMassSendingURL}/$idMassSending');
      response = await client.put(uri,
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Access-Control-Allow-Origin': "*",
            "Authorization": token ?? ''
          },
          body: jsonEncode(massSendingModel));
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

  Future getAccumulatorFromGive(
      {required String? token,
      required int idUserAppInstitution,
      required int idInstitution}) async {
    final Uri uri = Uri.parse(
        '${ApiRoutes.baseMassSendingURL}/Search-accumulator-from-give?idUserAppInstitution=$idUserAppInstitution&IdInstitution=$idInstitution');
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

  Future updateMassSendingGiveAccumulator(
      {String? token,
      required int idMassSending,
      required int idUserAppInstitution,
      required List<MassSendingGiveAccumulator>
          massSendingGiveAccumulator}) async {
    final Uri uri = Uri.parse('${ApiRoutes.baseMassSendingURL}' +
        '/$idMassSending/Recipient' +
        '?IdUserAppInstitution=$idUserAppInstitution');
    var t = List.from(massSendingGiveAccumulator)
        .map((e) => jsonEncode(massSendingGiveAccumulator))
        .toList();
    print(t);
    var tt = jsonEncode(massSendingGiveAccumulator);

    print(tt);
    final http.Response response = await client.post(uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Access-Control-Allow-Origin': "*",
          "Authorization": token ?? ''
        },
        body: jsonEncode(massSendingGiveAccumulator));

    if (response.statusCode == 200) {
      final dynamic body = response.body;
      return body;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      return null;
    }
  }

  Future findMassSendingList(
      {required String? token,
      required int idUserAppInstitution,
      required int pageNumber,
      required int pageSize,
      required List<String> orderBy,
      required List<String> filter}) async {
    String filterJoined = "";
    for (var item in filter) {
      filterJoined = filterJoined + "&" + item;
    }
    final Uri uri = Uri.parse(
        '${ApiRoutes.baseMassSendingURL}/find-mass-sending-list?idUserAppInstitution=$idUserAppInstitution&pageNumber=$pageNumber&pageSize=$pageSize&orderBy=$orderBy$filterJoined');
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
    } else if (response.statusCode == 401) {
      //REFRESH TOKEN??
      return null;
    }
  }

  // Future getEmailTemplateDetail(
  //     {required String? token,
  //     required int idUserAppInstitution,
  //     required int idInstitution,
  //     required String idTemplate}) async {
  //   final Uri uri = Uri.parse(
  //       '${ApiRoutes.massSendingURL}/Get-email-template-detail?idUserAppInstitution=$idUserAppInstitution&IdInstitution=$idInstitution&Idtemplate=$idTemplate');
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

  // addComunication({
  //   required BuildContext context,
  //   String? token,
  //   required ComunicationModel comunicationModel,
  // }) async {
  //   final Uri uri =
  //       Uri.parse('${ApiRoutes.comunicationURL}/Prepare-comunication');

  //   final http.Response response = await client.post(uri,
  //       headers: {
  //         'Content-Type': 'application/json',
  //         'Accept': 'application/json',
  //         'Access-Control-Allow-Origin': "*",
  //         "Authorization": token ?? ''
  //       },
  //       body: jsonEncode(comunicationModel));

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

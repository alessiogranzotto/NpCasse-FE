import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:np_casse/app/routes/api_routes.dart';
import 'package:np_casse/core/models/comunication.sending.model.dart';

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
        '${ApiRoutes.baseComunicationSendingURL}/Mass-sending/Find-mass-sending?idUserAppInstitution=$idUserAppInstitution&IdInstitution=$idInstitution&ReadAlsoArchived=$readAlsoArchived&NumberResult=$numberResult&NameDescSearch=$nameDescSearch&OrderBy=$orderBy');
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
    final http.Response response;
    var t = jsonEncode(massSendingModel);
    print(t);
    if (idMassSending == 0) {
      final Uri uri =
          Uri.parse('${ApiRoutes.baseComunicationSendingURL}/Mass-sending/');
      response = await client.post(uri,
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Access-Control-Allow-Origin': "*",
            "Authorization": token ?? ''
          },
          body: jsonEncode(massSendingModel));
    } else {
      final Uri uri = Uri.parse(
          '${ApiRoutes.baseComunicationSendingURL}/Mass-sending/$idMassSending');
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

  Future updateMassSendingGiveAccumulator(
      {String? token,
      required int idMassSending,
      required int idUserAppInstitution,
      required List<MassSendingGiveAccumulator>
          massSendingGiveAccumulator}) async {
    final Uri uri = Uri.parse(
        '${ApiRoutes.baseComunicationSendingURL}/Mass-sending' +
            '/$idMassSending/Recipient' +
            '?IdUserAppInstitution=$idUserAppInstitution');

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

  Future updateMassSendingPlanning(
      {String? token,
      required int idMassSending,
      required int idUserAppInstitution,
      required DateTime dateTimePlanMassSending}) async {
    final Uri uri = Uri.parse(
        '${ApiRoutes.baseComunicationSendingURL}/Mass-sending' +
            '/$idMassSending/Plan' +
            '?IdUserAppInstitution=$idUserAppInstitution');

    final http.Response response = await client.post(uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Access-Control-Allow-Origin': "*",
          "Authorization": token ?? ''
        },
        body: jsonEncode(dateTimePlanMassSending.toIso8601String()));

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
        '${ApiRoutes.baseComunicationSendingURL}/Mass-sending/find-mass-sending-list?idUserAppInstitution=$idUserAppInstitution&pageNumber=$pageNumber&pageSize=$pageSize&orderBy=$orderBy$filterJoined');
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

  Future downloadMassSendingList(
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
        '${ApiRoutes.baseComunicationSendingURL}/Mass-sending/download-mass-sending-list?idUserAppInstitution=$idUserAppInstitution&pageNumber=$pageNumber&pageSize=$pageSize&orderBy=$orderBy$filterJoined');
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

  Future getMassSendingJobStatistics(
      {required String? token,
      required int idUserAppInstitution,
      required int idInstitution,
      required int idMassSending}) async {
    final Uri uri = Uri.parse(
        '${ApiRoutes.baseComunicationSendingURL}/Mass-sending/Get-mass-sending-statistics?idUserAppInstitution=$idUserAppInstitution&IdInstitution=$idInstitution&IdMassSending=$idMassSending');
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

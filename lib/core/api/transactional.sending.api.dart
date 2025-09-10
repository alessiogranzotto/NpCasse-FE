import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:np_casse/app/routes/api_routes.dart';
import 'package:np_casse/core/models/comunication.sending.model.dart';

class TransactionalSendingAPI {
  final client = http.Client();

  Future findTransactionalSendings(
      {required String? token,
      required int idUserAppInstitution,
      required int idInstitution,
      required bool readAlsoArchived,
      required String numberResult,
      required String nameDescSearch,
      required String orderBy,
      required String type}) async {
    final Uri uri = Uri.parse(
        '${ApiRoutes.baseComunicationSendingURL}/Transactional-sending/Find-Transactional-sending?idUserAppInstitution=$idUserAppInstitution&IdInstitution=$idInstitution&ReadAlsoArchived=$readAlsoArchived&NumberResult=$numberResult&NameDescSearch=$nameDescSearch&OrderBy=$orderBy&Type=$type');
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

  Future addOrUpdateTransactionalSending(
      {String? token,
      required TransactionalSendingModel transactionalSendingModel}) async {
    int idTransactionalSending =
        transactionalSendingModel.idTransactionalSending;
    final http.Response response;
    if (idTransactionalSending == 0) {
      final Uri uri = Uri.parse(
          '${ApiRoutes.baseComunicationSendingURL}/Transactional-sending/');
      response = await client.post(uri,
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Access-Control-Allow-Origin': "*",
            "Authorization": token ?? ''
          },
          body: jsonEncode(transactionalSendingModel));
    } else {
      final Uri uri = Uri.parse(
          '${ApiRoutes.baseComunicationSendingURL}/Transactional-sending/$idTransactionalSending');
      response = await client.put(uri,
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Access-Control-Allow-Origin': "*",
            "Authorization": token ?? ''
          },
          body: jsonEncode(transactionalSendingModel));
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

  Future getAvailableAction(
      {required String? token, required int idUserAppInstitution}) async {
    final Uri uri = Uri.parse(
        '${ApiRoutes.baseComunicationSendingURL}/Transactional-sending/Get-available-action?idUserAppInstitution=$idUserAppInstitution');
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

  Future findTransactionalSendingList(
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
        '${ApiRoutes.baseComunicationSendingURL}/Transactional-sending/find-transactional-sending-list?idUserAppInstitution=$idUserAppInstitution&pageNumber=$pageNumber&pageSize=$pageSize&orderBy=$orderBy$filterJoined');
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

  Future downloadTransactionalSendingList(
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
        '${ApiRoutes.baseComunicationSendingURL}/Transactional-sending/download-transactional-sending-list?idUserAppInstitution=$idUserAppInstitution&pageNumber=$pageNumber&pageSize=$pageSize&orderBy=$orderBy$filterJoined');
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

  Future getTransactionalEmailStatistics(
      {required String? token,
      required int idUserAppInstitution,
      required int idInstitution,
      required int idTransactionalSending}) async {
    final Uri uri = Uri.parse(
        '${ApiRoutes.baseComunicationSendingURL}/Transactional-sending/Get-transactional-sending-statistics?idUserAppInstitution=$idUserAppInstitution&IdInstitution=$idInstitution&IdTransactionalSending=$idTransactionalSending');
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

// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:np_casse/app/routes/api_routes.dart';

class GiveAPI {
  final client = http.Client();
  final headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Access-Control-Allow-Origin': "*",
  };

  Future findStakeholder({
    required String? token,
    required int idUserAppInstitution,
    required String nameSurnameOrBusinessName,
    required String email,
    required String city,
    required String cf,
  }) async {
    final Uri uri = Uri.parse(
        '${ApiRoutes.giveURL}/Find-stakeholder?idUserAppInstitution=$idUserAppInstitution&NameSurnameOrBusinessName=$nameSurnameOrBusinessName&Email=$email&City=$city&Cf=$cf');
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

  Future addStakeholder(
      {String? token,
      required int idUserAppInstitution,
      required String nome,
      required String cognome,
      required String ragSoc,
      required String codfisc,
      required int? sesso,
      required String email,
      required String tel,
      required String cell,
      required String nazione_nn_norm,
      required String prov_nn_norm,
      required String cap_nn_norm,
      required String citta_nn_norm,
      required String indirizzo_nn_norm,
      required String n_civico_nn_norm,
      required int consenso_ringrazia,
      required int consenso_com_espresso,
      required int consenso_marketing,
      required int consenso_sms,
      required int com_cartacee,
      required int com_email,
      required int consenso_materiale_info,
      required String datanascita,
      required String tipo_donatore}) async {
    final Uri uri = Uri.parse(
        '${ApiRoutes.giveURL}/Add-Stakeholder?IdUserAppInstitution=$idUserAppInstitution');

    final http.Response response = await client.post(uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Access-Control-Allow-Origin': "*",
          "Authorization": token ?? ''
        },
        body: jsonEncode({
          "nome": nome,
          "cognome": cognome,
          "ragionesociale": ragSoc,
          "codfisc": codfisc,
          "sesso": sesso,
          "email": email,
          "tel": tel,
          "cell": tel,
          "nazione_nn_norm": nazione_nn_norm,
          "prov_nn_norm": prov_nn_norm,
          "cap_nn_norm": cap_nn_norm,
          "citta_nn_norm": citta_nn_norm,
          "indirizzo_nn_norm": indirizzo_nn_norm,
          "n_civico_nn_norm": n_civico_nn_norm,
          "consenso_ringrazia": consenso_ringrazia,
          "consenso_com_espresso": consenso_com_espresso,
          "consenso_marketing": consenso_marketing,
          "consenso_sms": consenso_sms,
          "com_cartacee": com_cartacee,
          "com_email": com_email,
          "consenso_materiale_info": consenso_materiale_info,
          "datanascita": datanascita,
          "tipo_donatore": tipo_donatore
        }));
    if (response.statusCode == 200) {
      final dynamic body = response.body;
      return body;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      return null;
    }
  }

  Future updateStakeholder(
      {String? token,
      required int idUserAppInstitution,
      required int id,
      required String nome,
      required String cognome,
      required String ragSoc,
      required String codfisc,
      required int? sesso,
      required String email,
      required String tel,
      required String cell,
      required String nazione_nn_norm,
      required String prov_nn_norm,
      required String cap_nn_norm,
      required String citta_nn_norm,
      required String indirizzo_nn_norm,
      required String n_civico_nn_norm,
      required int consenso_ringrazia,
      required int consenso_com_espresso,
      required int consenso_marketing,
      required int consenso_sms,
      required int com_cartacee,
      required int com_email,
      required int consenso_materiale_info,
      required String datanascita,
      required String tipo_donatore}) async {
    final Uri uri = Uri.parse(
        '${ApiRoutes.giveURL}/Update-stakeholder?IdUserAppInstitution=$idUserAppInstitution');
    final http.Response response = await client.put(uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Access-Control-Allow-Origin': "*",
          "Authorization": token ?? ''
        },
        body: jsonEncode({
          "idStakeholder": id,
          "nome": nome,
          "cognome": cognome,
          "ragionesociale": ragSoc,
          "codfisc": codfisc,
          "sesso": sesso,
          "email": email,
          "tel": tel,
          "cell": cell,
          "nazione_nn_norm": nazione_nn_norm,
          "prov_nn_norm": prov_nn_norm,
          "cap_nn_norm": cap_nn_norm,
          "citta_nn_norm": citta_nn_norm,
          "indirizzo_nn_norm": indirizzo_nn_norm,
          "n_civico_nn_norm": n_civico_nn_norm,
          "consenso_ringrazia": consenso_ringrazia,
          "consenso_com_espresso": consenso_com_espresso,
          "consenso_marketing": consenso_marketing,
          "consenso_sms": consenso_sms,
          "com_cartacee": com_cartacee,
          "com_email": com_email,
          "consenso_materiale_info": consenso_materiale_info,
          "datanascita": datanascita,
          "tipo_donatore": tipo_donatore
        }));

    var t = jsonEncode({
      "nome": nome,
      "cognome": cognome,
      "ragionesociale": ragSoc,
      "codfisc": codfisc,
      "sesso": sesso,
      "email": email,
      "tel": tel,
      "cell": cell,
      "nazione_nn_norm": nazione_nn_norm,
      "prov_nn_norm": prov_nn_norm,
      "cap_nn_norm": cap_nn_norm,
      "citta_nn_norm": citta_nn_norm,
      "indirizzo_nn_norm": indirizzo_nn_norm,
      "n_civico_nn_norm": n_civico_nn_norm,
      "consenso_ringrazia": consenso_ringrazia,
      "consenso_com_espresso": consenso_com_espresso,
      "consenso_marketing": consenso_marketing,
      "consenso_sms": consenso_sms,
      "com_cartacee": com_cartacee,
      "com_email": com_email,
      "consenso_materiale_info": consenso_materiale_info,
      "datanascita": datanascita,
      "tipo_donatore": tipo_donatore
    });
    print(t);
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

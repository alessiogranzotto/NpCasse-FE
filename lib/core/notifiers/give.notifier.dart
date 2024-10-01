// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:np_casse/core/api/give.api.dart';
import 'package:np_casse/core/models/give.model.dart';
import 'package:np_casse/core/notifiers/authentication.notifier.dart';
import 'package:np_casse/core/utils/snackbar.util.dart';
import 'package:provider/provider.dart';

class GiveNotifier with ChangeNotifier {
  final GiveAPI giveAPI = GiveAPI();
  StakeholderGiveModelSearch currentStakeholderGiveModelSearch =
      StakeholderGiveModelSearch.empty();

  setStakeholder(StakeholderGiveModelSearch stakeholderGiveModelSearch) {
    currentStakeholderGiveModelSearch = stakeholderGiveModelSearch;
  }

  getStakeholder() {
    return currentStakeholderGiveModelSearch;
  }

  Future findStakeholder(
      {required BuildContext context,
      required String? token,
      required int idUserAppInstitution,
      required int id,
      required String nameSurnameOrBusinessName,
      required String email,
      required String city,
      required String cf}) async {
    try {
      bool isOk = false;

      var response = await giveAPI.findStakeholder(
          token: token,
          id: id,
          idUserAppInstitution: idUserAppInstitution,
          nameSurnameOrBusinessName: nameSurnameOrBusinessName,
          email: email,
          city: city,
          cf: cf);

      if (response != null) {
        final Map<String, dynamic> parseData = await jsonDecode(response);
        isOk = parseData['isOk'];
        if (!isOk) {
          String errorDescription = parseData['errorDescription'];
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackUtil.stylishSnackBar(
                    title: "Anagrafiche",
                    message: errorDescription,
                    contentType: "failure"));
            // Navigator.pop(context);
          }
        } else {
          if (parseData['okResult'] != null) {
            List<StakeholderGiveModelSearch> stakeholderModel =
                List.from(parseData['okResult'])
                    .map((e) => StakeholderGiveModelSearch.fromJson(e))
                    .toList();

            // List<StakeholderGiveModel> stakeholderModel =
            //     List.from(parseData['okResult'])
            //         .map((e) => StakeholderGiveModel.fromMap(e))
            //         .toList();

            return stakeholderModel;
          } else {
            return null;
          }
        }
      } else {
        AuthenticationNotifier authenticationNotifier =
            Provider.of<AuthenticationNotifier>(context, listen: false);
        authenticationNotifier.exit(context);
      }
    } on SocketException catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackUtil.stylishSnackBar(
            title: "Anagrafiche",
            message: "Errore di connessione",
            contentType: "failure"));
      }
    }
  }

  Future<StakeholderGiveModelWithRulesSearch?> addStakeholder(
      {required BuildContext context,
      required String? token,
      required bool mustForce,
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
      required String regione_nn_norm,
      required String prov_nn_norm,
      required String statoFederale_nn_norm,
      required String cap_nn_norm,
      required String citta_nn_norm,
      required String suddivisioneComune_2_nn_norm,
      required String suddivisioneComune_3_nn_norm,
      required String localita_nn_norm,
      required String indirizzo_nn_norm,
      required String n_civico_nn_norm,
      required String row4,
      required String row5,
      required String cdxcnl,
      required String x,
      required String y,
      required int consenso_ringrazia,
      required int consenso_com_espresso,
      required int consenso_marketing,
      required int consenso_sms,
      required int com_cartacee,
      required int com_email,
      required int consenso_materiale_info,
      required String datanascita,
      required String tipo_donatore}) async {
    StakeholderGiveModelWithRulesSearch? cStakeholderGiveModelWithRulesSearch;
    try {
      var response = await giveAPI.addStakeholder(
          token: token,
          idUserAppInstitution: idUserAppInstitution,
          nome: nome,
          cognome: cognome,
          ragSoc: ragSoc,
          codfisc: codfisc,
          sesso: sesso,
          email: email,
          tel: tel,
          cell: cell,
          nazione_nn_norm: nazione_nn_norm,
          regione_nn_norm: regione_nn_norm,
          prov_nn_norm: prov_nn_norm,
          statoFederale_nn_norm: statoFederale_nn_norm,
          cap_nn_norm: cap_nn_norm,
          citta_nn_norm: citta_nn_norm,
          suddivisioneComune_2_nn_norm: suddivisioneComune_2_nn_norm,
          suddivisioneComune_3_nn_norm: suddivisioneComune_3_nn_norm,
          localita_nn_norm: localita_nn_norm,
          indirizzo_nn_norm: indirizzo_nn_norm,
          n_civico_nn_norm: n_civico_nn_norm,
          row4: row4,
          row5: row5,
          cdxcnl: cdxcnl,
          x: x,
          y: y,
          consenso_ringrazia: consenso_ringrazia,
          consenso_com_espresso: consenso_com_espresso,
          consenso_marketing: consenso_marketing,
          consenso_sms: consenso_sms,
          com_cartacee: com_cartacee,
          com_email: com_email,
          consenso_materiale_info: consenso_materiale_info,
          datanascita: datanascita,
          tipo_donatore: tipo_donatore,
          forza_duplicato: mustForce == true ? 1 : 0);

      if (response != null) {
        final Map<String, dynamic> parseData = await jsonDecode(response);
        //bool isOk = parseData['isOk'];
        cStakeholderGiveModelWithRulesSearch =
            StakeholderGiveModelWithRulesSearch.fromJson(parseData['okResult']);
        cStakeholderGiveModelWithRulesSearch.operationResult =
            parseData['errorDescription'] ?? 'Ok';
        return cStakeholderGiveModelWithRulesSearch;
      } else {
        AuthenticationNotifier authenticationNotifier =
            Provider.of<AuthenticationNotifier>(context, listen: false);
        authenticationNotifier.exit(context);
      }
    } on SocketException catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackUtil.stylishSnackBar(
            title: "Anagrafiche",
            message: "Errore di connessione",
            contentType: "failure"));
      }
      return cStakeholderGiveModelWithRulesSearch;
    }
  }

  Future<StakeholderGiveModelWithRulesSearch?> updateStakeholder(
      {required BuildContext context,
      required String? token,
      required bool mustForce,
      required int forcingId,
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
      required String regione_nn_norm,
      required String prov_nn_norm,
      required String statoFederale_nn_norm,
      required String cap_nn_norm,
      required String citta_nn_norm,
      required String suddivisioneComune_2_nn_norm,
      required String suddivisioneComune_3_nn_norm,
      required String localita_nn_norm,
      required String indirizzo_nn_norm,
      required String n_civico_nn_norm,
      required String row4,
      required String row5,
      required String cdxcnl,
      required String x,
      required String y,
      required int consenso_ringrazia,
      required int consenso_com_espresso,
      required int consenso_marketing,
      required int consenso_sms,
      required int com_cartacee,
      required int com_email,
      required int consenso_materiale_info,
      required String datanascita,
      required String tipo_donatore}) async {
    StakeholderGiveModelWithRulesSearch? cStakeholderGiveModelWithRulesSearch;
    try {
      int toUpdateId = 0;

      if (forcingId > 0) {
        toUpdateId = forcingId;
      } else {
        toUpdateId = id;
      }
      var response = await giveAPI.updateStakeholder(
          token: token,
          idUserAppInstitution: idUserAppInstitution,
          id: toUpdateId,
          nome: nome,
          cognome: cognome,
          ragSoc: ragSoc,
          codfisc: codfisc,
          sesso: sesso,
          email: email,
          tel: tel,
          cell: cell,
          nazione_nn_norm: nazione_nn_norm,
          regione_nn_norm: regione_nn_norm,
          prov_nn_norm: prov_nn_norm,
          statoFederale_nn_norm: statoFederale_nn_norm,
          cap_nn_norm: cap_nn_norm,
          citta_nn_norm: citta_nn_norm,
          suddivisioneComune_2_nn_norm: suddivisioneComune_2_nn_norm,
          suddivisioneComune_3_nn_norm: suddivisioneComune_3_nn_norm,
          localita_nn_norm: localita_nn_norm,
          indirizzo_nn_norm: indirizzo_nn_norm,
          n_civico_nn_norm: n_civico_nn_norm,
          row4: row4,
          row5: row5,
          cdxcnl: cdxcnl,
          x: x,
          y: y,
          consenso_ringrazia: consenso_ringrazia,
          consenso_com_espresso: consenso_com_espresso,
          consenso_marketing: consenso_marketing,
          consenso_sms: consenso_sms,
          com_cartacee: com_cartacee,
          com_email: com_email,
          consenso_materiale_info: consenso_materiale_info,
          datanascita: datanascita,
          tipo_donatore: tipo_donatore,
          forza_duplicato: mustForce == true ? 1 : 0);

      if (response != null) {
        final Map<String, dynamic> parseData = await jsonDecode(response);
        //bool isOk = parseData['isOk'];
        if (parseData['okResult'] != null &&
            parseData['okResult'].toString().isNotEmpty) {
          cStakeholderGiveModelWithRulesSearch =
              StakeholderGiveModelWithRulesSearch.fromJson(
                  parseData['okResult']);
          cStakeholderGiveModelWithRulesSearch.operationResult =
              parseData['errorDescription'] ?? 'Ok';
        } else {
          cStakeholderGiveModelWithRulesSearch =
              StakeholderGiveModelWithRulesSearch.empty();
          cStakeholderGiveModelWithRulesSearch.operationResult =
              parseData['errorDescription'] ?? 'Errore di connessione';
        }
      } else {
        cStakeholderGiveModelWithRulesSearch =
            StakeholderGiveModelWithRulesSearch.empty();
        cStakeholderGiveModelWithRulesSearch.operationResult =
            'Errore di connessione';
        AuthenticationNotifier authenticationNotifier =
            Provider.of<AuthenticationNotifier>(context, listen: false);
        authenticationNotifier.exit(context);
      }
      return cStakeholderGiveModelWithRulesSearch;
    } on SocketException catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackUtil.stylishSnackBar(
            title: "Anagrafiche",
            message: "Errore di connessione",
            contentType: "failure"));
      }
      return cStakeholderGiveModelWithRulesSearch;
    }
  }

  void refresh() {
    notifyListeners();
  }
}

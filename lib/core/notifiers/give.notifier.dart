// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:np_casse/core/api/give.api.dart';
import 'package:np_casse/core/models/give.model.dart';
import 'package:np_casse/core/utils/snackbar.util.dart';

class GiveNotifier with ChangeNotifier {
  final GiveAPI giveAPI = GiveAPI();

  Future findStakeholder(
      {required BuildContext context,
      required String? token,
      required int idUserAppInstitution,
      required String nameSurnameOrBusinessName,
      required String email,
      required String city,
      required String cf}) async {
    try {
      bool isOk = false;
      var response = await giveAPI.findStakeholder(
          token: token,
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
                    text: errorDescription, context: context));
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
      }
    } on SocketException catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackUtil.stylishSnackBar(
            text: 'Oops No You Need A Good Internet Connection',
            context: context,
          ),
        );
      }
    }
  }

  Future addStakeholder(
      {required BuildContext context,
      required String? token,
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
    try {
      bool isOk = false;
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
          prov_nn_norm: prov_nn_norm,
          cap_nn_norm: cap_nn_norm,
          citta_nn_norm: citta_nn_norm,
          indirizzo_nn_norm: indirizzo_nn_norm,
          n_civico_nn_norm: n_civico_nn_norm,
          consenso_ringrazia: consenso_ringrazia,
          consenso_com_espresso: consenso_com_espresso,
          consenso_marketing: consenso_marketing,
          consenso_sms: consenso_sms,
          com_cartacee: com_cartacee,
          com_email: com_email,
          consenso_materiale_info: consenso_materiale_info,
          datanascita: datanascita,
          tipo_donatore: tipo_donatore);

      if (response != null) {
        final Map<String, dynamic> parseData = await jsonDecode(response);
        isOk = parseData['isOk'];
        if (!isOk) {
          String errorDescription = parseData['errorDescription'];
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackUtil.stylishSnackBar(
                    text: errorDescription, context: context));
            // Navigator.pop(context);
          }
        } else {
          // ProjectModel projectDetail =
          //     ProjectModel.fromJson(parseData['okResult']);
          //return projectDetail;
          //notifyListeners();
        }
      }
      return isOk;
    } on SocketException catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackUtil.stylishSnackBar(
          text: 'Oops No You Need A Good Internet Connection',
          context: context,
        ),
      );
    }
  }

  Future updateStakeholder(
      {required BuildContext context,
      required String? token,
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
    try {
      bool isOk = false;
      var response = await giveAPI.updateStakeholder(
          token: token,
          idUserAppInstitution: idUserAppInstitution,
          id: id,
          nome: nome,
          cognome: cognome,
          ragSoc: ragSoc,
          codfisc: codfisc,
          sesso: sesso,
          email: email,
          tel: tel,
          cell: tel,
          nazione_nn_norm: nazione_nn_norm,
          prov_nn_norm: prov_nn_norm,
          cap_nn_norm: cap_nn_norm,
          citta_nn_norm: citta_nn_norm,
          indirizzo_nn_norm: indirizzo_nn_norm,
          n_civico_nn_norm: n_civico_nn_norm,
          consenso_ringrazia: consenso_ringrazia,
          consenso_com_espresso: consenso_com_espresso,
          consenso_marketing: consenso_marketing,
          consenso_sms: consenso_sms,
          com_cartacee: com_cartacee,
          com_email: com_email,
          consenso_materiale_info: consenso_materiale_info,
          datanascita: datanascita,
          tipo_donatore: tipo_donatore);

      if (response != null) {
        final Map<String, dynamic> parseData = await jsonDecode(response);
        isOk = parseData['isOk'];
        if (!isOk) {
          String errorDescription = parseData['errorDescription'];
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackUtil.stylishSnackBar(
                    text: errorDescription, context: context));
            // Navigator.pop(context);
          }
        } else {
          // ProjectModel projectDetail =
          //     ProjectModel.fromJson(parseData['okResult']);
          //return projectDetail;
          //notifyListeners();
        }
      }
      return isOk;
    } on SocketException catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackUtil.stylishSnackBar(
          text: 'Oops No You Need A Good Internet Connection',
          context: context,
        ),
      );
    }
  }

  void refresh() {
    notifyListeners();
  }
}

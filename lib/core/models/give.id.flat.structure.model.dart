import 'package:np_casse/app/constants/functional.dart';

class GiveIdsFlatStructureModel {
  GiveIdsFlatStructureModel(
      {required this.idFinalizzazione,
      required this.idEvento,
      required this.idAttivita,
      required this.idAgenda,
      required this.idComunicazioni,
      required this.idTipDonazione,
      required this.idCatalogo,
      required this.idPagamentoContante,
      required this.idPagamentoBancomat,
      required this.idPagamentoCartaDiCredito,
      required this.idPagamentoAssegno});
  late int idFinalizzazione;
  late int idEvento;
  late int idAttivita;
  late int idAgenda;
  late int idComunicazioni;
  late int idTipDonazione;
  late int idCatalogo;
  late int idPagamentoContante;
  late int idPagamentoBancomat;
  late int idPagamentoCartaDiCredito;
  late int idPagamentoAssegno;

  GiveIdsFlatStructureModel.empty() {
    idFinalizzazione = 0;
    idEvento = 0;
    idAttivita = 0;
    idAgenda = 0;
    idComunicazioni = 0;
    idTipDonazione = 0;
    idCatalogo = 0;
    idPagamentoContante = 0;
    idPagamentoBancomat = 0;
    idPagamentoCartaDiCredito = 0;
    idPagamentoAssegno = 0;
  }
  GiveIdsFlatStructureModel.fromCustomIdGive(
      List<String> customIdGive, String area) {
    idFinalizzazione = 0;
    idEvento = 0;
    idAttivita = 0;
    idAgenda = 0;
    idComunicazioni = 0;
    idTipDonazione = 0;
    idCatalogo = 0;
    idPagamentoContante = 0;
    idPagamentoBancomat = 0;
    idPagamentoCartaDiCredito = 0;
    idPagamentoAssegno = 0;
    if (area == "Product") {
      for (String item in customIdGive) {
        var split = item.split('=');
        if (split[0] == idGiveListNameProduct[0]) {
          idFinalizzazione = int.parse(split[1]);
        } else if (split[0] == idGiveListNameProduct[1]) {
          idEvento = int.parse(split[1]);
        } else if (split[0] == idGiveListNameProduct[2]) {
          idAttivita = int.parse(split[1]);
        } else if (split[0] == idGiveListNameProduct[3]) {
          idAgenda = int.parse(split[1]);
        } else if (split[0] == idGiveListNameProduct[4]) {
          idComunicazioni = int.parse(split[1]);
        } else if (split[0] == idGiveListNameProduct[5]) {
          idTipDonazione = int.parse(split[1]);
        } else if (split[0] == idGiveListNameProduct[6]) {
          idCatalogo = int.parse(split[1]);
        }
      }
    } else if (area == "Category") {
      for (String item in customIdGive) {
        var split = item.split('=');
        if (split[0] == idGiveListNameCategory[0]) {
          idFinalizzazione = int.parse(split[1]);
        } else if (split[0] == idGiveListNameCategory[1]) {
          idEvento = int.parse(split[1]);
        } else if (split[0] == idGiveListNameCategory[2]) {
          idAttivita = int.parse(split[1]);
        } else if (split[0] == idGiveListNameCategory[3]) {
          idAgenda = int.parse(split[1]);
        } else if (split[0] == idGiveListNameCategory[4]) {
          idComunicazioni = int.parse(split[1]);
        } else if (split[0] == idGiveListNameCategory[5]) {
          idTipDonazione = int.parse(split[1]);
        } else if (split[0] == idGiveListNameCategory[6]) {
          idCatalogo = int.parse(split[1]);
        } else if (split[0] == idGiveListNameCategory[7]) {
          idPagamentoContante = int.parse(split[1]);
        } else if (split[0] == idGiveListNameCategory[8]) {
          idPagamentoBancomat = int.parse(split[1]);
        } else if (split[0] == idGiveListNameCategory[9]) {
          idPagamentoCartaDiCredito = int.parse(split[1]);
        } else if (split[0] == idGiveListNameCategory[10]) {
          idPagamentoAssegno = int.parse(split[1]);
        }
      }
    }
  }
  GiveIdsFlatStructureModel.fromJson(Map<String, dynamic> json) {
    idFinalizzazione = json['idFinalizzazione'];
    idEvento = json['idEvento'];
    idAttivita = json['idAttività'];
    idAgenda = json['idAgenda'];
    idComunicazioni = json['idComunicazioni'];
    idTipDonazione = json['idTipDonazione'];
    idCatalogo = json['idCatalogo'];
    idPagamentoContante = json['idPagamentoContante'];
    idPagamentoBancomat = json['idPagamentoBancomat'];
    idPagamentoCartaDiCredito = json['idPagamentoCartaDiCredito'];
    idPagamentoAssegno = json['idPagamentoAssegno'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['idFinalizzazione'] = idFinalizzazione;
    data['idEvento'] = idEvento;
    data['idAttivita'] = idAttivita;
    data['idAgenda'] = idAgenda;
    data['idComunicazioni'] = idComunicazioni;
    data['idTipDonazione'] = idTipDonazione;
    data['idCatalogo'] = idCatalogo;
    data['idPagamentoContante'] = idPagamentoContante;
    data['idPagamentoBancomat'] = idPagamentoBancomat;
    data['idPagamentoCartaDiCredito'] = idPagamentoCartaDiCredito;
    data['idPagamentoAssegno'] = idPagamentoAssegno;
    return data;
  }
}

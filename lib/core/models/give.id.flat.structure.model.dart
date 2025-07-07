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
      required this.idPromotore,
      required this.idPagamentoContante,
      required this.idPagamentoBancomat,
      required this.idPagamentoCartaDiCredito,
      required this.idPagamentoAssegno,
      required this.codiceSottoconto,
      required this.codiceCentroRicavo,
      required this.fonteSh,
      required this.ringraziato});
  late String idFinalizzazione;
  late String idEvento;
  late String idAttivita;
  late String idAgenda;
  late String idComunicazioni;
  late String idTipDonazione;
  late String idCatalogo;
  late String idPromotore;
  late String idPagamentoContante;
  late String idPagamentoBancomat;
  late String idPagamentoCartaDiCredito;
  late String idPagamentoAssegno;
  late String codiceSottoconto;
  late String codiceCentroRicavo;
  late String fonteSh;
  late String ringraziato;

  GiveIdsFlatStructureModel.empty() {
    idFinalizzazione = '';
    idEvento = '';
    idAttivita = '';
    idAgenda = '';
    idComunicazioni = '';
    idTipDonazione = '';
    idCatalogo = '';
    idPromotore = '';
    idPagamentoContante = '';
    idPagamentoBancomat = '';
    idPagamentoCartaDiCredito = '';
    idPagamentoAssegno = '';
    codiceSottoconto = '';
    codiceCentroRicavo = '';
    fonteSh = '';
    ringraziato = '';
  }
  GiveIdsFlatStructureModel.fromCustomIdGive(
      List<String> customIdGive, String area) {
    idFinalizzazione = '';
    idEvento = '';
    idAttivita = '';
    idAgenda = '';
    idComunicazioni = '';
    idTipDonazione = '';
    idCatalogo = '';
    idPromotore = '';
    idPagamentoContante = '';
    idPagamentoBancomat = '';
    idPagamentoCartaDiCredito = '';
    idPagamentoAssegno = '';
    codiceSottoconto = '';
    codiceCentroRicavo = '';
    fonteSh = '';
    ringraziato = '';
    if (area == "Product") {
      for (String item in customIdGive) {
        var split = item.split('=');
        if (split[0] == idGiveListNameProduct[0]) {
          idFinalizzazione = split[1];
        } else if (split[0] == idGiveListNameProduct[1]) {
          idEvento = split[1];
        } else if (split[0] == idGiveListNameProduct[2]) {
          idAttivita = split[1];
        } else if (split[0] == idGiveListNameProduct[3]) {
          idAgenda = split[1];
        } else if (split[0] == idGiveListNameProduct[4]) {
          idComunicazioni = split[1];
        } else if (split[0] == idGiveListNameProduct[5]) {
          idTipDonazione = split[1];
        } else if (split[0] == idGiveListNameProduct[6]) {
          idCatalogo = split[1];
        } else if (split[0] == idGiveListNameProduct[7]) {
          idPromotore = split[1];
        } else if (split[0] == idGiveListNameProduct[8]) {
          codiceSottoconto = split[1];
        } else if (split[0] == idGiveListNameProduct[9]) {
          codiceCentroRicavo = split[1];
        } else if (split[0] == idGiveListNameProduct[10]) {
          fonteSh = split[1];
        } else if (split[0] == idGiveListNameProduct[11]) {
          ringraziato = split[1];
        }
      }
    } else if (area == "Category") {
      for (String item in customIdGive) {
        var split = item.split('=');
        if (split[0] == idGiveListNameCategory[0]) {
          idFinalizzazione = split[1];
        } else if (split[0] == idGiveListNameCategory[1]) {
          idEvento = split[1];
        } else if (split[0] == idGiveListNameCategory[2]) {
          idAttivita = split[1];
        } else if (split[0] == idGiveListNameCategory[3]) {
          idAgenda = split[1];
        } else if (split[0] == idGiveListNameCategory[4]) {
          idComunicazioni = split[1];
        } else if (split[0] == idGiveListNameCategory[5]) {
          idTipDonazione = split[1];
        } else if (split[0] == idGiveListNameCategory[6]) {
          idCatalogo = split[1];
        } else if (split[0] == idGiveListNameProduct[7]) {
          idPromotore = split[1];
        } else if (split[0] == idGiveListNameProduct[8]) {
          codiceSottoconto = split[1];
        } else if (split[0] == idGiveListNameProduct[9]) {
          codiceCentroRicavo = split[1];
        } else if (split[0] == idGiveListNameCategory[10]) {
          idPagamentoContante = split[1];
        } else if (split[0] == idGiveListNameCategory[11]) {
          idPagamentoBancomat = split[1];
        } else if (split[0] == idGiveListNameCategory[12]) {
          idPagamentoCartaDiCredito = split[1];
        } else if (split[0] == idGiveListNameCategory[13]) {
          idPagamentoAssegno = split[1];
        } else if (split[0] == idGiveListNameCategory[14]) {
          fonteSh = split[1];
        } else if (split[0] == idGiveListNameCategory[15]) {
          ringraziato = split[1];
        }
      }
    }
  }

  GiveIdsFlatStructureModel.fromJson(Map<String, dynamic> json) {
    idFinalizzazione = json['idFinalizzazione'];
    idEvento = json['idEvento'];
    idAttivita = json['idAttivita'];
    idAgenda = json['idAgenda'];
    idComunicazioni = json['idComunicazioni'];
    idTipDonazione = json['idTipDonazione'];
    idCatalogo = json['idCatalogo'];
    idPromotore = json['idPromotore'];
    idPagamentoContante = json['idPagamentoContante'];
    idPagamentoBancomat = json['idPagamentoBancomat'];
    idPagamentoCartaDiCredito = json['idPagamentoCartaDiCredito'];
    idPagamentoAssegno = json['idPagamentoAssegno'];
    codiceSottoconto = json['codiceSottoconto'];
    codiceCentroRicavo = json['codiceCentroRicavo'];
    fonteSh = json['fonteSh'];
    ringraziato = json['ringraziato'];
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
    data['idPromotore'] = idPromotore;
    data['idPagamentoContante'] = idPagamentoContante;
    data['idPagamentoBancomat'] = idPagamentoBancomat;
    data['idPagamentoCartaDiCredito'] = idPagamentoCartaDiCredito;
    data['idPagamentoAssegno'] = idPagamentoAssegno;
    data['codiceSottoconto'] = codiceSottoconto;
    data['codiceCentroRicavo'] = codiceCentroRicavo;
    data['fonteSh'] = fonteSh;
    data['ringraziato'] = ringraziato;
    return data;
  }
}

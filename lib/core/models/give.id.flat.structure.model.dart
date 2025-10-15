import 'package:np_casse/app/constants/functional.dart';

class GiveIdsFlatStructureModel {
  GiveIdsFlatStructureModel({
    required this.idFinalizzazione,
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
    required this.ringraziato,
    required this.idPagamentoPaypal,
    required this.idPagamentoEsterno,
    required this.idPagamentoSdd,
    required this.idPagamentoBonificoPromessa,
    required this.idPagamentoBonificoIstantaneo,
    required this.idPagamentoBonificoLink,
  });

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
  late String idPagamentoPaypal;
  late String idPagamentoEsterno;
  late String idPagamentoSdd;
  late String idPagamentoBonificoPromessa;
  late String idPagamentoBonificoIstantaneo;
  late String idPagamentoBonificoLink;

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
    idPagamentoPaypal = '';
    idPagamentoEsterno = '';
    idPagamentoSdd = '';
    idPagamentoBonificoPromessa = '';
    idPagamentoBonificoIstantaneo = '';
    idPagamentoBonificoLink = '';
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
    idPagamentoPaypal = '';
    idPagamentoEsterno = '';
    idPagamentoSdd = '';
    idPagamentoBonificoPromessa = '';
    idPagamentoBonificoIstantaneo = '';
    idPagamentoBonificoLink = '';

    final List<String> keys =
        area == "Product" ? idGiveListNameProduct : idGiveListNameCategory;

    final Map<String, void Function(String)> mapping = {
      for (int i = 0; i < keys.length; i++)
        keys[i]: (val) {
          switch (keys[i]) {
            case 'IdFinalizzazione':
              idFinalizzazione = val;
              break;
            case 'IdEvento':
              idEvento = val;
              break;
            case 'IdAttività':
              idAttivita = val;
              break;
            case 'IdAgenda':
              idAgenda = val;
              break;
            case 'IdComunicazioni':
              idComunicazioni = val;
              break;
            case 'IdTipDonazione':
              idTipDonazione = val;
              break;
            case 'IdCatalogo':
              idCatalogo = val;
              break;
            case 'IdPromotore':
              idPromotore = val;
              break;
            case 'CodiceSottoconto':
              codiceSottoconto = val;
              break;
            case 'CodiceCentroRicavo':
              codiceCentroRicavo = val;
              break;
            case 'FonteSh':
              fonteSh = val;
              break;
            case 'Ringraziato':
              ringraziato = val;
              break;
            case 'IdPagamentoContante':
              idPagamentoContante = val;
              break;
            case 'IdPagamentoBancomat':
              idPagamentoBancomat = val;
              break;
            case 'IdPagamentoCartaDiCredito':
              idPagamentoCartaDiCredito = val;
              break;
            case 'IdPagamentoAssegno':
              idPagamentoAssegno = val;
              break;
            case 'IdPagamentoPaypal':
              idPagamentoPaypal = val;
              break;
            case 'IdPagamentoEsterno':
              idPagamentoEsterno = val;
              break;
            case 'IdPagamentoSdd':
              idPagamentoSdd = val;
              break;
            case 'IdPagamentoBonificoPromessa':
              idPagamentoBonificoPromessa = val;
              break;
            case 'IdPagamentoBonificoIstantaneo':
              idPagamentoBonificoIstantaneo = val;
              break;
            case 'IdPagamentoBonificoLink':
              idPagamentoBonificoLink = val;
              break;
          }
        }
    };

    // Iteriamo sugli elementi e assegnamo i valori usando la mappa
    for (String item in customIdGive) {
      var split = item.split('=');
      if (split.length == 2 && mapping.containsKey(split[0])) {
        mapping[split[0]]!(split[1]);
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
    idPromotore = json['idPromotore'];
    idPagamentoContante = json['idPagamentoContante'];
    idPagamentoBancomat = json['idPagamentoBancomat'];
    idPagamentoCartaDiCredito = json['idPagamentoCartaDiCredito'];
    idPagamentoAssegno = json['idPagamentoAssegno'];
    idPagamentoPaypal = json['idPagamentoPaypal'];
    idPagamentoEsterno = json['idPagamentoEsterno'];
    idPagamentoSdd = json['idPagamentoSdd'];
    idPagamentoBonificoPromessa = json['idPagamentoBonificoPromessa'];
    idPagamentoBonificoIstantaneo = json['idPagamentoBonificoIstantaneo'];
    idPagamentoBonificoLink = json['idPagamentoBonificoLink'];
    codiceSottoconto = json['codiceSottoconto'];
    codiceCentroRicavo = json['codiceCentroRicavo'];
    fonteSh = json['fonteSh'];
    ringraziato = json['ringraziato'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['idFinalizzazione'] = idFinalizzazione;
    data['idEvento'] = idEvento;
    data['idAttività'] = idAttivita;
    data['idAgenda'] = idAgenda;
    data['idComunicazioni'] = idComunicazioni;
    data['idTipDonazione'] = idTipDonazione;
    data['idCatalogo'] = idCatalogo;
    data['idPromotore'] = idPromotore;
    data['idPagamentoContante'] = idPagamentoContante;
    data['idPagamentoBancomat'] = idPagamentoBancomat;
    data['idPagamentoCartaDiCredito'] = idPagamentoCartaDiCredito;
    data['idPagamentoAssegno'] = idPagamentoAssegno;
    data['idPagamentoPaypal'] = idPagamentoPaypal;
    data['idPagamentoEsterno'] = idPagamentoEsterno;
    data['idPagamentoSdd'] = idPagamentoSdd;
    data['idPagamentoBonificoPromessa'] = idPagamentoBonificoPromessa;
    data['idPagamentoBonificoIstantaneo'] = idPagamentoBonificoIstantaneo;
    data['idPagamentoBonificoLink'] = idPagamentoBonificoLink;
    data['codiceSottoconto'] = codiceSottoconto;
    data['codiceCentroRicavo'] = codiceCentroRicavo;
    data['fonteSh'] = fonteSh;
    data['ringraziato'] = ringraziato;

    return data;
  }
}

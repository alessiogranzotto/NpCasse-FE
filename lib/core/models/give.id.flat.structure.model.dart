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
  late final int idFinalizzazione;
  late final int idEvento;
  late final int idAttivita;
  late final int idAgenda;
  late final int idComunicazioni;
  late final int idTipDonazione;
  late final int idCatalogo;
  late final int idPagamentoContante;
  late final int idPagamentoBancomat;
  late final int idPagamentoCartaDiCredito;
  late final int idPagamentoAssegno;

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
  GiveIdsFlatStructureModel.fromJson(Map<String, dynamic> json) {
    idFinalizzazione = json['idFinalizzazione'];
    idEvento = json['idEvento'];
    idAttivita = json['idAttivita'];
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
